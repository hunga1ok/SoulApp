# Soul mobile app

Flutter client for Soul. The MVP is **app-only**: all user data stays on the device, and there is no backend, account, or sign-in (decision 2026-09-26, see [`docs/requirements.md`](docs/requirements.md) §0). The companion API at [`../SoulApi`](../SoulApi) is paused and kept as the reference design for future cross-device sync.

## Prerequisites

- Flutter/Dart installed and a configured Android emulator or iOS simulator.
- No server, database, or storage service is needed to run the app.

## Run

```bash
flutter pub get
flutter gen-l10n
flutter run
```

The first screen is the language-neutral `Tiếng Việt`/`English` gate, followed by the preferred-name question. Locale, preferred name, and the sound setting are stored locally with `shared_preferences`.

## Verify

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Component goldens live in `test/core/design_system/goldens/` and were generated on macOS. After an intended visual change, regenerate them with `flutter test --update-goldens test/core/design_system/components_golden_test.dart` and review the images before committing.

## Configuration

The app-only build needs no runtime configuration and must never contain secrets. See [`docs/backlog.md`](docs/backlog.md) for execution status and [`docs/requirements.md`](docs/requirements.md) for the product contract.
