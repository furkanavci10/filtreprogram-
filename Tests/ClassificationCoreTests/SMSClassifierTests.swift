import XCTest
import ClassificationCore
import Dataset
import MessageFilteringDomain
import RulesEngine

final class SMSClassifierTests: XCTestCase {
    private let normalizer = NormalizationEngine()

    func testNormalizationFixtures() {
        XCTAssertEqual(ClassificationFixtures.normalization.count, 15)

        for fixture in ClassificationFixtures.normalization {
            let normalized = normalizer.normalize(.init(body: fixture.input))
            for fragment in fixture.expectedComparableFragments {
                let compact = fragment.replacingOccurrences(of: " ", with: "")
                XCTAssertTrue(
                    normalized.normalizedText.contains(fragment)
                        || normalized.compactText.contains(compact)
                        || normalized.aggressiveText.contains(fragment)
                        || normalized.aggressiveCompactText.contains(compact),
                    "Normalization failed for \(fixture.name): \(normalized)"
                )
            }
        }
    }

    func testCriticalProtectionFixtures() {
        XCTAssertEqual(ClassificationFixtures.critical.count, 20)
        let classifier = SMSClassifier()

        for fixture in ClassificationFixtures.critical {
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed critical fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.safeScore, 0, "Expected safe score for \(fixture.name)")
            XCTAssertNotEqual(result.category, .filterSpam, "Critical-style message must not be spam: \(fixture.name)")
        }
    }

    func testTransactionalFixtures() {
        XCTAssertEqual(ClassificationFixtures.transactional.count, 15)
        let classifier = SMSClassifier()

        for fixture in ClassificationFixtures.transactional {
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed transactional fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.safeScore, result.riskScore, "Transactional safe score should dominate for \(fixture.name)")
        }
    }

    func testHighSafeTransactionalMessageDoesNotBecomeAllowCriticalWithoutCriticalSignals() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Aras Kargo",
            body: "Kargonuz dagitima cikarilmistir. Takip no 438219. Paketiniz teslim edilecektir."
        ))

        XCTAssertEqual(result.category, .allowTransactional)
        XCTAssertNotEqual(result.category, .allowCritical)
    }

    func testSafePlusWeakRiskDoesNotAlwaysBecomeReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Yurtici Kargo",
            body: "Kargonuz dagitima cikti. Takip no 12345. Hemen kontrol edin."
        ))

        XCTAssertEqual(result.category, .allowTransactional)
    }

    func testSpamAndPromotionalFixtures() {
        XCTAssertEqual(ClassificationFixtures.spam.count, 20)

        let defaultClassifier = SMSClassifier()
        let denylistClassifier = SMSClassifier(configuration: .init(denylistedSenders: ["spam sender"]))

        for fixture in ClassificationFixtures.spam {
            let classifier = fixture.name == "blacklist_term_spam" ? denylistClassifier : defaultClassifier
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed spam fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.riskScore, 0, "Expected risk score for \(fixture.name)")
        }
    }

    func testLegitimateCampaignLikeTelecomMessageDoesNotBecomePromotionalTooEagerly() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Vodafone",
            body: "Tarifenize ek 5GB hediye tanimlandi. Paketiniz bu ay icin yenilendi."
        ))

        XCTAssertNotEqual(result.category, .filterPromotional)
        XCTAssertTrue([MessageClassificationCategory.allowTransactional, .allowNormal].contains(result.category))
    }

    func testConflictAndPhishingFixtures() {
        XCTAssertEqual(ClassificationFixtures.conflict.count, 15)
        let classifier = SMSClassifier()

        for fixture in ClassificationFixtures.conflict {
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed conflict fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.safeScore + result.riskScore, 0, "Expected scoring for \(fixture.name)")
            XCTAssertNotEqual(result.category, .filterSpam, "Conflict case must not directly filter: \(fixture.name)")
        }
    }

    func testClearBahisSpamEscalatesToFilterSpam() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Bahis, casino, freebet, deneme bonusu, hemen uye ol ve tinyurl.com/abc adresine gir."
        ))

        XCTAssertEqual(result.category, .filterSpam)
        XCTAssertEqual(result.confidenceBand, .high)
    }

    func testFakeCargoConflictRoutesToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Kargonuz teslim edilemedi. 12,50 TL odeme icin ptt-odeme.top adresine girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertNotEqual(result.confidenceBand, .high)
    }

    func testFakeBankConflictRoutesToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Akbank hesabiniz bloke edildi. Sifrenizi guncellemek icin akbnk-guvenlik.net adresine girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertNotEqual(result.confidenceBand, .high)
    }

    func testMixedSignalFakeBankStillRoutesToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Akbank",
            body: "Akbank onay kodunuz 551122. Hesabinizi acmak icin linke tiklayip sifrenizi girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
    }

    func testExplicitBankSecurityMessageRemainsProtected() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Akbank",
            body: "Akbank: Mobil onay kodunuz 551122. Kimseyle paylasmayin."
        ))

        XCTAssertEqual(result.category, .allowCritical)
        XCTAssertEqual(result.confidenceBand, .high)
    }

    func testClearlyMaliciousPhishingWithWeakSafeBecomesSpam() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Hesabiniz askiya alindi, linke tiklayin, sifrenizi girin, tinyurl.com/abc ile hemen dogrulayin."
        ))

        XCTAssertEqual(result.category, .filterSpam)
    }

    func testWeakTransactionalHintDoesNotAutomaticallyBecomeTransactional() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Paketiniz icin bilgi mevcut."
        ))

        XCTAssertNotEqual(result.category, .allowTransactional)
    }

    func testExplanationsAndTriggeredSignalsArePresent() {
        let classifier = SMSClassifier(configuration: .init(blacklistTerms: ["spam paneli"]))
        let fixtures = Array(ClassificationFixtures.critical.prefix(3))
            + Array(ClassificationFixtures.transactional.prefix(3))
            + Array(ClassificationFixtures.spam.prefix(3))
            + Array(ClassificationFixtures.conflict.prefix(3))

        for fixture in fixtures {
            let result = classifier.classify(fixture.input)
            XCTAssertFalse(result.explanation.isEmpty, "Explanation missing for \(fixture.name)")
            XCTAssertFalse(result.triggeredSignals.isEmpty, "Signals missing for \(fixture.name)")
            XCTAssertFalse(result.normalizedText.isEmpty, "Normalized text missing for \(fixture.name)")
        }
    }

    func testUserPreferenceRulesDoNotWeakenCriticalProtection() {
        let configuration = ClassifierConfiguration(
            aggressivePromotionalFiltering: true,
            bahisFilteringEnabled: true,
            filteringStrength: .aggressive,
            blacklistTerms: ["bonus"]
        )
        let classifier = SMSClassifier(configuration: configuration)
        let result = classifier.classify(.init(sender: "Akbank", body: "Onay kodunuz 551122. Bonus puaniniz uygulamada."))

        XCTAssertEqual(result.category, .allowCritical)
        XCTAssertNotEqual(result.category, .filterSpam)
    }

    func testAllowlistAndDenylistBehavior() {
        let allowClassifier = SMSClassifier(configuration: .init(allowlistedSenders: ["mhrs"]))
        let allowResult = allowClassifier.classify(.init(sender: "MHRS", body: "Randevunuz yarin 14:00'te."))
        XCTAssertEqual(allowResult.category, .allowTransactional)

        let denyClassifier = SMSClassifier(configuration: .init(denylistedSenders: ["spam sender"]))
        let denyResult = denyClassifier.classify(.init(sender: "Spam Sender", body: "Bahis paneli aktif."))
        XCTAssertTrue([MessageClassificationCategory.reviewSuspicious, .filterSpam].contains(denyResult.category))
        XCTAssertTrue(denyResult.triggeredSignals.contains(where: { $0.id == "user.denylisted_sender" }))
    }

    func testConfidenceBandIsReturned() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Dogrulama kodunuz 771204. Bu kodu kimseyle paylasmayin."))
        XCTAssertEqual(result.confidenceBand, .high)
    }
}
