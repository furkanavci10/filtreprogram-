package com.filtreprogrami.organizer.storage

import androidx.room.Embedded
import androidx.room.Relation

data class ArtifactWithSnapshot(
    @Embedded val artifact: ArtifactEntity,
    @Relation(
        parentColumn = "artifactId",
        entityColumn = "artifactId"
    )
    val snapshot: ClassificationSnapshotEntity
)
