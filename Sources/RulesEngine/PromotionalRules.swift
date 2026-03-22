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
                    "ozel teklif", "ucretsiz kargo", "flash sale", "yeni uyelere",
                    "bu haftaya ozel", "hediye ceki", "sepete ozel", "firsat sizi bekliyor"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "promo.retail_language",
                description: "Retail and campaign-style promotional phrasing.",
                ruleType: .promotional,
                severity: .low,
                safeWeight: 0,
                riskWeight: RuleWeights.promo,
                explanationHint: "Detected retail or campaign-style promotional wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "kampanya basladi", "sizi bekliyor", "hediye tanimlandi",
                    "ozel firsat", "bu aya ozel", "firsati kacirma", "hemen kazan",
                    "alisverise ozel", "sepete indirim", "hediye cekleri"
                ], in: context.normalized)
            }
        ]
    }
}
