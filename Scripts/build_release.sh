#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="${APP_NAME:-RightKit}"
SCHEME="${SCHEME:-RightKitApp}"
CONFIGURATION="${CONFIGURATION:-Release}"
ARCH="${ARCH:-arm64}"
PROJECT_PATH="$ROOT_DIR/RightKit.xcodeproj"
RELEASE_ROOT="${RELEASE_ROOT:-$ROOT_DIR/.build/releases}"
DERIVED_DATA_DIR="$RELEASE_ROOT/DerivedData"
ARTIFACTS_DIR="$RELEASE_ROOT/artifacts"

VERSION="${1:-$(sed -n 's/^[[:space:]]*MARKETING_VERSION:[[:space:]]*//p' "$ROOT_DIR/project.yml" | head -n 1 | tr -d '\"')}"

if [[ -z "$VERSION" ]]; then
  echo "Unable to resolve MARKETING_VERSION from project.yml" >&2
  exit 1
fi

"$ROOT_DIR/Scripts/generate_xcodeproj.sh" >/dev/null

rm -rf "$DERIVED_DATA_DIR" "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR"

xcodebuild \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$DERIVED_DATA_DIR" \
  -destination "platform=macOS,arch=$ARCH" \
  ARCHS="$ARCH" \
  ONLY_ACTIVE_ARCH=YES \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

APP_PATH="$DERIVED_DATA_DIR/Build/Products/$CONFIGURATION/$APP_NAME.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/$APP_NAME"
DMG_PATH="$ARTIFACTS_DIR/${APP_NAME}-${VERSION}-mac-${ARCH}.dmg"
ZIP_PATH="$ARTIFACTS_DIR/${APP_NAME}-${VERSION}-mac-${ARCH}.zip"

if [[ ! -d "$APP_PATH" ]]; then
  echo "Expected app bundle not found: $APP_PATH" >&2
  exit 1
fi

if ! /usr/bin/file "$EXECUTABLE_PATH" | grep -q "$ARCH"; then
  echo "Expected $ARCH executable at $EXECUTABLE_PATH" >&2
  /usr/bin/file "$EXECUTABLE_PATH" >&2
  exit 1
fi

"$ROOT_DIR/Scripts/create_dmg.sh" "$APP_PATH" "$DMG_PATH" "$APP_NAME" >/dev/null
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" "$ZIP_PATH"

printf '%s\n' "$DMG_PATH"
