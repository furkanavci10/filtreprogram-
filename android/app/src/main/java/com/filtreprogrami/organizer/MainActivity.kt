package com.filtreprogrami.organizer

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.filtreprogrami.organizer.appshell.OrganizerApp
import com.filtreprogrami.organizer.ingestion.SharedTextCandidate
import com.filtreprogrami.organizer.ingestion.SharedTextIntakeParser

class MainActivity : ComponentActivity() {
    private val sharedTextIntakeParser = SharedTextIntakeParser()
    private var initialSharedCandidate: SharedTextCandidate? = null
    private var shareEventVersion: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initialSharedCandidate = sharedTextIntakeParser.parse(intent)
        setContent {
            OrganizerApp(
                sharedTextCandidate = initialSharedCandidate,
                shareEventVersion = shareEventVersion
            )
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val candidate = sharedTextIntakeParser.parse(intent) ?: return
        initialSharedCandidate = candidate
        shareEventVersion += 1
        setContent {
            OrganizerApp(
                sharedTextCandidate = initialSharedCandidate,
                shareEventVersion = shareEventVersion
            )
        }
    }
}
