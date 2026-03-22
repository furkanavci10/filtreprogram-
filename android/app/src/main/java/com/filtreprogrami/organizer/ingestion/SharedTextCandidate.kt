package com.filtreprogrami.organizer.ingestion

data class SharedTextCandidate(
    val body: String,
    val provenanceNote: String = "shared_text_intent"
)
