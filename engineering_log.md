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

## 2026-03-22 Step 21

- Refined top-level classifier output quality by stabilizing triggered-signal ordering before building the public result payload.
- Improved explanation behavior so output text is shorter, deterministic, rule-family-driven, and consistently aligned with critical, transactional, review, promotional, and spam outcomes.
- Added tests for explanation stability, deterministic triggered-signal ordering, normalized-text presence, and representative explanation wording.
- Output consistency improved because result fields now follow a more stable ordering and normalized text has a safer fallback path for low-signal inputs.
- Remaining limitation: explanations are intentionally concise summaries of dominant matched families, so they remain debug-friendly but not fully exhaustive descriptions of every triggered rule.

## 2026-03-22 Step 22

- Returned to the planned normalization phase and limited changes strictly to the normalization engine, normalization fixtures, normalization-focused tests, and this log entry.
- Strengthened adversarial text handling with broader invisible-character cleanup, safer repeated-character reduction, and targeted aggressive canonicalization for common Turkish spam obfuscations such as `bahis`, `iddaa`, `freebet`, `linke tiklayin`, and `kargonuz`.
- Expanded the normalization regression corpus with 20+ additional adversarial fixtures covering spaced tokens, punctuation injection, mixed leetspeak, repeated-noise spam terms, fake cargo/payment wording, phishing CTA fragmentation, and intact Turkish bank/OTP wording.
- Added focused normalization tests for repeated-noise `freebet`, invisible-character tricks, and multi-view auditability so readable normalized output, compact views, aggressive views, and tokens are all exercised together.
- Risks reduced: common Turkish spam evasions like `b.a.h.i.s`, `id-daa`, `fr3e-bet`, `linke\u200Ftiklayin`, and fragmented fake-cargo wording now normalize more consistently into comparable forms without relying on downstream rules alone.
- Remaining normalization blind spots: broader Unicode confusable alphabets outside the currently stripped ranges, sophisticated brand-lookalike strings/domains, and edge cases where aggressive compaction could still miss semantically disguised content or over-join rare legitimate fragments.

## 2026-03-22 Step 23

- Hardened normalization safety to reduce over-normalization and false-positive risk without changing decision logic or rules.
- Replaced naive aggressive substring replacement with token-level, boundary-aware canonicalization so only whole-token obfuscation families such as `bahis`, `iddaa`, `freebet`, `linke`, `tiklayin`, and `kargonuz` are normalized.
- Restricted repeated-character collapsing to tokens that both contain clear elongated noise and still resemble a known spam/obfuscation family after collapse; normal Turkish elongations are left intact.
- Tightened compaction safety by allowing single-character token joining only when the joined candidate matches a suspicious obfuscation target, instead of merging arbitrary short word runs.
- Added false-positive and near-miss normalization tests for ordinary spaced words, normal Turkish elongation, `linkedin/tiklama/iddianame`-style near misses, and partial-word bahis variants that should not be canonicalized into spam tokens.
- Over-normalization risks reduced: partial-word corruption, accidental joining of unrelated words, and aggressive collapse of normal Turkish text.
- Remaining intentional conservatism: some cleverly fragmented but non-canonical obfuscations may now require downstream rule context rather than normalization alone, which is preferable to creating new false positives in safe messages.

## 2026-03-22 Step 24

- Added an extra normalization safety guard for spaced-token compaction by rejecting suspicious-run joins outside a tight candidate-length window, which lowers the chance of joining unrelated short words into accidental spam-like tokens.
- Expanded false-positive regression coverage with harmless punctuation, normal telecom/package wording, and normal bank OTP phrasing so readable safe text stays intact and does not drift toward phishing or gambling-style aggressive forms.
- Reduced over-normalization risk further for benign conversational text and safe operational SMS phrasing, while keeping aggressive views available for clear obfuscation candidates.
- Remaining blind spots: highly creative multi-token obfuscations that do not land near current suspicious candidates, and Unicode confusable tricks that preserve whole-token shapes without using the currently stripped invisible marks.

## 2026-03-22 Step 25

