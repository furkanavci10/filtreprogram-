import Foundation
import MessageFilteringDomain

public struct RuleEvaluation: Sendable {
    public let input: ClassificationInput
    public let normalizedMessage: NormalizedMessage
    public let safeScore: Int
    public let riskScore: Int
    public let triggeredSignals: [TriggeredSignal]
    public let hasCriticalProtectionSignal: Bool
    public let hasTransactionalSignal: Bool
    public let hasPromotionalSignal: Bool
    public let hasSpamSignal: Bool
    public let hasPhishingSignal: Bool
    public let hasSevereRiskSignal: Bool

    public init(
        input: ClassificationInput,
        normalizedMessage: NormalizedMessage,
        safeScore: Int,
        riskScore: Int,
        triggeredSignals: [TriggeredSignal],
        hasCriticalProtectionSignal: Bool,
        hasTransactionalSignal: Bool,
        hasPromotionalSignal: Bool,
        hasSpamSignal: Bool,
        hasPhishingSignal: Bool,
        hasSevereRiskSignal: Bool
    ) {
        self.input = input
        self.normalizedMessage = normalizedMessage
        self.safeScore = safeScore
        self.riskScore = riskScore
        self.triggeredSignals = triggeredSignals
        self.hasCriticalProtectionSignal = hasCriticalProtectionSignal
        self.hasTransactionalSignal = hasTransactionalSignal
        self.hasPromotionalSignal = hasPromotionalSignal
        self.hasSpamSignal = hasSpamSignal
        self.hasPhishingSignal = hasPhishingSignal
        self.hasSevereRiskSignal = hasSevereRiskSignal
    }
}

public struct RuleEngine: Sendable {
    private let normalizationEngine: NormalizationEngine
    private let rules: [RuleDefinition]

    public init(normalizationEngine: NormalizationEngine = .init()) {
        self.normalizationEngine = normalizationEngine
        self.rules = CriticalProtectionRules.makeRules()
            + TransactionalSafeRules.makeRules()
            + PromotionalRules.makeRules()
            + SpamRiskRules.makeRules()
            + PhishingRiskRules.makeRules()
            + UserPreferenceRules.makeRules()
    }

    public func evaluate(
        input: ClassificationInput,
        configuration: ClassifierConfiguration
    ) -> RuleEvaluation {
        let normalized = normalizationEngine.normalize(input)
        let context = RuleMatchContext(input: input, normalized: normalized, configuration: configuration)
        let signals = rules.compactMap { $0.evaluate(with: context) }

        let safeScore = signals.reduce(into: 0) { $0 += $1.safeContribution }
        let riskScore = signals.reduce(into: 0) { $0 += $1.riskContribution }

        return RuleEvaluation(
            input: input,
            normalizedMessage: normalized,
            safeScore: safeScore,
            riskScore: riskScore,
            triggeredSignals: signals,
            hasCriticalProtectionSignal: signals.contains(where: { $0.ruleType == .criticalProtection }),
            hasTransactionalSignal: signals.contains(where: { $0.ruleType == .transactionalSafe }),
            hasPromotionalSignal: signals.contains(where: { $0.ruleType == .promotional }),
            hasSpamSignal: signals.contains(where: { $0.ruleType == .spamRisk }),
            hasPhishingSignal: signals.contains(where: { $0.ruleType == .phishingRisk }),
            hasSevereRiskSignal: signals.contains(where: {
                ($0.ruleType == .spamRisk || $0.ruleType == .phishingRisk || $0.ruleType == .userPreference)
                    && ($0.severity == .high || $0.severity == .critical)
            })
        )
    }
}
