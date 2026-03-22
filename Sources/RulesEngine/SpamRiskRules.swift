import Foundation
import MessageFilteringDomain

enum SpamRiskRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "spam.betting",
                description: "Betting or gambling vocabulary.",
                ruleType: .spamRisk,
                severity: .critical,
                safeWeight: 0,
                riskWeight: RuleWeights.betting,
                explanationHint: "Detected gambling or betting vocabulary."
            ) { context in
                guard context.configuration.bahisFilteringEnabled else { return false }
                return RulePatternMatcher.containsAny([
                    "bahis", "iddaa", "oran", "kupon", "freebet", "deneme bonusu",
                    "yatirim bonusu", "cevrimsiz bonus", "casino", "slot", "jackpot",
                    "freespin", "canli bahis"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "spam.bonus_amplifier",
                description: "Gambling CTA and bonus amplifier.",
                ruleType: .spamRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.bettingAmplifier,
                explanationHint: "Detected spam-style bonus or call-to-action language."
            ) { context in
                RulePatternMatcher.containsAny([
                    "kayit ol", "hemen gir", "bonus", "cekim", "vip giris",
                    "hemen uye ol", "paneli acildi", "sadece bugun"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "spam.urgency",
                description: "Urgency-heavy phrasing.",
                ruleType: .spamRisk,
                severity: .medium,
                safeWeight: 0,
                riskWeight: RuleWeights.urgency,
                explanationHint: "Detected urgency wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "hemen", "son sans", "simdi", "acil", "aksi halde", "son uyari"
                ], in: context.normalized)
            }
        ]
    }
}
