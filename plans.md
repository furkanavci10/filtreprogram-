# Implementation Plan

## Milestone 1

- Goal: Build the deterministic local classifier core with a small embedded dataset and strong critical-safe protections.
- Files:
  - `Package.swift`
  - `Sources/ClassificationCore/*`
  - `Sources/RulesEngine/*`
  - `Sources/Dataset/*`
  - `Tests/*`
- Tests:
  - normalization tests
  - critical protection tests
  - spam detection tests
  - dataset-driven regression tests
- Acceptance criteria:
  - classifier returns category, confidence, explanation, triggered rules
  - critical OTP/bank examples classify safely
  - obvious bahis/scam examples classify as spam or review according to policy
  - all tests pass

## Milestone 2

- Goal: Add local configuration, sender allowlist/denylist, and richer explanation formatting.
- Files:
  - `Sources/ClassificationCore/Configuration/*`
  - `Sources/App/*`
  - `Tests/Configuration*`
- Tests:
  - override precedence
  - persistence round-trip
  - explanation regression
- Acceptance criteria:
  - user overrides change future classifications locally
  - shared settings model remains deterministic

## Milestone 3

- Goal: Integrate with iOS host app and SMS Filter Extension skeleton.
- Files:
  - `ios/App/*`
  - `ios/FilterExtension/*`
- Tests:
  - integration smoke tests
  - extension mapping tests
- Acceptance criteria:
  - host app can invoke classifier
  - extension maps internal categories to platform actions safely

## Milestone 4

- Goal: Expand regression corpus and adversarial defenses for Turkish obfuscation.
- Files:
  - `docs/DATASET_TR.md`
  - `docs/EDGE_CASES_TR.md`
  - `Tests/Adversarial*`
- Tests:
  - expanded dataset sweep
  - edge-case suite
- Acceptance criteria:
  - edge-case regressions remain green
  - no critical false positives introduced
