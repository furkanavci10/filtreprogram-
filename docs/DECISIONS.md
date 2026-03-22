# Decisions

## D-001: Deterministic rules before ML

- Status: Accepted
- Reason: MVP needs maximum explainability and minimum false positives.

## D-002: Fully local processing

- Status: Accepted
- Reason: Privacy and offline reliability are core product requirements.

## D-003: Six internal categories

- Status: Accepted
- Reason: Internal nuance is required even if platform actions are coarser.

## D-004: Conservative routing

- Status: Accepted
- Reason: `ALLOW > REVIEW > FILTER` reduces user trust risk.

## D-005: Swift Package for core logic

- Status: Accepted
- Reason: Maximizes testability and reuse between app and filter extension.

## D-006: Review bucket retained in MVP

- Status: Accepted
- Reason: Ambiguity is common in Turkish phishing and cargo impersonation.

## D-007: No raw-message cloud analytics

- Status: Accepted
- Reason: Privacy-first positioning and threat model do not allow it.

## D-008: Bank and security messages are sacred

- Status: Accepted
- Reason: Users do not trust SMS filters if bank, OTP, login, suspicious transaction, account-access, or payment-confirmation messages can be blocked.

## D-009: Trust-first coverage over aggressive blocking

- Status: Accepted
- Reason: The product should focus on clearly unwanted Turkish junk such as bahis, casino, bonus spam, obvious promotional clutter, and strong-evidence scams rather than attempting to block every suspicious-looking message.

## D-010: User-controlled filtering for unwanted categories

- Status: Accepted
- Reason: Bahis, casino, bonus, and selected advertising patterns are appropriate areas for stronger user-controlled filtering because the false-positive cost is much lower than for critical bank/security communication.
