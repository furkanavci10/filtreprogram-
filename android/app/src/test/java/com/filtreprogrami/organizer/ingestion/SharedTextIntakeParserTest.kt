package com.filtreprogrami.organizer.ingestion

import android.content.Intent
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class SharedTextIntakeParserTest {
    private val parser = SharedTextIntakeParser()

    @Test
    fun parse_validSendTextIntent_returnsCandidate() {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, "Akbank onay kodunuz 123456")
        }

        val result = parser.parse(intent)

        requireNotNull(result)
        assertEquals("Akbank onay kodunuz 123456", result.body)
        assertEquals("shared_text_intent", result.provenanceNote)
    }

    @Test
    fun parse_blankSharedText_returnsNull() {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, "   ")
        }

        val result = parser.parse(intent)

        assertNull(result)
    }

    @Test
    fun parse_nonSendIntent_returnsNull() {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, "Kargonuz dagitima cikti")
        }

        val result = parser.parse(intent)

        assertNull(result)
    }

    @Test
    fun parse_nonTextMimeType_returnsNull() {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "image/png"
            putExtra(Intent.EXTRA_TEXT, "This should not be parsed")
        }

        val result = parser.parse(intent)

        assertNull(result)
    }
}
