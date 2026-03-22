# Android Policy Risks

## Core Risk Statement

The biggest Android product risk is accidentally drifting from a trust-first organizer into a restricted-SMS or de facto messaging-client posture.

For a Play-distributed product, that drift creates both policy exposure and user-trust damage.

Relevant official sources:

- [Android Developers: Permissions used only in default handlers](https://developer.android.com/guide/topics/permissions/default-handlers)
- [Android Developers: Minimize permission requests](https://developer.android.com/privacy-and-security/minimize-permission-requests)
- [Google Play Help: Use of SMS or Call Log permission groups](https://support.google.com/googleplay/android-developer/answer/10208820?hl=en)

## Main Policy and Platform Risks

### Risk 1: Broad SMS permission dependence

Risk indicators:

- MVP assumes `READ_SMS`
- the app is not meaningfully useful without broad inbox access
- product copy suggests routine full-inbox visibility

Why it matters:

- high Play review risk
- high privacy sensitivity
- not aligned with the current product promise

### Risk 2: Becoming a de facto SMS app

Risk indicators:

- thread-based primary UI
- inbox replacement language
- roadmap depends on owning receive/send workflow

Why it matters:

- changes product category
- changes user expectations
- increases platform and support burden

### Risk 3: Notification-listener drift

Risk indicators:

- product starts relying on notification access as the main ingestion strategy
- users may not understand the breadth of the permission
- behavior varies across OEMs and Android versions

Why it matters:

- trust risk
- incomplete data reliability
- potential policy and review scrutiny depending on implementation and copy

### Risk 4: Overclaiming filtering power

Risk indicators:

- “blocks spam on Android”
- “filters all SMS automatically”
- “never miss a message because we manage your inbox”

Why it matters:

- misleading promise
- high support burden
- damages trust when platform reality is coarser

### Risk 5: Silent hiding or de-prioritizing of critical content

Risk indicators:

- product copy implies automatic suppression
- UI hides messages without clear provenance
- risk classification is framed as certainty

Why it matters:

- violates the trust-first model
- especially dangerous for bank, OTP, cargo, billing, hospital, and official notices

## Product Boundaries That Must Stay Explicit

The Android app should remain:

- an organizer
- a classifier
- a search assistant
- a clutter-reduction tool

It should not become:

- a replacement SMS client
- an aggressive silent blocker
- a background inbox owner

## Marketing and Copy Guardrails

Do not say:

- block all spam on Android
- replace your inbox
- automatically manage all your text messages
- silent filtering in the background

Prefer:

- helps organize and find important messages
- classifies messages locally when they are provided to the app
- highlights likely suspicious or promotional content
- designed to work without replacing your messaging app

## Recommended Policy-Safe Boundaries

Recommended boundaries for the early Android product:

- primary ingestion should be user-initiated
- permissions should stay minimal
- local processing should be the default
- product copy should avoid inbox-ownership language
- suspicious classification should remain explainable and conservative

## Paths That Increase Play Risk

Higher-risk implementation choices:

- broad SMS-provider access for a non-default app
- background ingestion assumptions that are not clearly user-driven
- notification access as the hidden primary data pipeline
- marketing that implies system-level SMS filtering powers

## Remaining Uncertainty

The main open question is product viability under a strict Play-safe posture:

- will user-initiated ingestion create enough repeated value for users to return
- can the app feel meaningfully useful without broad automatic inbox capture

This uncertainty should be answered through conservative prototype testing, not through premature permission escalation.

## Explicit Boundary Statement

The Android version should reduce clutter and improve message discoverability without forcing users into a new primary messaging workflow.
