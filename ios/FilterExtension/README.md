# Filter Extension Module

Planned iOS SMS Filter Extension responsibilities:

- receive SMS classification requests from iOS
- build a `FilterClassificationRequest` from sender/body
- call `SMSFilterClassifierService` synchronously
- map internal categories to platform filter actions
- prefer allow/review over junk when uncertain

Suggested integration boundary:

- Input:
  - `sender`
  - `messageBody`
- Output:
  - `FilterDisposition`
  - full `ClassificationResult`

Recommended mapping:

- `allow` -> allow message
- `review` -> allow at system layer, preserve internal review semantics for host app/audit
- `junk` -> map to junk/spam action in the extension

Current minimal scaffold:

- `IdentityLookupAdapter` wraps the shared classifier for future extension usage
- `ExtensionClassificationMapper` converts internal `FilterDisposition` into extension-facing allow/junk actions
- `ExtensionClassificationOutcome` packages request, response, action, category, confidence, and explanation for extension-side inspection/logging
- `MessageFilterExtension` is the Apple-side `IdentityLookup` entry point and query handler
- `FilterExtension-Info.plist.template` shows the minimum extension principal class registration
- `FilterExtension.entitlements.template` shows the minimum App Group entitlement placeholder

Apple-side MVP mapping in this repository:

- `ALLOW_CRITICAL` -> allow
- `ALLOW_TRANSACTIONAL` -> allow
- `ALLOW_NORMAL` -> allow
- `REVIEW_SUSPICIOUS` -> allow at the system layer, preserve review semantics in the internal outcome
- `FILTER_PROMOTIONAL` -> junk
- `FILTER_SPAM` -> junk

Minimum Xcode target setup:

- create an `Identity Lookup Message Filter Extension` target
- set the extension principal class to `$(PRODUCT_MODULE_NAME).MessageFilterExtension`
- link `IdentityLookup.framework`
- include the shared Swift package/modules used by `ClassificationCore`
- assign an App Group matching the host app if shared config will be used
