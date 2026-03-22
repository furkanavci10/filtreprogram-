# Classification Policy

## 1. Policy Goals

- Minimize false positives above all else
- Preserve critical Turkish communication
- Use deterministic, explainable rules
- Route uncertainty to review, not spam
- Protect bank, security, OTP, and payment-confirmation messages as the highest-priority class

## 1.1 Trust-first classification system

The product is redesigned around a trust-first classification system:

- critical financial and security messages are protected first
- junk filtering is important, but secondary
- uncertainty is handled conservatively
- filtering should focus on clearly unwanted categories, not every suspicious message

## 2. Categories

- `ALLOW_CRITICAL`
- `ALLOW_TRANSACTIONAL`
- `ALLOW_NORMAL`
- `REVIEW_SUSPICIOUS`
- `FILTER_PROMOTIONAL`
- `FILTER_SPAM`

`ALLOW_CRITICAL` is the highest-priority class in the system.

## 2.1 Why bank messages must be strongly protected

Bank and security messages are sacred because they directly affect money, identity, login access, and fraud response. Users may tolerate a junk message slipping through, but they will not tolerate losing visibility into:

- bank alerts
- OTP / verification codes
- login alerts
- card spending alerts
- suspicious transaction notices
- account access notices
- payment confirmations

Therefore, these messages must receive the strongest protection in the system and must not be filtered as junk under normal conditions.

## 2.2 Hard protection layer

The first decision layer is a hard protection layer for:

- bank messages
- OTP / verification codes
- login alerts
- card spending alerts
- suspicious transaction notices
- account access notices
- payment confirmations

Rules:

- these signals have top priority
- they override weak spam signals
- they must never be directly classified as `FILTER_SPAM`
- if strong critical-safe signals conflict with risky signals, the system must prefer `ALLOW_CRITICAL` or `REVIEW_SUSPICIOUS`

## 3. Normalization Rules

Before evaluation:

- Lowercase using Turkish-aware normalization where feasible
- Replace Turkish diacritics with ASCII fallback for parallel matching: `ş -> s`, `ı -> i`, `ç -> c`, `ğ -> g`, `ö -> o`, `ü -> u`
- Collapse repeated whitespace
- Remove zero-width and decorative punctuation where safe
- Convert common leetspeak: `@ -> a`, `! -> i`, `1 -> i/l`, `3 -> e`, `0 -> o`, `$ -> s`
- Join spaced token sequences when pattern suggests evasion: `b a h i s`, `i d d a a`

Store both raw and normalized forms for explanation fidelity.

## 4. Safe Pattern Library

### 4.1 Critical-safe patterns

Examples:

- `dogrulama kodu`
- `onay kodu`
- `tek kullanimlik sifre`
- `otp`
- `3d secure`
- `isleminiz onaylandi`
- `hesabiniza giris`
- `kartinizla ... harcama`
- `supheli islem`
- `parola`

Signals:

- short numeric code near `kod`, `sifre`, `otp`, `onay`
- bank/security language without promotional bait
- payment confirmation with merchant or amount
- account access and suspicious transaction notices
- card spending or transfer completion notices

### 4.2 Transactional-safe patterns

- cargo tracking: `kargonuz`, `teslimat`, `dagitima cikti`, `takip no`
- e-commerce logistics: `siparisiniz`, `iade`, `teslim edildi`
- healthcare: `randevunuz`, `muayene`, `hastane`, `MHRS`
- government-like legitimate service language: `e-devlet`, `turkiye.gov.tr`, `resmi bildirim`
- telecom/invoice: `faturaniz`, `odeme tarihi`, `tarifeniz`, `paketiniz`

## 5. Risk Pattern Library

### 5.1 Betting / gambling

Primary patterns:

- `bahis`
- `iddaa`
- `oran`
- `kupon`
- `freebet`
- `deneme bonusu`
- `yatirim bonusu`
- `cevrimsiz bonus`
- `casino`
- `slot`
- `jackpot`

Amplifiers:

- money reward plus betting terms
- repeated exclamation marks
- short links
- urgency: `hemen`, `simdi gir`, `kayit ol`

### 5.2 Scam

- `hesabiniz askiya alindi`
- `odul kazandiniz`
- `para odulu`
- `hediyeniz hazir`
- `uyeliginiz donduruldu`
- `son sans`
- `hemen tiklayin`
- `dogrulayin yoksa`

### 5.3 Phishing

- fake bank urgency with link
- fake cargo fee requests
- credential-reset language
- domain mismatch between brand and URL
- suspicious shortened URLs

## 6. Linguistic Trick Detection

Must detect:

- `b@h!s`
- `b4his`
- `b a h i s`
- `i.dd.a.a`
- `fr33bet`
- `bonu$s`
- zero-width joiner insertion
- mixed Turkish-English bait

Detection methods:

