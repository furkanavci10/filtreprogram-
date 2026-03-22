package com.filtreprogrami.organizer.storage

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import com.filtreprogrami.organizer.model.ArtifactSourceType

@Database(
    entities = [ArtifactEntity::class, ClassificationSnapshotEntity::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(OrganizerTypeConverters::class)
abstract class OrganizerDatabase : RoomDatabase() {
    abstract fun artifactDao(): ArtifactDao
}

class OrganizerTypeConverters {
    @TypeConverter
    fun fromArtifactSourceType(value: ArtifactSourceType): String = value.name

    @TypeConverter
    fun toArtifactSourceType(value: String): ArtifactSourceType = ArtifactSourceType.valueOf(value)
}
