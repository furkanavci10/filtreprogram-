# Android Strategy

## Product Positioning

This product should not position itself as the user's new primary SMS application.

Android positioning:

- trust-first SMS organizer
- local classification assistant
- search and discoverability aid
- clutter-reduction layer

Not Android positioning:

- default SMS replacement
- silent blocking product
- aggressive spam-killer

Core product statement:

This product is meant to help users comfortably reach the SMS messages they care about when they need them. It should reduce clutter and improve discoverability. It should not force users into a new primary messaging workflow.

## Recommended Android Strategy

The Android strategy should be split into two clear layers.

### Layer 1: Play-safe, non-default-SMS strategy

Primary recommendation:

- do not require becoming the default SMS app
- avoid product promises that imply full inbox filtering powers
- keep permissions minimal
- treat Android as an assistant and organizer surface, not the transport owner

Play-safe value focuses on:

- user-initiated analysis of message text
- categorized search and saved views when message data is available through compliant flows
- highlighting likely critical messages
- grouping likely junk, promo, bahis, and phishing content
- local explanation of why a message looks important or risky

Reasoning:

- the trust-first classification core is valuable even when the app does not own message delivery
- avoiding default-SMS positioning preserves product trust and reduces platform/policy risk

### Layer 2: Optional future deeper-integration paths

These should be documented as optional future paths, not MVP assumptions:

- default SMS app mode
- OEM / carrier / enterprise distribution paths
- tightly scoped SMS-permission exception cases if policy and distribution model support them

## What Is Realistically Valuable on Android

Without turning into a full SMS client, the app can still provide meaningful value through:

- important-message discovery
- on-device text classification when message text is available
- quick category views such as Bank, OTP, Cargo, Billing, Hospital, Official, Promotional, Suspicious
- sender and keyword-centered search aids
- user-controlled saved filters and category chips
- trust-first interpretation of suspicious messages

## Practical Product Modes

### Recommended MVP mode

Android MVP should act as:

- organizer
- classifier
- search assistant
- clutter reducer

Likely user journey:

1. User opens the app when they need to find an important SMS.
2. User uses category chips or search.
3. App surfaces likely Bank, OTP, Cargo, Billing, Hospital, Official, Promotional, and Suspicious buckets.
4. App explains why a message was grouped there.

### Future optional advanced mode

If product and policy strategy later justify it:

- evaluate a separate default-SMS-app track
- keep this as a deliberate strategic fork, not an accidental drift

## User Value on Android

The app should help users:

- find OTP and bank messages faster
- quickly separate cargo, invoice, hospital, and official notices
- spot likely bahis, phishing, and promo content
- create user-controlled views and filters
- understand inbox clutter safely

## Permissions Philosophy

Android permission strategy should be conservative:

- request the smallest possible set
- avoid SMS permissions unless distribution and policy strategy explicitly support them
- prefer explicit user actions over background scanning assumptions
- keep local processing first

## Promises the Product Must Avoid

Do not promise:

- full Android SMS filtering without being the default SMS app
- guaranteed inbox-wide background filtering on Play-distributed Android
- silent hiding or blocking of suspicious messages
- complete cross-device parity with iOS extension behavior

## Trust-First Rules on Android

- critical-looking messages must never be treated casually
- uncertain messages should be surfaced conservatively
- user trust is more important than aggressive classification coverage
- Android UX should emphasize discovery, review, and explanation rather than forceful filtering

## Recommended MVP Decision

Recommended Android MVP:

- proceed as a non-default-SMS organizer and classification assistant
- reuse the trust-first core conceptually
- keep message ingestion assumptions conservative and policy-aware
- explicitly defer any full inbox-control strategy until separate product and policy approval
