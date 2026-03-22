# Cross-Platform Core

## Shared Product Philosophy

The core should remain trust-first across iOS and Android:

- protect critical messages
- minimize false positives
- prefer allow over aggressive filtering
- provide explanations
- keep classification deterministic and reviewable

## Reusable Cross-Platform Core Concepts

The existing classification engine is conceptually reusable across platforms in these areas:

- Turkish-aware normalization
- deterministic rule engine
- safe-score and risk-score model
- conflict resolution
- confidence routing
- explanation generation
- trust-first classification policy

These concepts should remain platform-neutral.

## Shared Category Model

The same conceptual categories can be reused:

- `ALLOW_CRITICAL`
- `ALLOW_TRANSACTIONAL`
- `ALLOW_NORMAL`
- `REVIEW_SUSPICIOUS`
- `FILTER_PROMOTIONAL`
- `FILTER_SPAM`

Cross-platform consistency matters because users should see the same trust logic regardless of OS.

## Platform-Specific Boundaries

### iOS-specific

- SMS Filter Extension integration
- `IdentityLookup` action mapping
- extension execution constraints
- host app + extension coordination

### Android-specific

- message ingestion strategy
- permission and Play policy handling
- non-default-SMS UX design
- Android-specific storage and search flows

## Recommended Architecture Split

Shared conceptual core:

- normalization
- rules
- scoring
- explanation
- category policy

Platform-specific shell:

- data access
- permission handling
- runtime integration
- user interface
- persistence wiring

## Android Reuse Strategy

Android should reuse the classification logic conceptually and, where feasible, technically through:

- the same normalization policy
- the same rule families
- the same category semantics
- the same trust-first explanation style

Android should not attempt to reuse iOS-specific action models or extension assumptions.

## Realistic Android Adapter Path

The current Swift classification core should not be treated as directly reusable on Android.

Recommended Android adapter path:

- keep the shared product contract stable
- keep the shared category model stable
- keep explanation-oriented output stable
- implement an Android-native evaluator that mirrors the trust-first contract
- later move toward a shared rule/data representation if true cross-platform reuse becomes practical

This is more realistic than pretending a Swift engine can be called natively from the Android app without a deliberate shared-runtime strategy.

Recommended near-term Android approach:

- Android-native bridge layer
- Android-native deterministic evaluator
- contract-compatible snapshot output

Recommended future path:

- shared normalization/rule data definitions
- platform-native evaluators on iOS and Android
- or a deliberate true shared-runtime approach if the engineering cost is justified

## Why This Matters

This product is meant to help users comfortably reach the SMS messages they care about when they need them. The product should reduce clutter and improve discoverability. It should not force users into a new primary messaging workflow.

That vision should remain the same across platforms even when runtime capabilities differ.
