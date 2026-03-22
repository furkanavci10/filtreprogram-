# Implementation Notes

Implementation starts only after required documentation is complete.

Current MVP coding target:

- Pure Swift rule engine
- Turkish normalization helpers
- Classification result model
- Embedded starter dataset
- Unit and regression tests

Planned follow-up after Milestone 1:

- Xcode iOS app shell
- SMS Filter Extension shell
- App group persistence
- review UI and override settings

Integration boundary now prepared:

- `ClassificationCore` exposes request/response adapter types for future iOS extension usage
- Apple-specific framework integration remains intentionally outside the core package
