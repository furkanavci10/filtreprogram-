import Foundation
import MessageFilteringDomain
import RulesEngine

struct DecisionEngine {
    private let spamThreshold = 75
    private let veryHighRiskThreshold = 90
    private let transactionalSafeThreshold = 45
    private let weakSafeThreshold = 18
    private let strongDominanceGap = 24
    private let moderateDominanceGap = 10
    private let criticalClearSafetyGap = 18

    func decide(from evaluation: RuleEvaluation) -> MessageClassificationCategory {
        let safe = evaluation.safeScore
        let risk = evaluation.riskScore
        let hasConflict = safe > 0 && risk > 0
        let scoreGap = abs(safe - risk)

        if evaluation.hasCriticalProtectionSignal {
            if risk == 0 || (risk <= weakSafeThreshold && (safe - risk) >= criticalClearSafetyGap) {
                return .allowCritical
            }

            if risk > 0 {
                return .reviewSuspicious
            }

            return .allowCritical
        }

        let canRoutePromotional = evaluation.hasPromotionalSignal
            && !evaluation.hasSpamSignal
            && !evaluation.hasPhishingSignal
            && !evaluation.hasCriticalProtectionSignal
            && !evaluation.hasTransactionalSignal
            && safe <= weakSafeThreshold
            && risk < spamThreshold

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

                if (evaluation.hasSpamSignal || evaluation.hasPhishingSignal)
                    && scoreGap >= strongDominanceGap
                    && safe <= weakSafeThreshold {
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
            return (evaluation.hasTransactionalSignal && evaluation.riskScore == 0) || distance >= strongDominanceGap ? .high : .medium
        case .allowNormal:
            return evaluation.triggeredSignals.isEmpty ? .medium : .low
        case .reviewSuspicious:
            return distance >= strongDominanceGap ? .medium : .low
        case .filterPromotional:
            return evaluation.hasPromotionalSignal && !evaluation.hasSpamSignal && !evaluation.hasPhishingSignal ? .medium : .low
        case .filterSpam:
            return (evaluation.hasSevereRiskSignal || evaluation.riskScore >= veryHighRiskThreshold)
                && distance >= strongDominanceGap ? .high : .medium
        }
    }
}
