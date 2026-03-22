package com.filtreprogrami.organizer.appshell

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.filtreprogrami.organizer.ingestion.AnalyzeRequest
import com.filtreprogrami.organizer.ingestion.AnalyzeResult
import com.filtreprogrami.organizer.ingestion.SharedTextCandidate
import com.filtreprogrami.organizer.model.AnalyzedArtifact
import com.filtreprogrami.organizer.model.ArtifactSourceType
import com.filtreprogrami.organizer.settings.PrivacySummary

private enum class ShellScreen {
    HOME,
    ANALYZE_INPUT,
    ANALYSIS_RESULT,
    IMPORTANT,
    SEARCH,
    DETAIL,
    SETTINGS
}

@Composable
fun OrganizerApp(
    sharedTextCandidate: SharedTextCandidate? = null,
    shareEventVersion: Int = 0
) {
    MaterialTheme {
        val context = LocalContext.current
        val container = remember { AppContainer(context) }
        val privacySummary = remember { PrivacySummary() }
        var currentScreen by remember { mutableStateOf(ShellScreen.HOME) }
        var draftSender by remember { mutableStateOf("") }
        var draftBody by remember { mutableStateOf("") }
        var analyzeProvenance by remember { mutableStateOf("manual_paste") }
        var analyzeBanner by remember { mutableStateOf<String?>(null) }
        var searchQuery by remember { mutableStateOf("") }
        var lastResult by remember { mutableStateOf<AnalyzeResult?>(null) }
        var selectedArtifact by remember { mutableStateOf<AnalyzedArtifact?>(null) }
        val searchResults = remember { mutableStateListOf<AnalyzedArtifact>() }
        var dataVersion by remember { mutableIntStateOf(0) }

        LaunchedEffect(shareEventVersion, sharedTextCandidate) {
            val candidate = sharedTextCandidate ?: return@LaunchedEffect
            draftBody = candidate.body
            draftSender = ""
            analyzeProvenance = candidate.provenanceNote
            analyzeBanner = "Shared text received. Review and analyze before saving."
            lastResult = null
            currentScreen = ShellScreen.ANALYZE_INPUT
        }

        fun refreshSearch() {
            searchResults.clear()
            searchResults.addAll(container.searchRepository.search(searchQuery))
        }

        when (currentScreen) {
            ShellScreen.HOME -> HomeScreen(
                onAnalyze = { currentScreen = ShellScreen.ANALYZE_INPUT },
                onImportant = { currentScreen = ShellScreen.IMPORTANT },
                onSearch = {
                    refreshSearch()
                    currentScreen = ShellScreen.SEARCH
                },
                onSettings = { currentScreen = ShellScreen.SETTINGS },
                recentArtifacts = dataVersion.let { container.searchRepository.recentArtifacts() },
                onOpenArtifact = {
                    selectedArtifact = it
                    currentScreen = ShellScreen.DETAIL
                }
            )

            ShellScreen.ANALYZE_INPUT -> AnalyzeInputScreen(
                sender = draftSender,
                body = draftBody,
                bannerMessage = analyzeBanner,
                onSenderChange = { draftSender = it },
                onBodyChange = { draftBody = it },
                onAnalyze = {
                    lastResult = container.artifactIntakeCoordinator.analyzeAndPersist(
                        AnalyzeRequest(
                            sourceType = if (analyzeProvenance == "shared_text_intent") {
                                ArtifactSourceType.SHARE_IN
                            } else {
                                ArtifactSourceType.PASTE_ANALYZE
                            },
                            senderText = draftSender,
                            messageBody = draftBody,
                            provenanceNote = analyzeProvenance
                        )
                    )
                    if (lastResult is AnalyzeResult.Success) {
                        dataVersion++
                    }
                    analyzeBanner = null
                    currentScreen = ShellScreen.ANALYSIS_RESULT
                },
                onBack = {
                    analyzeBanner = null
                    currentScreen = ShellScreen.HOME
                }
            )

            ShellScreen.ANALYSIS_RESULT -> AnalysisResultScreen(
                result = lastResult,
                onOpenSaved = {
                    val success = lastResult as? AnalyzeResult.Success ?: return@AnalysisResultScreen
                    selectedArtifact = container.localArtifactStore.findById(
                        success.analyzedArtifact.artifact.artifactId
                    ) ?: success.analyzedArtifact
                    currentScreen = ShellScreen.DETAIL
                },
                onDeleteDraft = {
                    val success = lastResult as? AnalyzeResult.Success
                    if (success != null) {
                        container.localArtifactStore.deleteById(success.analyzedArtifact.artifact.artifactId)
                        dataVersion++
                    }
                    draftSender = ""
                    draftBody = ""
                    analyzeProvenance = "manual_paste"
                    lastResult = null
                    currentScreen = ShellScreen.HOME
                },
                onBack = { currentScreen = ShellScreen.HOME }
            )

            ShellScreen.IMPORTANT -> ImportantMessagesScreen(
                artifacts = dataVersion.let { container.searchRepository.importantArtifacts() },
                onOpenArtifact = {
                    selectedArtifact = it
                    currentScreen = ShellScreen.DETAIL
                },
                onBack = { currentScreen = ShellScreen.HOME }
            )

            ShellScreen.SEARCH -> SearchScreen(
                query = searchQuery,
                onQueryChange = {
                    searchQuery = it
                    refreshSearch()
                },
                artifacts = searchResults,
                onOpenArtifact = {
                    selectedArtifact = it
                    currentScreen = ShellScreen.DETAIL
                },
                onBack = { currentScreen = ShellScreen.HOME }
            )

            ShellScreen.DETAIL -> MessageDetailScreen(
                artifact = selectedArtifact,
                onDelete = {
                    val artifactId = selectedArtifact?.artifact?.artifactId ?: return@MessageDetailScreen
                    container.localArtifactStore.deleteById(artifactId)
                    dataVersion++
                    selectedArtifact = null
                    currentScreen = ShellScreen.HOME
                },
                onBack = { currentScreen = ShellScreen.HOME }
            )

            ShellScreen.SETTINGS -> SettingsScreen(
                privacySummary = privacySummary,
                onBack = { currentScreen = ShellScreen.HOME }
            )
        }
    }
}

