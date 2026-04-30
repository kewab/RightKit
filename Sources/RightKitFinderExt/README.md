# RightKit Finder Extension

This folder contains the Finder Sync Extension entry point.

The current local build scripts compile only the host app because this machine is using Command Line Tools without a full Xcode installation. When an Xcode project is added, create a Finder Sync Extension target and include:

- `Sources/RightKitFinderExt/FinderSync.swift`
- all files under `Sources/RightKitCore`
- `Config/RightKit.entitlements`

The extension should share the same App Group as the host app:

```text
group.com.deacyn.RightKit
```
