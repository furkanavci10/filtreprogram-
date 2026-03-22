# Android Shell Architecture

## Product Boundary

The Android shell should behave like a trust-first organizer, classifier, and search assistant.

It should not behave like:

- a full SMS inbox
- the default SMS app
- a transport owner
- a silent blocking system

Core statement:

The app should help users analyze, find, and organize selected or imported message artifacts. It should reduce clutter and improve discoverability without replacing the native messaging flow.

## Minimum Android Shell

The minimum Android shell should contain six lightweight layers.

### 1. Ingestion Adapters

Responsibility:

- receive user-provided message artifacts
- normalize incoming Android intents or pasted text into a shared app model

Examples:

- share-in adapter
- paste/analyze adapter
- future explicit import adapter

### 2. Artifact Intake Coordinator

Responsibility:

- validate incoming data
- build a local artifact draft
- trigger classification
- decide whether to save or discard based on user action

This coordinator should be the boundary between platform inputs and the organizer/search product shell.

### 3. Classification Bridge

Responsibility:

- convert Android artifact input into classifier input
- call the shared trust-first classification core
- return category, confidence, explanation, normalized text, and signals

This should remain a thin wrapper over the existing shared core logic.

### 4. Local Artifact Store

Responsibility:

- persist user-provided message artifacts
- persist classification snapshots
- support deletion and local history views
- support search/filter indexing

### 5. Search and Distribution Layer

Responsibility:

- provide important-message views
- provide category chips and saved searches
- provide suspicious/promotional review lists
- provide explanation-rich detail views

### 6. Privacy and Settings Layer

Responsibility:

- make ingestion provenance visible
- define retention and deletion controls
- expose conservative preferences
- keep privacy promises explicit

## Recommended Lightweight Module Split

Minimal Android-side modules:

- `android/app-shell`
- `android/ingestion`
- `android/model`
- `android/classification`
- `android/storage`
- `android/search`
- `android/settings`

This split is intentionally small. It avoids UI overgrowth while keeping platform wiring separate from the shared classifier.

## State Holders

Minimal state-holder set:

- `HomeViewState`
- `AnalyzeInputState`
- `ImportantMessagesState`
- `SearchState`
- `ReviewState`
- `MessageDetailState`
- `SettingsState`

These should be screen-oriented state holders, not a giant app-wide inbox controller.

## Main Runtime Flow

1. User shares or pastes a message artifact.
2. Ingestion adapter converts platform input into a local artifact draft.
3. Artifact Intake Coordinator validates the draft.
4. Classification Bridge calls the shared classifier.
5. Classification snapshot is attached to the artifact.
6. User sees immediate analysis results.
7. If saved, artifact and classification snapshot are written to local storage.
8. Search and distribution surfaces use only locally stored artifacts.

## Product Boundary Protection

The shell must avoid:

- unread count semantics that imply inbox ownership
- thread-first navigation
- send/reply composition flows
- copy that implies automatic system-wide SMS management

The shell should emphasize:

- analysis
- discovery
- categorization
- explanation
- local organization

## Minimum Useful Android MVP Shell

For the first real Android implementation, the minimum useful shell should include:

- one entry/home surface
- one share/paste analyze flow
- one local artifact history view
- one important-messages surface
- one categorized search surface
- one explanation-rich message detail screen
- one simple privacy/settings surface

This is enough to validate the organizer product without drifting into messaging-client territory.
