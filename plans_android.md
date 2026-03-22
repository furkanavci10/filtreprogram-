# Android Plan

## Product Boundary

The Android version should reduce clutter and improve message discoverability without forcing users into a new primary messaging workflow.

## Phase 1: Constraints and Policy Research

Goal:

- lock the Android product boundary before implementation

Likely files/modules:

- `docs/ANDROID_STRATEGY.md`
- `docs/ANDROID_LIMITATIONS.md`
- `docs/CROSS_PLATFORM_CORE.md`
- `docs/ANDROID_UX_CONCEPT.md`

Main risks:

- overclaiming Android capabilities
- drifting into default-SMS assumptions
- Play policy exposure

Acceptance criteria:

- Android strategy is conservative and explicit
- product promises are bounded clearly
- default-SMS path is optional, not assumed

## Phase 2: Ingestion and Distribution Decision

Goal:

- choose the primary Android ingestion and user-facing distribution model

Likely files/modules:

- `docs/ANDROID_DATA_MODEL.md`
- `docs/ANDROID_INGESTION_OPTIONS.md`
- `docs/ANDROID_DISTRIBUTION_OPTIONS.md`
- `docs/ANDROID_POLICY_RISKS.md`

Main risks:

- choosing a model that depends on restricted SMS permissions
- drifting into replacement-inbox territory
- overpromising Android capabilities

Acceptance criteria:

- one preferred Play-aware ingestion model is chosen
- one preferred organizer/search distribution model is chosen
- policy and trust tradeoffs are documented explicitly

## Phase 3: Minimal Android Shell Architecture

Goal:

- define the minimum Android app shell that fits the chosen organizer/search-assistant model

Likely files/modules:

- `docs/ANDROID_SHELL_ARCHITECTURE.md`
- `docs/ANDROID_DATA_FLOW.md`
- `docs/ANDROID_SCREEN_FLOW.md`
- `docs/ANDROID_LOCAL_STORAGE.md`
- `docs/ANDROID_PRIVACY_MODEL.md`

Main risks:

- shell starts to look like an inbox replacement
- storage or flow design implies hidden inbox ownership
- ingestion and distribution layers become overbuilt too early

Acceptance criteria:

- minimal shell architecture is documented
- ingestion and distribution flows are explicit
- local storage and privacy boundaries are clear
- app remains clearly outside default-SMS territory

## Phase 4: Minimal Android Scaffold

Goal:

- create the first lightweight Android project/module shell without overbuilding UI

Likely files/modules:

- future `android/app-shell`
- future `android/navigation`
- future `android/model`

Main risks:

- architecture drift into a messaging client
- premature UI complexity

Acceptance criteria:

- project/module skeleton exists
- app shell is clearly organizer/search-oriented
- no screen implies inbox ownership

## Phase 5: Ingestion Entry Points

Goal:

- implement the recommended Play-aware ingestion path

Likely files/modules:

- future `android/ingestion`
- future `android/share`
- future `android/import`

Main risks:

- user friction may be too high
- imported/shared data may be incomplete
- provenance may be unclear

Acceptance criteria:

- manual share-in works end to end
- paste/analyze flow works end to end
- imported artifacts retain clear provenance and deletion controls

## Phase 6: Local Artifact Storage

Goal:

- persist user-provided artifacts and classification snapshots locally

Likely files/modules:

- future `android/storage`
- future `android/model`
- future `android/search`

Main risks:

- unclear retention behavior
- deletion behavior is too weak or confusing
- provenance gets lost

Acceptance criteria:

- artifact storage is local and auditable
- classification snapshots are linked clearly
- delete and clear-history behavior is defined

## Phase 7: Classification Bridge

Goal:

- connect Android-ingested message artifacts to the trust-first classifier

Likely files/modules:

- future `android/classification`
- future `android/model`
- future shared core adapter layer

Main risks:

- ingestion metadata mismatch
- poor explanation presentation
- confusion between suspicious and junk buckets

Acceptance criteria:

- artifacts can be classified locally
- category, confidence, and explanation are shown
- critical-safe behavior is preserved

## Phase 8: Categorized Search Surfaces

Goal:

- build the smallest useful organizer/search UI surfaces

Likely files/modules:

- future `android/ui/home`
- future `android/ui/important`
- future `android/ui/search`
- future `android/ui/review`
- future `android/ui/detail`

Main risks:

- drifting into inbox-style UX
- weak explanation UX
- search feels too shallow for repeat use

Acceptance criteria:

- Important Messages surface exists
- Search with category chips exists
- Suspicious/Promotional review exists
- Message detail explains the result clearly

## Phase 9: Privacy and Settings

Goal:

- add explicit privacy boundaries and conservative user controls

Likely files/modules:

- future `android/settings`
- future `android/preferences`
- future `android/privacy`

Main risks:

- settings become too complex
- privacy language is vague
- preferences weaken trust-first defaults

Acceptance criteria:

- privacy boundary is explicit in-app
- retention and deletion controls are visible
- conservative preferences exist without weakening critical-safe behavior

## Phase 10: Validation and Store Readiness

Goal:

- prepare for Play review and realistic release posture

Likely files/modules:

- compliance docs
- store listing drafts
- privacy disclosures
- permission rationale text

Main risks:

- policy rejection
- misleading store claims
- privacy/trust mismatch
- product still feels too weak under user-initiated ingestion

Acceptance criteria:

- product copy stays within organizer/search-assistant promises
- permissions are minimized and defensible
- no release claim depends on default-SMS behavior
- early usability and trust assumptions are validated