- Expanded Turkish fixture coverage substantially while preserving the trust-first model: the corpus now includes 60 critical fixtures, 56 transactional fixtures, 70 spam/promotional fixtures, and 55 mixed-signal conflict fixtures.
- Added higher-value fixture families for bank login alerts, OTP and activation flows, suspicious transaction notices, card spending and payment confirmations, cargo branch/delivery states, telecom billing and package renewals, hospital reminders/results, e-commerce shipment states, fake cargo fee traps, fake bank credential phishing, urgency/prize scams, and mixed Turkish-English spam.
- Expanded deterministic rule families across critical protection, transactional-safe, promotional, spam-risk, and phishing-risk layers with more Turkish wording variants and stronger impersonation-plus-action combinations.
- False-positive precautions preserved: critical-safe rules still rely on explicit protected-account phrasing, transactional rules stay oriented toward operational wording, promotional rules remain separate from spam, and mixed safe+risky examples were added mainly to the conflict bank rather than force more direct spam filtering.
- Added targeted tests for new critical suspicious-transaction/device-approval variants, telecom/e-commerce transactional variants, gift-voucher promotional copy, mixed Turkish-English bahis spam, and impersonation-plus-urgency phishing combinations.
- Remaining blind spots before iOS extension integration: more long-tail institutional sender phrasing across smaller Turkish brands, more sophisticated brand-spoof domains that do not use obvious TLD/link patterns, and real-device build verification in an Apple toolchain environment.

## 2026-03-22 Step 26

- Added a final trust-hardening pass for sender/domain spoofing and long-tail Turkish operational phrasing before iOS extension integration.
- Expanded fixtures with smaller-bank security wording, private hospital/clinic reminders, smaller logistics providers, utility billing notices, spoofed sender-name variants, lookalike bank/cargo domains, and realistic safe-looking messages that pivot into payment, credential entry, or urgent action.
- Strengthened phishing/spam coverage for fake support or verification language, sender impersonation hints such as `Guvenlik` and `Destek`, and brand-like suspicious domains embedding bank/cargo names inside risky TLD patterns.
- Preserved trust-first behavior by routing trusted-looking sender plus suspicious-action patterns into the conflict/review bank rather than forcing direct spam when strong safe context is also present.
- Added targeted tests for spoofed sender names, fake bank/cargo domains, private clinic legitimate reminders, utility billing versus fake payment phishing, and trusted-looking sender bodies that request suspicious action.
- Spoofing risks reduced: sender-name cosmetics and brand-like domains now contribute more consistent risk signals, especially when combined with urgency, payment, or credential prompts.
- Remaining blind spots before extension integration: sender reputation is still text-only in this local MVP, advanced homoglyph domains beyond current normalization/link heuristics remain partially uncovered, and real extension-time behavior still needs verification in an Apple build environment with live SMS Filter APIs.

## 2026-03-22 Step 27

- Completed the first minimal iOS integration boundary pass without refactoring the shared trust-first classifier core.
- Added a clearer extension-facing outcome wrapper so the SMS Filter Extension side can receive request, response, mapped action, category, confidence, and explanation through one reviewable type.
- Expanded the host-app bridge slightly so it can accept either raw sender/body values or the shared `FilterClassificationRequest`.
- Updated iOS integration documentation to describe the host-app call path, extension call path, request/response contract, and Apple platform constraints such as coarse action mapping, offline execution, and likely App Group needs.
- Platform constraints noted explicitly: iOS SMS filtering is limited by `IdentityLookup`, there is no rich system review bucket, and the extension will likely only surface allow/junk while the host app preserves internal review semantics.
- What remains before a usable SMS Filter Extension prototype exists: real Xcode targets, `IdentityLookup` callback glue, build verification in an Apple toolchain, and minimal host-app audit/review screens backed by optional App Group persistence.

## 2026-03-22 Step 28

- Added the first real Apple-platform glue layer for SMS filtering under `ios/FilterExtension` using `IdentityLookup`-gated code paths.
- Implemented a minimal `MessageFilterExtension` entry point that handles capabilities queries, accepts `ILMessageFilterQueryRequest`, calls `IdentityLookupAdapter.classifyOutcome(sender:messageBody:)`, and maps the result into `ILMessageFilterQueryResponse.filterAction`.
- Mapping decisions remain trust-first and conservative: `ALLOW_CRITICAL`, `ALLOW_TRANSACTIONAL`, and `ALLOW_NORMAL` map to allow; `FILTER_PROMOTIONAL` and `FILTER_SPAM` map to junk; `REVIEW_SUSPICIOUS` also maps to allow because Apple does not expose a native review bucket and the product must avoid overblocking uncertain messages.
- Preserved rich internal outcome data by keeping category, confidence, explanation, and the full classification result in `ExtensionClassificationOutcome`, even though the Apple action surface is coarse.
- Added minimal host-app native scaffolding for future App Group/shared defaults and settings integration via `AppGroupConfiguration` and `HostAppIntegrationEnvironment`.
- Platform constraints documented more explicitly: limited sender/body inputs, no user-facing explanation surface inside the extension path, offline execution expectations, and the need to validate `IdentityLookup` behavior in Xcode.
- Remaining blockers before a working iOS prototype: actual Xcode project/targets, principal class registration, entitlements/App Group setup, build verification against Apple SDKs, and on-device validation of request data and response mapping.

