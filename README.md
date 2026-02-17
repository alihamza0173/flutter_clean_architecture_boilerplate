# Flutter Clean Architecture Boilerplate

A production-ready Flutter boilerplate following Clean Architecture with BLoC state management, Firebase integration (Auth, Firestore, Analytics, Crashlytics, Messaging), Freezed for code generation, GetIt for dependency injection, GoRouter for navigation, and Material 3 theming.

## Architecture

This project follows **Clean Architecture** principles, separating code into distinct layers:

```
lib/
├── main.dart
├── injection_container.dart
├── app/
│   ├── app.dart
│   └── router/
│       └── app_router.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_constants.dart
│   │   └── app_strings.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── logger.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── loading_indicator.dart
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── auth_remote_data_source.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_entity.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── sign_in_usecase.dart
│       │       └── sign_up_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           ├── pages/
│           │   ├── login_page.dart
│           │   └── register_page.dart
│           └── widgets/
│               └── auth_form.dart
└── services/
    └── firebase/
        ├── analytics_service.dart
        ├── crashlytics_service.dart
        ├── firebase_service.dart
        └── messaging_service.dart
```

### Layer Responsibilities

| Layer | Purpose |
|---|---|
| **Domain** | Entities, repository contracts, and use cases. Zero dependencies on other layers. |
| **Data** | Repository implementations, data sources, and models. Depends on Domain. |
| **Presentation** | BLoC, pages, and widgets. Depends on Domain. |
| **Core** | Shared utilities, themes, constants, error types, and reusable widgets. |
| **Services** | Third-party service wrappers (Firebase). |

### Data Flow

```
UI (Pages/Widgets)
    ↓ events
BLoC (State Management)
    ↓ calls
Use Cases (Business Logic)
    ↓ calls
Repository (Abstract → Impl)
    ↓ calls
Data Sources (Remote/Local)
    ↓
Firebase / API
```

## Tech Stack

| Category | Package |
|---|---|
| State Management | `flutter_bloc` |
| Routing | `go_router` |
| Dependency Injection | `get_it` + `injectable` |
| Error Handling | `dartz` (Either type) |
| Code Generation | `freezed` + `json_serializable` |
| Network | `connectivity_plus` |
| Auth | `firebase_auth` |
| Database | `cloud_firestore` |
| Storage | `firebase_storage` |
| Analytics | `firebase_analytics` |
| Crash Reporting | `firebase_crashlytics` |
| Push Notifications | `firebase_messaging` |

## Getting Started

### Prerequisites

- Flutter SDK `^3.11.0`
- Firebase project configured ([FlutterFire CLI](https://firebase.flutter.dev/docs/cli))

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/flutter_clean_architecture_boilerplate.git
   cd flutter_clean_architecture_boilerplate
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   ```bash
   flutterfire configure
   ```

4. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Adding a New Feature

1. Create the feature directory under `lib/features/<feature_name>/`
2. Add layers following the existing structure:

```
features/
└── <feature_name>/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

3. Register dependencies in `injection_container.dart`
4. Add routes in `app/router/app_router.dart`

## Error Handling

Errors are handled using the **Either** type from `dartz`:

- **Left** = `Failure` (ServerFailure, CacheFailure, NetworkFailure, AuthFailure)
- **Right** = Success value

Custom exceptions (`ServerException`, `CacheException`, `NetworkException`) are caught in the data layer and mapped to typed failures.

## Code Generation

This project uses `freezed` and `json_serializable` for immutable models with JSON serialization. After modifying any `@freezed` annotated class, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or use watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```
