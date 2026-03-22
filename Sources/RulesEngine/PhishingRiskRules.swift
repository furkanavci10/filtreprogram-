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
                    "adres onayi yapin", "guncelleyin", "dogrulayin", "odeme icin",
                    "kimlik dogrulama", "hesap dogrulamasi", "bu baglantiyi acin", "bilgilerinizi girin"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "phishing.fake_cargo_payment",
                description: "Fake cargo fee or delivery payment request.",
                ruleType: .phishingRisk,
                severity: .critical,
                safeWeight: 0,
                riskWeight: RuleWeights.phishing,
                explanationHint: "Detected fake cargo payment or fee request."
            ) { context in
                let hasCargoContext = RulePatternMatcher.containsAny([
                    "kargonuz", "paketiniz", "teslimat", "gonderiniz", "takip no", "ptt",
                    "yeniden dagitim", "subede bekliyor"
                ], in: context.normalized)
                let hasPaymentTrap = RulePatternMatcher.containsAny([
                    "odeme yapin", "ucret odemesi", "kart bilgisi", "teslim ucreti", "iade olmamasi icin",
                    "odemeyi tamamlayin", "teslim icin", "yeniden gonderim icin odeme"
                ], in: context.normalized)
                return hasCargoContext && hasPaymentTrap
            },
            RuleDefinition(
                id: "phishing.fake_bank_credentials",
                description: "Fake bank credential or account unlock phishing.",
                ruleType: .phishingRisk,
                severity: .critical,
                safeWeight: 0,
                riskWeight: RuleWeights.phishing,
                explanationHint: "Detected fake bank credential phishing behavior."
            ) { context in
                let hasBankContext = RulePatternMatcher.containsAny([
                    "akbank", "garanti", "ziraat", "is bankasi", "vakifbank", "yapi kredi",
                    "hesabiniz bloke", "hesabiniz kapanacak", "kartiniz kapatilacak",
                    "garanti bbva", "internet subesi", "mobil bankacilik"
                ], in: context.normalized)
                let hasCredentialAsk = RulePatternMatcher.containsAny([
                    "sifrenizi girin", "hesabinizi dogrulayin", "guncelleyin", "linke tiklayin",
                    "kimlik dogrulama", "bilgilerinizi guncelleyin", "hesabinizi aktife almak"
                ], in: context.normalized)
                return hasBankContext && hasCredentialAsk
            },
            RuleDefinition(
                id: "phishing.sender_impersonation_hint",
                description: "Trusted-looking support or security sender wording combined with suspicious action prompts.",
                ruleType: .phishingRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.phishingAmplifier,
                explanationHint: "Detected sender impersonation or fake support wording."
            ) { context in
                let hasImpersonationHint = RulePatternMatcher.containsAny([
                    "guvenlik", "destek", "support", "yardim masasi", "musteri hizmetleri"
                ], in: context.normalized)
                let hasSuspiciousAsk = RulePatternMatcher.containsAny([
                    "sifrenizi girin", "odeme yapin", "kimlik dogrulama", "bu baglantiyi acin", "linke tiklayin"
                ], in: context.normalized)
                return hasImpersonationHint && hasSuspiciousAsk
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
                    || RulePatternMatcher.matchesRegex("([a-z0-9-]*)(akbank|garanti|ziraat|ptt|aras|yurtici|mng)([a-z0-9-]*)(\\.top|\\.click|\\.live|\\.cc|\\.net)", in: context.normalized)
            },
            RuleDefinition(
                id: "phishing.impersonation_combo",
                description: "Impersonation plus urgency plus link combination.",
                ruleType: .phishingRisk,
                severity: .high,
                safeWeight: 0,
                riskWeight: RuleWeights.phishingAmplifier,
                explanationHint: "Detected impersonation, urgency, and action-request combination."
            ) { context in
                let hasImpersonation = RulePatternMatcher.containsAny([
                    "musteri hizmetleri", "e devlet", "mhrs", "ptt", "banka", "cargo", "delivery",
                    "trendyol", "amazon", "sgk", "internet subesi"
                ], in: context.normalized)
                let hasUrgency = RulePatternMatcher.containsAny([
                    "hemen", "son sans", "aksi halde", "son uyari", "acil", "iptal edilecek", "donduruldu"
                ], in: context.normalized)
                let hasAction = RulePatternMatcher.containsAny([
                    "linke tiklayin", "guncelleyin", "dogrulayin", "odeme yapin", "sifrenizi girin",
                    "bu baglantiyi acin", "verify", "pay fee", "kart bilgisi girin"
                ], in: context.normalized)
                return hasImpersonation && hasUrgency && hasAction
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
                    "kargonuz beklemede", "bloke edildi", "kartiniz kapatilacak",
                    "hesabiniz guvenlik nedeniyle donduruldu", "buyuk odul kazandiniz", "paketiniz iade olmamasi icin"
                ], in: context.normalized)
            }
        ]
    }
}