## 2026-03-22 Step 29

- Completed an Xcode-readiness pass focused on reducing ambiguity before the first real Apple build and SMS Filter Extension validation run.
- Added minimal template scaffolding for manual Xcode setup: host-app App Group entitlements, filter-extension App Group entitlements, and a filter-extension Info.plist template with the required principal class registration shape.
- Expanded iOS documentation with exact Xcode setup steps, manual configuration items, simulator-versus-device guidance, and a concrete runtime validation checklist covering build, extension loading, sender/body availability, category-to-action mapping, App Group access, and offline/performance expectations.
- Documented what cannot be trusted until real runtime validation, especially principal-class registration, actual `IdentityLookup` request contents, App Group behavior, and the user-visible effect of `REVIEW_SUSPICIOUS -> allow`.
- Remaining blockers before the first usable prototype: creating the actual Xcode project/targets, assigning signing and bundle identifiers, enabling entitlements/App Groups in Xcode, and validating the full flow on a physical iPhone with the Apple Messages filtering runtime.

## 2026-03-22 Step 30

- Completed the Android strategy and feasibility pass without turning the product into a default SMS app design.
- Added Android strategy, limitations, cross-platform-core, UX, and phased implementation documents, plus a lightweight `android/` placeholder directory.
- Chose a conservative Android direction: organizer, classifier, and search assistant first; default-SMS-app behavior is explicitly deferred as an optional future path.
- Documented the main Android constraint that broad SMS access on Play-distributed Android is policy-sensitive unless the app becomes the default handler or qualifies for a narrow exception path.
- Preserved the cross-platform trust model: critical-message protection, explainable classification, and conservative suspicious handling remain central on Android.
- Main remaining uncertainty: whether a strong Android inbox-organization experience can be delivered on Play-distributed devices without drifting into a default-SMS or policy-sensitive SMS-permission posture.

## 2026-03-22 Step 31

- Completed the Android ingestion and distribution decision pass with a stricter product boundary: the app should organize and classify only the SMS-like artifacts it is legitimately given, not act as the canonical owner of the device inbox.
- Added dedicated Android documents for data modeling, ingestion options, distribution options, and policy risks, then realigned `plans_android.md` around the chosen model.
- Evaluated multiple ingestion paths: manual share-in, paste/analyze flow, explicit local batch import from user-supplied material, notification-adjacent helper concepts, broad SMS-provider access, and the separate future default-SMS-app path.
- Recommended a conservative primary Android ingestion model:
  - primary: manual share-in from the user’s existing messaging app
  - secondary: paste/analyze flow
  - optional later enhancement: explicit user-initiated local archive import from user-supplied material
- Recommended a conservative Android distribution model:
  - primary surface: Important Messages Finder
  - primary interaction: Categorized Search Assistant
  - secondary surfaces: Suspicious and Promotional review views
  - supporting surface: explanation-rich Analysis Workspace
- Policy and trust risks were tightened explicitly:
  - avoid broad `READ_SMS` dependence in a non-default app
  - avoid notification-listener drift as a hidden primary pipeline
  - avoid product copy that implies automatic Android-wide filtering or inbox ownership
  - keep suspicious handling conservative and explainable
- Product-vision protection was made explicit again: Android should reduce clutter and improve discoverability without forcing a new primary messaging workflow.
- Biggest remaining Android uncertainty: whether user-initiated ingestion has enough convenience and repeat value to support a compelling Play-safe early product without sliding toward restricted SMS access.

## 2026-03-22 Step 32

- Completed the minimal Android shell architecture pass without building a full Android app and without drifting into default-SMS assumptions.
- Added dedicated Android shell documents for architecture, data flow, screen flow, local storage, and privacy boundaries.
- Defined the minimum Android-side layers as:
  - ingestion adapters
  - artifact intake coordinator
  - classification bridge
  - local artifact store
  - search/distribution layer
  - privacy/settings layer
