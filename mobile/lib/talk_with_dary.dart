import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TalkWithDary extends StatefulWidget {
  const TalkWithDary({super.key});

  @override
  State<TalkWithDary> createState() => _TalkWithDaryState();
}

class _TalkWithDaryState extends State<TalkWithDary>
    with SingleTickerProviderStateMixin {
  final _recorder = AudioRecorder();
  String? _filePath;
  bool _isRecording = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}/dary_record_${DateTime.now().millisecondsSinceEpoch}.m4a';

    if (await _recorder.hasPermission()) {
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      setState(() {
        _filePath = path;
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() => _isRecording = false);
    if (_filePath != null) {
      debugPrint('Recording saved at: $_filePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFFB8E6B8),
        elevation: 0,
        title: const Text(
          "Talk With Dary",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 38, 38, 38),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Status text
              Text(
                _isRecording ? "Listening..." : "Tap to speak",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: _isRecording
                      ? const Color(0xFFB8E6B8)
                      : Colors.white70,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 60),

              // Animated microphone button
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFB8E6B8,
                                  ).withOpacity(0.4 * _pulseAnimation.value),
                                  blurRadius: 40 * _pulseAnimation.value,
                                  spreadRadius: 10 * _pulseAnimation.value,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _isRecording
                                ? [
                                    const Color(0xFFB8E6B8),
                                    const Color(0xFF90D890),
                                  ]
                                : [
                                    const Color(0xFF2A2A2A),
                                    const Color(0xFF1A1A1A),
                                  ],
                          ),
                          border: Border.all(
                            color: _isRecording
                                ? const Color(0xFFB8E6B8).withOpacity(0.5)
                                : Colors.white.withOpacity(0.1),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          size: 80,
                          color: _isRecording
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFFB8E6B8),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Helper text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _isRecording
                      ? "Speak your command or tap to stop"
                      : "Ask Dary to control your smart home",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(),

              // Recording indicator
              if (_isRecording)
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFB8E6B8).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB8E6B8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Recording",
                        style: TextStyle(
                          color: Color(0xFFB8E6B8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
