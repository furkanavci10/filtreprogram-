# Android Local Storage

## Storage Goal

Local storage should support a privacy-first organizer/search assistant operating on user-provided message artifacts.

It should be easy to reason about, easy to delete, and clearly separated from any notion of owning the device SMS inbox.

## Core Stored Objects

### Message Artifact

Suggested fields:

- `artifactId`
- `sourceType`
- `senderText`
- `messageBody`
- `receivedAt`
- `ingestedAt`
- `importBatchId`
- `provenanceNote`

### Classification Snapshot

Suggested fields:

- `artifactId`
- `category`
- `confidenceBand`
- `safeScore`
- `riskScore`
- `explanation`
- `normalizedText`
- `triggeredSignals`
- `classifiedAt`
- `rulesVersion`

### User Organization Metadata

Suggested fields:

- `artifactId`
- `isPinned`
- `userLabel`
- `savedCategoryView`
- `manualReviewState`
- `lastViewedAt`

## Recommended Persistence Principles

- local-first by default
- no mandatory cloud sync
- clear linkage between artifact and classification snapshot
- explicit provenance for every artifact
- deletion should remove both artifact and classification snapshot

## Retention Assumptions

Recommended MVP retention:

- keep saved artifacts until user deletes them
- allow draft analysis without forced saving
- make batch deletion available
- avoid retaining discarded drafts

This reduces surprise and keeps the app understandable.

## Search Indexing

Suggested indexed fields:

- sender text
- body text
- normalized text
- category
- source type
- user label

## Privacy Boundaries

The app should store only:

- content the user explicitly provided
- classification output derived from that content
- user-created organization metadata

The app should not imply:

- full inbox mirroring
- hidden background harvesting
- transport ownership

## Export and Deletion Expectations

Users should be able to:

- delete one artifact
- delete selected artifacts
- clear all locally stored artifacts

Optional future capability:

- export selected local artifacts and classifications for personal backup

## Storage Technology Direction

The specific Android storage stack can be chosen later, but the model should support:

- transactional save/delete behavior
- local search/filter queries
- simple migration/versioning

For MVP, the storage layer should stay lightweight and auditable.
