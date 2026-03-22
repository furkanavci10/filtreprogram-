# Threat Model

## 1. Assets

- User SMS content
- Classification decisions
- User trust
- Local allowlist/denylist data
- Audit trail metadata

## 2. Security Goals

- Keep SMS processing on-device
- Prevent privacy leakage through logs or analytics
- Resist basic text obfuscation by attackers
- Avoid false positives on critical communication

## 3. Adversaries

### Opportunistic spammers

- Send broad betting or ad campaigns
- Use keyword obfuscation and short links

### Phishers

- Impersonate cargo or banks
- Create urgency and credential theft flows

### Malicious insiders or local attackers

- Attempt to inspect stored audit data on-device

## 4. Abuse Scenarios

- Betting spam evades rules via Unicode or spacing tricks
- Fake bank message includes `kod` to trick simplistic allow rules
- Fake cargo message mimics trusted brands and requests payment
- Promotional senders imitate invoice or discount confirmation patterns

## 5. Threats

### Privacy threats

- Raw SMS bodies retained unnecessarily
- Debug logs contain sensitive OTPs
- Shared container stores plaintext historical data

### Integrity threats

- Attackers craft messages that exploit allowlist precedence
- User overrides abused by accidental taps

### Availability threats

- Extension slowdown from heavy regex or oversized rule lists
- Crashes from malformed Unicode input

## 6. Mitigations

- Process all messages offline
- Avoid remote analytics of message content
- Redact or hash sensitive data in logs where possible
- Prefer exact critical templates, not just `kod` keyword
- Normalize and compact text before matching
- Separate safe-critical detection from generic brand words
- Keep rules deterministic and tested with adversarial examples
- Default to less destructive outcome on ambiguity

## 7. Residual Risks

- Sophisticated phishing may mimic legitimate transactional structure closely
- Sender identity in SMS is not fully trustworthy
- Local device compromise can expose any locally stored review history

## 8. Secure Logging Guidance

- Log category, confidence, and rule IDs by default
- Avoid storing full OTP-bearing messages unless user explicitly keeps review history
- If storing examples for QA builds, redact numeric codes and long identifiers

## 9. Privacy Statement for MVP

- No mandatory backend
- No raw content upload
- No third-party data brokers
- No hidden model training from user SMS
