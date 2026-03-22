package com.filtreprogrami.organizer.classification

import com.filtreprogrami.organizer.ingestion.AnalyzeRequest
import com.filtreprogrami.organizer.model.ArtifactSourceType
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class HeuristicClassificationBridgeTest {
    private val bridge = HeuristicClassificationBridge()

    @Test
    fun criticalBankOtpMessage_mapsToAllowCritical() {
        val result = bridge.classifyContract(
            request(
                sender = "Akbank",
                body = "Onay kodunuz 123456. Bu kodu kimseyle paylasmayin."
            )
        )

        assertEquals(ClassificationCategory.ALLOW_CRITICAL, result.category)
        assertEquals(ConfidenceBand.HIGH, result.confidenceBand)
        assertTrue(result.safeScore > result.riskScore)
    }

    @Test
    fun securityAlertWithWeakNoise_staysProtectedOrReviewButNotSpam() {
        val result = bridge.classifyContract(
            request(
                sender = "Garanti BBVA",
                body = "Supheli islem bildirimi. Hesabiniza giris denemesi algilandi, hemen kontrol edin."
            )
        )

        assertTrue(
            result.category == ClassificationCategory.ALLOW_CRITICAL ||
                result.category == ClassificationCategory.REVIEW_SUSPICIOUS
        )
        assertTrue(result.category != ClassificationCategory.FILTER_SPAM)
    }

    @Test
    fun cargoMessage_mapsToAllowTransactional() {
        val result = bridge.classifyContract(
            request(
                sender = "Yurtici Kargo",
                body = "Kargonuz dagitima cikti. Takip no 12345."
            )
        )

        assertEquals(ClassificationCategory.ALLOW_TRANSACTIONAL, result.category)
        assertTrue(result.safeScore > result.riskScore)
    }

    @Test
    fun billingAppointmentMessage_mapsToAllowTransactional() {
        val result = bridge.classifyContract(
            request(
                sender = "Turk Telekom",
                body = "Faturaniz hazir. Son odeme tarihi 25 Mart. Paket yenileme bilginiz ektedir."
            )
        )

        assertEquals(ClassificationCategory.ALLOW_TRANSACTIONAL, result.category)
    }

    @Test
    fun fakeBankConflict_mapsToReviewSuspicious() {
        val result = bridge.classifyContract(
            request(
                sender = "Akbank Guvenlik",
                body = "Hesabiniza giris denemesi var. Linke tiklayin ve sifrenizi dogrulayin."
            )
        )

        assertEquals(ClassificationCategory.REVIEW_SUSPICIOUS, result.category)
        assertTrue(result.riskScore > 0)
        assertTrue(result.safeScore > 0)
    }

    @Test
    fun fakeCargoPaymentScam_mapsToReviewWhenSafeLooking() {
        val result = bridge.classifyContract(
            request(
                sender = "Aras Kargo",
                body = "Kargonuz beklemede. Teslimat icin linke tiklayin ve 14,99 TL kargo ucreti odeyin."
            )
        )

        assertEquals(ClassificationCategory.REVIEW_SUSPICIOUS, result.category)
        assertTrue(result.safeScore > 0)
        assertTrue(result.riskScore > 0)
    }

    @Test
    fun clearBahisSpam_mapsToFilterSpam() {
        val result = bridge.classifyContract(
            request(
                sender = "BonusClub",
                body = "Freebet bonus casino bahis kupon oran hemen giris yap!"
            )
        )

        assertEquals(ClassificationCategory.FILTER_SPAM, result.category)
        assertEquals(ConfidenceBand.HIGH, result.confidenceBand)
    }

    @Test
    fun obfuscatedBahisSpamStillMapsToFilterSpam() {
        val result = bridge.classifyContract(
            request(
                sender = "BonusClub",
                body = "B@his fr33bet 1ddaa bonusu hemen tikla"
            )
        )

        assertEquals(ClassificationCategory.FILTER_SPAM, result.category)
        assertTrue(result.triggeredSignals.contains("betting_or_casino_wording"))
    }

    @Test
    fun clearPhishingWithWeakSafe_mapsToFilterSpam() {
        val result = bridge.classifyContract(
            request(
                sender = "Destek",
                body = "Hesabiniz askiya alindi. http://guvenlik-giris.top linke tiklayin ve sifrenizi girin."
            )
        )

        assertEquals(ClassificationCategory.FILTER_SPAM, result.category)
        assertEquals(ConfidenceBand.HIGH, result.confidenceBand)
    }

    @Test
    fun promotionalMessage_mapsToFilterPromotional() {
        val result = bridge.classifyContract(
            request(
                sender = "Marka",
                body = "Size ozel kampanya ve indirim firsati."
            )
        )

        assertEquals(ClassificationCategory.FILTER_PROMOTIONAL, result.category)
    }

    @Test
    fun promotionalMessage_isNotEscalatedToSpamWithoutStrongerRisk() {
        val result = bridge.classifyContract(
            request(
                sender = "Marka",
                body = "Ozel teklif ve kampanya kuponu sizi bekliyor."
            )
        )

        assertTrue(result.category != ClassificationCategory.FILTER_SPAM)
    }

    @Test
    fun harmlessMessage_mapsToAllowNormal() {
        val result = bridge.classifyContract(
            request(
                sender = "Arkadas",
                body = "Aksam goruselim, eve gelince haber ver."
            )
        )

        assertEquals(ClassificationCategory.ALLOW_NORMAL, result.category)
        assertTrue(result.explanation.isNotBlank())
    }

    private fun request(sender: String?, body: String): AnalyzeRequest {
        return AnalyzeRequest(
            sourceType = ArtifactSourceType.PASTE_ANALYZE,
            senderText = sender,
            messageBody = body,
            provenanceNote = "test"
        )
    }
}
