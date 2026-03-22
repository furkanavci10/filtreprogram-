# Engineering Log

## 2026-03-22 Step 1

- Inspected workspace.
- Confirmed the directory was effectively empty and not a git repository.
- Chose design-first execution as required.

## 2026-03-22 Step 2

- Created required repository-level documentation structure.
- Added PRD, system design, classification policy, threat model, test strategy, decisions, plan, implementation notes, and README.
- Implementation intentionally deferred until all mandatory design docs are complete.

## 2026-03-22 Step 3

- Added a 200-example Turkish synthetic SMS dataset spanning safe, suspicious, promotional, and spam categories.
- Added 100 Turkish edge cases focused on normalization, spoofing, obfuscation, mixed signals, and conservative fallback behavior.

## 2026-03-22 Step 4

- Created a Swift Package structure for the local MVP core.
- Implemented `ClassificationCore`, `RulesEngine`, `Dataset`, and starter tests.
- Added iOS module placeholder directories for the future SwiftUI app and SMS Filter Extension integration.

## 2026-03-22 Step 5

- Refactored shared models into a separate domain module to avoid circular dependencies between the classifier and rule engine.

## 2026-03-22 Step 6

- Attempted to verify the Swift toolchain in the current environment.
- `swift --version` failed because the Swift toolchain is not installed on this machine, so package build/test execution could not be completed here.
- Performed static review of the created source tree and preserved the missing-toolchain limitation in the implementation status.

## 2026-03-22 Step 7

- Refined the product trust model in the PRD, system design, classification policy, and decision log.
- Elevated bank/security/OTP/account-access/payment-confirmation messages to explicit highest-priority protection.
- Added dedicated sections for why bank messages must be strongly protected and how user-controlled filtering should focus on bahis, casino, promotional junk, and selected ad patterns.
- Paused further implementation work until the updated trust-first spec is clearly reflected and reviewed.

## 2026-03-22 Step 8

- Redefined the policy and system docs around a layered trust-first decision engine with a hard protection layer and dual `SAFE_SCORE` / `RISK_SCORE` scoring.
- Documented conservative conflict resolution: when safe and risky signals coexist, the system must prefer review and never direct filtering.
- Added Turkish example pairs for safe vs scam bank messages, safe vs fake cargo, and OTP vs phishing flows.
- Kept implementation paused pending spec alignment review.

## 2026-03-22 Step 9

- Rebuilt the local classification core around expanded domain models, Turkish-aware normalization, explicit deterministic rule definitions, dual safe/risk scoring, confidence bands, and deterministic explanation generation.
- Split rules into critical protection, transactional safe, promotional, spam risk, phishing risk, and user preference groups so behavior is easier to review and test.
- Added user configuration support for bahis filtering, promotional aggressiveness, filtering strength, and local allowlist/denylist terms.

## 2026-03-22 Step 10

- Replaced starter fixtures with larger normalization and classification fixture sets covering critical-safe, transactional, spam/promotional, and conflict/phishing examples.
- Added milestone test coverage targeting normalization, critical protection, transactional routing, spam/promotional routing, conflict handling, explanations, and user preference behavior.
- Attempted to run `swift test`, but the Swift toolchain is still unavailable in this environment, so execution could not be verified locally.

## 2026-03-22 Step 11

- Refined the decision engine so `ALLOW_CRITICAL` depends on explicit critical protection evidence instead of a generic high safe score.
- Replaced broad conflict routing with score-gap-based handling so safe-dominant messages can still allow, close contests route to review, and risk-dominant low-safe messages can escalate to spam.
- Centralized promotional routing and tightened confidence-band behavior so review remains an uncertainty bucket and high confidence spam requires strong severe-risk evidence.
- Added targeted tests for high-safe transactional routing, safe-plus-weak-risk allow behavior, clear bahis spam escalation, fake cargo/bank review conflicts, and protected explicit bank security messages.

## 2026-03-22 Step 12

- Tightened promotional routing so campaign-like content is not filtered too early when transactional or other safe evidence is present.
- Made the critical-protection fallback more conservative so non-trivial risk in critical-looking messages now tends toward review unless the message is clearly safe-critical.
- Added a broader high-risk spam path for clearly malicious bahis/phishing content with weak safe evidence, even when the previous severe-risk path is not the only trigger.
- Tightened `ALLOW_TRANSACTIONAL` so weak transactional hints and tiny score leads do not automatically become transactional classification.
- Added tests for telecom campaign-like messages, mixed-signal fake bank review behavior, strong phishing spam escalation, and weak transactional hints.
