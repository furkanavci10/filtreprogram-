import Foundation

public enum MessageClassificationCategory: String, Codable, CaseIterable, Sendable {
    case allowCritical = "ALLOW_CRITICAL"
    case allowTransactional = "ALLOW_TRANSACTIONAL"
    case allowNormal = "ALLOW_NORMAL"
    case reviewSuspicious = "REVIEW_SUSPICIOUS"
    case filterPromotional = "FILTER_PROMOTIONAL"
    case filterSpam = "FILTER_SPAM"
}

public enum ConfidenceBand: String, Codable, CaseIterable, Sendable {
    case low
    case medium
    case high
}

public enum RuleSeverity: String, Codable, CaseIterable, Sendable {
    case low
    case medium
    case high
    case critical
}

public enum RuleType: String, Codable, CaseIterable, Sendable {
    case criticalProtection
    case transactionalSafe
    case promotional
    case spamRisk
    case phishingRisk
    case userPreference
}

public struct ClassificationInput: Codable, Hashable, Sendable {
    public let sender: String?
    public let body: String

    public init(sender: String? = nil, body: String) {
        self.sender = sender
        self.body = body
    }
}

public struct NormalizedMessage: Codable, Hashable, Sendable {
    public let rawText: String
    public let loweredText: String
    public let normalizedText: String
    public let compactText: String
    public let aggressiveText: String
    public let aggressiveCompactText: String

    public init(
        rawText: String,
        loweredText: String,
        normalizedText: String,
        compactText: String,
        aggressiveText: String,
        aggressiveCompactText: String
    ) {
        self.rawText = rawText
        self.loweredText = loweredText
        self.normalizedText = normalizedText
        self.compactText = compactText
        self.aggressiveText = aggressiveText
        self.aggressiveCompactText = aggressiveCompactText
    }
}

public struct TriggeredSignal: Codable, Hashable, Sendable {
    public let id: String
    public let description: String
    public let ruleType: RuleType
    public let severity: RuleSeverity
    public let safeContribution: Int
    public let riskContribution: Int
    public let explanationHint: String?

    public init(
        id: String,
        description: String,
        ruleType: RuleType,
        severity: RuleSeverity,
        safeContribution: Int,
        riskContribution: Int,
        explanationHint: String? = nil
    ) {
        self.id = id
        self.description = description
        self.ruleType = ruleType
        self.severity = severity
        self.safeContribution = safeContribution
        self.riskContribution = riskContribution
        self.explanationHint = explanationHint
    }
}

public struct ClassificationResult: Codable, Sendable {
    public let category: MessageClassificationCategory
    public let confidenceBand: ConfidenceBand
    public let safeScore: Int
    public let riskScore: Int
    public let triggeredSignals: [TriggeredSignal]
    public let explanation: String
    public let normalizedText: String

    public init(
        category: MessageClassificationCategory,
        confidenceBand: ConfidenceBand,
        safeScore: Int,
        riskScore: Int,
        triggeredSignals: [TriggeredSignal],
        explanation: String,
        normalizedText: String
    ) {
        self.category = category
        self.confidenceBand = confidenceBand
        self.safeScore = safeScore
        self.riskScore = riskScore
        self.triggeredSignals = triggeredSignals
        self.explanation = explanation
        self.normalizedText = normalizedText
    }
}

public struct ClassifierConfiguration: Sendable {
    public enum FilteringStrength: String, Codable, Sendable {
        case conservative
        case balanced
        case aggressive
    }

    public var aggressivePromotionalFiltering: Bool
    public var bahisFilteringEnabled: Bool
    public var filteringStrength: FilteringStrength
    public var allowlistedSenders: Set<String>
    public var whitelistTerms: Set<String>
    public var denylistedSenders: Set<String>
    public var blacklistTerms: Set<String>

    public init(
        aggressivePromotionalFiltering: Bool = false,
        bahisFilteringEnabled: Bool = true,
        filteringStrength: FilteringStrength = .balanced,
        allowlistedSenders: Set<String> = [],
        whitelistTerms: Set<String> = [],
        denylistedSenders: Set<String> = [],
        blacklistTerms: Set<String> = []
    ) {
        self.aggressivePromotionalFiltering = aggressivePromotionalFiltering
        self.bahisFilteringEnabled = bahisFilteringEnabled
        self.filteringStrength = filteringStrength
        self.allowlistedSenders = Set(allowlistedSenders.map(Self.normalizeToken))
        self.whitelistTerms = Set(whitelistTerms.map(Self.normalizeToken))
        self.denylistedSenders = Set(denylistedSenders.map(Self.normalizeToken))
        self.blacklistTerms = Set(blacklistTerms.map(Self.normalizeToken))
    }

    public func isAllowlisted(sender: String?) -> Bool {
        guard let sender else { return false }
        return allowlistedSenders.contains(Self.normalizeToken(sender))
    }

    public func isDenylisted(sender: String?) -> Bool {
        guard let sender else { return false }
        return denylistedSenders.contains(Self.normalizeToken(sender))
    }

    public func matchesWhitelistTerm(_ text: String) -> Bool {
        let normalized = Self.normalizeToken(text)
        return whitelistTerms.contains(where: normalized.contains)
    }

    public func matchesBlacklistTerm(_ text: String) -> Bool {
        let normalized = Self.normalizeToken(text)
        return blacklistTerms.contains(where: normalized.contains)
    }

    private static func normalizeToken(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
