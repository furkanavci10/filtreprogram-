# Android Ingestion Options

## Decision Context

Android ingestion is the most sensitive product and policy decision for this app.

The product does not want to become the default SMS app. That means the app should not quietly depend on the same access patterns or product promises as a full messaging client.

For Play-distributed Android apps, broad SMS permission use is policy-sensitive, especially when the app is not the default SMS handler.

Relevant official sources:

- [Android Developers: Telephony provider APIs](https://developer.android.com/reference/android/provider/Telephony)
- [Android Developers: Default handler and restricted permission guidance](https://developer.android.com/guide/topics/permissions/default-handlers)
- [Google Play Help: Use of SMS or Call Log permission groups](https://support.google.com/googleplay/android-developer/answer/10208820?hl=en)

## Evaluation Criteria

Each ingestion path should be judged on:

- what the user must do
- what data the app can actually access
- user friction
- privacy implications
- policy risk
- scalability
- trust implications
- fit with non-default-SMS positioning

## Option 1: Manual Share-In

### What the user does

1. User opens their existing messaging app.
2. User selects a message.
3. User shares the content into this app.

### What the app can access

- the text the user explicitly shared
- sender text only if the share payload includes it or the user adds it
- limited metadata

### User friction

- medium

### Privacy implications

- strong
- fully user-initiated
- easy to explain

### Policy risk

- low

### Scalability

- limited for whole-history organization
- strong for focused analysis and saved archive growth

### Trust implications

- strong
- users understand what entered the app

### Non-default-SMS positioning

- preserved strongly

### Assessment

- one of the safest early Android paths
- especially good for suspicious-message analysis and curated archive building

## Option 2: Paste or Analyze-Copied-Text Flow

### What the user does

1. User copies message text.
2. User pastes it into the app for analysis or saving.

### What the app can access

- body text
- sender only if user enters it manually

### User friction

- medium to high

### Privacy implications

- strong
- explicit and narrow

### Policy risk

- low

### Scalability

- weaker than share-in for structured archive growth

### Trust implications

- very strong

### Non-default-SMS positioning

- preserved strongly

### Assessment

- useful as a low-risk companion path
- not strong enough as the only product flow

## Option 3: User-Initiated Batch Import

### What the user does

1. User explicitly starts an import flow.
2. User selects a local source or export-compatible input.
3. App builds a local archive for search and categorization.

### What the app can access

- potentially larger sender/body/time datasets
- only to the extent allowed by the chosen import path

### User friction

- medium

### Privacy implications

- more sensitive than single-message sharing
- requires clear explanation and deletion controls

### Policy risk

- variable
- low if driven by explicit user-supplied export/import material
- high if it quietly depends on restricted SMS provider access

### Scalability

- strong if the import path is policy-safe and understandable

### Trust implications

- mixed
- useful, but users may perceive “you imported my inbox”

### Non-default-SMS positioning

- can be preserved
- but only if the flow is clearly user-initiated and not framed as inbox ownership

### Assessment

- good as a secondary path
- should be limited to explicit, reviewable imports

## Option 4: Notification-Adjacent Helper

### What the user does

- user grants notification access or similar helper permission

### What the app can access

- notification text that may include SMS content
- incomplete and OEM-dependent signals

### User friction

- medium

### Privacy implications

- sensitive
- notification access is broad and easy to misunderstand

### Policy risk

- moderate

### Scalability

- inconsistent

### Trust implications

- risky
- may feel like silent monitoring

### Non-default-SMS positioning

- preserved at a technical level
- weaker at a trust level

### Assessment

- not recommended as the primary Android ingestion model
- could be considered later only with very careful disclosure

## Option 5: Broad SMS Provider Access in a Non-Default App

### What the user does

- installs the app and grants SMS access

### What the app can access

- potentially large portions of inbox history and future read scope

### User friction

- low in the short term

### Privacy implications

- very sensitive

### Policy risk

- high

### Scalability

- technically strong
- distribution-risk heavy

### Trust implications

- weak for this product position

### Non-default-SMS positioning

- formally preserved
- but substantively undermined

### Assessment

- not recommended for the early product
- too close to restricted-SMS behavior

## Option 6: Future Default-SMS-App Track

### What the user does

- makes the app their default SMS app

### What the app can access

- full messaging-client responsibilities and delivery role

### User friction

- high

### Privacy implications

- very sensitive

### Policy risk

- different policy posture, but much larger product burden

### Scalability

- high

### Trust implications

- depends on a fundamentally different product promise

### Non-default-SMS positioning

- not preserved

### Assessment

- explicit future fork only
- not part of the recommended path

## Option Comparison

### Lowest-risk options

- manual share-in
- paste/analyze flow
- explicit local archive building from user-provided content

### Highest-value but riskier options

- broader import paths
- notification-adjacent helper features

### Paths to avoid for the current product

- broad SMS-provider dependence in a non-default app
- default-SMS-app assumptions hidden inside MVP planning

## Preferred Ingestion Model

Recommended Android ingestion model:

- primary: manual share-in from the existing messaging app
- secondary: paste/analyze flow
- optional later enhancement: explicit user-initiated local archive import from user-supplied material

Why this is preferred:

- keeps the app clearly out of the default-SMS role
- minimizes Play policy exposure
- preserves user trust and clear consent
- still creates enough local corpus to power categorized search, important-message discovery, and suspicious-message analysis

## Product Boundary Statement

The Android version should reduce clutter and improve message discoverability without forcing users into a new primary messaging workflow.

That means early Android success should not depend on:

- hidden background inbox sync
- broad restricted SMS permissions
- automatic interception claims
- becoming the default SMS app
