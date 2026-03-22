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
                    "freespin", "canli bahis", "canli casino", "blackjack", "rulet"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "spam.betting_variants",
                description: "Extended bahis and casino pattern family.",
                ruleType: .spamRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.betting,
                explanationHint: "Detected extended bahis, casino, or freebet wording."
            ) { context in
                guard context.configuration.bahisFilteringEnabled else { return false }
                return RulePatternMatcher.containsAny([
                    "banko mac", "oranlar burada", "kupon yap", "vip giris",
                    "cashout", "join ol", "register simdi", "mac tahmini",
                    "deneme bonusu", "yatirimsiz bonus", "hizli cekim",
                    "bonusunu al", "odds active", "casino vip", "kuponun hazir"
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
                    "hemen uye ol", "paneli acildi", "sadece bugun", "aktif",
                    "simdi kullan", "kazan", "firsat seni bekliyor"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "spam.link_urgency_combo",
                description: "Urgency plus suspicious action language common in spam campaigns.",
                ruleType: .spamRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.bettingAmplifier,
                explanationHint: "Detected suspicious spam CTA and urgency combination."
            ) { context in
                let hasCTA = RulePatternMatcher.containsAny([
                    "tikla", "tiklayin", "girin", "acin", "hemen", "simdi", "tamamlayin"
                ], in: context.normalized)
                let hasSpamish = RulePatternMatcher.containsAny([
                    "bonus", "freebet", "hediye", "odul", "kampanya", "firsat", "join"
                ], in: context.normalized)
                return hasCTA && hasSpamish
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
                    "hemen", "son sans", "simdi", "acil", "aksi halde", "son uyari",
                    "hemen tamamlayin", "bugun", "aktif edildi"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "spam.fake_support_verification",
                description: "Fake support or verification language that often accompanies spoofed senders.",
                ruleType: .spamRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.bettingAmplifier,
                explanationHint: "Detected fake support or verification language."
            ) { context in
                RulePatternMatcher.containsAny([
                    "destek", "musteri hizmetleri", "guvenlik bildirimi", "hesabinizi aktif etmek",
                    "dogrulama merkezi", "verification", "support"
                ], in: context.normalized)
            }
        ]
    }
}
