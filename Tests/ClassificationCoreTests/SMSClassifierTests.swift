import XCTest
import ClassificationCore
import Dataset
import MessageFilteringDomain
import RulesEngine

final class SMSClassifierTests: XCTestCase {
    private let normalizer = NormalizationEngine()

    func testNormalizationFixtures() {
        XCTAssertGreaterThanOrEqual(ClassificationFixtures.normalization.count, 35)

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

    func testNormalizationCapturesBahisObfuscation() {
        let samples = ["b a h i s", "ba-his", "ba.his", "ba_hi_s", "b@h!s", "b4his", "baaahiiis"]

        for sample in samples {
            let normalized = normalizer.normalize(.init(body: sample))
            XCTAssertTrue(
                normalized.compactText.contains("bahis") || normalized.aggressiveCompactText.contains("bahis"),
                "Expected bahis normalization for \(sample), got \(normalized)"
            )
        }
    }

    func testNormalizationCapturesIddaaObfuscation() {
        let samples = ["i d d a a", "i.d.d.a.a", "\u{131}ddaa", "1ddaa"]

        for sample in samples {
            let normalized = normalizer.normalize(.init(body: sample))
            XCTAssertTrue(
                normalized.compactText.contains("iddaa") || normalized.aggressiveCompactText.contains("iddaa"),
                "Expected iddaa normalization for \(sample), got \(normalized)"
            )
        }
    }

    func testNormalizationCapturesObfuscatedPhishingCTA() {
        let normalized = normalizer.normalize(.init(body: "l!nke t!klay!n ve d0grulayin"))
        XCTAssertTrue(normalized.aggressiveText.contains("linke tiklayin"))
        XCTAssertTrue(normalized.aggressiveText.contains("dogrulayin"))
    }

    func testNormalizationHandlesFakeCargoVariations() {
        let samples = [
            "kar go nuz bekle mede",
            "kargo-nuz beklemede",
            "karg0nuz beklemede",
            "kargonuz teslim edilemedi"
        ]

        for sample in samples {
            let normalized = normalizer.normalize(.init(body: sample))
            XCTAssertTrue(
                normalized.compactText.contains("kargonuz") || normalized.aggressiveCompactText.contains("kargonuz"),
                "Expected cargo normalization for \(sample), got \(normalized)"
            )
        }
    }

    func testNormalizationPreservesSafeBankAndOtpWording() {
        let normalized = normalizer.normalize(.init(body: "\u{15E}üpheli işlem için doğrulama kodunuz 551122."))
        XCTAssertTrue(normalized.normalizedText.contains("supheli islem"))
        XCTAssertTrue(normalized.normalizedText.contains("dogrulama kodunuz"))
        XCTAssertTrue(normalized.tokens.contains("supheli"))
        XCTAssertTrue(normalized.tokens.contains("islem"))
    }

    func testCriticalProtectionFixtures() {
        XCTAssertGreaterThanOrEqual(ClassificationFixtures.critical.count, 40)
        let classifier = SMSClassifier()

        for fixture in ClassificationFixtures.critical {
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed critical fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.safeScore, 0, "Expected safe score for \(fixture.name)")
            XCTAssertNotEqual(result.category, .filterSpam, "Critical-style message must not be spam: \(fixture.name)")
        }
    }

