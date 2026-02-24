# 🚀 Quick Start Guide

Get up and running with Poker Hand Evaluator in 5 minutes!

## Prerequisites

Make sure you have these installed:
- ✅ Flutter SDK (3.9.2+)
- ✅ Dart SDK (3.9.2+)
- ✅ Android Studio or VS Code
- ✅ Git

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/benjamin-bekele/poker-hand-evaluator.git
cd poker-hand-evaluator
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

That's it! The app should now be running on your device/emulator.

## First Time Setup

### For Android Development

1. Install Android Studio
2. Set up an Android emulator or connect a physical device
3. Enable USB debugging on your device

### For iOS Development (Mac only)

1. Install Xcode from the App Store
2. Run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
3. Run `sudo xcodebuild -runFirstLaunch`
4. Open iOS Simulator or connect an iPhone

### For Web Development

```bash
flutter run -d chrome
```

## Project Structure

```
poker-hand-evaluator/
├── lib/
│   ├── main.dart              # Main app entry point
│   ├── about_dialog.dart      # About dialog component
│   └── pokerhandranking.dart  # Hand ranking reference
├── assets/
│   ├── Poker.png             # App icon
│   └── Parkinsans.ttf        # Custom font
├── test/                      # Test files
├── pubspec.yaml              # Dependencies
└── README.md                 # Documentation
```

## Common Commands

### Run the app
```bash
flutter run
```

### Run tests
```bash
flutter test
```

### Build for production
```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Format code
```bash
flutter format .
```

### Analyze code
```bash
flutter analyze
```

### Clean build
```bash
flutter clean
flutter pub get
```

## Troubleshooting

### "Flutter command not found"
Add Flutter to your PATH:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### "No devices found"
- For Android: Start an emulator or connect a device
- For iOS: Open Simulator
- For Web: Use `flutter run -d chrome`

### Dependencies issues
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Build errors
1. Check Flutter version: `flutter --version`
2. Update Flutter: `flutter upgrade`
3. Clean and rebuild: `flutter clean && flutter run`

## Development Tips

### Hot Reload
Press `r` in the terminal while the app is running to hot reload changes.

### Hot Restart
Press `R` in the terminal for a full restart.

### Debug Mode
The app runs in debug mode by default. For better performance, use release mode:
```bash
flutter run --release
```

### VS Code Extensions
- Flutter
- Dart
- Flutter Widget Snippets
- Awesome Flutter Snippets

### Android Studio Plugins
- Flutter
- Dart

## Next Steps

1. ✅ Read the [README.md](README.md) for full documentation
2. ✅ Check [CONTRIBUTING.md](CONTRIBUTING.md) to contribute
3. ✅ Review [CHANGELOG.md](CHANGELOG.md) for version history
4. ✅ Explore the code and start building!

## Need Help?

- 📧 Email: mr.benjaminbekele@gmail.com
- 💬 Telegram: [@benjamin_bekele](https://t.me/benjamin_bekele)
- 🐙 GitHub Issues: [Report a bug](https://github.com/benjamin-bekele/poker-hand-evaluator/issues)

---

**Happy Coding! 🃏**
