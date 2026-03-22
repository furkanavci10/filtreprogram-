# Product Requirements Document

## 1. Product Summary

Build a Turkish-first SMS filtering application for iOS that classifies incoming messages locally and conservatively. The product targets the SMS spam landscape in Turkiye, where betting spam, illegal gambling ads, fake cargo notices, fake bank alerts, and general scam campaigns are common. The app must protect users without blocking bank alerts, OTP codes, cargo notifications, hospital reminders, official notices, or telecom billing messages.

The MVP is not a black-box blocker. It is an explainable local classification engine coupled to an iOS SMS Filter Extension and a host app that allows review, override, and trust-building transparency.

## 2. Problem Context in Turkiye

### 2.1 Turkish user behavior analysis

- SMS remains important in Turkiye for OTP, banking, cargo, e-commerce, healthcare, telecom, and government-adjacent notifications.
- Users routinely receive critical one-time codes from banks, e-commerce checkouts, 3D Secure flows, and identity/authentication systems.
- Cargo and marketplace activity is high due to strong e-commerce usage from platforms such as Trendyol, Hepsiburada, n11, Amazon TR, Aras Kargo, Yurtiçi Kargo, MNG, and PTT.
- Users are exposed to frequent promotional SMS and are often desensitized to generic short-link calls to action.
- Scam senders exploit trust in brands, urgency language, and Turkish-specific phrasing.
- Users often cannot distinguish legitimate sender names from spoofed-looking text because iOS SMS filtering has limited sender identity guarantees for ordinary phone-originated traffic.

### 2.2 Spam landscape in Turkiye

High-frequency abuse categories:

- Illegal betting and gambling promotion
- Bonus/freebet acquisition campaigns
- Loan/cash/credit scams
- Fake cargo redirection and unpaid fee traps
- Fake bank/account-lock alerts
- Prize/reward claims
- Subscription traps and adult-content promotions
- Broad ad blasts with links and urgency

Observed attacker patterns:

- Turkish-English mixing: `freebet`, `bonus`, `win`, `cashout`
- Obfuscation: `b@his`, `i d d a a`, `fr33bet`
- Short links and lookalike domains
- Brand imitation: bank, telecom, cargo, e-Devlet-like language
- Emotional triggers: urgency, fear, greed, curiosity

### 2.3 Why current solutions fail

- Platform-level filtering is generic and not tuned for Turkish lexical patterns.
- Black-box spam detection offers poor explainability, which reduces user trust when mistakes happen.
- Aggressive filters overfit on commercial language and can misclassify legitimate campaign, invoice, or shipment messages.
- Many systems under-handle Turkish morphology, spacing tricks, leetspeak, and Unicode substitutions.
- Users need message review and override, not silent disappearance of potentially critical content.

## 3. Product Vision

Create the most trustworthy local SMS triage layer for Turkish users:

- Preserve critical communication
- Surface suspicious content safely
- Filter obvious spam with high confidence
- Explain every decision

## 3.1 Why bank messages must be strongly protected

Bank and security-related SMS messages are among the highest-trust and highest-importance message types on a phone in Turkiye. Users depend on them for:

- OTP and login verification
- card spending alerts
- suspicious transaction warnings
- payment confirmations
- account access notices
- password reset and device approval flows

If these messages are blocked even occasionally, users stop trusting the filter immediately. For that reason, bank/security/OTP/account-access/payment-confirmation style messages are treated as sacred in the product philosophy. Under normal conditions they must not be filtered as junk. If ambiguity exists, the system must prefer `ALLOW_CRITICAL` or at most `REVIEW_SUSPICIOUS`, never aggressive spam routing based only on weak spam evidence.

## 4. Personas

### Persona A: Security-sensitive banker

- Receives many OTP and payment alerts
- Cannot tolerate false positives
- Wants certainty and traceability

### Persona B: Heavy e-commerce shopper

- Receives many cargo and order messages
- Is vulnerable to fake delivery scams
- Needs shipment messages protected while suspicious clones are flagged

### Persona C: Family phone manager

- Helps parents/elders avoid scams
- Values simple explanations over technical scores

### Persona D: High-noise mobile user

- Gets many ad and spam SMS
- Wants junk reduced but not at the cost of missing a doctor appointment or invoice reminder

## 5. Core User Stories

1. As a user, I want OTP and bank security messages to always remain visible.
2. As a user, I want obvious betting spam to be filtered automatically.
3. As a user, I want uncertain suspicious messages to be sent to review, not filtered.
4. As a user, I want to understand why a message was categorized.
5. As a user, I want local-only processing so my messages do not leave my device.
6. As a user, I want to override misclassifications and improve future decisions locally.

