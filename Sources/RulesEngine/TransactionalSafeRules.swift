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
                id: "safe.cargo_extended",
                description: "Extended cargo tracking and delivery states.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected extended cargo tracking or delivery update wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "subeye ulasmistir", "transfer merkezine ulasti", "adresinizde bulunamadiniz",
                    "teslimata cikmistir", "teslim kodunuz", "dagitim merkezinde",
                    "gonderi takip", "kurye kapida", "teslim edilecektir"
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
                id: "safe.order_and_delivery",
                description: "E-commerce order, return, and fulfillment notices.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected order, return, or e-commerce delivery wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "siparisiniz", "iade talebiniz", "kuryeye verildi", "magaza teslimine hazirdir",
                    "teslim edildi", "siparisiniz yola cikti", "hazirlaniyor", "e fatura olusturuldu"
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
                id: "safe.telecom_extended",
                description: "Telecom package, renewal, and service-visit notices.",
                ruleType: .transactionalSafe,
                severity: .medium,
                safeWeight: RuleWeights.transactional,
                riskWeight: 0,
                explanationHint: "Detected telecom billing, package, or service wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "ek paketiniz tanimlandi", "paketinizin suresi", "taahhut bitis tarihiniz",
                    "ariza ekibimiz", "tarifenize ek", "faturaniz odendi", "geri arama talebiniz"
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
