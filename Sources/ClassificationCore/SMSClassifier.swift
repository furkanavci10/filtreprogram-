import Foundation
import MessageFilteringDomain
import RulesEngine

public struct SMSClassifier: Sendable {
    private let configuration: ClassifierConfiguration
    private let ruleEngine: RuleEngine
    private let decisionEngine: DecisionEngine
    private let explanationEngine: ExplanationEngine

    public init(
        configuration: ClassifierConfiguration = .init(),
        ruleEngine: RuleEngine = .init()
    ) {
        self.configuration = configuration
        self.ruleEngine = ruleEngine
        self.decisionEngine = DecisionEngine()
        self.explanationEngine = ExplanationEngine()
    }

    public func classify(_ input: ClassificationInput) -> ClassificationResult {
        let evaluation = ruleEngine.evaluate(input: input, configuration: configuration)
        let category = decisionEngine.decide(from: evaluation)
        let confidenceBand = decisionEngine.confidenceBand(for: category, evaluation: evaluation)
        let explanation = explanationEngine.explanation(for: category, evaluation: evaluation)

        return ClassificationResult(
            category: category,
            confidenceBand: confidenceBand,
            safeScore: evaluation.safeScore,
            riskScore: evaluation.riskScore,
            triggeredSignals: evaluation.triggeredSignals,
            explanation: explanation,
            normalizedText: evaluation.normalizedMessage.normalizedText
        )
    }
}
