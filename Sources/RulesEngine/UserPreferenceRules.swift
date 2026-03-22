import Foundation
import MessageFilteringDomain

enum UserPreferenceRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "user.allowlisted_sender",
                description: "Sender is allowlisted by the user.",
                ruleType: .userPreference,
                severity: .medium,
                safeWeight: RuleWeights.allowlist,
                riskWeight: 0,
                explanationHint: "Sender is on the local allowlist."
            ) { context in
                context.configuration.isAllowlisted(sender: context.input.sender)
            },
            RuleDefinition(
                id: "user.whitelist_term",
                description: "Message contains a user-approved term.",
                ruleType: .userPreference,
                severity: .low,
                safeWeight: RuleWeights.allowlist,
                riskWeight: 0,
                explanationHint: "Message matched a local whitelist term."
            ) { context in
                context.configuration.matchesWhitelistTerm(context.normalized.normalizedText)
            },
            RuleDefinition(
                id: "user.denylisted_sender",
                description: "Sender is denylisted by the user.",
                ruleType: .userPreference,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.denylist,
                explanationHint: "Sender is on the local denylist."
            ) { context in
                context.configuration.isDenylisted(sender: context.input.sender)
            },
            RuleDefinition(
                id: "user.blacklist_term",
                description: "Message contains a user-blocked term.",
                ruleType: .userPreference,
                severity: .medium,
                safeWeight: 0,
                riskWeight: RuleWeights.blacklistTerm,
                explanationHint: "Message matched a local blacklist term."
            ) { context in
                context.configuration.matchesBlacklistTerm(context.normalized.normalizedText)
            },
            RuleDefinition(
                id: "user.aggressive_promo",
                description: "Promotional filtering strength is elevated by user preference.",
                ruleType: .userPreference,
                severity: .low,
                safeWeight: 0,
                riskWeight: RuleWeights.promo,
                explanationHint: "Aggressive promotional filtering is enabled."
            ) { context in
                context.configuration.aggressivePromotionalFiltering
                    && RulePatternMatcher.containsAny(["kampanya", "indirim", "firsat", "ozel teklif"], in: context.normalized)
            }
        ]
    }
}
