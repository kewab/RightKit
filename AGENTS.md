# RightKit AGENTS

## Project Goal

RightKit is a native macOS productivity app focused on Finder context menu enhancements.

The first release only includes:

- New File
- Copy To
- Move To
- Favorite Directories
- Copy Path
- Cut / Paste

The product goal for v1 is stability, fast interaction, and predictable file operations inside Finder. Do not expand scope unless explicitly requested.

## Product Boundaries

Current MVP excludes:

- Translation
- QR code generation
- Image conversion
- Custom folder icons
- Third-party app integrations
- Cloud-drive-specific compatibility work beyond what is required for basic functionality

If a future task suggests adding any of the above, treat it as out of scope unless the user explicitly approves it.

## Technical Direction

Use a native Apple stack.

- Language: `Swift`
- UI: `SwiftUI`
- System integration: `AppKit` where SwiftUI is insufficient
- Finder integration: `Finder Sync Extension`
- Shared storage: `App Group` + `UserDefaults`
- File operations: `FileManager`
- Project format: `Xcode app project` with extension target and shared code module
- Dependency management: prefer `Swift Package Manager`

Do not introduce Electron, Tauri, Flutter, React Native, or any other cross-platform shell for core app architecture.

## Suggested Targets

Unless the repository evolves differently, keep the project split into:

1. `RightKitApp`
2. `RightKitFinderExt`
3. `RightKitCore`

Responsibilities:

- `RightKitApp`
  - Settings UI
  - Favorite directory management
  - File template management
  - Permission guidance and onboarding

- `RightKitFinderExt`
  - Finder context menu injection
  - Selection/context inspection
  - Invocation of shared file actions

- `RightKitCore`
  - Shared models
  - File action services
  - Shared state and storage
  - Error types
  - Logging helpers

## MVP Behavior Decisions

These decisions are intentional and should be preserved unless changed by the user.

### New File

- v1 supports a small fixed template set such as `txt`, `md`, and `json`
- Files are created in the currently focused Finder directory
- Avoid complex template engines in v1

### Copy To / Move To

- Destination choices come from Favorite Directories
- v1 does not need a custom directory picker inside the extension menu
- Handle duplicate filenames explicitly and predictably

### Favorite Directories

- Managed by the host app
- Read by the Finder extension through shared storage
- Keep ordering stable

### Copy Path

- Use `NSPasteboard`
- For multiple paths, use newline-delimited plain text in v1

### Cut / Paste

- Do not rely on a system-level Finder cut implementation
- "Cut" means storing file URLs and intent in shared app state
- "Paste" means executing a move operation into the current target directory
- The implementation must handle:
  - source missing
  - destination exists
  - permission denied
  - cross-volume moves

## Engineering Principles

- Optimize for Finder reliability over feature breadth
- Keep business logic out of SwiftUI views
- Keep Finder extension code thin; place reusable logic in shared modules
- Prefer simple data flow and explicit state over hidden magic
- Add logging around all file mutations and extension-triggered actions
- Treat permissions and entitlement handling as first-class engineering work, not polish

## Code Style

- Use clear English names in code, even if product copy is Chinese
- Prefer small focused types over large manager classes
- Use value types where practical
- Keep platform-specific code isolated
- Add comments only when the intent is not obvious from the code

## Storage Rules

Shared configuration should live behind a narrow abstraction, for example:

- `FavoriteDirectoryStore`
- `TemplateStore`
- `ClipboardMoveStore`

Do not scatter direct `UserDefaults` access throughout the codebase.

All shared data between the app and extension must go through the configured `App Group`.

## Error Handling

- File operations must return actionable errors
- Surface user-facing failures in plain language
- Never silently swallow move/copy failures
- Prefer typed errors over generic strings in the core layer

## UI Expectations

The host app should remain small and utilitarian in v1.

Prioritize:

- Favorite directory management
- New file template management
- Extension enablement guidance

Do not spend early cycles on visual polish that does not improve setup or reliability.

## Testing Priorities

When tests are added, prioritize:

1. path resolution
2. favorite directory persistence
3. cut/paste state transitions
4. duplicate filename handling
5. cross-volume move fallback behavior

UI snapshot testing is lower priority than core file-operation correctness.

## Dependencies

Keep third-party dependencies close to zero in v1.

Before adding any external package, verify that:

- Apple frameworks cannot reasonably cover the use case
- the package does not complicate extension compatibility
- the package is worth the maintenance cost for a Finder-based utility

## Delivery Bias

For this repository, prefer shipping in this order:

1. Shared models and storage
2. File action services
3. Host app settings UI
4. Finder Sync menu wiring
5. Permission onboarding
6. Edge-case hardening

Do not invert this sequence by polishing UI before the extension path is working.

## Agent Instructions

When working in this repository:

- preserve the native macOS direction
- preserve the MVP scope unless the user changes it
- keep Finder extension code minimal and push logic into shared code
- avoid speculative abstractions for future non-MVP features
- document entitlements, app group usage, and extension constraints as they are introduced
- prefer incremental, testable changes over large scaffolding dumps
