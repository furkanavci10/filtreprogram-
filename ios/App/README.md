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
- accepts either raw `sender/body` values or a shared `FilterClassificationRequest`
- `AppGroupConfiguration` provides a minimal native container for future shared defaults/App Group wiring
- `HostAppIntegrationEnvironment` groups the shared bridge and App Group config for future settings/audit surfaces
- `App.entitlements.template` shows the minimum host-app App Group placeholder

Minimum Xcode target setup:

- create a host app target
- attach the shared Swift package containing `ClassificationCore`
- add the same App Group used by the SMS Filter Extension target
- keep the app shell minimal; its first job is validating shared configuration and later surfacing audit/review results
