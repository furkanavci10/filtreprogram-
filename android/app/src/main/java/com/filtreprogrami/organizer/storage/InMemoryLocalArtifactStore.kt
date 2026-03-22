package com.filtreprogrami.organizer.storage

import com.filtreprogrami.organizer.model.AnalyzedArtifact

class InMemoryLocalArtifactStore : LocalArtifactStore {
    private val artifacts = linkedMapOf<String, AnalyzedArtifact>()

    override fun save(analyzedArtifact: AnalyzedArtifact) {
        artifacts[analyzedArtifact.artifact.artifactId] = analyzedArtifact
    }

    override fun listAll(): List<AnalyzedArtifact> {
        return artifacts.values.toList().reversed()
    }

    override fun listByCategory(category: String): List<AnalyzedArtifact> {
        return artifacts.values.filter { it.snapshot.category == category }.reversed()
    }

    override fun findById(artifactId: String): AnalyzedArtifact? {
        return artifacts[artifactId]
    }

    override fun deleteById(artifactId: String) {
        artifacts.remove(artifactId)
    }

    override fun clear() {
        artifacts.clear()
    }
}
