package com.filtreprogrami.organizer.ingestion

import com.filtreprogrami.organizer.classification.HeuristicClassificationBridge
import com.filtreprogrami.organizer.model.ArtifactSourceType
import com.filtreprogrami.organizer.storage.InMemoryLocalArtifactStore
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ArtifactIntakeCoordinatorTest {
    @Test
    fun analyzeAndPersist_savesArtifactToLocalStore() {
        val store = InMemoryLocalArtifactStore()
        val coordinator = ArtifactIntakeCoordinator(HeuristicClassificationBridge(), store)

        val result = coordinator.analyzeAndPersist(
            AnalyzeRequest(
                sourceType = ArtifactSourceType.PASTE_ANALYZE,
                senderText = "Akbank",
                messageBody = "Onay kodunuz 123456",
                provenanceNote = "manual_paste"
            )
        )

        assertTrue(result is AnalyzeResult.Success)
        assertEquals(1, store.listAll().size)
        assertEquals("ALLOW_CRITICAL", store.listAll().first().snapshot.category)
        assertTrue(store.listAll().first().snapshot.explanation.isNotBlank())
    }

    @Test
    fun analyzeAndPersist_emptyBodyReturnsValidationError() {
        val store = InMemoryLocalArtifactStore()
        val coordinator = ArtifactIntakeCoordinator(HeuristicClassificationBridge(), store)

        val result = coordinator.analyzeAndPersist(
            AnalyzeRequest(
                sourceType = ArtifactSourceType.PASTE_ANALYZE,
                senderText = null,
                messageBody = "   ",
                provenanceNote = "manual_paste"
            )
        )

        assertTrue(result is AnalyzeResult.ValidationError)
        assertEquals(0, store.listAll().size)
    }
}
