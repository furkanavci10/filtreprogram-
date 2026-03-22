package com.filtreprogrami.organizer.classification

enum class ClassificationCategory {
    ALLOW_CRITICAL,
    ALLOW_TRANSACTIONAL,
    ALLOW_NORMAL,
    REVIEW_SUSPICIOUS,
    FILTER_PROMOTIONAL,
    FILTER_SPAM
}

enum class ConfidenceBand {
    LOW,
    MEDIUM,
    HIGH
}

data class BridgeClassificationResult(
    val category: ClassificationCategory,
    val confidenceBand: ConfidenceBand,
    val safeScore: Int,
    val riskScore: Int,
    val explanation: String,
    val normalizedText: String,
    val triggeredSignals: List<String>
)
