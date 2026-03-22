# iOS Integration Notes

## Minimal integration scaffold

This repository contains a thin iOS-facing boundary under `ios/`:

- `ios/App/AppClassificationBridge.swift`
- `ios/App/AppGroupConfiguration.swift`
- `ios/App/App.entitlements.template`
- `ios/FilterExtension/ExtensionClassificationMapper.swift`
- `ios/FilterExtension/ExtensionClassificationOutcome.swift`
- `ios/FilterExtension/IdentityLookupAdapter.swift`
- `ios/FilterExtension/MessageFilterExtension.swift`
- `ios/FilterExtension/FilterExtension.entitlements.template`
- `ios/FilterExtension/FilterExtension-Info.plist.template`

These wrappers sit on top of the shared classifier. They do not replace or reshape the platform-agnostic core.

## Shared core usage

The shared package boundary already exists in `ClassificationCore`:

- `FilterClassificationRequest`
- `FilterClassificationResponse`
- `FilterDisposition`
- `SMSFilterClassifierService`

That means both the host app and the future SMS Filter Extension can pass the same request object into the same local service and receive the same rich classification result back.

## Host app boundary

The host app should call:

- `AppClassificationBridge.classifyPreview(sender:body:)`
- `AppClassificationBridge.classifyPreview(request:)`

Input available to the host app:

- optional `sender`
- required `messageBody`

Output returned:

- `FilterClassificationResponse`

That response includes:

- `disposition`
- full `ClassificationResult`
- category
- confidence band
- safe/risk scores
- triggered signals
- explanation
- normalized text

Recommended host-app usage:

- audit/review screen
- local preview/debug screen
- future override and trust-explanation surfaces
- future App Group-backed preferences and shared configuration

## SMS Filter Extension boundary

The extension should call:

- `IdentityLookupAdapter.classify(sender:messageBody:)`
- or `IdentityLookupAdapter.classifyOutcome(sender:messageBody:)`

The Apple entry point in this repository is:

- `MessageFilterExtension.handle(_:context:completion:)`

`classifyOutcome` is the more explicit integration boundary. It returns:

- original `FilterClassificationRequest`
- full `FilterClassificationResponse`
- extension-facing `ExtensionFilterAction`

Recommended mapping:

- `allow` -> system allow
- `review` -> system allow, while preserving internal review semantics for host-app audit
- `junk` -> system junk/spam action

This preserves the product trust model even though the Apple extension surface is coarser than the internal classifier.

Concrete category mapping in this MVP:

- `ALLOW_CRITICAL` -> allow
- `ALLOW_TRANSACTIONAL` -> allow
- `ALLOW_NORMAL` -> allow
- `REVIEW_SUSPICIOUS` -> allow at the Apple action layer
- `FILTER_PROMOTIONAL` -> junk
- `FILTER_SPAM` -> junk

`REVIEW_SUSPICIOUS` is intentionally not mapped to junk because Apple does not provide a native review bucket and the product trust model prefers conservative delivery when uncertainty remains.

## Apple platform limitations

- SMS filtering on iOS is constrained by the `IdentityLookup` framework.
- The extension path is effectively offline and should remain fast and deterministic.
- Apple does not expose a rich system-level review bucket equivalent to the internal `REVIEW_SUSPICIOUS` class.
- In practice, extension behavior is closer to `allow` or `junk`, so internal review semantics must be preserved outside the system action itself.
- If the host app needs to inspect extension outcomes later, App Group persistence will likely be required.
- Sender metadata available to the extension may be limited; the core should assume only `sender` and `messageBody`.
- The Apple extension response model is coarse; this MVP intentionally does not use promotional/transactional sub-actions even if newer APIs support them.
- The extension cannot directly show explanations or confidence to the user during filtering; those stay in internal outcome objects for host-app audit/debug use.

## Current request/response contract

Input passed to the classifier:

- `sender: String?`
- `messageBody: String`

Output available from the classifier:

- top-level `FilterDisposition`
- detailed `MessageClassificationCategory`
- `ConfidenceBand`
- explanation text
- triggered rules/signals
- normalized text

Output available to the Apple glue layer:

- `ExtensionFilterAction`
- full `ExtensionClassificationOutcome`
- internal category, confidence, and explanation for logging/audit handoff

## What still remains before a usable prototype

- actual Xcode project and targets
- real `IdentityLookup` request/response glue code
- App Group persistence for audit/review state if needed
- a minimal host-app surface for viewing review/junk rationale
- build/test verification in an Apple toolchain environment

## Exact next steps in Xcode

1. Create a new iOS app target for the host app.
2. Add an `Identity Lookup Message Filter Extension` target.
3. Add this repository's Swift package to the Xcode project and link the host app and extension targets to the needed modules.
4. For the extension target:
   - link `IdentityLookup.framework`
   - set the extension Info.plist using the structure shown in `ios/FilterExtension/FilterExtension-Info.plist.template`
   - ensure the principal class resolves to `$(PRODUCT_MODULE_NAME).MessageFilterExtension`
5. For both host app and extension targets:
   - enable the same App Group
   - use the entitlement structure shown in `ios/App/App.entitlements.template` and `ios/FilterExtension/FilterExtension.entitlements.template`
6. Confirm the extension target can import `ClassificationCore` and the iOS wrapper files under `ios/FilterExtension`.
7. Build both targets before attempting on-device SMS filter validation.

## Manual configuration required

- bundle identifiers for app and extension
- signing and team selection
- App Group identifier
- extension Info.plist principal class registration
- `IdentityLookup.framework` linkage
- target membership for the files under `ios/App` and `ios/FilterExtension`
- any future host-app persistence wiring that uses the shared App Group suite name

## What must be validated in Xcode

- `IdentityLookup` target wiring and principal class registration
- `MessageFilterExtension` compile/runtime behavior against the real Apple SDK
- `ILMessageFilterQueryRequest` sender/body availability on-device
- `filterAction` mapping for allow/junk in real SMS filter flows
- extension performance and offline behavior under Apple execution limits
- optional App Group access from both host app and extension

## Concrete runtime validation checklist

- host app target builds successfully
- filter extension target builds successfully
- extension principal class is recognized by the system
- extension loads without immediate runtime failure
- `ILMessageFilterQueryRequest.messageBody` arrives as expected
- `ILMessageFilterQueryRequest.sender` is present when Apple provides it
- `IdentityLookupAdapter.classifyOutcome(sender:messageBody:)` receives the same values seen by the Apple handler
- `ALLOW_CRITICAL` maps to allow
- `ALLOW_TRANSACTIONAL` maps to allow
- `ALLOW_NORMAL` maps to allow
- `FILTER_PROMOTIONAL` maps to junk
- `FILTER_SPAM` maps to junk
- `REVIEW_SUSPICIOUS` currently maps to allow
- App Group shared defaults can be read from host app and extension
- extension execution remains fast enough for Apple runtime expectations
- no network dependency is required for classification

## Simulator vs device

Safer to validate in simulator:

- project setup
- package linkage
- target membership
- compile success
- basic host-app launch

Must be validated on a real device:

- actual SMS filter extension loading
- real `IdentityLookup` request delivery
- real sender/message body availability
- end-to-end filter action behavior in Messages
- App Group behavior between app and extension under realistic conditions

## What cannot be trusted until real runtime validation

- that the principal class is registered correctly just because the code compiles
- that `sender` is always populated the way local assumptions expect
- that `review -> allow` behavior produces the intended user-visible effect in Messages
- that App Group state is shared correctly without entitlement/signing issues
- that extension execution performance is acceptable on-device
