package com.filtreprogrami.organizer.storage

import com.filtreprogrami.organizer.model.AnalyzedArtifact
import com.filtreprogrami.organizer.model.ClassificationSnapshot
import com.filtreprogrami.organizer.model.MessageArtifact

class RoomLocalArtifactStore(
    private val artifactDao: ArtifactDao
) : LocalArtifactStore {
    override fun save(analyzedArtifact: AnalyzedArtifact) {
        artifactDao.insertArtifact(
            ArtifactEntity(
                artifactId = analyzedArtifact.artifact.artifactId,
                sourceType = analyzedArtifact.artifact.sourceType,
                senderText = analyzedArtifact.artifact.senderText,
                messageBody = analyzedArtifact.artifact.messageBody,
                receivedAtEpochMillis = analyzedArtifact.artifact.receivedAtEpochMillis,
                ingestedAtEpochMillis = analyzedArtifact.artifact.ingestedAtEpochMillis,
                provenanceNote = analyzedArtifact.artifact.provenanceNote
            )
        )
        artifactDao.insertSnapshot(
            ClassificationSnapshotEntity(
                artifactId = analyzedArtifact.artifact.artifactId,
                category = analyzedArtifact.snapshot.category,
                confidenceBand = analyzedArtifact.snapshot.confidenceBand,
                safeScore = analyzedArtifact.snapshot.safeScore,
                riskScore = analyzedArtifact.snapshot.riskScore,
                explanation = analyzedArtifact.snapshot.explanation,
                normalizedText = analyzedArtifact.snapshot.normalizedText,
                triggeredSignalsBlob = analyzedArtifact.snapshot.triggeredSignals.joinToString("||"),
                classifiedAtEpochMillis = analyzedArtifact.snapshot.classifiedAtEpochMillis
            )
        )
    }

    override fun listAll(): List<AnalyzedArtifact> = artifactDao.listAll().map { it.toModel() }

    override fun listByCategory(category: String): List<AnalyzedArtifact> {
        return artifactDao.listByCategory(category).map { it.toModel() }
    }

    override fun findById(artifactId: String): AnalyzedArtifact? = artifactDao.findById(artifactId)?.toModel()

    override fun deleteById(artifactId: String) {
        artifactDao.deleteSnapshotById(artifactId)
        artifactDao.deleteArtifactById(artifactId)
    }

    override fun clear() {
        artifactDao.clearSnapshots()
        artifactDao.clearArtifacts()
    }

    private fun ArtifactWithSnapshot.toModel(): AnalyzedArtifact {
        return AnalyzedArtifact(
            artifact = MessageArtifact(
                artifactId = artifact.artifactId,
                sourceType = artifact.sourceType,
                senderText = artifact.senderText,
                messageBody = artifact.messageBody,
                receivedAtEpochMillis = artifact.receivedAtEpochMillis,
                ingestedAtEpochMillis = artifact.ingestedAtEpochMillis,
                provenanceNote = artifact.provenanceNote
            ),
            snapshot = ClassificationSnapshot(
                category = snapshot.category,
                confidenceBand = snapshot.confidenceBand,
                safeScore = snapshot.safeScore,
                riskScore = snapshot.riskScore,
                explanation = snapshot.explanation,
                normalizedText = snapshot.normalizedText,
                triggeredSignals = snapshot.triggeredSignalsBlob
                    .takeIf { it.isNotEmpty() }
                    ?.split("||")
                    ?: emptyList(),
                classifiedAtEpochMillis = snapshot.classifiedAtEpochMillis
            )
        )
    }
}
