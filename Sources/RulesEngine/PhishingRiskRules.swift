import Foundation
import MessageFilteringDomain

enum PhishingRiskRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "phishing.credential_harvest",
                description: "Credential or payment capture behavior.",
                ruleType: .phishingRisk,
                severity: .critical,
                safeWeight: 0,
                riskWeight: RuleWeights.phishing,
                explanationHint: "Detected credential, payment, or identity-harvest behavior."
            ) { context in
                RulePatternMatcher.containsAny([
                    "linke tiklayin", "sifrenizi girin", "kart bilgisi", "iban giriniz",
                    "adres onayi yapin", "guncelleyin", "dogrulayin", "odeme icin"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "phishing.suspicious_domain",
                description: "Suspicious domain or short link pattern.",
                ruleType: .phishingRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.suspiciousLink,
                explanationHint: "Detected suspicious link or fake domain pattern."
            ) { context in
                RulePatternMatcher.matchesRegex("(bit\\.ly|tinyurl|t\\.co|\\.top|\\.click|\\.live|\\.cc|\\.net)", in: context.normalized)
            },
            RuleDefinition(
                id: "phishing.scam_language",
                description: "Common scam or legal threat phrasing.",
                ruleType: .phishingRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.phishingAmplifier,
                explanationHint: "Detected scam or impersonation wording."
            ) { context in
                RulePatternMatcher.containsAny([
                    "hesabiniz askiya alindi", "hesabiniz kapanacak", "odul kazandiniz",
                    "hediyeniz hazir", "icra dosyasi acildi", "devlet yardimi",
                    "kargonuz beklemede", "bloke edildi", "kartiniz kapatilacak"
                ], in: context.normalized)
            }
        ]
    }
}
