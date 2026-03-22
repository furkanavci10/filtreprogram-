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
