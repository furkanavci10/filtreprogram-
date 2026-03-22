package com.filtreprogrami.organizer.classification

import com.filtreprogrami.organizer.ingestion.AnalyzeRequest
import com.filtreprogrami.organizer.model.ClassificationSnapshot

interface ClassificationBridge {
    fun classify(request: AnalyzeRequest, classifiedAtEpochMillis: Long): ClassificationSnapshot
}
