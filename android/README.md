# Android Scaffold

This directory now contains the first minimal Android scaffold for the organizer/search-assistant product direction.

Current purpose:

- establish Android project structure
- lock clean boundaries before feature work
- keep the product away from default-SMS-app assumptions

Current module shape:

- `android/app`
- `android/app/src/main/java/com/filtreprogrami/organizer/appshell`
- `android/app/src/main/java/com/filtreprogrami/organizer/model`
- `android/app/src/main/java/com/filtreprogrami/organizer/ingestion`
- `android/app/src/main/java/com/filtreprogrami/organizer/classification`
- `android/app/src/main/java/com/filtreprogrami/organizer/storage`
- `android/app/src/main/java/com/filtreprogrami/organizer/search`
- `android/app/src/main/java/com/filtreprogrami/organizer/settings`

What is implemented now:

- lightweight Gradle and app manifest skeleton
- placeholder Compose app shell
- lightweight artifact models
- placeholder ingestion coordinator
- placeholder classification bridge
- in-memory local artifact store

What is intentionally not implemented yet:

- real SMS permissions or inbox access
- default-SMS behavior
- polished UI
- persistent database
- shared classification core binding
