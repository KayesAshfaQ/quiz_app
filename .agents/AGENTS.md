# Agent Instructions for Quiz App

This document defines rules and guidelines for autonomous agents interacting with this repository.

## Framework Constraints
- **Routing**: Strictly use `go_router`. Add new routes in `lib/app_route.dart`.
- **State Management**: Use the `provider` package (`ChangeNotifier`). Place providers in `lib/providers/` and inject them in `main.dart` or locally as appropriate.
- **Storage**: Use `hive` for local caching and Firebase Firestore for remote data.

## Documentation Standards (Diátaxis)
When asked to write or update documentation, adhere to the Diátaxis framework (Tutorials, How-To, Reference, Explanation) and organize files in the `docs/` directory accordingly. Ensure the `documentation_plan.md` (in the agent brain) is followed.

## Code Style & Architecture
- Always use standard Dart documentation conventions (`///`).
- Keep widgets modular by extracting complex UI components into `lib/widgets/`.
- Handle network and Firebase calls strictly within `lib/services/`. Do not mix service logic directly into UI pages or providers.
- Review existing models in `lib/models/` before generating new ones to avoid duplication.
- Ensure that the `///` Dartdoc comments are clear and concise.
