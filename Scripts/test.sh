#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p .build/tests

core_sources=()
while IFS= read -r file; do
  core_sources+=("$file")
done < <(find Sources/RightKitCore -name '*.swift' | sort)

test_sources=()
while IFS= read -r file; do
  test_sources+=("$file")
done < <(find Tests/RightKitCoreTests -name '*.swift' | sort)

swiftc \
  -module-name RightKitCoreTests \
  -o .build/tests/RightKitCoreTests \
  "${core_sources[@]}" \
  "${test_sources[@]}"

.build/tests/RightKitCoreTests
