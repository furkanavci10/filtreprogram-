import Foundation
import MessageFilteringDomain

enum PromotionalRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "promo.marketing",
                description: "Generic promotional or campaign language.",
                ruleType: .promotional,
                severity: .medium,
                safeWeight: 0,
                riskWeight: RuleWeights.promo,
                explanationHint: "Detected promotional language."
            ) { context in
                RulePatternMatcher.containsAny([
                    "kampanya", "indirim", "firsat", "hemen kazan",
                    "ozel teklif", "ucretsiz kargo", "flash sale", "yeni uyelere"
                ], in: context.normalized)
            }
        ]
    }
}
