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

When the Xcode project is created, add a Finder Sync Extension target and include the shared `RightKitCore` files.
