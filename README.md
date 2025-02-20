# LoginWizard

![App Logo](assets/loginwizard.png)

A Flutter application that helps generate secure usernames, passwords, and PINs.

## Features

- Username Generator
  - Customizable format (words, numbers)
  - Copy to clipboard
  - View generation history
  
- Password Generator
  - Configurable length (4-128 characters)
  - Options for uppercase, lowercase, numbers, and symbols
  - Password strength indicator
  - Copy to clipboard
  - View generation history

- PIN Generator 
  - Configurable length
  - Copy to clipboard
  - View generation history

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio / VS Code
- Git

### Build Instructions

#### For Android

1. Clone the repository
    ```bash
    git clone https://github.com/yourusername/LoginWizard.git
    cd LoginWizard
    ```
2. Get dependencies
    ```bash
    flutter pub get
    ```
3. Build APK
    ```bash
    flutter build apk --release
    ```
4. The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

#### For Desktop (Windows)

1. Build Windows executable
    ```bash
    flutter build windows --release
    ```
2. The executable will be available at: `build/windows/runner/Release/`

#### For Desktop (Linux)

1. Build Linux executable
    ```bash
    flutter build linux --release
    ```
2. The executable will be available at: `build/linux/runner/Release/`

#### For Desktop (macOS)

1. Build macOS executable
    ```bash
    flutter build macos --release
    ```
2. The executable will be available at: `build/macos/Build/Products/Release/`

### Development

To run in debug mode:
```bash
flutter run
```

To generate database code:
```bash
flutter packages pub run build_runner build
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
