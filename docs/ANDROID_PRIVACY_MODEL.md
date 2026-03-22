# Android Privacy Model

## Core Promise

The Android app should process user-provided message artifacts locally and conservatively.

It should not present itself as the primary place where all SMS are automatically managed.

## Explicit Privacy Boundaries

The app should assume:

- no default-SMS-app role
- no hidden inbox ownership
- no silent background collection as the core product behavior
- no mandatory backend for classification

The app should make clear:

- how a message entered the app
- whether it was saved locally
- how it can be deleted

## Trust-First Handling

The privacy model should reinforce the product’s trust model:

- critical-looking messages should not be treated casually
- suspicious messages should be explained, not overclaimed
- saved artifacts should remain visible and user-controlled
- review/junk semantics should not imply silent hiding

## Local-First Processing

Recommended local-first principles:

- classification runs on-device where possible
- raw message artifacts stay local by default
- user-controlled organization stays local by default
- cloud sync should not be assumed

## User Expectations That Must Be Explicit

Users should understand:

- this app helps analyze and organize selected message artifacts
- this app does not replace their messaging app
- this app does not guarantee full inbox visibility
- this app does not silently block messages

## Permission Minimization

Preferred permission posture:

- avoid broad SMS permissions in the early Android product
- prefer explicit share/paste/import actions
- keep any future helper permissions optional and clearly explained

## Deletion and Retention

Privacy expectations:

- users can analyze without forced retention
- saved artifacts can be deleted individually or in batch
- discarded drafts should not linger unnecessarily

## Product Boundary Protection

The Android version should help users analyze, find, and organize selected or imported message artifacts.

It should reduce clutter and improve discoverability without replacing the native messaging flow.
