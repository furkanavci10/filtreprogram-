package com.filtreprogrami.organizer.storage

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "classification_snapshots")
data class ClassificationSnapshotEntity(
    @PrimaryKey val artifactId: String,
    val category: String,
    val confidenceBand: String,
    val safeScore: Int,
    val riskScore: Int,
    val explanation: String,
    val normalizedText: String,
    val triggeredSignalsBlob: String,
    val classifiedAtEpochMillis: Long
)
