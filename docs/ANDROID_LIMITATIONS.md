# Android Limitations

## Core Constraint

Android should not be treated as if it offers full SMS filtering powers to any app by default.

For a Play-distributed app, broad SMS and call-log access is policy-sensitive. The product must not assume full inbox reading, background filtering, or delivery control unless it becomes the default SMS handler or qualifies for a narrow exception path.

## What Is Realistically Possible Without Becoming the Default SMS App

Conservative baseline:

- local classification when SMS text is available through compliant product flows
- search and categorization experiences built around message text the app is legitimately given
- user-driven analysis workflows
- app-specific OTP retrieval for this app's own verification use cases through SMS Retriever-style flows

## What Is Not Safe To Assume

Do not assume the app can:

- become a system-level SMS filter without default-handler status
- receive all incoming SMS directly
- write to the SMS provider as a normal third-party app
- promise full inbox-wide Play-compliant background organization without careful distribution analysis
- silently block, reroute, or hide critical messages

## Permissions and Policy Reality

### Sensitive permission risk

Call log and SMS permissions are highly restricted on Google Play. A non-default-SMS organizer that broadly reads the user's SMS inbox may face policy risk unless it clearly fits an allowed exception path.

### Permission minimization guidance

The product should prefer:

- no SMS permission when avoidable
- explicit user-controlled ingestion or limited flows
- local processing

### OTP-specific nuance

Android supports SMS Retriever-style flows for app-specific verification use cases without requiring broad SMS-read permission. This is useful for the app's own phone verification, but it is not a general-purpose inbox organizer capability.

## Product Promises That Must Be Avoided

Avoid promising:

- full inbox indexing on all Android devices without default-SMS role
- direct incoming-message interception
- guaranteed sender availability or delivery metadata richness
- zero-friction spam blocking on Android equivalent to a dedicated platform filter surface

## Play Store and Trust Risks

Main risks:

- SMS permission policy rejection
- user confusion if the app looks like a shadow SMS client
- trust damage if critical messages appear hidden or deprioritized
- misleading store claims about filtering power

## Safe Positioning Language

Preferred language:

- organize and search messages
- help identify important and suspicious content
- assist users in finding what matters quickly
- classify locally where possible

Avoid:

- block all spam
- fully filter Android SMS
- replace your messages app

## Recommended Distribution Posture

Primary Android posture:

- Play-safe assistant first

Optional future posture:

- separate deeper-integration path evaluated independently

## Biggest Remaining Uncertainty

The biggest uncertainty is whether the desired inbox-wide organization experience can be delivered on Play-distributed Android without drifting into a default-SMS-app or policy-sensitive SMS-permission posture.

## Official References

- Android Developers: Permissions used only in default handlers
- Android Developers: Minimize permission requests
- Android Developers: Telephony and Telephony.Sms references
- Google Play policy/help guidance on restricted SMS and call-log permissions
