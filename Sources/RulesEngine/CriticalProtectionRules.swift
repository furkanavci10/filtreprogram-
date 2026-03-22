import Foundation
import MessageFilteringDomain

enum CriticalProtectionRules {
    static func makeRules() -> [RuleDefinition] {
        [
            RuleDefinition(
                id: "critical.otp_phrase",
                description: "OTP-style wording with a one-time code.",
                ruleType: .criticalProtection,
                severity: .critical,
                safeWeight: RuleWeights.criticalOTP,
                riskWeight: 0,
                explanationHint: "Detected OTP-style code and security wording; protected as critical."
            ) { context in
                RulePatternMatcher.matchesRegex("(kod|sifre|otp|onay)\\s*(unuz|in|i|u|nuz|kodu)?\\s*[:\\- ]*\\d{4,8}", in: context.normalized)
                    || RulePatternMatcher.matchesRegex("\\d{4,8}\\s*(kod|sifre|otp)", in: context.normalized)
            },
            RuleDefinition(
                id: "critical.otp_variant",
                description: "Broader OTP and verification wording variants.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.criticalSecurityPhrase,
                riskWeight: 0,
                explanationHint: "Detected OTP or verification wording variant; protected as critical."
            ) { context in
                RulePatternMatcher.containsAny([
                    "dogrulama", "aktivasyon kodu", "tek kullanimlik kod", "tek kullanimlik kod",
                    "guvenlik kodu", "islem onay kodu", "hesap onay kodu", "sifre dogrulama",
                    "hesap dogrulama kodu", "mobil onay kodu", "aktivasyon sifresi",
                    "dogrulama sifresi", "onay sifresi", "guvenlik sifresi"
                ], in: context.normalized)
                    && RulePatternMatcher.matchesRegex("\\d{4,8}", in: context.normalized)
            },
            RuleDefinition(
                id: "critical.security_phrase",
                description: "Security wording that strongly suggests a protected account flow.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.criticalSecurityPhrase,
                riskWeight: 0,
                explanationHint: "Detected strong security phrasing; protected as critical."
            ) { context in
                RulePatternMatcher.containsAny([
                    "dogrulama kodu",
                    "onay kodu",
                    "tek kullanimlik sifre",
                    "bu kodu kimseyle paylasmayin",
                    "kimseyle paylasmayin",
                    "sifre yenileme",
                    "3d secure",
                    "giris kodu",
                    "dogrulama icin kod",
                    "hesap onayi",
                    "guvenlik nedeniyle"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "critical.login_alert",
                description: "Login, device, or session alert wording.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.accountAccess,
                riskWeight: 0,
                explanationHint: "Detected login or device security alert wording; protected as critical."
            ) { context in
                RulePatternMatcher.containsAny([
                    "girisiniz onaylandi", "oturum acma kodu", "yeni cihaz",
                    "cihaz tanimlama", "hesabiniza giris yapildi", "internet subesi giris",
                    "mobil giris", "guvenlik uyarisi", "hesabiniz icin giris kodu",
                    "cihaz eslestirme", "mobil bankacilik girisiniz", "yeni cihaz onayi",
                    "hesabiniza erisim", "guvenli giris"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "critical.bank_transaction",
                description: "Bank/payment/account access message.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.bankTransaction,
                riskWeight: 0,
                explanationHint: "Detected bank or payment confirmation structure; protected as critical."
            ) { context in
                let hasBankTerm = RulePatternMatcher.containsAny([
                    "akbank", "garanti", "ziraat", "is bankasi", "isbank", "vakifbank",
                    "yapi kredi", "teb", "enpara", "halkbank", "qnb", "finansbank",
                    "kuveyt turk", "albaraka", "papara", "paycell", "denizbank", "odeabank",
                    "garanti bbva", "kartinizla", "hesabiniza", "kredi kartinizla", "sanal kartinizla"
                ], in: context.normalized)
                let hasAction = RulePatternMatcher.containsAny([
                    "harcama", "odeme", "isleminiz onaylandi", "islem gerceklesti",
                    "supheli islem", "hesabiniza giris", "mobil bankacilik", "para girisi",
                    "fast isleminiz", "havale isleminiz", "eft isleminiz", "odemeniz alinmistir",
                    "para transferiniz", "islem basariyla tamamlandi", "tutarinda odeme", "guvenlik nedeniyle"
                ], in: context.normalized)
                return hasBankTerm && hasAction
            },
            RuleDefinition(
                id: "critical.card_spend",
                description: "Card spending and payment amount alerts.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.bankTransaction,
                riskWeight: 0,
                explanationHint: "Detected card spending or payment amount alert; protected as critical."
            ) { context in
                RulePatternMatcher.matchesRegex("(kartinizla|kartiniz)\\s+.*(tl|try|odeme|harcama)", in: context.normalized)
                    || RulePatternMatcher.matchesRegex("\\d+[\\.,]?\\d*\\s*(tl|try).*(harcama|odeme|islem)", in: context.normalized)
                    || RulePatternMatcher.matchesRegex("(kredi kartinizla|sanal kartinizla)\\s+.*(harcama|odeme)", in: context.normalized)
            },
            RuleDefinition(
                id: "critical.payment_confirmation_variant",
                description: "Payment confirmation phrasing variants.",
                ruleType: .criticalProtection,
                severity: .medium,
                safeWeight: RuleWeights.bankTransaction,
                riskWeight: 0,
                explanationHint: "Detected payment confirmation wording; protected as critical."
            ) { context in
                RulePatternMatcher.containsAny([
                    "odemeniz alindi", "odemeniz alinmistir", "isleminiz tamamlandi",
                    "isleminiz basariyla tamamlandi", "havale isleminiz tamamlandi",
                    "eft isleminiz tamamlandi", "fast isleminiz tamamlandi",
                    "mobil odeme isleminiz", "para transferiniz tamamlandi", "odeme talebiniz onaylandi"
                ], in: context.normalized)
            },
            RuleDefinition(
                id: "critical.account_access",
                description: "Account access or suspicious transaction notice.",
                ruleType: .criticalProtection,
                severity: .high,
                safeWeight: RuleWeights.accountAccess,
                riskWeight: 0,
                explanationHint: "Detected login, suspicious transaction, or account-access wording; protected as critical."
            ) { context in
                RulePatternMatcher.containsAny([
                    "hesabiniza giris",
                    "giris denemeniz",
                    "supheli islem",
                    "hesabiniz icin dogrulama",
                    "yeni cihaz tanimlama",
                    "parola",
                    "sanal kart",
                    "supheli kart islemi",
                    "supheli giris",
                    "guvenlik nedeniyle hesabiniz",
                    "bilginiz disinda"
                ], in: context.normalized)
            }
        ]
    }
}
