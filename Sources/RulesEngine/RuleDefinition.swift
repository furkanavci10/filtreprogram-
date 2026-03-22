import Foundation
import MessageFilteringDomain

public struct RuleMatchContext: Sendable {
    public let input: ClassificationInput
    public let normalized: NormalizedMessage
    public let configuration: ClassifierConfiguration

    public init(input: ClassificationInput, normalized: NormalizedMessage, configuration: ClassifierConfiguration) {
        self.input = input
        self.normalized = normalized
        self.configuration = configuration
    }
}

public struct RuleDefinition: Sendable {
    public let id: String
    public let description: String
    public let ruleType: RuleType
    public let severity: RuleSeverity
    public let safeWeight: Int
    public let riskWeight: Int
    public let explanationHint: String?
    public let evaluator: @Sendable (RuleMatchContext) -> Bool

    public init(
        id: String,
        description: String,
        ruleType: RuleType,
        severity: RuleSeverity,
        safeWeight: Int,
        riskWeight: Int,
        explanationHint: String? = nil,
        evaluator: @escaping @Sendable (RuleMatchContext) -> Bool
    ) {
        self.id = id
        self.description = description
        self.ruleType = ruleType
        self.severity = severity
        self.safeWeight = safeWeight
        self.riskWeight = riskWeight
        self.explanationHint = explanationHint
        self.evaluator = evaluator
    }

    public func evaluate(with context: RuleMatchContext) -> TriggeredSignal? {
        guard evaluator(context) else { return nil }
        return TriggeredSignal(
            id: id,
            description: description,
            ruleType: ruleType,
            severity: severity,
            safeContribution: safeWeight,
            riskContribution: riskWeight,
            explanationHint: explanationHint
        )
    }
}

enum RulePatternMatcher {
    static func containsAny(_ patterns: [String], in message: NormalizedMessage) -> Bool {
        patterns.contains { pattern in
            let compactPattern = pattern.replacingOccurrences(of: " ", with: "")
            return message.normalizedText.contains(pattern)
                || message.compactText.contains(compactPattern)
                || message.aggressiveText.contains(pattern)
                || message.aggressiveCompactText.contains(compactPattern)
        }
    }

    static func matchesRegex(_ pattern: String, in message: NormalizedMessage) -> Bool {
        message.normalizedText.range(of: pattern, options: .regularExpression) != nil
            || message.aggressiveText.range(of: pattern, options: .regularExpression) != nil
    }
}
