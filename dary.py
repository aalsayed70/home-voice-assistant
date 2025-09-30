#!/usr/bin/env python3

import io
import os
import time
import wave
import json
import signal
import logging
from typing import Optional, Dict, Any
from pathlib import Path

import numpy as np
import requests
import webrtcvad
import sounddevice as sd
from dotenv import load_dotenv
from pydub import AudioSegment

from openwakeword.model import Model as OWWModel

HERE = Path(__file__).resolve().parent
load_dotenv(dotenv_path=HERE / ".env")

XI_KEY = (os.getenv("ELEVENLABS_API_KEY", "") or "").strip()
VOICE_ID = (os.getenv("VOICE_ID", "") or "").strip()
WEBHOOK_URL = (os.getenv("WEBHOOK_URL", "") or "").strip()
LANGUAGE_CODE = (os.getenv("LANGUAGE_CODE", "auto") or "auto").strip()
TTS_ENABLED = (os.getenv("TTS_ENABLED", "true") or "true").strip().lower() in {"1", "true", "yes", "on"}
TTS_VOICE_ID = (os.getenv("TTS_VOICE_ID", "") or "").strip() or VOICE_ID

INPUT_DEVICE_ENV = (os.getenv("INPUT_DEVICE", "") or "").strip() or None
OUTPUT_DEVICE_ENV = (os.getenv("OUTPUT_DEVICE", "") or "").strip() or None

WAKEWORD_MODEL_PATH_ENV = (os.getenv("WAKEWORD_MODEL_PATH", "") or "").strip()
WAKEWORD_MODEL_DIR_ENV = (os.getenv("WAKEWORD_MODEL_DIR", "") or "").strip()
WAKEWORD_MODEL_FILENAME_ENV = (os.getenv("WAKEWORD_MODEL_FILENAME", "") or "").strip()
WAKEWORD_MODEL_LEGACY = (os.getenv("WAKEWORD_MODEL", "") or "").strip()
WAKEWORD_NAME = "daari"

SAMPLE_RATE = 16000
CHANNELS = 1
SAMPLE_WIDTH = 2

WAKE_THRESHOLD = 0.1
WAKE_FRAME_SEC = 0.08
REQUIRED_HITS = 1

VAD_AGGRESSIVENESS = 2
VAD_FRAME_MS = 20
MAX_UTTERANCE_SEC = 15
SILENCE_TAIL_MS = 700

STT_URL = "https://api.elevenlabs.io/v1/speech-to-text"
TTS_URL_TMPL = "https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"

def _resolve_wake_model_path() -> Path:
    # Priority: explicit path → legacy single var → dir+filename
    if WAKEWORD_MODEL_PATH_ENV:
        return Path(WAKEWORD_MODEL_PATH_ENV)
    if WAKEWORD_MODEL_LEGACY:
        return Path(WAKEWORD_MODEL_LEGACY)
    if WAKEWORD_MODEL_DIR_ENV:
        if not WAKEWORD_MODEL_FILENAME_ENV:
            raise AssertionError(
                "WAKEWORD_MODEL_FILENAME is required when using WAKEWORD_MODEL_DIR"
            )
        return Path(WAKEWORD_MODEL_DIR_ENV) / WAKEWORD_MODEL_FILENAME_ENV
    raise AssertionError(
        "Missing wake word model configuration: set WAKEWORD_MODEL_PATH, or "
        "WAKEWORD_MODEL (legacy), or WAKEWORD_MODEL_DIR + WAKEWORD_MODEL_FILENAME"
    )


def _assert_env() -> None:
    assert XI_KEY, "Missing ELEVENLABS_API_KEY in environment/.env"
    assert VOICE_ID, "Missing VOICE_ID in environment/.env"
    assert WEBHOOK_URL, "Missing WEBHOOK_URL in environment/.env"
    model_path = _resolve_wake_model_path()
    assert model_path.exists(), f"Wake model not found: {model_path}"

def _parse_device(dev: Optional[str]):
    if not dev:
        return None
    try:
        return int(dev)
    except ValueError:
        return dev

def _configure_devices() -> None:
    in_dev = _parse_device(INPUT_DEVICE_ENV)
    out_dev = _parse_device(OUTPUT_DEVICE_ENV)
    if in_dev is not None or out_dev is not None:
        current = list(sd.default.device) if isinstance(sd.default.device, (list, tuple)) else [None, None]
        if in_dev is not None:
            current[0] = in_dev
        if out_dev is not None:
            current[1] = out_dev
        sd.default.device = tuple(current)

