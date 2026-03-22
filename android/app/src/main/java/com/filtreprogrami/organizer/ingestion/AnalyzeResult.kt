package com.filtreprogrami.organizer.ingestion

import com.filtreprogrami.organizer.model.AnalyzedArtifact

sealed interface AnalyzeResult {
    data class Success(val analyzedArtifact: AnalyzedArtifact) : AnalyzeResult
    data class ValidationError(val message: String) : AnalyzeResult
}
