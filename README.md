# Filtre Programi

A trust-first SMS filtering and organizing system designed to reduce clutter without risking critical message loss.

Trust-first SMS filtering and organizing for important-message discovery.

## Status

This project is currently in active development.

- iOS: architecture and integration layer ready (not yet runtime validated)
- Android: organizer prototype with share-in flow implemented
- Classification core: functional, expanding

## Problem

SMS remains a high-trust channel for important communication, but it is also crowded and increasingly hostile.

Common user problems this project is trying to address:

- spam SMS
- bahis, casino, and bonus junk
- unwanted promotional campaigns
- phishing attempts
- fake cargo payment traps
- fake bank credential messages
- difficulty finding important messages quickly
- risk of missing critical SMS such as bank, OTP, cargo, billing, hospital, and official notices

In Türkiye, this problem is especially visible because high-value operational SMS and high-risk junk often coexist in the same message stream.

## Product Vision

This project is built around a trust-first philosophy.

Core product beliefs:

- critical messages are sacred
- uncertain messages should not be aggressively blocked
- reducing clutter matters, but not at the cost of losing trust
- the product should improve discoverability, not silently hide important communication

This leads to a conservative classification worldview:

- `ALLOW_CRITICAL`
- `ALLOW_TRANSACTIONAL`
- `ALLOW_NORMAL`
- `REVIEW_SUSPICIOUS`
- `FILTER_PROMOTIONAL`
- `FILTER_SPAM`

The intended behavior is explainable and testable. If the system is unsure, it should prefer review or allow over aggressive filtering.

## Current Platform Status

### Shared classification and core work

The repository contains a substantial deterministic classification foundation:

- Turkish-first normalization
- rule-based detection
- safe-score and risk-score logic
- conservative conflict handling
- explanation-oriented output

### iOS direction

The iOS side is designed around:

- a local Swift classification core
- SMS Filter Extension integration boundaries
- a trust-first action mapping where uncertain messages are not overblocked

The iOS implementation is at prototype/integration stage. Real Xcode and device validation are still needed.

### Android direction

The Android side is explicitly not being positioned as a default SMS app.

Current Android direction:

- organizer
- classifier
- search assistant
- user-controlled artifact ingestion

The Android prototype currently supports:

- a local app shell
- paste/analyze flow
- local storage
- share-in flow for `text/plain`
- Android-native heuristic classifier adapter aligned to the trust-first contract

Android build/runtime validation is still pending.

## Key Features

- Turkish-first normalization and classification
- trust-first safe/risk scoring model
- critical, transactional, normal, suspicious, promotional, and spam categorization
- explanation-aware classification output
- deterministic, reviewable rule behavior
- local-first and privacy-aware design
- iOS SMS Filter Extension integration direction
- Android organizer/search-assistant shell
- user-controlled ingestion on Android

## Architecture Overview

At a high level, the repository is organized around a local, explainable classification system plus platform-specific integration shells.

Core concepts:

- normalization
- deterministic rules
- scoring and conflict resolution
- explanation generation
- platform adapters

Main architecture layers:

- classification core
- Turkish-aware normalization
- deterministic safe/risk rules
- decision and explanation logic
- iOS integration boundary
- Android organizer shell and local artifact flow

The Swift trust core is currently the deeper implementation. Android uses a contract-aligned native bridge strategy rather than pretending the Swift runtime can be reused directly.

## Repository Structure

- [`Sources/`](C:\Users\mehme\Desktop\Filtre Programı\Sources): Swift classification core, normalization, rules, scoring, datasets
- [`Tests/`](C:\Users\mehme\Desktop\Filtre Programı\Tests): Swift classification and regression tests
- [`ios/`](C:\Users\mehme\Desktop\Filtre Programı\ios): iOS app and SMS Filter Extension integration scaffolding
- [`android/`](C:\Users\mehme\Desktop\Filtre Programı\android): Android organizer/search-assistant scaffold and early ingestion prototype
- [`docs/`](C:\Users\mehme\Desktop\Filtre Programı\docs): product, architecture, platform, policy, and testing documentation

