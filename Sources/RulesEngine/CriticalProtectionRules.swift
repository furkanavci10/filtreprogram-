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
                    "sifre yenileme",
                    "3d secure",
                    "giris kodu"
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
                    "kuveyt turk", "albaraka", "papara", "kartinizla", "hesabiniza"
                ], in: context.normalized)
                let hasAction = RulePatternMatcher.containsAny([
                    "harcama", "odeme", "isleminiz onaylandi", "islem gerceklesti",
                    "supheli islem", "hesabiniza giris", "mobil bankacilik", "para girisi",
                    "fast isleminiz", "havale isleminiz", "eft isleminiz", "odemeniz alinmistir"
                ], in: context.normalized)
                return hasBankTerm && hasAction
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
                    "sanal kart"
                ], in: context.normalized)
            }
        ]
    }
}
