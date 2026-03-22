import Foundation
import MessageFilteringDomain

enum TransactionalSafeRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "safe.cargo",
                description: "Cargo or delivery operations.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected cargo or delivery wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "kargonuz", "takip no", "dagitima cikti", "dagitima cikarilmistir",
                    "teslim edildi", "teslimat", "kurye", "paketiniz", "gonderiniz"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "safe.appointment",
                description: "Healthcare, reservation, or official appointments.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected appointment, healthcare, or reservation wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "randevunuz", "muayene", "mhrs", "hastane", "provizyon",
                    "rezervasyonunuz", "pnr"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "safe.billing",
                description: "Invoice, telecom, or service notices.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected billing, invoice, or telecom notice wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "faturaniz", "son odeme tarihi", "tarifeniz", "paketiniz",
                    "ariza kaydiniz", "numara tasima", "modem kurulum", "e fatura"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "safe.trusted_domain",
                description: "Trusted official or carrier domain mention.",
                ruleType: .transactionalSafe,
                severity: .low,
                safeWeight: RuleWeights.trustedDomain,
                riskWeight: 0,
                explanationHint: "Detected a trusted service domain."
            ) { context in
                RulePatternMatcher.containsAny([
                    "turkiye gov tr",
                    "turkiye.gov.tr",
                    "yurticikargo.com",
                    "amazon.com.tr"
                ], in: context.normalized)
            }
        ]
    }
}
