package com.filtreprogrami.organizer.search

import com.filtreprogrami.organizer.model.AnalyzedArtifact
import com.filtreprogrami.organizer.model.ArtifactSourceType
import com.filtreprogrami.organizer.model.ClassificationSnapshot
import com.filtreprogrami.organizer.model.MessageArtifact
import com.filtreprogrami.organizer.storage.InMemoryLocalArtifactStore
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SearchRepositoryTest {
    @Test
    fun importantArtifacts_returnsCriticalAndTransactionalOnly() {
        val store = InMemoryLocalArtifactStore()
        store.save(sampleArtifact("1", "ALLOW_CRITICAL", "OTP kodunuz 123456"))
        store.save(sampleArtifact("2", "ALLOW_TRANSACTIONAL", "Kargonuz dagitima cikti"))
        store.save(sampleArtifact("3", "FILTER_SPAM", "FREEBET bonus"))

        val repository = SearchRepository(store)

        assertEquals(2, repository.importantArtifacts().size)
    }

    @Test
    fun search_findsBySenderOrMessageBody() {
        val store = InMemoryLocalArtifactStore()
        store.save(sampleArtifact("1", "ALLOW_TRANSACTIONAL", "Kargonuz teslim edildi", "Yurtici"))
        store.save(sampleArtifact("2", "FILTER_PROMOTIONAL", "Kampanya firsati", "Marka"))

        val repository = SearchRepository(store)

        assertEquals(1, repository.search("Yurtici").size)
        assertEquals(1, repository.search("teslim").size)
    }

    @Test
    fun suspiciousArtifacts_returnsReviewAndFilteredBuckets() {
        val store = InMemoryLocalArtifactStore()
        store.save(sampleArtifact("1", "REVIEW_SUSPICIOUS", "Akbank hesabiniz dogrulayin"))
        store.save(sampleArtifact("2", "FILTER_PROMOTIONAL", "Kampanya"))
        store.save(sampleArtifact("3", "FILTER_SPAM", "Bahis bonus"))
        store.save(sampleArtifact("4", "ALLOW_NORMAL", "Merhaba"))

        val repository = SearchRepository(store)

        assertEquals(3, repository.suspiciousArtifacts().size)
        assertTrue(repository.suspiciousArtifacts().none { it.snapshot.category == "ALLOW_NORMAL" })
    }
}

private fun sampleArtifact(
    id: String,
    category: String,
    body: String,
    sender: String? = null
): AnalyzedArtifact {
    return AnalyzedArtifact(
        artifact = MessageArtifact(
            artifactId = id,
            sourceType = ArtifactSourceType.PASTE_ANALYZE,
            senderText = sender,
            messageBody = body,
            ingestedAtEpochMillis = 1L,
            provenanceNote = "test"
        ),
        snapshot = ClassificationSnapshot(
            category = category,
            confidenceBand = "MEDIUM",
            safeScore = 10,
            riskScore = 10,
            explanation = "test",
            normalizedText = body.lowercase(),
            triggeredSignals = emptyList(),
            classifiedAtEpochMillis = 1L
        )
    )
}