- Designed three ingestion flows explicitly:
  - share-in from another app
  - paste/analyze inside the app
  - future explicit local artifact import
- Kept storage behavior conservative:
  - immediate analysis is allowed without forced saving
  - saved artifacts remain local
  - provenance is attached to each artifact
  - deletion removes both artifact and classification snapshot
- Defined the smallest useful Android surface set:
  - Home
  - Analyze Input
  - Analysis Result
  - Important Messages
  - Search
  - Review
  - Message Detail
  - Settings and Privacy
- Preserved product-boundary guardrails:
  - no inbox-thread-first shell
  - no reply/send workflow
  - no unread semantics implying inbox ownership
  - no hidden ingestion assumptions
- Realigned `plans_android.md` for the next implementation stages: minimal scaffold, ingestion entry points, local artifact storage, classification bridge, categorized search surfaces, privacy/settings, and validation/store-readiness.
- Biggest remaining Android UX risk: user-initiated ingestion may still feel too high-friction unless the first organizer/search surfaces are immediately useful and explanation-rich after a message is shared or pasted.

## 2026-03-22 Step 33

- Added the first minimal Android implementation scaffold under `android/` without turning the product into a messaging client.
- Introduced a lightweight Gradle/app structure with a single Android app module, manifest, and placeholder Compose activity.
- Added minimal architecture-aligned Kotlin layers:
  - `model` for message artifacts and classification snapshots
  - `ingestion` for analyze request/result flow and artifact intake coordination
  - `classification` for a placeholder bridge boundary
  - `storage` for a local artifact store abstraction and in-memory implementation
  - `search` for basic organizer/search repository logic
  - `settings` for privacy summary placeholder state
  - `appshell` for minimal placeholder screens
- Added placeholder screens for:
  - Home
  - Analyze Input
  - Analysis Result
  - Important Messages
  - Search
  - Message Detail
  - Settings and Privacy
- Kept product boundaries explicit in code:
  - no SMS permissions
  - no default-SMS assumptions
  - no inbox ownership
  - only user-provided artifact flows
- What remains placeholder:
  - classification bridge still returns a stub result
  - local storage is in-memory only
  - navigation is screen-state based, not a production navigation stack
  - no real share target or import flow is wired yet
- Next implementation step should be:
  - wire the real share-in and paste/analyze entry points
  - replace the placeholder classification bridge with a real shared-core adapter
  - move from in-memory storage to a real local artifact store

## 2026-03-22 Step 34

- Implemented the first real functional Android slice for the paste/analyze flow while preserving the non-default-SMS product boundary.
- Replaced the purely in-memory app flow with a lightweight Room-backed local artifact store:
  - added artifact and classification entities
  - added DAO and Room database
  - added `RoomLocalArtifactStore`
  - added `AppContainer` to provide a single local store, coordinator, bridge, and search repository
- Made the paste/analyze flow end-to-end inside the Android shell:
  - user enters sender and message body
  - `ArtifactIntakeCoordinator` validates input
  - placeholder `ClassificationBridge` returns a classification snapshot
  - analyzed artifact is persisted immediately
  - Analysis Result, Home, Important, Search, and Detail all read from the same local store
- Kept the architecture conservative:
  - no SMS permissions
  - no share target yet
  - no inbox ownership assumptions
  - only user-provided artifacts are analyzed and stored
- Added lightweight JVM-side tests for:
  - analyze-and-persist behavior
  - validation failure behavior
  - search behavior
  - important/suspicious bucket behavior
- Storage decision:
  - chose Room as the first persistent local store because it keeps artifact/snapshot relationships explicit, local-first, and easy to replace later with richer persistence patterns
  - allowed main-thread queries temporarily to keep this first slice minimal; this should be removed once view models and async loading are added
- What remains placeholder:
  - classification bridge still uses stub output and is not wired to the shared classifier core
  - navigation is still simple screen-state switching
  - no share-in flow is wired yet
  - no import flow is wired yet
- Next recommended Android step:
  - replace the placeholder classification bridge with a real shared-core adapter
  - then add a real share-in entry point so the organizer can ingest message artifacts from outside the app without changing the non-default-SMS posture

## 2026-03-22 Step 35

- Completed the Android classification-adapter strategy pass before adding share target integration.
- Evaluated realistic adapter paths:
  - direct reuse of the current Swift core on Android was rejected as unrealistic for this stage
  - a fragile “pretend-shared” shortcut was rejected because it would hide real platform differences
  - a stable Android-native evaluator aligned to the shared contract was chosen as the safest near-term path
