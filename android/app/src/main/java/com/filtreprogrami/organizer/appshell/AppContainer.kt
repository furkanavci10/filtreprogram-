package com.filtreprogrami.organizer.appshell

import android.content.Context
import androidx.room.Room
import com.filtreprogrami.organizer.classification.ClassificationBridge
import com.filtreprogrami.organizer.classification.HeuristicClassificationBridge
import com.filtreprogrami.organizer.ingestion.ArtifactIntakeCoordinator
import com.filtreprogrami.organizer.search.SearchRepository
import com.filtreprogrami.organizer.storage.LocalArtifactStore
import com.filtreprogrami.organizer.storage.OrganizerDatabase
import com.filtreprogrami.organizer.storage.RoomLocalArtifactStore

class AppContainer(context: Context) {
    private val database: OrganizerDatabase = Room.databaseBuilder(
        context.applicationContext,
        OrganizerDatabase::class.java,
        "organizer.db"
    )
        .fallbackToDestructiveMigration()
        .allowMainThreadQueries()
        .build()

    val classificationBridge: ClassificationBridge = HeuristicClassificationBridge()
    val localArtifactStore: LocalArtifactStore = RoomLocalArtifactStore(database.artifactDao())
    val artifactIntakeCoordinator = ArtifactIntakeCoordinator(classificationBridge, localArtifactStore)
    val searchRepository = SearchRepository(localArtifactStore)
}
