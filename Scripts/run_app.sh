#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_BUNDLE="$("$ROOT_DIR/Scripts/build_app.sh")"

open "$APP_BUNDLE"
echo "$APP_BUNDLE"
