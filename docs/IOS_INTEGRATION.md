# iOS Integration Notes

## Minimal integration scaffold

This repository now contains a minimal iOS-facing scaffold under `ios/`:

- `ios/App/AppClassificationBridge.swift`
- `ios/FilterExtension/ExtensionClassificationMapper.swift`
- `ios/FilterExtension/IdentityLookupAdapter.swift`

These files are intentionally thin. They do not replace the platform-agnostic classifier core.

## Intended usage

### Host app

The host app can call:

- `AppClassificationBridge.classifyPreview(sender:body:)`

This is meant for:

- internal preview screens
- audit views
- local debugging of classification behavior

### SMS Filter Extension

The future extension can call:

- `IdentityLookupAdapter.classify(sender:messageBody:)`

This returns:

- `FilterClassificationResponse`
- `ExtensionFilterAction`

Recommended behavior:

- `allow` and `review` both map to system allow behavior
- `junk` maps to the platform junk action

The internal `review` concept remains useful for the host app, even if Apple exposes only coarser allow/junk behavior at the extension layer.

## Apple platform constraints

- SMS filtering on iOS is limited by the `IdentityLookup` framework and its action model.
- The extension may not be able to surface a distinct system-level "review" bucket.
- The extension execution path must stay fast, synchronous, and offline.
- Host app and extension coordination typically requires an App Group if shared persistence is needed.

## What still remains

- actual Xcode project/targets
- `IdentityLookup` request/response glue code
- App Group persistence for audit/review state
- minimal host app screens to inspect classification results
