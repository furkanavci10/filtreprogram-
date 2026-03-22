# Filtre Programi

Privacy-first, fully local Turkish SMS filtering MVP for iOS.

This repository is intentionally design-first. The product goal is to reduce betting, scam, phishing, and unwanted promotional SMS in Turkiye while aggressively minimizing false positives for critical communication.

Core principles:

- Offline-first classification
- Deterministic, explainable rules
- `ALLOW > REVIEW > FILTER`
- No silent deletion
- User trust over aggressive filtering

Repository map:

- `docs/PRD.md`: Product requirements and user/problem analysis
- `docs/SYSTEM_DESIGN.md`: iOS architecture and local processing model
- `docs/CLASSIFICATION_POLICY.md`: Turkish-first rule and scoring policy
- `docs/THREAT_MODEL.md`: Security and abuse analysis
- `docs/EDGE_CASES_TR.md`: Turkish linguistic and adversarial edge cases
- `docs/TEST_STRATEGY.md`: Validation, regression, and false-positive protections
- `docs/DATASET_TR.md`: Turkish SMS example corpus with expected labels
- `docs/DECISIONS.md`: Architectural decision log
- `plans.md`: Milestones and acceptance criteria
- `implement.md`: Current implementation scope and build notes
- `engineering_log.md`: Step-by-step execution log

Implementation scope in this MVP:

- Swift Package based local classification core
- Deterministic rule engine
- Explainable scoring output
- Dataset-driven tests
- iOS app and filter extension structure documented for later Xcode integration

Out of scope for Milestone 1:

- Production UI polish
- Model-based NLP classifier
- Cloud sync or backend services
- Telemetry that sends message content off-device
