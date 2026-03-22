# Integration Boundary

`ClassificationCore` exposes a small platform-agnostic integration boundary for a future iOS host app and SMS Filter Extension:

- `FilterClassificationRequest`
- `FilterClassificationResponse`
- `FilterDisposition`
- `MessageClassifying`
- `SMSFilterClassifierService`

Expected extension flow:

1. Extension receives sender and message body from iOS.
2. Extension builds `FilterClassificationRequest`.
3. Extension calls `SMSFilterClassifierService.classify(_:)`.
4. Service returns:
   - `disposition`: `allow`, `review`, or `junk`
   - `result`: full classifier output with category, confidence band, scores, triggers, explanation, and normalized text

Limitations:

- The package does not import iOS SMS filter frameworks directly.
- Apple-specific mapping from `FilterDisposition` to system APIs must happen in the extension target.
- Review is an internal trust-first concept; Apple surfaces may only support allow/junk, so host app behavior must decide how to preserve review visibility.
