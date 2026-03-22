# App Module

Planned SwiftUI host app responsibilities:

- onboarding and privacy explanation
- category education and trust model
- local allowlist/denylist management
- classification audit view
- user override flow

Current minimal scaffold:

- `AppClassificationBridge` provides a tiny host-app-facing entry point into the shared local classifier
- intended for preview, audit, and future settings/debug surfaces
