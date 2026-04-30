#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/.build/local"
APP_BUNDLE="$BUILD_DIR/RightKit.app"
EXECUTABLE_DIR="$APP_BUNDLE/Contents/MacOS"
RESOURCES_DIR="$APP_BUNDLE/Contents/Resources"
EXECUTABLE="$EXECUTABLE_DIR/RightKit"
INFO_PLIST="$APP_BUNDLE/Contents/Info.plist"
INFO_PLIST_SOURCE="$ROOT_DIR/Config/RightKitApp.Info.plist"

rm -rf "$APP_BUNDLE"
mkdir -p "$EXECUTABLE_DIR" "$RESOURCES_DIR"

SWIFT_FILES=()
while IFS= read -r file; do
  SWIFT_FILES+=("$file")
done < <(find "$ROOT_DIR/Sources/RightKitCore" "$ROOT_DIR/Sources/RightKitApp" -name "*.swift" | sort)

swiftc \
  -parse-as-library \
  -target arm64-apple-macosx13.0 \
  -framework SwiftUI \
  -framework AppKit \
  "${SWIFT_FILES[@]}" \
  -o "$EXECUTABLE"

cp "$INFO_PLIST_SOURCE" "$INFO_PLIST"

echo "$APP_BUNDLE"