- normalized substring search
- compacted token search
- punctuation-stripped search
- simple confusable substitution table

## 7. Rule Priority

Priority order:

1. `ALLOW_CRITICAL` override for bank/security/OTP/account-access/payment-confirmation messages
2. Explicit user allowlist
3. Explicit user denylist
4. Strong transactional-safe patterns
5. Strong spam/phishing patterns
6. Promotional patterns
7. Fallback default

Rationale:

- Critical protection must be evaluated before risk scoring.
- Strong critical-safe signals must have absolute routing priority under normal conditions.
- User explicit decisions outrank generic heuristics.
- Transactional-safe patterns should neutralize moderate ad-like language where context is operational.
- Bahis/promotional filtering can be more user-driven because mistakes there are less costly than mistakes on bank/security traffic.

## 7.1 Explicit override rules for bank and security patterns

If a message strongly matches bank/security/OTP/account-access/payment-confirmation structure, the policy must:

- assign `ALLOW_CRITICAL` first
- record the critical-safe triggers
- suppress weak spam and promotional indicators from changing the class to junk

Examples of strong critical-safe override conditions:

- OTP or verification code plus `kod`, `sifre`, `otp`, `onay`
- bank or finance terms plus payment/transaction/login/security language
- card spending alert with amount
- suspicious transaction or fraud warning without credential-harvest behavior
- password reset or device approval flow

Only strong contradictory evidence should reduce confidence, and even then the message should route to `REVIEW_SUSPICIOUS`, not `FILTER_SPAM`, unless there is explicit high-confidence phishing behavior such as credential theft requests or clear malicious link/domain impersonation.

## 8. Scoring Model

Maintain two primary score channels:

- `safeScore`
- `riskScore`

Optional secondary routing metadata such as promotional tags may exist, but the main decision engine is driven by `safeScore` and `riskScore`.

Example weights:

- critical OTP pattern: `safeScore +90`
- bank transaction alert: `safeScore +85`
- cargo tracking exact phrase: `safeScore +65`
- appointment reminder: `safeScore +60`
- generic suspicious link: `riskScore +20`
- fake urgency phrase: `riskScore +25`
- betting keyword exact match: `riskScore +45`
- betting obfuscation detected: `riskScore +55`
- generic promotion markers: `riskScore +15` by default, with user-driven amplification available

Policy constraint:

- weak spam signals must never override strong critical-safe signals
- promotional evidence must never override strong critical-safe signals
- bahis/promotional filtering may be increased through user-controlled preferences rather than global default aggression

## 8.1 Dual scoring model

Every signal must contribute to one of two primary scores:

- `SAFE_SCORE`
- `RISK_SCORE`

Examples:

- OTP phrase plus code -> `SAFE_SCORE`
- bank transaction amount plus account wording -> `SAFE_SCORE`
- cargo tracking and appointment structures -> `SAFE_SCORE`
- fake urgency, phishing links, credential requests -> `RISK_SCORE`
- bahis, casino, bonus spam patterns -> `RISK_SCORE`
- generic promotional clutter -> `RISK_SCORE` with lower default weight

Interpretation:

- `SAFE_SCORE` measures evidence that a message is operationally important or trusted
- `RISK_SCORE` measures evidence that a message is malicious, deceptive, or strongly unwanted

## 9. Decision Engine

The decision engine must be simple, conservative, and testable.

Base logic:

- if `SAFE_SCORE` is very high -> `ALLOW_CRITICAL`
- if `SAFE_SCORE > RISK_SCORE` -> allow outcome
- if `RISK_SCORE > SAFE_SCORE` -> `REVIEW_SUSPICIOUS`
- if `RISK_SCORE` is very high and `SAFE_SCORE` is low -> `FILTER_SPAM`

Allow outcome routing:

- if the allow evidence is bank/security/OTP/payment/account-access -> `ALLOW_CRITICAL`
- if the allow evidence is cargo, invoice, reservation, appointment, telecom, or order flow -> `ALLOW_TRANSACTIONAL`
- otherwise -> `ALLOW_NORMAL`

## 9.1 Decision routing thresholds

Illustrative routing:

- if `SAFE_SCORE >= 85` -> `ALLOW_CRITICAL`
- else if `SAFE_SCORE > RISK_SCORE` and transactional-safe evidence exists -> `ALLOW_TRANSACTIONAL`
- else if `SAFE_SCORE > RISK_SCORE` -> `ALLOW_NORMAL`
- else if `RISK_SCORE >= 90` and `SAFE_SCORE <= 20` -> `FILTER_SPAM`
- else if `RISK_SCORE > SAFE_SCORE` -> `REVIEW_SUSPICIOUS`
- else -> `ALLOW_NORMAL`

Uncertainty bias:

