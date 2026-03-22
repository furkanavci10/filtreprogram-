package com.filtreprogrami.organizer.model

data class ClassificationSnapshot(
    val category: String,
    val confidenceBand: String,
    val safeScore: Int,
    val riskScore: Int,
    val explanation: String,
    val normalizedText: String,
    val triggeredSignals: List<String>,
    val classifiedAtEpochMillis: Long
)
