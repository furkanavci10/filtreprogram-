# System Design

## 1. Design Goals

- Offline-first and fully functional without backend
- Low false positives for critical Turkish SMS
- Deterministic and explainable outputs
- Reusable pure Swift core for both app and extension
- Strongest protection for bank, security, OTP, account-access, and payment-confirmation messages

## 2. High-Level Architecture

Modules:

- `App`: SwiftUI host application for onboarding, settings, overrides, audit trail, and review UX
- `FilterExtension`: iOS SMS Filter Extension entry point
- `ClassificationCore`: domain models, classifier orchestration, result/explanation types
- `RulesEngine`: normalization, pattern matching, rule definitions, scoring
- `Dataset`: embedded QA dataset and fixtures
- `Tests`: unit, regression, and adversarial validation

## 2.1 Trust-first decision architecture

The system must be designed around a trust-first decision engine rather than a generic blocklist mentality. The architecture must ensure:

- hard protection for critical financial/security communication
- dual-score evaluation for safe vs risky evidence
- conservative conflict routing
- user-driven filtering for unwanted junk categories

## 3. Extension Flow

1. iOS delivers SMS metadata and body to the SMS Filter Extension.
2. Extension invokes `ClassificationCore`.
3. `ClassificationCore` normalizes text and runs layered evaluation.
4. Result is mapped to Apple filter action buckets while preserving app-specific internal category detail.
5. Host app stores local audit metadata when available through shared app group storage.

## 4. Layered Classification Pipeline

### Layer 1: Critical protection rules

- Detect OTP, bank security alerts, payment confirmations, authentication phrases
- Immediate `ALLOW_CRITICAL` override unless strong contradictory evidence exists
- Weak spam or promotional cues must never override strong critical-safe signals
- Contradictory evidence cannot directly force spam for critical-structured messages in MVP under normal conditions; it can only lower confidence to `REVIEW_SUSPICIOUS` when explicit high-risk phishing evidence is present

### Layer 2: Dual scoring

- Assign each safe signal to `SAFE_SCORE`
- Assign each risky signal to `RISK_SCORE`
- Keep the score sources explainable and deterministic

Examples:

- OTP, bank login, payment confirmation -> `SAFE_SCORE`
- cargo tracking, appointment reminders, invoice reminders -> `SAFE_SCORE`
- phishing links, credential prompts, bahis/casino, fake urgency -> `RISK_SCORE`
- promotions -> lower-weight `RISK_SCORE`, subject to user-driven policy

### Layer 3: Allowlist / blacklist

- Sender allowlist for trusted brands or user-approved senders
- Sender/text blacklist amplification for repeated high-confidence junk
- User overrides take precedence over heuristics
- User-controlled filtering should be especially exposed for bahis, casino, bonus, and ad-junk categories

### Layer 4: Pattern detection

- Turkish keyword and regex matching
- Normalized obfuscation handling
- Suspicious URL and brand-impersonation cues
- Safe domain and cargo pattern recognition

### Layer 5: Decision engine

- if `SAFE_SCORE` is very high -> `ALLOW_CRITICAL`
- if `SAFE_SCORE > RISK_SCORE` -> allow path
- if `RISK_SCORE > SAFE_SCORE` -> `REVIEW_SUSPICIOUS`
- if `RISK_SCORE` is very high and `SAFE_SCORE` is low -> `FILTER_SPAM`

### Layer 6: Conflict resolution

- When both safe and risky signals exist, never directly filter
- Prefer `REVIEW_SUSPICIOUS`
- Preserve both safe and risky triggers for explanation and audit

### Layer 7: Confidence routing and explanation generation

- Return concise reasons in user-facing plain language
- Include triggered rule identifiers for debugging and tests

## 5. Host App Responsibilities

- Onboarding and privacy explanation
- Toggle conservative/aggressive review threshold only within safe bounds
- Show local rule outcomes and reasoning
- Collect user overrides
- Manage local allowlist and denylist
- Display sample classifications and self-test suite results
- Expose user-controlled filtering preferences for unwanted categories such as bahis, casino, and promotional junk

