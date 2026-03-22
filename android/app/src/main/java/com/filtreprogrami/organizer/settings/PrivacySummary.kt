package com.filtreprogrami.organizer.settings

data class PrivacySummary(
    val localOnlyProcessing: Boolean = true,
    val readsInboxAutomatically: Boolean = false,
    val defaultSmsAppRequired: Boolean = false
)
