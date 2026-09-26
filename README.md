# Soul mobile app

Flutter client for Soul. It shares product contracts with the companion API at [`../SoulApi`](../SoulApi).

## Prerequisites

- Flutter/Dart installed and a configured Android emulator or iOS simulator.
- Node.js 24 LTS (or 22 LTS) for the API. The current machine's Node 23 can run the scaffold but is not a supported release target.
- PostgreSQL and S3-compatible storage are required only when database and upload tickets begin.

## Run the mobile shell

```bash
flutter pub get
flutter gen-l10n
cp config/app.development.json.example config/app.development.json
flutter run --dart-define-from-file=config/app.development.json
```

The first screen is the language-neutral `Tiếng Việt`/`English` gate. Google identity is deliberately simulated only in debug until the API, OAuth clients and bundle IDs are configured; release builds do not treat the development path as authentication.

## Verify

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Component goldens live in `test/core/design_system/goldens/` and were generated on macOS. After an intended visual change, regenerate them with `flutter test --update-goldens test/core/design_system/components_golden_test.dart` and review the images before committing.

## API setup

```bash
cd ../SoulApi
cp .env.example .env
npm install
npm run start:dev
```

The API health endpoint is available at `http://localhost:3000/v1/health` and the OpenAPI UI at `http://localhost:3000/docs`.

## Configuration

The Flutter app accepts only public values through `--dart-define-from-file`. Copy an environment example locally; these local JSON files are ignored by Git:

```json
{
  "API_BASE_URL": "https://api.example.com/v1",
  "GOOGLE_WEB_CLIENT_ID": "example.apps.googleusercontent.com",
  "OAUTH_REDIRECT_SCHEME": "com.manifest.soul"
}
```

Use `app.staging.json.example` or `app.production.json.example` only for the matching signed build. A debug/profile build intentionally aborts if it is configured with `APP_ENV=production`.

Never place database, storage, OAuth client secrets or JWT keys in the Flutter project. See [`docs/backlog.md`](docs/backlog.md) for execution status and [`docs/requirements.md`](docs/requirements.md) for the product contract.
