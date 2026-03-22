package com.filtreprogrami.organizer.ingestion

import com.filtreprogrami.organizer.classification.ClassificationBridge
import com.filtreprogrami.organizer.model.AnalyzedArtifact
import com.filtreprogrami.organizer.model.MessageArtifact
import com.filtreprogrami.organizer.storage.LocalArtifactStore
import java.util.UUID

class ArtifactIntakeCoordinator(
    private val classificationBridge: ClassificationBridge,
    private val localArtifactStore: LocalArtifactStore
) {
    fun analyzeAndPersist(request: AnalyzeRequest): AnalyzeResult {
        val body = request.messageBody.trim()
        if (body.isEmpty()) {
            return AnalyzeResult.ValidationError("Message body is required for analysis.")
        }

        val now = System.currentTimeMillis()
        val artifact = MessageArtifact(
            artifactId = UUID.randomUUID().toString(),
            sourceType = request.sourceType,
            senderText = request.senderText?.trim()?.ifEmpty { null },
            messageBody = body,
            ingestedAtEpochMillis = now,
            provenanceNote = request.provenanceNote
        )

        val snapshot = classificationBridge.classify(request, now)
        val analyzedArtifact = AnalyzedArtifact(artifact, snapshot)
        localArtifactStore.save(analyzedArtifact)
        return AnalyzeResult.Success(analyzedArtifact)
    }

    fun analyze(request: AnalyzeRequest): AnalyzeResult {
        return analyzeAndPersist(request)
    }
}
