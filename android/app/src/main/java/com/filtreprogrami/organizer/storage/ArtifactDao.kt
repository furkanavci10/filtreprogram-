package com.filtreprogrami.organizer.storage

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Transaction

@Dao
interface ArtifactDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertArtifact(artifact: ArtifactEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertSnapshot(snapshot: ClassificationSnapshotEntity)

    @Transaction
    @Query("SELECT * FROM artifacts ORDER BY ingestedAtEpochMillis DESC")
    fun listAll(): List<ArtifactWithSnapshot>

    @Transaction
    @Query("SELECT * FROM artifacts WHERE artifactId = :artifactId LIMIT 1")
    fun findById(artifactId: String): ArtifactWithSnapshot?

    @Transaction
    @Query(
        """
        SELECT * FROM artifacts
        WHERE artifactId IN (
            SELECT artifactId FROM classification_snapshots WHERE category = :category
        )
        ORDER BY ingestedAtEpochMillis DESC
        """
    )
    fun listByCategory(category: String): List<ArtifactWithSnapshot>

    @Query("DELETE FROM classification_snapshots WHERE artifactId = :artifactId")
    fun deleteSnapshotById(artifactId: String)

    @Query("DELETE FROM artifacts WHERE artifactId = :artifactId")
    fun deleteArtifactById(artifactId: String)

    @Query("DELETE FROM classification_snapshots")
    fun clearSnapshots()

    @Query("DELETE FROM artifacts")
    fun clearArtifacts()
}
