# Android Data Flow

## Design Principle

Android data flow should begin only from user-provided message artifacts.

The system should not assume automatic inbox ownership.

## Flow 1: Share-In From Another App

### User entry point

- user taps Android share from a messaging app
- this app appears as an analysis/organizer target

### Data passed in

- message body text
- sender text if present in the share payload
- optional timestamp or source hint if available

### Processing path

1. Android share intent enters the share-in adapter.
2. Adapter extracts available sender/body fields.
3. Artifact Intake Coordinator builds a draft artifact.
4. Classification Bridge converts the artifact into classifier input.
5. Shared core returns category, confidence, explanation, signals, and normalized text.

### Classification trigger

- immediate on arrival

### Storage behavior

- do not auto-save silently
- show result first
- allow user to save the artifact into local history

### Result presentation

- explanation-rich analysis screen
- actions: Save, Delete, Search Similar, View Category

### Failure and empty states

- missing text: show “No analyzable message content received”
- malformed share payload: show editable recovery form
- classifier failure: show raw artifact and retry option

## Flow 2: Paste / Analyze

### User entry point

- user opens app
- taps Analyze
- pastes text and optional sender

### Data passed in

- message body
- optional sender

### Processing path

1. User submits pasted input.
2. Intake Coordinator validates minimum content.
3. Classification Bridge classifies locally.
4. Result is shown immediately.

### Classification trigger

- on Analyze action

### Storage behavior

- default should be explicit save, not automatic retention

### Result presentation

- same detail/result screen as share-in

### Failure and empty states

- empty body: show validation message
- too-short content: still allow analysis, but explain limited certainty

## Flow 3: Future Explicit Local Artifact Import

### User entry point

- user opens Import in the app
- selects a clearly user-initiated import source

### Data passed in

- batch of sender/body/timestamp artifacts if available

### Processing path

1. Import adapter parses selected input.
2. Intake Coordinator validates each artifact.
3. Classification runs locally in batch.
4. Results are written to local artifact storage.

### Classification trigger

- batch trigger after explicit import confirmation

### Storage behavior

- imported artifacts are saved locally with provenance
- import batch id should be recorded

### Result presentation

- import summary
- counts by category
- link to Important, Search, and Review surfaces

### Failure and empty states

- parse failure
- empty import
- partially invalid artifact rows

## Distribution Flow

Once artifacts are stored locally:

1. Search layer indexes sender, body, normalized text, category, and source type.
2. Home surface derives Important buckets.
3. Review surface derives Suspicious and Promotional buckets.
4. Detail screen shows explanation and provenance.

## Deletion Flow

1. User opens artifact detail or history management.
2. User deletes one artifact or a selected batch.
3. Raw artifact and classification snapshot are removed locally.

This should be easy and explicit.

## Non-Goals

The Android shell should not assume:

- background inbox sync
- auto-ingestion of future SMS
- transport-level block or hide behavior
- complete device inbox coverage
