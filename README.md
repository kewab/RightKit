# RightKit

RightKit is a native macOS Finder context menu utility.

The first version focuses on:

- New File
- Copy To
- Move To
- Favorite Directories
- Copy Path
- Cut / Paste

## Current State

This repository currently contains:

- a runnable SwiftUI host app
- shared core models, storage, and file action services
- a Finder Sync Extension target definition for the Xcode project
- shared Chinese/English language settings, defaulting to Chinese

The local machine currently has Command Line Tools but not a full Xcode installation, so the temporary scripts compile the host app with `swiftc`.

## Run Host App

```bash
chmod +x Scripts/build_app.sh Scripts/run_app.sh
Scripts/run_app.sh
```

The generated app bundle is placed at:

```text
.build/local/RightKit.app
```

## Run Tests

Core regression tests live under:

```text
Tests/RightKitCoreTests
```

Run them with:

```bash
chmod +x Scripts/test.sh
Scripts/test.sh
```

For this repository, every code change should end by running `Scripts/test.sh`.

The script does not require a full Xcode installation. It compiles `Sources/RightKitCore` together with the test runner using `swiftc`, which makes it usable on machines that only have Command Line Tools installed.

## Finder Extension

The Finder extension source lives in:

```text
Sources/RightKitFinderExt
```

The extension source currently wires the MVP actions:

- New File
- Copy To
- Move To
- Favorite Directories
- Copy Path
- Cut
- Paste

## Generate Xcode Project

The repository now includes an `xcodegen` spec for the host app and Finder extension:

```bash
brew install xcodegen
chmod +x Scripts/generate_xcodeproj.sh
Scripts/generate_xcodeproj.sh
open RightKit.xcodeproj
```

This creates:

- `RightKitApp`
- `RightKitFinderExt`

## Full Xcode Environment

To move from Command Line Tools to a full Xcode setup:

```bash
brew install xcodes
xcodes install --latest
sudo xcode-select -s /Applications/Xcode.app
sudo xcodebuild -runFirstLaunch
```

`xcodes install --latest` requires an Apple ID sign-in to download Xcode from Apple.

## Finder Extension

The Finder extension source and config live in:

```text
Sources/RightKitFinderExt
Config/RightKitFinderExt.Info.plist
Config/RightKitFinderExt.entitlements
```

The generated project embeds `RightKitFinderExt` into `RightKitApp`. To make the Finder context menu appear, you still need to:

1. install full Xcode
2. set the same Signing Team on both targets
3. run `RightKitApp` once
4. enable `RightKit` under Finder Extensions in System Settings

## Language

RightKit stores the active language in shared configuration so the host app and Finder extension can render the same language.

Default:

```text
中文
```
