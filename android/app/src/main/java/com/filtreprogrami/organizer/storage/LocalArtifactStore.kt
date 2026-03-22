package com.filtreprogrami.organizer.storage

import com.filtreprogrami.organizer.model.AnalyzedArtifact

interface LocalArtifactStore {
    fun save(analyzedArtifact: AnalyzedArtifact)
    fun listAll(): List<AnalyzedArtifact>
    fun listByCategory(category: String): List<AnalyzedArtifact>
    fun findById(artifactId: String): AnalyzedArtifact?
    fun deleteById(artifactId: String)
    fun clear()
}