- Chosen path:
  - keep the Android `ClassificationBridge` boundary stable
  - introduce Android-native classification contract types for category and confidence
  - implement a deterministic heuristic bridge that mirrors the trust-first cross-platform worldview
  - keep the output contract compatible with existing Android storage and UI layers
- Implemented `HeuristicClassificationBridge` as the first realistic non-placeholder Android classifier layer.
- Preserved cross-platform alignment through:
  - the same category model
  - the same important-vs-junk worldview
  - trust-first critical protection
  - explanation-oriented output
  - conservative review routing for mixed safe/risky messages
- Updated the Android app container to use the heuristic bridge instead of the stub bridge.
- Added contract-level tests for:
  - critical bank/OTP behavior
  - transactional cargo behavior
  - clear bahis spam behavior
  - fake-bank mixed-signal review behavior
  - promotional behavior
  - harmless normal-message behavior
- Why this path is realistic:
  - it gives Android a real local classifier now
  - it avoids pretending Swift can be reused directly inside the Android runtime
  - it leaves room for a future shared rule/data representation without breaking Android app boundaries
- What remains before share target integration:
  - classifier coverage is still much narrower than the full Swift trust core
  - Android normalization/rule detail still needs to deepen if the app becomes more user-facing
  - the placeholder bridge file can be retired once the real adapter path is fully stabilized

## 2026-03-22 Step 36

- Completed a focused Android classifier hardening pass before adding the first external share-in flow.
- Strengthened the Android heuristic classifier in three areas:
  - broader critical-safe wording for bank, OTP, security, payment, and spend alerts
  - broader transactional wording for cargo, billing, telecom, and appointment reminders
  - stronger risk detection for bahis/casino/freebet spam, fake cargo payment scams, fake bank credential phishing, and mixed safe-looking phishing conflicts
- Improved Android-side normalization conservatively:
  - Turkish casing and ASCII folding are now handled correctly
  - lightweight obfuscation handling was added for core spam terms and CTA patterns such as `b@his`, `fr33bet`, and `linke tiklayin`
  - normalization remains intentionally modest to avoid over-normalization and false positives
- Preserved the trust-first contract:
  - critical-looking messages do not go directly to spam under mixed-signal conditions
  - mixed safe+risky bank and cargo messages tend toward `REVIEW_SUSPICIOUS`
  - clearly malicious weak-safe bahis/phishing examples can still reach `FILTER_SPAM`
- Added focused Android classifier tests for:
  - critical protection
  - transactional routing
  - fake bank and fake cargo mixed-signal review behavior
  - clear bahis/phishing spam
  - promotional versus spam distinction
- What still differs from the Swift core:
  - Android normalization is much lighter
  - Android rule coverage is narrower and not yet layered as deeply as the Swift trust core
  - explanation generation is simpler and contract-oriented rather than policy-complete
- Why share target is safer after this pass:
  - the first externally ingested messages are less likely to misroute obvious critical wording
  - obvious gambling/phishing content is more likely to land in the intended suspicious/spam buckets
  - mixed safe-looking scams are more likely to be surfaced conservatively as review instead of being over-filtered or ignored

## 2026-03-22 Step 37

- Added the first Android share target flow for user-controlled text sharing without changing the non-default-SMS product boundary.
- Updated the Android manifest so the app can receive `ACTION_SEND` payloads for `text/plain`.
- Added a lightweight `SharedTextIntakeParser` and `SharedTextCandidate` so external shared text is parsed conservatively before entering the organizer shell.
- Wired `MainActivity` to:
  - inspect launch intents for shared text
  - reopen safely on new share intents
  - pass valid shared text into the existing app shell
- Wired the app shell so shared text:
  - pre-fills the Analyze Input screen
  - is labeled as user-shared content
  - still requires explicit user review and analyze action before classification and storage
- Preserved privacy and trust boundaries:
  - no silent background ingestion
  - no automatic inbox ownership
  - no SMS permissions
  - no forced analysis without user action
- Added lightweight intake tests for:
  - valid shared-text parsing
  - blank payload rejection
  - wrong-action rejection
  - wrong-mime-type rejection
- What still remains before the first Android prototype is really usable:
  - the Android classifier is still a heuristic bridge, not a shared-rule implementation
  - share payload parsing is body-first and does not reliably recover sender metadata
  - navigation is still minimal screen-state navigation
  - the app still needs real Android build/runtime validation for chooser/share behavior
