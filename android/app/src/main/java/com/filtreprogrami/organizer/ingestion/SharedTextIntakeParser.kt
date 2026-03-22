package com.filtreprogrami.organizer.ingestion

import android.content.Intent

class SharedTextIntakeParser {
    fun parse(intent: Intent?): SharedTextCandidate? {
        if (intent == null) return null
        if (intent.action != Intent.ACTION_SEND) return null
        if (intent.type?.startsWith("text/") != true) return null

        val rawText = intent.getStringExtra(Intent.EXTRA_TEXT)?.trim().orEmpty()
        if (rawText.isBlank()) return null

        return SharedTextCandidate(body = rawText)
    }
}
