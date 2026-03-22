package com.filtreprogrami.organizer.search

import com.filtreprogrami.organizer.model.AnalyzedArtifact
import com.filtreprogrami.organizer.storage.LocalArtifactStore

class SearchRepository(
    private val localArtifactStore: LocalArtifactStore
) {
    fun recentArtifacts(): List<AnalyzedArtifact> = localArtifactStore.listAll()

    fun importantArtifacts(): List<AnalyzedArtifact> {
        val importantCategories = setOf(
            "ALLOW_CRITICAL",
            "ALLOW_TRANSACTIONAL"
        )
        return localArtifactStore.listAll().filter { it.snapshot.category in importantCategories }
    }

    fun suspiciousArtifacts(): List<AnalyzedArtifact> {
        val reviewCategories = setOf(
            "REVIEW_SUSPICIOUS",
            "FILTER_PROMOTIONAL",
            "FILTER_SPAM"
        )
        return localArtifactStore.listAll().filter { it.snapshot.category in reviewCategories }
    }

    fun search(query: String): List<AnalyzedArtifact> {
        val trimmed = query.trim()
        if (trimmed.isEmpty()) return localArtifactStore.listAll()
        return localArtifactStore.listAll().filter {
            it.artifact.messageBody.contains(trimmed, ignoreCase = true) ||
                (it.artifact.senderText?.contains(trimmed, ignoreCase = true) == true) ||
                it.snapshot.explanation.contains(trimmed, ignoreCase = true)
        }
    }
}