    func testCriticalOtpVariantRuleCoversActivationAndSecurityCodeWording() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Amazon",
            body: "Aktivasyon kodunuz 551908. Guvenlik kodu olarak kullaniniz."
        ))

        XCTAssertEqual(result.category, .allowCritical)
        XCTAssertGreaterThan(result.safeScore, 0)
    }

    func testCriticalCardSpendRuleCoversAmountBasedAlerts() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Garanti",
            body: "Kartinizla 1.149 TL odeme yapildi."
        ))

        XCTAssertEqual(result.category, .allowCritical)
    }

    func testTransactionalFixtures() {
        XCTAssertGreaterThanOrEqual(ClassificationFixtures.transactional.count, 35)
        let classifier = SMSClassifier()

        for fixture in ClassificationFixtures.transactional {
            let result = classifier.classify(fixture.input)
            XCTAssertEqual(result.category, fixture.expectedCategory, "Failed transactional fixture: \(fixture.name)")
            XCTAssertGreaterThan(result.safeScore, result.riskScore, "Transactional safe score should dominate for \(fixture.name)")
        }
    }

    func testTransactionalExtendedCargoRuleCoversSubeAndDeliveryWindowLanguage() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "MNG Kargo",
            body: "Gonderiniz subeye ulasmistir ve bugun teslim edilecektir."
        ))

        XCTAssertEqual(result.category, .allowTransactional)
    }

    func testTransactionalTelecomExtendedRuleCoversPackageRenewal() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Vodafone",
            body: "Ek paketiniz tanimlandi. Paketinizin suresi yarin doluyor."
        ))

        XCTAssertEqual(result.category, .allowTransactional)
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

    func testStrongSafePlusWeakRiskStillAllowsWhenTransactionalDominates() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "MHRS",
            body: "Randevunuz yarin 13:45 icin onaylanmistir. Hemen kontrol edin."
        ))

        XCTAssertEqual(result.category, .allowTransactional)
        XCTAssertTrue([ConfidenceBand.medium, .high].contains(result.confidenceBand))
    }

    func testSpamAndPromotionalFixtures() {
        XCTAssertGreaterThanOrEqual(ClassificationFixtures.spam.count, 45)

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

    func testPromotionalRuleCoversRetailCampaignWithoutBecomingSpam() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Retail",
            body: "Kampanya basladi, ozel firsat sizi bekliyor."
        ))

        XCTAssertEqual(result.category, .filterPromotional)
    }

    func testConflictAndPhishingFixtures() {
        XCTAssertGreaterThanOrEqual(ClassificationFixtures.conflict.count, 35)
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

    func testSpamVariantRuleCoversMixedTurkishEnglishBettingLanguage() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Cashout hizli, vip giris aktif, register simdi."
        ))

        XCTAssertEqual(result.category, .filterSpam)
    }

    func testFakeCargoConflictRoutesToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Kargonuz teslim edilemedi. 12,50 TL odeme icin ptt-odeme.top adresine girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertNotEqual(result.confidenceBand, .high)
    }

    func testFakeCargoPaymentRuleCoversCargoFeeTrap() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "PTT teslim ucreti odemesi bekliyor, odeme yapin ve kart bilgisi girin."
        ))

        XCTAssertTrue([MessageClassificationCategory.reviewSuspicious, .filterSpam].contains(result.category))
        XCTAssertGreaterThan(result.riskScore, 0)
    }

    func testFakeBankConflictRoutesToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Akbank hesabiniz bloke edildi. Sifrenizi guncellemek icin akbnk-guvenlik.net adresine girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertNotEqual(result.confidenceBand, .high)
    }

    func testFakeBankCredentialRuleCoversCredentialHarvestLanguage() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Garanti hesabiniz kapanacak, sifrenizi girin ve hesabinizi dogrulayin."
        ))

        XCTAssertTrue([MessageClassificationCategory.reviewSuspicious, .filterSpam].contains(result.category))
        XCTAssertGreaterThan(result.riskScore, 0)
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

    func testClearSpamWithLowSafeDoesNotOverRouteToReview() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Hesabiniz askiya alindi, odul kazandiniz, linke tiklayin, sifrenizi girin, tinyurl.com/abc"
        ))

        XCTAssertEqual(result.category, .filterSpam)
    }

    func testLegitimateCampaignLikeMessageRemainsNonSpam() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Turkcell",
            body: "Tarifenize ek 5GB hediye tanimlandi. Paketiniz bu ay icin yenilendi."
        ))

        XCTAssertNotEqual(result.category, .filterSpam)
    }

    func testConfidenceBandForReviewStaysUncertaintyOriented() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            body: "Akbank onay kodunuz 551122. Linke tiklayip sifrenizi girin."
        ))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertNotEqual(result.confidenceBand, .high)
    }

    func testConfidenceBandForPromotionalIsNotHigh() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(
            sender: "Retail",
            body: "Kampanya basladi, ozel firsat sizi bekliyor."
        ))

        XCTAssertEqual(result.category, .filterPromotional)
        XCTAssertNotEqual(result.confidenceBand, .high)
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

    func testExplanationIsStableForSameInput() {
        let classifier = SMSClassifier()
        let input = ClassificationInput(body: "Akbank: Mobil onay kodunuz 551122. Kimseyle paylasmayin.")
        let first = classifier.classify(input)
        let second = classifier.classify(input)

        XCTAssertEqual(first.explanation, second.explanation)
        XCTAssertEqual(first.category, second.category)
        XCTAssertEqual(first.confidenceBand, second.confidenceBand)
    }

    func testCriticalExplanationIsConciseAndDeterministic() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Dogrulama kodunuz 771204. Bu kodu kimseyle paylasmayin."))

        XCTAssertEqual(result.explanation, "Detected OTP/security wording; protected as critical.")
    }

    func testReviewExplanationMentionsCargoAndSuspiciousCues() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Kargonuz teslim edilemedi. 12,50 TL odeme icin ptt-odeme.top adresine girin."))

        XCTAssertEqual(result.category, .reviewSuspicious)
        XCTAssertEqual(result.explanation, "Detected cargo wording with suspicious payment/link cues; routed to review.")
    }

    func testSpamExplanationMentionsGamblingAndLinkCues() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Bahis, casino, freebet, deneme bonusu, tinyurl.com/abc"))

        XCTAssertEqual(result.category, .filterSpam)
        XCTAssertEqual(result.explanation, "Detected gambling terms, bonus language, and suspicious link; classified as spam.")
    }

    func testClassificationResultAlwaysIncludesConsistentOutputFields() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Merhaba, musait misin?"))

        XCTAssertFalse(result.explanation.isEmpty)
        XCTAssertFalse(result.normalizedText.isEmpty)
        XCTAssertGreaterThanOrEqual(result.safeScore, 0)
        XCTAssertGreaterThanOrEqual(result.riskScore, 0)
        XCTAssertNotNil(result.confidenceBand)
        XCTAssertNotNil(result.category)
        XCTAssertNotNil(result.triggeredSignals)
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

    func testAllowlistedSenderMatchesTurkishCasingAndSpacingVariation() {
        let configuration = ClassifierConfiguration(allowlistedSenders: ["Türk Telekom"])
        XCTAssertTrue(configuration.isAllowlisted(sender: " turk  telekom "))
        XCTAssertTrue(configuration.isAllowlisted(sender: "TURK-TELEKOM"))
    }

    func testDenylistedSenderMatchesPunctuationVariation() {
        let configuration = ClassifierConfiguration(denylistedSenders: ["Spam Sender"])
        XCTAssertTrue(configuration.isDenylisted(sender: "spam-sender"))
        XCTAssertTrue(configuration.isDenylisted(sender: "Spam   Sender"))
    }

    func testWhitelistTermMatchesTurkishAsciiVariants() {
        let configuration = ClassifierConfiguration(whitelistTerms: ["şüpheli işlem"])
        XCTAssertTrue(configuration.matchesWhitelistTerm("Supheli islem tespit edildi"))
        XCTAssertTrue(configuration.matchesWhitelistTerm("supheli-islem bildirimi"))
    }

    func testBlacklistTermMatchesNormalizedVariants() {
        let configuration = ClassifierConfiguration(blacklistTerms: ["linke tıklayın"])
        XCTAssertTrue(configuration.matchesBlacklistTerm("Linke tiklayin"))
        XCTAssertTrue(configuration.matchesBlacklistTerm("linke-tiklayin"))
    }

    func testUserPreferencesStillDoNotOverrideCriticalSafeProtection() {
        let configuration = ClassifierConfiguration(
            aggressivePromotionalFiltering: true,
            bahisFilteringEnabled: true,
            filteringStrength: .aggressive,
            allowlistedSenders: [],
            whitelistTerms: [],
            denylistedSenders: ["Akbank"],
            blacklistTerms: ["onay kodu", "bonus"]
        )
        let classifier = SMSClassifier(configuration: configuration)
        let result = classifier.classify(.init(sender: "Akbank", body: "Mobil onay kodunuz 551122. Kimseyle paylasmayin."))

        XCTAssertNotEqual(result.category, .filterSpam)
        XCTAssertTrue([MessageClassificationCategory.allowCritical, .reviewSuspicious].contains(result.category))
    }

    func testConfidenceBandIsReturned() {
        let classifier = SMSClassifier()
        let result = classifier.classify(.init(body: "Dogrulama kodunuz 771204. Bu kodu kimseyle paylasmayin."))
        XCTAssertEqual(result.confidenceBand, .high)
    }

    func testIntegrationServiceReturnsAllowDispositionForCriticalMessage() {
        let service = SMSFilterClassifierService()
        let response = service.classify(.init(sender: "Akbank", messageBody: "Mobil onay kodunuz 551122."))

        XCTAssertEqual(response.disposition, .allow)
        XCTAssertEqual(response.result.category, .allowCritical)
    }

    func testIntegrationServiceReturnsReviewDispositionForMixedSignalMessage() {
        let service = SMSFilterClassifierService()
        let response = service.classify(.init(messageBody: "Akbank onay kodunuz 551122. Linke tiklayip sifrenizi girin."))

        XCTAssertEqual(response.disposition, .review)
        XCTAssertEqual(response.result.category, .reviewSuspicious)
    }

    func testIntegrationServiceReturnsJunkDispositionForSpamMessage() {
        let service = SMSFilterClassifierService()
        let response = service.classify(.init(messageBody: "Bahis, casino, freebet, tinyurl.com/abc"))

        XCTAssertEqual(response.disposition, .junk)
        XCTAssertEqual(response.result.category, .filterSpam)
    }
}