def wav_bytes_from_pcm16(pcm16: bytes, sample_rate: int = SAMPLE_RATE) -> bytes:
    buf = io.BytesIO()
    with wave.open(buf, "wb") as w:
        w.setnchannels(CHANNELS)
        w.setsampwidth(SAMPLE_WIDTH)
        w.setframerate(sample_rate)
        w.writeframes(pcm16)
    return buf.getvalue()

def play_mp3_via_sounddevice(mp3_bytes: bytes) -> None:
    seg = AudioSegment.from_file(io.BytesIO(mp3_bytes), format="mp3")
    samples = np.array(seg.get_array_of_samples())
    if seg.channels > 1:
        samples = samples.reshape((-1, seg.channels))
    audio_f32 = (samples.astype(np.float32)) / 32768.0
    sd.play(audio_f32, seg.frame_rate)
    sd.wait()

def transcribe_with_scribe(wav_bytes: bytes, language_code: str = LANGUAGE_CODE) -> str:
    headers = {"xi-api-key": XI_KEY}
    files = {"file": ("audio.wav", io.BytesIO(wav_bytes), "audio/wav")}
    data: Dict[str, Any] = {"model_id": "scribe_v1"}
    if language_code and language_code.lower() != "auto":
        data["language_code"] = language_code
    r = requests.post(STT_URL, headers=headers, files=files, data=data, timeout=60)
    try:
        r.raise_for_status()
    except requests.HTTPError:
        try:
            logging.error("STT error body: %s", r.json())
        except Exception:
            logging.error("STT error body (text): %s", r.text)
        raise
    j = r.json()
    for key in ("text", "transcript", "output_text"):
        if isinstance(j, dict) and isinstance(j.get(key), str) and j[key].strip():
            return j[key].strip()
    return json.dumps(j) if isinstance(j, (dict, list)) else str(j)

def tts_to_mp3_bytes(text: str, voice_id: Optional[str] = None) -> bytes:
    v_id = (voice_id or TTS_VOICE_ID or VOICE_ID)
    url = TTS_URL_TMPL.format(voice_id=v_id)
    headers = {
        "xi-api-key": XI_KEY,
        "accept": "audio/mpeg",
        "Content-Type": "application/json",
    }
    payload = {
        "text": text,
        "model_id": "eleven_multilingual_v2",
        "voice_settings": {"stability": 0.5, "similarity_boost": 0.7},
    }
    r = requests.post(url, headers=headers, json=payload, timeout=60)
    r.raise_for_status()
    return r.content

def record_until_silence(raw_stream: sd.RawInputStream,
                         vad: webrtcvad.Vad,
                         max_seconds: int = MAX_UTTERANCE_SEC,
                         tail_ms: int = SILENCE_TAIL_MS) -> Optional[bytes]:
    frame_len = int(SAMPLE_RATE * (VAD_FRAME_MS / 1000.0))
    voiced = False
    start_t = time.time()
    last_voice_t = start_t
    ring = bytearray()
    while True:
        if time.time() - start_t > max_seconds:
            break
        data, overflowed = raw_stream.read(frame_len)
        if overflowed:
            logging.debug("Input overflow")
        if not data:
            continue
        ring.extend(data)
        try:
            if vad.is_speech(bytes(data), SAMPLE_RATE):
                voiced = True
                last_voice_t = time.time()
        except Exception as e:
            logging.debug(f"VAD error: {e}")
        if voiced and ((time.time() - last_voice_t) * 1000.0 > tail_ms):
            break
    if len(ring) < SAMPLE_RATE * SAMPLE_WIDTH * 1:
        return None
    return bytes(ring)

