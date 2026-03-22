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

## 2026-03-22 Step 13

- Hardened the normalization layer for adversarial Turkish spam patterns by improving invisible-character cleanup, punctuation normalization, single-character token joining, repeated-character noise reduction, leetspeak handling, and multi-view output generation.
- Added token output alongside readable normalized text, compact text, and aggressive compact text so matching is stronger without losing auditability.
- Expanded normalization fixtures from the original starter set to a larger adversarial set covering spaced bahis/iddaa, punctuation injection, mixed obfuscation, fake cargo variations, phishing CTA variants, repeated-character noise, and safe Turkish bank/OTP phrases.
- Added focused normalization tests for bahis obfuscation, iddaa obfuscation, phishing-like CTA obfuscation, fake cargo wording variations, and safe bank/OTP wording preservation.
- Reduced risk of missing common Turkish spam evasions such as `b a h i s`, `ba-his`, `b@h!s`, `1ddaa`, invisible characters, and repeated-letter bait.
- Remaining risks: normalization still does not solve all Unicode confusable attacks, brand-lookalike domain tricks, or Turkish morphology edge cases; those still depend on downstream rules and future targeted fixtures.

## 2026-03-22 Step 14

- Improved `ClassifierConfiguration` normalization so allowlist/denylist and whitelist/blacklist matching align better with the main text normalization behavior instead of relying on only trim-and-lowercase.
- Added lighter-weight config normalization for Turkish casing, ASCII fallback, punctuation collapsing, and compact matching so sender and term matching are more consistent without becoming as aggressive as full body normalization.
- Covered new configuration edge cases including Turkish sender-name variations, spacing/punctuation changes in senders, Turkish/ASCII whitelist term matching, and normalized blacklist term matching.
- Preserved conservative behavior: user preferences still do not gain enough power to silently break critical bank/OTP protection.

## 2026-03-22 Step 15

- Expanded the local Turkish fixture corpus significantly across critical-safe, transactional-safe, spam/phishing, promotional, and mixed-signal conflict categories.
- Added more realistic Turkiye-focused scenarios for bank login alerts, OTP flows, card spending alerts, cargo tracking, delivery windows, telecom billing and package messages, hospital reminders, e-commerce fulfillment, fake cargo fee traps, fake bank credential phishing, bahis/casino/freebet spam, and urgency/prize scams.
- Added more adversarial fixtures covering obfuscated bahis variants, suspicious URLs, mixed Turkish-English junk, and safe-looking messages combined with malicious instructions.
- Increased regression expectations in tests so the larger fixture banks are exercised automatically.
- These fixture expansions matter because regression safety for a trust-first filter depends on broad Turkish scenario coverage, especially around critical false positives and realistic phishing conflicts.
- Still underrepresented: long-tail regional brand phrasing, more healthcare-provider wording variants, more government-notice phrasing, and highly sophisticated Unicode confusable attacks.

## 2026-03-22 Step 16

- Expanded deterministic rule coverage across critical protection, transactional-safe, promotional, spam-risk, and phishing-risk rule families to better match realistic Turkish SMS phrasing.
- Added broader OTP, activation, login, device, card-spend, payment-confirmation, cargo-state, telecom-package, retail-promo, bahis/casino, fake cargo fee, fake bank credential, and impersonation-plus-urgency rule patterns.
- Preserved false-positive precautions by keeping strong critical-safe rules separate and high-priority, while allowing mixed safe+risky patterns to remain review-oriented rather than aggressively filtered.
- Added focused tests for the new rule families so coverage is not only fixture-driven but also behavior-specific.
- Remaining blind spots: more subtle bank-phishing wordsmithing that avoids classic credential terms, sender-level brand spoofing nuances, and long-tail institutional phrasing across smaller Turkish service providers.

## 2026-03-22 Step 17

- Re-tuned decision thresholds after the larger fixture and rule expansion so transactional allows require stronger evidence, weak-safe spam escalates more reliably, and critical-safe fallback behaves more cautiously when risk is present.
- Tightened routing so mixed safe+risky cases still lean toward review, while clearly malicious low-safe spam/phishing is less likely to be over-routed into `REVIEW_SUSPICIOUS`.
- Refined confidence bands so `ALLOW_CRITICAL` stays high only with explicit critical evidence, `REVIEW_SUSPICIOUS` remains intentionally uncertain, and promotional results do not present misleadingly high certainty.
- Added targeted decision tests for strong-safe-plus-weak-risk allows, low-safe clear spam, mixed fake bank/cargo review routing, legitimate campaign-like messages, and confidence-band expectations.
- What became safer: critical-looking messages with non-trivial risk now review more consistently, weak transactional hints no longer over-upgrade, and clear spam gets filtered with less hesitation when safe evidence is weak.
- What remains intentionally conservative: mixed bank/cargo impersonation patterns still prefer review over spam, and review confidence stays below high to reflect uncertainty rather than overclaiming precision.

## 2026-03-22 Step 18

- Improved top-level classifier output consistency so every result continues to carry category, confidence band, safe/risk scores, triggered signals, explanation, and normalized text even for low-signal inputs.
- Refined explanation generation to be shorter, more deterministic, and more directly tied to matched rule families rather than whichever hint happened to appear first.
- Added explicit explanation wording for critical-safe, cargo-review, gambling-spam, promotional, and generic review/normal paths, while keeping review phrasing informative but not overconfident.
- Added tests for explanation presence, explanation stability, triggered signal population, normalized text presence, and deterministic explanation text for representative critical/review/spam scenarios.
- Remaining limitation: explanations summarize dominant matched families rather than enumerating every trigger, so they are optimized for concise debugging rather than exhaustive forensic detail.

## 2026-03-22 Step 19

- Prepared the project for future iOS SMS Filter Extension integration without moving core logic into platform-specific code.
- Added a small platform-agnostic integration boundary in `ClassificationCore` with request/response models, a service protocol, and disposition mapping for allow/review/junk flows.
- Documented how an extension should call the classifier, what input it passes, what output it receives, and where Apple-specific API mapping should live.
- Added lightweight integration-facing tests to confirm the adapter returns stable allow/review/junk dispositions on representative critical, mixed-signal, and spam inputs.
- Next recommended implementation step: create the actual Xcode SMS Filter Extension target and map `FilterDisposition` into Apple framework callbacks while preserving the internal `ClassificationResult` for host-app visibility and auditing.

## 2026-03-22 Step 20

- Added the first minimal iOS-facing scaffold under `ios/` without refactoring the trust-first classification core.
- Added a thin host-app bridge for local preview/audit calls and a thin extension-side adapter/mapper for future SMS Filter Extension integration.
- Documented Apple-side constraints such as coarse allow/junk action mapping, the likely need for App Group persistence, and the lack of a native system-level review bucket.
- What still remains before a usable iOS extension exists: real Xcode targets, `IdentityLookup` framework glue, entitlements/App Group setup, and a minimal host-app surface to inspect review/audit results.
- Current blocker/limitation: this repository still does not contain an actual Xcode project or installed Apple toolchain, so the new iOS scaffold is structural rather than build-verified.