## 5.1 Why bank messages must be strongly protected

The host app must explain clearly that bank/security/OTP/account-access/payment-confirmation messages receive the strongest protection because user trust depends on them. Missing a betting spam message is acceptable; missing a bank alert is not. This trust principle should be visible in onboarding, settings copy, and category definitions.

## 5.2 User-controlled filtering for unwanted categories

The app should provide explicit user-facing controls for categories people may want filtered more aggressively:

- bahis / betting
- casino
- bonus/promotional junk
- selected ad patterns

These controls should adjust category-specific thresholds or explicit local rules without weakening the protection of `ALLOW_CRITICAL`.

Supported user-driven controls:

- block bahis / gambling
- block promotional messages
- customize filtering strength

## 6. Storage Design

Storage must remain local and minimal.

Use shared app group storage for:

- user allowlist senders
- user denylist senders
- local settings
- optional hashed audit artifacts

Avoid storing full message bodies long-term by default. If the app stores examples for user review, keep retention short and explicit.

## 7. Performance Constraints

- Extension should avoid dynamic network or disk-heavy work on the hot path
- Rule sets loaded statically where possible
- Classification path must be pure and synchronous
- String normalization must be linear-time and allocation-conscious

## 8. Explainability Model

Each classification returns:

- `category`
- `confidence`
- `explanation`
- `triggeredRules`
- optional `normalizedPreview` for debug/test builds only

Explainability must explicitly call out when a critical-safe override protected a message from junk classification.
Explainability must also explicitly call out when a safe-risk conflict caused routing to `REVIEW_SUSPICIOUS`.

## 9. Apple Integration Notes

Apple SMS filtering APIs ultimately expose broader system actions than our internal six-category model. The internal mapping should be:

- `ALLOW_*` and `REVIEW_SUSPICIOUS` -> allow / optional in-app review visibility
- `FILTER_PROMOTIONAL` and `FILTER_SPAM` -> junk classification in extension

The app-level category detail exists for trust and debugging even if the platform surface is coarser.

## 10. Failure Handling

- If parsing or normalization fails, default to `ALLOW_NORMAL`
- If classification is uncertain, default to `REVIEW_SUSPICIOUS` or `ALLOW_NORMAL`, never direct spam
- If shared storage unavailable, continue with bundled defaults
- If a message is bank/security/OTP-like and the engine is uncertain, prefer `ALLOW_CRITICAL` or `REVIEW_SUSPICIOUS`, never `FILTER_SPAM` based only on weak signals

## 10.1 Decision examples

### Safe vs scam bank messages

- `Garanti BBVA: 1.250,00 TL tutarinda kart harcamaniz yapildi.` -> `ALLOW_CRITICAL`
- `Garanti hesabiniz bloke edildi, sifrenizi girin: garanti-onay.net` -> `REVIEW_SUSPICIOUS`

### Safe vs fake cargo

- `Yurtici Kargo: Gonderiniz dagitima cikmistir.` -> `ALLOW_TRANSACTIONAL`
- `Kargonuz iade olmamasi icin 9 TL odeme yapin: cargo-fast.click` -> `REVIEW_SUSPICIOUS`

### OTP vs phishing

- `Onay kodunuz 551122.` -> `ALLOW_CRITICAL`
- `Onay kodunuz 551122, hesabinizi acmak icin linke gidin.` -> `REVIEW_SUSPICIOUS`

## 11. Security/Privacy Posture

- No backend required
- No remote content lookups
- No mandatory analytics
- No raw SMS upload
- No hidden automated deletions

## 12. Future Evolution

- Add local statistical signals after deterministic baseline proves safe
- Add sender reputation derived purely from user-confirmed local history
- Add Turkish morphological segmentation only if it improves recall without hurting critical precision
- Add richer user-controlled category policies for unwanted junk before considering any broader aggressive filtering
