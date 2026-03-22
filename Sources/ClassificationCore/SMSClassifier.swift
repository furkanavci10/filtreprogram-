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
        let triggeredSignals = evaluation.triggeredSignals.sorted(by: Self.signalSort)
        let explanation = explanationEngine.explanation(
            for: category,
            evaluation: evaluation,
            triggeredSignals: triggeredSignals
        )
        let normalizedText = evaluation.normalizedMessage.normalizedText.isEmpty
            ? evaluation.normalizedMessage.loweredText
            : evaluation.normalizedMessage.normalizedText

        return ClassificationResult(
            category: category,
            confidenceBand: confidenceBand,
            safeScore: evaluation.safeScore,
            riskScore: evaluation.riskScore,
            triggeredSignals: triggeredSignals,
            explanation: explanation,
            normalizedText: normalizedText
        )
    }

    private static func signalSort(lhs: TriggeredSignal, rhs: TriggeredSignal) -> Bool {
        let lhsSeverity = severityRank(lhs.severity)
        let rhsSeverity = severityRank(rhs.severity)

        if lhsSeverity != rhsSeverity {
            return lhsSeverity > rhsSeverity
        }

        if lhs.ruleType != rhs.ruleType {
            return lhs.ruleType.rawValue < rhs.ruleType.rawValue
        }

        return lhs.id < rhs.id
    }

    private static func severityRank(_ severity: RuleSeverity) -> Int {
        switch severity {
        case .critical: return 3
        case .high: return 2
        case .medium: return 1
        case .low: return 0
        }
    }
}
