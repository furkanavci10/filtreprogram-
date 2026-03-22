import Foundation
import MessageFilteringDomain
import RulesEngine

struct DecisionEngine {
    private let spamThreshold = 75
    private let veryHighRiskThreshold = 90
    private let transactionalSafeThreshold = 40
    private let weakSafeThreshold = 20
    private let strongDominanceGap = 25
    private let moderateDominanceGap = 12

    func decide(from evaluation: RuleEvaluation) -> MessageClassificationCategory {
        let safe = evaluation.safeScore
        let risk = evaluation.riskScore
        let hasConflict = safe > 0 && risk > 0
        let scoreGap = abs(safe - risk)

        if evaluation.hasCriticalProtectionSignal {
            if risk == 0 || risk <= safe / 3 {
                return .allowCritical
            }

            if risk >= moderateDominanceGap {
                return .reviewSuspicious
            }

            return safe >= 90 ? .allowCritical : .reviewSuspicious
        }

        let canRoutePromotional = evaluation.hasPromotionalSignal
            && !evaluation.hasSpamSignal
            && !evaluation.hasPhishingSignal
            && !evaluation.hasCriticalProtectionSignal
            && !evaluation.hasTransactionalSignal
            && safe <= weakSafeThreshold

        if canRoutePromotional {
            return .filterPromotional
        }

        if hasConflict {
            if safe > risk {
                if evaluation.hasTransactionalSignal
                    && (safe >= transactionalSafeThreshold || scoreGap >= moderateDominanceGap) {
                    return .allowTransactional
                }

                if scoreGap >= strongDominanceGap {
                    return .allowNormal
                }

                return .reviewSuspicious
            }

            if risk > safe {
                if evaluation.hasSevereRiskSignal && safe <= weakSafeThreshold && scoreGap >= moderateDominanceGap {
                    return .filterSpam
                }

                return .reviewSuspicious
            }
        }

        if risk >= veryHighRiskThreshold
            && safe <= weakSafeThreshold
            && (evaluation.hasSpamSignal || evaluation.hasPhishingSignal) {
            return .filterSpam
        }

        if risk >= spamThreshold && safe <= weakSafeThreshold && evaluation.hasSevereRiskSignal {
            return .filterSpam
        }

        if safe > risk
            && evaluation.hasTransactionalSignal
            && (safe >= transactionalSafeThreshold || scoreGap >= moderateDominanceGap) {
            return .allowTransactional
        }

        if safe > risk {
            return .allowNormal
        }

        if risk > safe {
            return .reviewSuspicious
        }

        return .allowNormal
    }

    func confidenceBand(for category: MessageClassificationCategory, evaluation: RuleEvaluation) -> ConfidenceBand {
        let distance = abs(evaluation.safeScore - evaluation.riskScore)

        switch category {
        case .allowCritical:
            return evaluation.hasCriticalProtectionSignal ? .high : .medium
        case .allowTransactional:
            return distance >= 20 ? .high : .medium
        case .allowNormal:
            return evaluation.triggeredSignals.isEmpty ? .medium : .low
        case .reviewSuspicious:
            return distance >= 30 ? .medium : .low
        case .filterPromotional:
            return distance >= 15 || evaluation.hasPromotionalSignal ? .medium : .low
        case .filterSpam:
            return evaluation.hasSevereRiskSignal && distance >= 25 ? .high : .medium
        }
    }
}
