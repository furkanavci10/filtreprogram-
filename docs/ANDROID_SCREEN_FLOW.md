# Android Screen Flow

## UX Goal

The app should feel like a helper tool for analysis, search, and organization.

It should not feel like a replacement inbox.

## Minimum Screen Set

### 1. Home

Purpose:

- explain the product clearly
- provide quick entry into Analyze, Important, Search, and Review

Primary elements:

- Analyze Message
- Important Messages
- Search
- Suspicious and Promotional Review
- Recent Saved Artifacts

### 2. Analyze Input

Purpose:

- handle paste/analyze flow
- receive share-in handoff

Inputs:

- message body
- optional sender

Actions:

- Analyze
- Clear

### 3. Analysis Result

Purpose:

- show the classification result immediately
- explain why the result was reached

Displayed data:

- category
- confidence
- explanation
- sender
- body
- normalized summary if helpful

Actions:

- Save to Local History
- Search Similar
- View Category
- Delete Draft

### 4. Important Messages

Purpose:

- give fast access to high-value artifacts

Sections:

- Bank and Security
- OTP
- Cargo and Delivery
- Billing and Telecom
- Hospital and Appointment
- Official

### 5. Search

Purpose:

- provide categorized search over saved local artifacts

Elements:

- query field
- quick chips
- source filter
- category filter
- recent searches

### 6. Review

Purpose:

- show likely Suspicious and Promotional artifacts conservatively

Sections:

- Suspicious
- Promotional

Guardrail:

- do not frame this as automatic blocking

### 7. Message Detail

Purpose:

- explanation-rich inspection of a saved artifact

Displayed data:

- raw body
- sender
- source type
- timestamps
- category and confidence
- explanation
- triggered signals summary

Actions:

- Delete
- Re-run analysis
- Add label or pin

### 8. Settings and Privacy

Purpose:

- make product boundaries explicit

Minimum sections:

- local-only processing statement
- what data enters the app
- deletion controls
- future import/preferences placeholder

## Navigation Shape

Recommended minimal navigation:

- Home
- Analyze
- Important
- Search
- Review

Message Detail should be pushed from Important, Search, Review, and Recent Saved Artifacts.

## Screen Flow Guardrails

Avoid:

- conversation list as primary home
- unread counters that imply inbox ownership
- reply/send affordances
- notification language implying silent filtering

Prefer:

- category chips
- clear provenance
- explanation-rich inspection
- saved artifact history