- When scores conflict, choose less destructive category
- No direct filter outcome when safe and risk scores are both high unless denylist or explicit severe scam patterns exist
- If a message looks bank/security/OTP-like, weak spam signals must not push it into `FILTER_SPAM`
- Ambiguous bank/security-like messages should prefer `ALLOW_CRITICAL` or `REVIEW_SUSPICIOUS`

## 9.2 Conflict resolution

When both safe and risky signals exist:

- never directly filter
- prefer `REVIEW_SUSPICIOUS`
- preserve triggered explanations for both sides of the conflict

Examples:

- bank-like alert plus suspicious link -> `REVIEW_SUSPICIOUS`
- cargo-like delivery text plus payment demand -> `REVIEW_SUSPICIOUS`
- OTP-like message plus credential-harvest phrasing -> `REVIEW_SUSPICIOUS`

## 10. Allowlist Override

Allowlist sources:

- user-approved sender
- bundled trusted sender names or phrases
- exact safe domain references

Override behavior:

- user allowlist can still route to `REVIEW_SUSPICIOUS` if content contains extreme scam markers like credential theft plus non-matching URL, but must never jump directly to `FILTER_SPAM` in MVP

## 11. Blacklist Amplification

Blacklist sources:

- user blocked sender
- repeated known spam sender token
- internally curated local spam sender pattern

Amplification behavior:

- add strong risk boost
- bypass promotional bucket for clearly malicious content
- must not automatically override strong `ALLOW_CRITICAL` evidence unless high-confidence phishing markers are present

## 11.1 User-controlled filtering for unwanted categories

User-controlled filtering is encouraged most strongly for categories users explicitly want gone:

- bahis
- casino
- bonus/promotional junk
- selected unwanted ad patterns

These settings can safely make filtering more assertive in those categories because the downside of over-filtering is materially lower than for bank/security communication. The global default, however, must remain trust-first and conservative.

## 11.2 User-driven filtering controls

Users should be able to:

- block bahis / gambling
- block promotional messages
- customize filtering strength

Recommended product behavior:

- keep critical protection non-optional and always active
- make bahis/casino filtering easy to enable aggressively
- make promotional filtering user-tunable from conservative to stronger review/filter behavior
- apply user-driven strength changes to junk categories only, never to reduce `ALLOW_CRITICAL` protection

## 12. Fallback Logic

- Unknown short harmless text -> `ALLOW_NORMAL`
- Unknown with suspicious link or urgent threat -> `REVIEW_SUSPICIOUS`
- Parser failure -> `ALLOW_NORMAL`
- Mixed safe and spam indicators -> prefer `REVIEW_SUSPICIOUS` unless safe-critical is strong enough to allow
- Mixed bank/security signals plus weak spam indicators -> `ALLOW_CRITICAL`
- Mixed bank/security signals plus strong contradiction -> `REVIEW_SUSPICIOUS`

## 13. Example pairs

### 13.1 Safe vs scam bank messages

Safe:

- `Akbank: Mobil onay kodunuz 551122. Kimseyle paylasmayin.`
- Expected: `ALLOW_CRITICAL`
- Why: strong OTP and bank-security structure -> very high `SAFE_SCORE`

Scam:

- `Akbank hesabiniz bloke edildi. Sifrenizi guncellemek icin akbnk-guvenlik.net adresine girin.`
- Expected: `REVIEW_SUSPICIOUS`
- Why: bank-like wording creates safe conflict, but fake-domain and credential request create strong `RISK_SCORE`; conflict must not directly filter

### 13.2 Safe vs fake cargo

Safe:

- `Aras Kargo: 438219 takip nolu gonderiniz dagitima cikarilmistir.`
- Expected: `ALLOW_TRANSACTIONAL`
- Why: clear operational cargo structure -> stronger `SAFE_SCORE`

Fake:

- `Kargonuz teslim edilemedi. 12,50 TL odeme icin hemen ptt-odeme.top adresine girin.`
- Expected: `REVIEW_SUSPICIOUS`
- Why: cargo-like wording plus payment trap and suspicious domain -> conflicting signals, so review

### 13.3 OTP vs phishing

Safe:

- `Dogrulama kodunuz 771204. Bu kodu kimseyle paylasmayin.`
- Expected: `ALLOW_CRITICAL`
- Why: classic OTP pattern with no harmful indicators

Phishing-like:

- `Onay kodunuz 771204. Hesabinizi korumak icin linke tiklayip sifrenizi girin.`
- Expected: `REVIEW_SUSPICIOUS`
- Why: OTP-like wording conflicts with credential-harvest behavior; never direct spam when both exist

## 13. Explanation Policy

Explanation must be human-readable:

- `Contains OTP phrasing and a one-time code`
- `Looks like betting spam due to bahis/freebet terms and a suspicious link`
- `Looks transactional because it includes cargo tracking language`

Triggered rule IDs must be included for QA.
