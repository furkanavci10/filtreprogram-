import Foundation
import MessageFilteringDomain
import RulesEngine

struct ExplanationEngine {
    func explanation(for category: MessageClassificationCategory, evaluation: RuleEvaluation) -> String {
        let rankedSignals = evaluation.triggeredSignals.sorted {
            if $0.severity == $1.severity {
                return $0.id < $1.id
            }
            return severityRank($0.severity) > severityRank($1.severity)
        }

        switch category {
        case .allowCritical:
            if hasSignalType(.criticalProtection, in: rankedSignals) {
                return "Detected OTP/security wording; protected as critical."
            }
            return "Detected critical-safe wording; protected as critical."
        case .allowTransactional:
            if containsSignal(idPrefix: "safe.cargo", in: rankedSignals) {
                return "Detected cargo or delivery wording; routed as transactional."
            }
            if containsSignal(idPrefix: "safe.billing", in: rankedSignals) || containsSignal(idPrefix: "safe.telecom", in: rankedSignals) {
                return "Detected billing or telecom service wording; routed as transactional."
            }
            if containsSignal(idPrefix: "safe.appointment", in: rankedSignals) {
                return "Detected appointment or healthcare wording; routed as transactional."
            }
            return "Detected operational service wording; routed as transactional."
        case .allowNormal:
            return "No strong risky or protected-service signals were found; classified as normal."
        case .reviewSuspicious:
            if evaluation.safeScore > 0 && evaluation.riskScore > 0 {
                if containsSignal(idPrefix: "phishing.fake_cargo", in: rankedSignals) || containsSignal(idPrefix: "safe.cargo", in: rankedSignals) {
                    return "Detected cargo wording with suspicious payment/link cues; routed to review."
                }
                if containsSignal(idPrefix: "phishing.fake_bank", in: rankedSignals) || hasSignalType(.criticalProtection, in: rankedSignals) {
                    return "Detected bank/security wording with suspicious credential/link cues; routed to review."
                }
                return "Detected mixed safe and risky signals; routed conservatively to review."
            }
            return "Detected suspicious wording or risk cues; routed to review."
        case .filterPromotional:
            return "Detected promotional or campaign wording without strong scam cues; classified as promotional."
        case .filterSpam:
            if containsSignal(idPrefix: "spam.betting", in: rankedSignals) || containsSignal(idPrefix: "spam.betting_variants", in: rankedSignals) {
                if containsSignal(idPrefix: "phishing.suspicious_domain", in: rankedSignals) || containsSignal(idPrefix: "spam.link_urgency_combo", in: rankedSignals) {
                    return "Detected gambling terms, bonus language, and suspicious link; classified as spam."
                }
                return "Detected gambling and bonus language; classified as spam."
            }
            if hasSignalType(.phishingRisk, in: rankedSignals) {
                return "Detected phishing or credential-harvest cues with weak safe evidence; classified as spam."
            }
            return "Detected strong spam or scam cues with weak safe evidence; classified as spam."
        }
    }

    private func containsSignal(idPrefix: String, in signals: [TriggeredSignal]) -> Bool {
        signals.contains(where: { $0.id.hasPrefix(idPrefix) })
    }

    private func hasSignalType(_ type: RuleType, in signals: [TriggeredSignal]) -> Bool {
        signals.contains(where: { $0.ruleType == type })
    }

    private func severityRank(_ severity: RuleSeverity) -> Int {
        switch severity {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        case .critical: return 3
        }
    }
}
