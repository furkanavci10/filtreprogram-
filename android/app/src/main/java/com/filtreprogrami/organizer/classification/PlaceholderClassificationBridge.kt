package com.filtreprogrami.organizer.classification

import com.filtreprogrami.organizer.ingestion.AnalyzeRequest
import com.filtreprogrami.organizer.model.ClassificationSnapshot

class PlaceholderClassificationBridge : ClassificationBridge {
    override fun classify(
        request: AnalyzeRequest,
        classifiedAtEpochMillis: Long
    ): ClassificationSnapshot {
        val contract = BridgeClassificationResult(
            category = ClassificationCategory.ALLOW_NORMAL,
            confidenceBand = ConfidenceBand.LOW,
            safeScore = 0,
            riskScore = 0,
            explanation = "Placeholder bridge: shared trust-first classifier is not connected yet.",
            normalizedText = request.messageBody.trim(),
            triggeredSignals = listOf("placeholder_bridge")
        )
        return ClassificationSnapshot(
            category = contract.category.name,
            confidenceBand = contract.confidenceBand.name,
            safeScore = contract.safeScore,
            riskScore = contract.riskScore,
            explanation = contract.explanation,
            normalizedText = contract.normalizedText,
            triggeredSignals = contract.triggeredSignals,
            classifiedAtEpochMillis = classifiedAtEpochMillis
        )
    }
}
