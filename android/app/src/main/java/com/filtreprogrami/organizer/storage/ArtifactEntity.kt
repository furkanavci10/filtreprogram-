package com.filtreprogrami.organizer.storage

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.filtreprogrami.organizer.model.ArtifactSourceType

@Entity(tableName = "artifacts")
data class ArtifactEntity(
    @PrimaryKey val artifactId: String,
    val sourceType: ArtifactSourceType,
    val senderText: String?,
    val messageBody: String,
    val receivedAtEpochMillis: Long?,
    val ingestedAtEpochMillis: Long,
    val provenanceNote: String
)