def load_wake_model() -> OWWModel:
    path = _resolve_wake_model_path()
    if not path.exists():
        raise FileNotFoundError(f"Custom wake model not found at: {path}")
    logging.info(f"Loading custom wake model (ONNX): {path}")
    try:
        return OWWModel(
            wakeword_models=[str(path)],
            inference_framework="onnx",
            vad_threshold=0.5,
            enable_speex_noise_suppression=False,
        )
    except TypeError as e:
        logging.warning(f"OpenWakeWord kwargs not accepted ({e}); trying minimal init…")
        try:
            return OWWModel(
                wakeword_models=[str(path)],
                inference_framework="onnx",
            )
        except Exception as e2:
            raise RuntimeError(
                "Your openwakeword install can't accept custom model kwargs. "
                "Reinstall it from GitHub and skip deps:\n"
                "  python3 -m pip uninstall -y openwakeword\n"
                "  python3 -m pip install --no-cache-dir --no-deps "
                "\"openwakeword @ git+https://github.com/dscripka/openWakeWord.git@main\"\n"
            ) from e2

def pick_score(scores: Dict[str, float], name_substr: str) -> float:
    name_substr = (name_substr or "").lower()
    if not scores:
        return 0.0
    candidates = [v for k, v in scores.items() if name_substr and name_substr in k.lower()]
    if candidates:
        return max(candidates)
    return max(scores.values())

def listen_loop() -> None:
    logging.info("🎙️ Dary is listening for the wake word… (say: 'daari')")
    model = load_wake_model()
    vad = webrtcvad.Vad(VAD_AGGRESSIVENESS)
    wake_frames = int(SAMPLE_RATE * WAKE_FRAME_SEC)
    printed_keys_once = False
    consec = 0
    _configure_devices()
    with sd.RawInputStream(samplerate=SAMPLE_RATE, channels=CHANNELS, dtype="int16") as stream:
        while True:
            data, overflowed = stream.read(wake_frames)
            if overflowed:
                logging.debug("Wake stream overflow")
            if not data:
                continue
            np_frame = np.frombuffer(data, dtype=np.int16)
            scores = model.predict(np_frame)
            if not printed_keys_once:
                logging.info(f"Wake model score keys seen: {list(scores.keys())}")
                printed_keys_once = True
            score = pick_score(scores, WAKEWORD_NAME)
            if score >= WAKE_THRESHOLD:
                consec += 1
            else:
                consec = 0
            if consec >= REQUIRED_HITS:
                consec = 0
                logging.info(f"✅ Wake word detected: {WAKEWORD_NAME} (score={score:.2f})")
                logging.info("🎧 Speak your command…")
                pcm16 = record_until_silence(stream, vad)
                if not pcm16:
                    logging.info("(too short / no speech captured, ignoring)")
                    continue
                try:
                    wav_bytes = wav_bytes_from_pcm16(pcm16, SAMPLE_RATE)
                    logging.info("📝 Transcribing with Scribe v1…")
                    query_text = transcribe_with_scribe(wav_bytes, LANGUAGE_CODE)
                    logging.info(f"👉 Query: {query_text}")
                except Exception:
                    logging.exception("STT error")
                    continue
                try:
                    logging.info("🌐 POST → webhook…")
                    resp = requests.post(
                        WEBHOOK_URL,
                        json={"query": query_text, "source": "dary", "timestamp": int(time.time())},
                        timeout=60,
                    )
                    reply_text: Optional[str] = None
                    try:
                        j = resp.json()
                        for k in ("text", "reply", "answer", "message", "output"):
                            if isinstance(j, dict) and isinstance(j.get(k), str) and j[k].strip():
                                reply_text = j[k].strip()
                                break
                        if (not reply_text) and isinstance(j, dict) and j.get("choices"):
                            reply_text = j["choices"][0]["message"]["content"]
                    except Exception:
                        pass
                    if not reply_text:
                        reply_text = resp.text or "(no response)"
                except Exception:
                    logging.exception("Webhook error")
                    reply_text = "I couldn’t reach the webhook."

                # Speak the reply using TTS if enabled
                try:
                    if TTS_ENABLED and reply_text and reply_text.strip():
                        logging.info("🔊 Speaking reply via TTS…")
                        mp3_bytes = tts_to_mp3_bytes(reply_text)
                        play_mp3_via_sounddevice(mp3_bytes)
                    else:
                        logging.info("💬 Reply: %s", reply_text)
                except Exception:
                    logging.exception("TTS playback failed; printing text instead")
                    logging.info("💬 Reply: %s", reply_text)

def main() -> None:
    _assert_env()
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s: %(message)s",
        datefmt="%H:%M:%S",
    )
    signal.signal(signal.SIGINT, lambda *args: exit(0))
    listen_loop()

if __name__ == "__main__":
    main()
