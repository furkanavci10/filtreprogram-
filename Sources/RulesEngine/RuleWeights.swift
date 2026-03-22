import Foundation

enum RuleWeights {
    static let criticalOTP = 95
    static let criticalSecurityPhrase = 72
    static let bankTransaction = 70
    static let accountAccess = 65
    static let transactional = 44
    static let trustedDomain = 15
    static let allowlist = 35

    static let denylist = 92
    static let betting = 58
    static let bettingAmplifier = 20
    static let phishing = 48
    static let phishingAmplifier = 28
    static let promo = 24
    static let urgency = 14
    static let suspiciousLink = 24
    static let blacklistTerm = 28
}