Important top-level files:

- [`plans.md`](C:\Users\mehme\Desktop\Filtre Programı\plans.md): main implementation milestones
- [`plans_android.md`](C:\Users\mehme\Desktop\Filtre Programı\plans_android.md): Android-specific phased plan
- [`implement.md`](C:\Users\mehme\Desktop\Filtre Programı\implement.md): implementation notes and scope
- [`engineering_log.md`](C:\Users\mehme\Desktop\Filtre Programı\engineering_log.md): detailed execution log

## Current Limitations

This repository is still at prototype/integration stage.

Current limitations include:

- real Xcode runtime validation is still needed
- real iOS SMS Filter Extension behavior still needs device testing
- Android build/runtime validation is still needed
- the Android classifier is not yet as deep as the Swift trust core
- some platform integrations are still prototype-level
- Android share-in currently focuses on shared text and does not recover rich sender metadata reliably
- no production UI polish yet

## Roadmap

Short-term roadmap:

- runtime validation in Xcode and on-device iOS testing
- iOS SMS Filter Extension behavior verification
- Android share-flow validation in a real device/build environment
- Android classifier expansion toward deeper trust-core parity
- search and review UX refinement
- local storage and settings improvements

Medium-term direction:

- stronger cross-platform rule alignment
- deeper Android ingestion ergonomics
- stronger platform-specific review surfaces

## How to Run

iOS:

- Requires Xcode (not yet fully validated in runtime)

Android:

- Open the `android/` folder in Android Studio
- Build and run the app
- Share text into the app to test analyze flow

Note:

- full runtime validation is still in progress

## Privacy and Trust

This repository is built with a local-first mindset.

Privacy and trust principles:

- local processing first
- no exaggerated blocking claims
- no aggressive hidden blocking philosophy
- critical message protection is a first-class requirement
- Android ingestion is user-controlled
- uncertain messages should be surfaced conservatively

The intended product should help users reach the messages they care about more comfortably. It should not quietly become the owner of their message stream.

## How To Explore The Project

If you are new to the repository, start here:

1. Read [`docs/PRD.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\PRD.md) for product vision and user problem framing.
2. Read [`docs/CLASSIFICATION_POLICY.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\CLASSIFICATION_POLICY.md) for the trust model and classification rules.
3. Read [`docs/SYSTEM_DESIGN.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\SYSTEM_DESIGN.md) and [`docs/CROSS_PLATFORM_CORE.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\CROSS_PLATFORM_CORE.md) for architecture.
4. Read [`docs/IOS_INTEGRATION.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\IOS_INTEGRATION.md) for iOS integration status.
5. Read [`docs/ANDROID_STRATEGY.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\ANDROID_STRATEGY.md) and [`docs/ANDROID_SHELL_ARCHITECTURE.md`](C:\Users\mehme\Desktop\Filtre Programı\docs\ANDROID_SHELL_ARCHITECTURE.md) for Android direction.

Where key logic lives:

- Swift classification logic: [`Sources/ClassificationCore/`](C:\Users\mehme\Desktop\Filtre Programı\Sources\ClassificationCore) and [`Sources/RulesEngine/`](C:\Users\mehme\Desktop\Filtre Programı\Sources\RulesEngine)
- Swift datasets and fixtures: [`Sources/Dataset/`](C:\Users\mehme\Desktop\Filtre Programı\Sources\Dataset)
- iOS integration scaffolding: [`ios/`](C:\Users\mehme\Desktop\Filtre Programı\ios)
- Android shell and classifier adapter: [`android/app/src/main/java/com/filtreprogrami/organizer/`](C:\Users\mehme\Desktop\Filtre Programı\android\app\src\main\java\com\filtreprogrami\organizer)

## Notes

This repository is intentionally design-heavy and documentation-rich. The goal is to make product boundaries, trust assumptions, and platform constraints explicit before claiming a finished filtering product.
