# Android Data Model

## Product Boundary

Android data handling must support an SMS organizer, classifier, and search assistant.

It must not assume ownership of:

- SMS transport
- message delivery
- the default inbox workflow
- silent blocking or hiding

Core product statement:

The Android version should reduce clutter and improve message discoverability without forcing users into a new primary messaging workflow.

## Design Principle

The Android data model should represent only the message artifacts the app is legitimately given.

It should not model itself as the canonical owner of the device inbox unless the product later takes a deliberate default-SMS path, which is out of scope for the current strategy.

## Recommended Android Data Layers

### Layer 1: Message Artifact

This is the raw SMS-like content the user intentionally brings into the app.

Suggested fields:

- `artifactId`
- `sourceType`
- `senderText`
- `messageBody`
- `receivedAt` if available
- `ingestedAt`
- `provenance`
- `sourceMetadata`

Notes:

- `artifactId` should be app-scoped, not assumed to be an Android SMS provider row id.
- `sourceType` should explicitly say how the app obtained the data.
- `provenance` should record whether the content was shared, pasted, imported in batch, or came from an optional future helper path.

### Layer 2: Classification Snapshot

Each artifact should have a local classification record that is separate from the raw content.

Suggested fields:

- `category`
- `confidenceBand`
- `safeScore`
- `riskScore`
- `triggeredSignals`
- `explanation`
- `normalizedText`
- `classifiedAt`
- `rulesVersion`

This preserves the shared trust-first core model across platforms.

### Layer 3: User Organization State

User organization should be modeled separately from raw message content and from the classifier decision.

Suggested fields:

- `savedViews`
- `pinnedCategories`
- `trustedSenders`
- `userLabels`
- `hiddenClutterPreference`
- `manualReviewMarks`

This is important because the app should help users find messages, not silently rewrite the core trust judgment.

## Source Types

Recommended source types:

- `manual_share`
- `manual_paste`
- `user_import_batch`
- `optional_notification_helper`
- `optional_future_default_sms`

For the preferred early Android model, only the first three should be considered primary.

## Data Acquisition Assumptions

The Android app should assume:

- sender text may be present or missing depending on the share/import path
- timestamp may be approximate or absent in some user-driven imports
- import sessions may contain only a subset of the user’s message history
- the app may never have a complete inbox view

This matters because UX, copy, and search behavior must not imply full inbox ownership.

## Local Storage Model

Storage should remain privacy-first and local by default.

Recommended principles:

- store only what the user explicitly provided
- keep provenance visible
- support deletion of imported/shared artifacts
- avoid unnecessary metadata retention
- do not require a cloud backend

## Search and Retrieval Model

The app should search only over artifacts it legitimately holds.

Recommended searchable fields:

- sender text
- raw message body
- normalized text
- category
- explanation text
- user labels
- source type

Recommended quick chips:

- Bank
- OTP
- Cargo
- Billing
- Hospital
- Official
- Promotional
- Suspicious

## Distribution Implications

This data model supports an organizer-first product, not a replacement inbox.

It is optimized for:

- categorized search
- important-message discovery
- suspicious/promotional grouping
- explanation-rich inspection
- user-controlled saved views

It is not optimized for:

- threaded conversations
- reply/send flows
- background delivery ownership

## Recommended Data Model Decision

Preferred Android MVP data model:

- treat every SMS-like input as a user-provided message artifact
- attach a local classification snapshot
- expose user organization as a separate view layer

This is the cleanest fit with:

- non-default-SMS positioning
- privacy-first handling
- Play-aware product boundaries
- cross-platform trust-first classification
