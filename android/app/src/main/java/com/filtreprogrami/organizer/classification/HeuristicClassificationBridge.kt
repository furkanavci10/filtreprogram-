package com.filtreprogrami.organizer.classification

import com.filtreprogrami.organizer.ingestion.AnalyzeRequest
import com.filtreprogrami.organizer.model.ClassificationSnapshot
import java.util.Locale

class HeuristicClassificationBridge : ClassificationBridge {
    override fun classify(request: AnalyzeRequest, classifiedAtEpochMillis: Long): ClassificationSnapshot {
        val result = classifyContract(request)
        return ClassificationSnapshot(
            category = result.category.name,
            confidenceBand = result.confidenceBand.name,
            safeScore = result.safeScore,
            riskScore = result.riskScore,
            explanation = result.explanation,
            normalizedText = result.normalizedText,
            triggeredSignals = result.triggeredSignals,
            classifiedAtEpochMillis = classifiedAtEpochMillis
        )
    }

    internal fun classifyContract(request: AnalyzeRequest): BridgeClassificationResult {
        val normalized = normalize(request.messageBody)
        val sender = normalize(request.senderText.orEmpty())
        val combined = "$sender $normalized".trim()
        val compact = combined.replace(" ", "")

        var safeScore = 0
        var riskScore = 0
        val signals = linkedSetOf<String>()

        val hasOtp = containsPhrase(
            combined,
            compact,
            listOf(
                "onay kodu",
                "dogrulama kodu",
                "tek kullanimlik sifre",
                "giris kodu",
                "aktivasyon kodu",
                "bu kodu kimseyle paylasmayin"
            ),
            listOf("onaykodu", "dogrulamakodu", "tekkullanimliksifre", "giriskodu", "aktivasyonkodu", "otp")
        )
        val hasSecurity = containsPhrase(
            combined,
            compact,
            listOf(
                "hesabiniza giris",
                "supheli islem",
                "guvenlik",
                "oturum acma",
                "kartinizla",
                "islem onayi",
                "hesap hareketi",
                "sifre degisiklik"
            ),
            listOf("hesabinizagiris", "supheliislem", "oturumacma", "islemonayi", "hesaphareketi")
        )
        val hasBankHint = containsPhrase(
            combined,
            compact,
            listOf(
                "akbank",
                "garanti",
                "ziraat",
                "is bankasi",
                "yapi kredi",
                "vakifbank",
                "denizbank",
                "finansbank",
                "enpara",
                "kuveyt turk"
            ),
            listOf("akbank", "garanti", "ziraat", "isbankasi", "yapikredi", "vakifbank", "denizbank", "finansbank", "enpara", "kuveytturk")
        )
        val hasPaymentHint = containsPhrase(
            combined,
            compact,
            listOf(
                "odemeniz alindi",
                "isleminiz onaylandi",
                "harcama",
                "odeme",
                "tutar",
                "nakit cekim",
                "kart harcamaniz"
            ),
            listOf("odemenizalindi", "isleminizonaylandi", "nakitcekim", "kartharcamaniz")
        )
        val hasCargoHint = containsPhrase(
            combined,
            compact,
            listOf(
                "kargonuz",
                "takip no",
                "dagitima cikti",
                "teslim",
                "sube",
                "kurye",
                "paketiniz",
                "teslimat kodu"
            ),
            listOf("kargonuz", "takipno", "dagitimacikti", "paketiniz", "teslimatkodu")
        )
        val hasBillingHint = containsPhrase(
            combined,
            compact,
            listOf(
                "faturaniz",
                "son odeme",
                "paket yenileme",
                "fatura",
                "telekom",
                "vodafone",
                "turk telekom",
                "turkcell",
                "odeme tarihi"
            ),
            listOf("faturaniz", "sonodeme", "paketyenileme", "turktelekom", "odemetarihi")
        )
        val hasAppointmentHint = containsPhrase(
            combined,
            compact,
            listOf(
                "randevunuz",
                "muayene",
                "kontrol",
                "hastane",
                "klinik",
                "poliklinik",
                "hasta kabul",
                "muayene saati"
            ),
            listOf("randevunuz", "poliklinik", "hastakabul", "muayenesaati")
        )
        val hasPromoHint = containsPhrase(
            combined,
            compact,
            listOf("kampanya", "indirim", "firsat", "ozel teklif", "hediye", "kupon"),
            listOf("kampanya", "indirim", "firsat", "ozelteklif", "hediye", "kupon")
        )
        val hasBettingHint = containsPhrase(
            combined,
            compact,
            listOf(
                "bahis",
                "iddaa",
                "casino",
                "slot",
                "freebet",
                "bonus",
                "jackpot",
                "kupon",
                "oran",
                "yatirim bonusu",
                "deneme bonusu"
            ),
            listOf(
                "bahis",
                "iddaa",
                "casino",
                "slot",
                "freebet",
                "bonus",
                "jackpot",
                "kupon",
                "oran",
                "yatirimbonusu",
                "denemebonusu",
                "fr33bet",
                "b@his"
            )
        )
        val hasCredentialHint = containsPhrase(
            combined,
            compact,
            listOf(
                "sifre girin",
                "sifrenizi girin",
                "dogrulayin",
                "hesabinizi dogrulayin",
                "giris yapin",
                "kimlik bilgisi"
            ),
            listOf("sifregirin", "sifrenizigirin", "dogrulayin", "hesabinizidogrulayin", "girisyapin", "kimlikbilgisi")
        )
        val hasPaymentScamHint = containsPhrase(
            combined,
            compact,
            listOf(
                "odeme yapin",
                "kargo ucreti",
                "teslimat ucreti",
                "ek odeme",
                "borcunuz bulunmaktadir"
            ),
            listOf("odemeyapin", "kargoucreti", "teslimatucreti", "ekodeme", "borcunuzbulunmaktadir")
        )
        val hasActionHint = containsPhrase(
            combined,
            compact,
            listOf("linke tiklayin", "hemen tikla", "hemen gir", "islem yapin", "guncelleyin"),
            listOf("linketiklayin", "hementikla", "hemengir", "islemyapin", "guncelleyin", "lnketiklayin")
        )
        val hasSuspensionHint = containsPhrase(
            combined,
            compact,
            listOf("hesabiniz askiya alindi", "uyelik askida", "hesabiniz kapanacak", "kargonuz beklemede"),
            listOf("hesabinizaskiyaalindi", "uyelikaskida", "hesabinizkapanacak", "kargonuzbeklemede")
        )
        val hasUrgency = containsPhrase(
            combined,
            compact,
            listOf("son sans", "hemen", "acil", "bugun", "kapatilacak", "beklemede"),
            listOf("sonsans", "kapatilacak", "beklemede")
        )
        val hasUrl = combined.contains("http") ||
            combined.contains("www") ||
            compact.contains(".com") ||
            compact.contains(".top") ||
            compact.contains(".xyz") ||
            compact.contains(".cc")

        val hasPhishingHint = hasCredentialHint || hasPaymentScamHint || hasActionHint || hasSuspensionHint
        val hasCriticalSignal = hasOtp || hasSecurity || hasBankHint || hasPaymentHint
        val hasTransactionalSignal = hasCargoHint || hasBillingHint || hasAppointmentHint
        val hasSevereRisk = hasBettingHint ||
            ((hasCredentialHint || hasPaymentScamHint) && hasActionHint) ||
            (hasUrl && hasUrgency && hasPhishingHint)

        if (hasOtp) {
            safeScore += 70
            signals += "otp_wording"
        }
        if (hasSecurity || hasBankHint) {
            safeScore += 40
            signals += "security_or_bank_wording"
        }
        if (hasPaymentHint) {
            safeScore += 25
            signals += "payment_or_spend_wording"
        }
        if (hasCargoHint) {
            safeScore += 35
            signals += "cargo_wording"
        }
        if (hasBillingHint || hasAppointmentHint) {
            safeScore += 30
            signals += "transactional_wording"
        }

        if (hasPromoHint) {
            riskScore += 25
            signals += "promotional_wording"
        }
        if (hasBettingHint) {
            riskScore += 80
            signals += "betting_or_casino_wording"
        }
        if (hasCredentialHint) {
            riskScore += 45
            signals += "credential_request"
        }
        if (hasPaymentScamHint) {
            riskScore += 45
            signals += "payment_request"
        }
        if (hasActionHint) {
            riskScore += 20
            signals += "action_cta"
        }
        if (hasSuspensionHint) {
            riskScore += 25
            signals += "account_or_delivery_problem"
        }
        if (hasPhishingHint) {
            riskScore += 65
            signals += "phishing_cta"
        }
        if (hasUrgency) {
            riskScore += 15
            signals += "urgency_wording"
        }
        if (hasUrl) {
            riskScore += 15
            signals += "link_or_domain_present"
        }

        val category: ClassificationCategory
        val confidence: ConfidenceBand
        val explanation: String

        if (hasCriticalSignal && riskScore <= 25) {
            category = ClassificationCategory.ALLOW_CRITICAL
            confidence = if (hasOtp || hasBankHint) ConfidenceBand.HIGH else ConfidenceBand.MEDIUM
            explanation = "Detected OTP/security-style wording; protected as critical."
        } else if (hasCriticalSignal && riskScore > 25) {
            category = ClassificationCategory.REVIEW_SUSPICIOUS
            confidence = ConfidenceBand.MEDIUM
            explanation = "Detected critical-looking wording with suspicious cues; routed to review."
        } else if (hasTransactionalSignal && safeScore >= riskScore + 20) {
            category = ClassificationCategory.ALLOW_TRANSACTIONAL
            confidence = if (safeScore >= 45) ConfidenceBand.MEDIUM else ConfidenceBand.LOW
            explanation = "Detected transactional wording; treated as operational communication."
        } else if (hasBettingHint && safeScore <= 10) {
            category = ClassificationCategory.FILTER_SPAM
            confidence = ConfidenceBand.HIGH
            explanation = "Detected gambling terms and spam-style language; classified as spam."
        } else if (hasSevereRisk && safeScore <= 20) {
            category = ClassificationCategory.FILTER_SPAM
            confidence = ConfidenceBand.HIGH
            explanation = "Detected phishing-style action, urgency, and link cues; classified as spam."
        } else if ((hasPhishingHint || hasUrl || hasUrgency) && safeScore > 0) {
            category = ClassificationCategory.REVIEW_SUSPICIOUS
            confidence = ConfidenceBand.MEDIUM
            explanation = "Detected safe-looking wording with suspicious cues; routed to review."
        } else if (hasPromoHint && !hasBettingHint && !hasPhishingHint && !hasCriticalSignal && !hasTransactionalSignal && safeScore < 25) {
            category = ClassificationCategory.FILTER_PROMOTIONAL
            confidence = ConfidenceBand.MEDIUM
            explanation = "Detected promotional wording without strong critical or transactional signals."
        } else if (safeScore >= 20 && safeScore >= riskScore) {
            category = ClassificationCategory.ALLOW_NORMAL
            confidence = ConfidenceBand.LOW
            explanation = "Detected non-risky content; treated as normal."
        } else if (riskScore > safeScore) {
            category = ClassificationCategory.REVIEW_SUSPICIOUS
            confidence = ConfidenceBand.LOW
            explanation = "Detected suspicious cues without enough confidence for direct spam filtering."
        } else {
            category = ClassificationCategory.ALLOW_NORMAL
            confidence = ConfidenceBand.LOW
            explanation = "No strong risk signals detected; treated as normal."
        }

        return BridgeClassificationResult(
            category = category,
            confidenceBand = confidence,
            safeScore = safeScore,
            riskScore = riskScore,
            explanation = explanation,
            normalizedText = normalized,
            triggeredSignals = signals.toList()
        )
    }

    private fun normalize(text: String): String {
        val lowered = text.lowercase(Locale("tr", "TR"))
        val folded = lowered
            .replace('ç', 'c')
            .replace('ğ', 'g')
            .replace('ı', 'i')
            .replace('ö', 'o')
            .replace('ş', 's')
            .replace('ü', 'u')
            .replace("@", "a")
            .replace("!", "i")
            .replace("$", "s")
            .replace("3", "e")
            .replace("1", "i")
            .replace("0", "o")

        return folded
            .replace(Regex("[^a-z0-9 ]"), " ")
            .replace(Regex("\\s+"), " ")
            .trim()
    }

    private fun containsPhrase(
        text: String,
        compactText: String,
        phraseCandidates: List<String>,
        compactCandidates: List<String>
    ): Boolean {
        return phraseCandidates.any { text.contains(it) } || compactCandidates.any { compactText.contains(it) }
    }
}
