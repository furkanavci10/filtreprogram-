package com.filtreprogrami.organizer.model

data class MessageArtifact(
    val artifactId: String,
    val sourceType: ArtifactSourceType,
    val senderText: String?,
    val messageBody: String,
    val receivedAtEpochMillis: Long? = null,
    val ingestedAtEpochMillis: Long,
    val provenanceNote: String
)
