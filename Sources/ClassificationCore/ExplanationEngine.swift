import Foundation
import MessageFilteringDomain
import RulesEngine

struct ExplanationEngine {
    func explanation(for category: MessageClassificationCategory, evaluation: RuleEvaluation) -> String {
        let hints = evaluation.triggeredSignals.compactMap(\.explanationHint)

        switch category {
        case .allowCritical:
            if let firstHint = hints.first {
                return firstHint
            }
            return "Detected critical-safe wording; protected as a critical message."
        case .allowTransactional:
            if let hint = hints.first(where: { $0.contains("cargo") || $0.contains("appointment") || $0.contains("billing") }) {
                return "\(hint) Routed as transactional."
            }
            return "Detected operational delivery, billing, reservation, or appointment language; routed as transactional."
        case .allowNormal:
            return "No strong malicious evidence was found, and safe evidence did not indicate a critical or transactional flow."
        case .reviewSuspicious:
            if evaluation.safeScore > 0 && evaluation.riskScore > 0 {
                return "Detected both safe-looking and risky signals; routed conservatively to review."
            }
            return "Detected suspicious wording or risk indicators without enough certainty for direct filtering."
        case .filterPromotional:
            return "Detected promotional or campaign language without strong scam evidence; classified as promotional."
        case .filterSpam:
            return "Detected strong betting, scam, phishing, or malicious CTA signals with weak safe evidence; classified as spam."
        }
    }
}