## 6. UX Philosophy

- Conservative by design
- Explain before asking for trust
- Review over irreversible action
- Small number of categories with plain-language meaning
- Safe defaults on first install
- Bank and security messages are sacred
- User trust comes before filtering coverage

## 6.1 User-controlled filtering for unwanted categories

The product should not try to automatically remove everything suspicious. Instead, it should focus on the categories users most consistently want gone:

- bahis / betting spam
- casino spam
- illegal bonus campaigns
- obvious ad/promotional junk
- scam/phishing messages with strong evidence

The host app should let users explicitly control unwanted categories and patterns they personally want filtered more aggressively, especially:

- bahis
- casino
- bonus/promotional junk
- selected unwanted ad patterns

This user-controlled layer strengthens filtering where users want it, without weakening the global protection for critical messages.

## 7. Trust Model

The app earns trust through:

- Offline-only classification
- Deterministic rules first
- Logged reasons and triggered rules
- Explicit uncertainty handling
- User overrides that are visible and reversible
- Strongest protection for bank, security, and OTP messages

Trust is lost if:

- OTP, bank, cargo, appointment, invoice, or official notices are hidden
- The app claims certainty without evidence
- Users cannot inspect or correct decisions
- Weak spam cues override strong bank/security evidence

## 8. Classification Definitions

- `ALLOW_CRITICAL`: OTP, login, security, fraud check, payment confirmation, bank-critical alerts.
- `ALLOW_TRANSACTIONAL`: cargo, delivery, reservation, invoice, purchase updates, appointment reminders.
- `ALLOW_NORMAL`: personal or unknown but non-threatening content.
- `REVIEW_SUSPICIOUS`: medium-risk or ambiguous content; suspicious indicators without enough confidence to filter.
- `FILTER_PROMOTIONAL`: unwanted ads/promotions with low direct harm.
- `FILTER_SPAM`: high-confidence spam, scam, illegal betting, phishing, malicious promotions.

Every result must include:

- category
- confidence score
- explanation
- triggered rules

## 9. Functional Requirements

### 9.1 Mandatory

- Fully offline classification
- Deterministic rule engine
- Explanation generation
- Turkish text normalization
- Safe-pattern protection layer
- Critical bank/security override layer
- Suspicious-pattern and spam-pattern scoring
- Review bucket for uncertainty
- Local user allowlist and denylist
- User-controlled category filtering for unwanted junk

### 9.2 Host app

- Explain category definitions
- Show last classified examples and reasons
- Allow sender/text overrides
- Import regression dataset for QA builds
- Reset local learning

### 9.3 Filter extension

- Fast execution under extension constraints
- No network dependency
- Stable, deterministic output

## 10. Non-Functional Requirements

- Offline operation only
- Low-latency classification
- Memory-conscious implementation
- Testable pure-core logic
- Stable behavior across app launches
- Privacy-preserving local storage

## 11. Success Metrics

- Zero critical false-positive rate in regression suite
- Greater than 95% precision for `FILTER_SPAM` on high-confidence corpus
- Greater than 98% recall for `ALLOW_CRITICAL` known patterns
- Median classification time below 10 ms on representative devices for short SMS-sized input
- Explanation present in 100% of classifications

## 12. Failure Metrics

Primary failure metric:

- Any critical message classified as `REVIEW_SUSPICIOUS`, `FILTER_PROMOTIONAL`, or `FILTER_SPAM`

Secondary failures:

- Cargo or appointment messages filtered
- Generic short harmless message marked spam
- Non-explainable decision
- Excessive sensitivity to Turkish diacritics or Unicode tricks
- Bank/security/OTP-like message filtered because of only weak spam or promotional signals

## 13. Risks

### Product risks

- Overblocking legitimate finance and logistics messages
- Underblocking adaptive phishing campaigns
- Erosion of trust if explanations are weak

### Technical risks

- Overly brittle keyword rules
- Insufficient normalization for Turkish text variants
- Extension performance regressions

### Security risks

- Adversarial obfuscation to evade simple rules
- Local logs exposing sensitive message text if not stored carefully

## 14. MVP Scope

Included:

- Local deterministic classifier
- Turkish normalization and pattern logic
- Test corpus and edge-case coverage
- Review path and explainability
- Trust-first protection for bank/security/OTP flows
- User-controlled filtering configuration for clearly unwanted categories in the product spec

Deferred:

- ML or hybrid ranking
- Federated learning
- Cloud-assisted reputation feeds
- Cross-device sync

## 15. Launch Criteria

- Required docs complete
- Milestone 1 classifier implemented
- Core regression tests green
- Critical false-positive guard tests green
- Decision log updated with tradeoffs
