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
- a Finder Sync Extension source placeholder for the future Xcode target

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

## Finder Extension

The Finder extension source lives in:

```text
Sources/RightKitFinderExt
```

## Generate Xcode Project

The repository now includes an `xcodegen` spec for the host app:

```bash
brew install xcodegen
chmod +x Scripts/generate_xcodeproj.sh
Scripts/generate_xcodeproj.sh
open RightKit.xcodeproj
```

This creates a runnable macOS app target named `RightKitApp`.

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

The default generated project keeps the extension out of the initial run path so the host app can launch without Apple Developer signing. Add the Finder Sync Extension target in Xcode after full Xcode installation and team signing are available.
