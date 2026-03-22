package com.filtreprogrami.organizer.ingestion

import com.filtreprogrami.organizer.model.ArtifactSourceType

data class AnalyzeRequest(
    val sourceType: ArtifactSourceType,
    val senderText: String?,
    val messageBody: String,
    val provenanceNote: String
)