@Composable
private fun HomeScreen(
    onAnalyze: () -> Unit,
    onImportant: () -> Unit,
    onSearch: () -> Unit,
    onSettings: () -> Unit,
    recentArtifacts: List<AnalyzedArtifact>,
    onOpenArtifact: (AnalyzedArtifact) -> Unit
) {
    ScreenColumn("Organizer Home") {
        Text("This placeholder shell analyzes only user-provided message artifacts.")
        Spacer(Modifier.height(12.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = onAnalyze) { Text("Analyze") }
            Button(onClick = onImportant) { Text("Important") }
            Button(onClick = onSearch) { Text("Search") }
            Button(onClick = onSettings) { Text("Privacy") }
        }
        Spacer(Modifier.height(16.dp))
        Text("Recent Saved Artifacts")
        ArtifactList(artifacts = recentArtifacts, onOpenArtifact = onOpenArtifact)
    }
}

@Composable
private fun AnalyzeInputScreen(
    sender: String,
    body: String,
    bannerMessage: String?,
    onSenderChange: (String) -> Unit,
    onBodyChange: (String) -> Unit,
    onAnalyze: () -> Unit,
    onBack: () -> Unit
) {
    ScreenColumn("Analyze Input") {
        if (bannerMessage != null) {
            Text(bannerMessage)
            Spacer(Modifier.height(8.dp))
        }
        OutlinedTextField(
            value = sender,
            onValueChange = onSenderChange,
            label = { Text("Sender (optional)") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(8.dp))
        OutlinedTextField(
            value = body,
            onValueChange = onBodyChange,
            label = { Text("Message body") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(12.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = onAnalyze) { Text("Analyze") }
            Button(onClick = onBack) { Text("Back") }
        }
    }
}

@Composable
private fun AnalysisResultScreen(
    result: AnalyzeResult?,
    onOpenSaved: () -> Unit,
    onDeleteDraft: () -> Unit,
    onBack: () -> Unit
) {
    ScreenColumn("Analysis Result") {
        when (result) {
            is AnalyzeResult.Success -> {
                Text("Category: ${result.analyzedArtifact.snapshot.category}")
                Text("Confidence: ${result.analyzedArtifact.snapshot.confidenceBand}")
                Text("Stored locally for organizer/search surfaces.")
                Spacer(Modifier.height(8.dp))
                Text(result.analyzedArtifact.snapshot.explanation)
                Spacer(Modifier.height(12.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Button(onClick = onOpenSaved) { Text("Open Detail") }
                    Button(onClick = onDeleteDraft) { Text("Delete Stored Copy") }
                    Button(onClick = onBack) { Text("Back") }
                }
            }

            is AnalyzeResult.ValidationError -> {
                Text(result.message)
                Spacer(Modifier.height(12.dp))
                Button(onClick = onBack) { Text("Back") }
            }

            null -> {
                Text("No analysis result yet.")
                Spacer(Modifier.height(12.dp))
                Button(onClick = onBack) { Text("Back") }
            }
        }
    }
}

@Composable
private fun ImportantMessagesScreen(
    artifacts: List<AnalyzedArtifact>,
    onOpenArtifact: (AnalyzedArtifact) -> Unit,
    onBack: () -> Unit
) {
    ScreenColumn("Important Messages") {
        Text("Placeholder surface for critical and transactional artifacts.")
        Spacer(Modifier.height(12.dp))
        ArtifactList(artifacts = artifacts, onOpenArtifact = onOpenArtifact)
        Spacer(Modifier.height(12.dp))
        Button(onClick = onBack) { Text("Back") }
    }
}

@Composable
private fun SearchScreen(
    query: String,
    onQueryChange: (String) -> Unit,
    artifacts: List<AnalyzedArtifact>,
    onOpenArtifact: (AnalyzedArtifact) -> Unit,
    onBack: () -> Unit
) {
    ScreenColumn("Search") {
        OutlinedTextField(
            value = query,
            onValueChange = onQueryChange,
            label = { Text("Search saved artifacts") },
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(Modifier.height(12.dp))
        ArtifactList(artifacts = artifacts, onOpenArtifact = onOpenArtifact)
        Spacer(Modifier.height(12.dp))
        Button(onClick = onBack) { Text("Back") }
    }
}

@Composable
private fun MessageDetailScreen(
    artifact: AnalyzedArtifact?,
    onDelete: () -> Unit,
    onBack: () -> Unit
) {
    ScreenColumn("Message Detail") {
        if (artifact == null) {
            Text("No artifact selected.")
        } else {
            Text("Sender: ${artifact.artifact.senderText ?: "Unknown"}")
            Text("Source: ${artifact.artifact.sourceType}")
            Spacer(Modifier.height(8.dp))
            Text("Body: ${artifact.artifact.messageBody}")
            Spacer(Modifier.height(8.dp))
            Text("Category: ${artifact.snapshot.category}")
            Text("Confidence: ${artifact.snapshot.confidenceBand}")
            Text("Explanation: ${artifact.snapshot.explanation}")
            Text("Source: ${artifact.artifact.provenanceNote}")
        }
        Spacer(Modifier.height(12.dp))
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = onBack) { Text("Back") }
            if (artifact != null) {
                Button(onClick = onDelete) { Text("Delete") }
            }
        }
    }
}

@Composable
private fun SettingsScreen(
    privacySummary: PrivacySummary,
    onBack: () -> Unit
) {
    ScreenColumn("Settings and Privacy") {
        Text("Local processing: ${privacySummary.localOnlyProcessing}")
        Text("Reads inbox automatically: ${privacySummary.readsInboxAutomatically}")
        Text("Requires default SMS app: ${privacySummary.defaultSmsAppRequired}")
        Spacer(Modifier.height(12.dp))
        Text("This placeholder app shell handles only user-provided message artifacts.")
        Spacer(Modifier.height(12.dp))
        Button(onClick = onBack) { Text("Back") }
    }
}

@Composable
private fun ArtifactList(
    artifacts: List<AnalyzedArtifact>,
    onOpenArtifact: (AnalyzedArtifact) -> Unit
) {
    if (artifacts.isEmpty()) {
        Text("No saved artifacts yet.")
        return
    }

    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        items(artifacts) { artifact ->
            Card(
                modifier = Modifier.fillMaxWidth(),
                onClick = { onOpenArtifact(artifact) }
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text(artifact.artifact.senderText ?: "Unknown sender")
                    Text(artifact.snapshot.category)
                    Text(artifact.artifact.messageBody.take(120))
                }
            }
        }
    }
}

@Composable
private fun ScreenColumn(
    title: String,
    content: @Composable () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Top
    ) {
        Text(title, style = MaterialTheme.typography.headlineSmall)
        Spacer(Modifier.height(16.dp))
        content()
    }
}
