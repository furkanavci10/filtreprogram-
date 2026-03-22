# Test Strategy

## 1. Objectives

- Prove critical messages are protected
- Verify Turkish spam detection works for common abuse patterns
- Catch regressions in normalization and scoring
- Ensure every output includes explanation and rule list

## 2. Test Layers

### Unit tests

- normalization behavior
- rule matching behavior
- score aggregation
- decision routing
- explanation rendering

### Classification tests

- dataset-driven checks using curated Turkish SMS corpus
- one test per example or grouped by category

### Regression tests

- fixed gold dataset from `docs/DATASET_TR.md`
- must run on every commit

### Adversarial tests

- Unicode confusables
- spaced keywords
- leetspeak
- mixed safe and spam content
- fake bank/cargo impersonation

### False-positive guard tests

- critical OTP messages
- bank alerts
- payment confirmations
- real cargo notifications
- appointment reminders
- invoice reminders

## 3. Hard Safety Rule

Critical messages must never be misclassified into:

- `REVIEW_SUSPICIOUS`
- `FILTER_PROMOTIONAL`
- `FILTER_SPAM`

For the MVP test suite, any such failure is blocking.

## 4. Coverage Targets

- 100% of decision routing branches
- 100% of critical-safe rules covered by tests
- Representative examples for each major Turkish spam family

## 5. Performance Checks

- Micro-benchmark classification on short and long SMS texts
- Validate classification remains fast under repeated calls

## 6. Required Assertions Per Classification Test

- expected category matches
- confidence is non-zero and within `[0, 1]`
- explanation is non-empty
- triggered rules are non-empty for any non-default route

## 7. Regression Management

- Add new failing real-world samples before changing rules
- Preserve historical false-positive examples permanently
- Tag tests by bucket: critical, transactional, suspicious, spam, promo

## 8. Manual QA

- Review extension mapping behavior on simulator/device
- Verify host app explanation text is understandable in Turkish/English mixed cases
- Verify local override flow updates future classifications
