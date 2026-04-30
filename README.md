[English](README.md) | [简体中文](README.zh-CN.md)

# RightKit

RightKit is a native macOS Finder context menu utility built for fast, predictable file operations.

## MVP Features

- New File
- Copy To
- Move To
- Favorite Directories
- Copy Path
- Cut / Paste

## Tech Stack

- `Swift`
- `SwiftUI`
- `AppKit`
- `Finder Sync Extension`
- `App Group` + `UserDefaults`
- `FileManager`
- `XcodeGen`

## Project Structure

- `RightKitApp`: host app, settings, onboarding, shared configuration management
- `RightKitFinderExt`: Finder context menu integration
- `Sources/RightKitCore`: shared models, storage, localization, and file actions

## Requirements

- macOS 13+
- Xcode
- `xcodegen` if you need to regenerate the project

## Getting Started

### 1. Generate the Xcode project

```bash
brew install xcodegen
chmod +x Scripts/generate_xcodeproj.sh
Scripts/generate_xcodeproj.sh
```

### 2. Open the project

```bash
open RightKit.xcodeproj
```

### 3. Build and run the app

Run the `RightKitApp` scheme from Xcode.

### 4. Enable the Finder extension

After the app launches once, enable `RightKit` in:

`System Settings > Extensions > Finder Extensions`

If Finder does not pick up the extension immediately, relaunch Finder.

## Command Line Helpers

### Run the host app only

```bash
chmod +x Scripts/build_app.sh Scripts/run_app.sh
Scripts/run_app.sh
```

This path builds the SwiftUI host app with `swiftc` and outputs:

```text
.build/local/RightKit.app
```

It is useful for host app iteration, but Finder extension development and verification should be done through Xcode.

### Run tests

```bash
chmod +x Scripts/test.sh
Scripts/test.sh
```

Core regression tests live in:

```text
Tests/RightKitCoreTests
```

## Finder Extension Notes

- The extension source lives in `Sources/RightKitFinderExt`
- Extension configuration lives in `Config/RightKitFinderExt.Info.plist` and `Config/RightKitFinderExt.entitlements`
- Shared configuration is stored through the configured App Group
- The app and extension both support Chinese and English, with Chinese as the default UI language

## Development Notes

- Keep Finder extension code thin and move reusable logic into `RightKitCore`
- Prioritize reliability over feature breadth
- Avoid expanding beyond the MVP unless explicitly approved
