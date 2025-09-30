# Dary Mobile App (Flutter)

A cross-platform Flutter app that complements the `dary.py` voice assistant. It provides remote control for Home Assistant devices, quick actions (Moments), and a chat/voice interface to talk with Dary via your N8N backend.

## ✨ Features

- Remote control for Home Assistant devices
- Moments/Scenes configuration and execution
- Talk with Dary (text/voice) connected to the same backend
- Cross-platform targets: Android, iOS, Web, macOS, Windows, Linux

## 📦 Requirements

- Flutter SDK 3.24+ (Dart 3)
- Android Studio (Android SDK, emulator) and/or Xcode (iOS)
- A running N8N instance and Home Assistant (see repository root README)

## 🚀 Setup

```bash
cd mobile
flutter pub get
```

If building for Android/iOS, ensure you have platform toolchains installed (Android SDK/Xcode) and an emulator or device available.

## ⚙️ Configuration

The app communicates with your backend (N8N, Home Assistant). Update base URLs and endpoints where applicable. Key places to check:

- `lib/talk_with_dary.dart`: webhook/API endpoint used for chatting with Dary
- `lib/screens/*.dart`: any screens that access backend endpoints
- `lib/models/*.dart`: data models that might encode base URLs or keys

For secure builds, prefer storing secrets in platform-specific configuration rather than committing them to source.

## ▶️ Run

```bash
flutter run
```

Select your target device when prompted. For web:

```bash
flutter run -d chrome
```

## 🔨 Build

Android APK (debug):
```bash
flutter build apk --debug
```

Android APK (release):
```bash
flutter build apk --release
```

iOS (requires macOS/Xcode):
```bash
flutter build ios --release
```

Web:
```bash
flutter build web
```

## 🧩 Project Layout

```
mobile/
├── lib/                    # Dart source (UI, models, state)
├── assets/                 # Images and other assets
├── android/, ios/, web/    # Platform targets
├── linux/, macos/, windows # Desktop targets
└── README.md
```

Notable files:
- `lib/main.dart`: app entry point
- `lib/talk_with_dary.dart`: chat/voice integration with backend
- `lib/screens/`: feature screens (dashboard, device control, moments, etc.)
- `lib/models/`: data models e.g., devices, moments

## 🧪 Testing

```bash
flutter test
```

## ❓ Troubleshooting

- If the app cannot reach your backend, verify the base URL/webhook in `lib/` files and that N8N is accessible from your device/emulator network.
- For Android emulators accessing a host machine service, use `10.0.2.2` for localhost.
- Ensure required Home Assistant tokens/credentials are configured server-side.

## 📄 License

This app is part of the Dary project. See the repository root for licensing details.
