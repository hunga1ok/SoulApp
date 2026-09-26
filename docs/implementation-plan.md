# Flutter implementation plan

## Delivery principles

- Ship vertical slices that can be demonstrated on a device.
- Keep one bilingual screen tree; do not maintain separate Vietnamese and English apps.
- Integrate backend contracts early so prototype-only state does not spread through the codebase.
- A phase is complete only when its exit criteria pass.

## Phase 0 — Repository baseline

### Work

- Replace the default counter README with project setup instructions.
- Add `.gitignore` coverage for generated Flutter, IDE, build, and local secret files.
- Establish `docs/`, agent instructions, branch conventions, and CI checks.
- Record supported Flutter/Dart versions and run the untouched baseline tests.

### Verify

- `flutter doctor -v` has no blocking iOS/Android issue for the selected development platform.
- `dart format`, `flutter analyze`, and `flutter test` pass.
- Generated `build/`, `.dart_tool/`, and local secret files are not tracked.

### Exit criteria

The repository can be cloned and validated from documented commands without opening an IDE.

## Phase 1 — App foundation and design system

### Work

- Replace the sample counter app with `SoulApp` bootstrap.
- Add environment configuration through `--dart-define-from-file`.
- Add `go_router`, Riverpod, generated localization, `dio`, secure token storage, and small-preference persistence as defined in `tech-stack.md`.
- Create design tokens and shared components from the approved web prototype.
- Add Vietnamese and English ARB resources.
- Copy approved logo assets into Flutter assets and configure app icons/splash separately.

### Verify

- App launches on one Android and one iOS target.
- A component gallery renders both locales and large text without overflow.
- No visible string is hardcoded in feature widgets.

### Exit criteria

The shell, theme, localization, routing, and dependency boundaries are stable enough for feature work.

## Phase 2 — API and PostgreSQL foundation

### Work

- Create the modular NestJS API with configuration validation, health endpoint, OpenAPI, and Docker development setup.
- Add Drizzle schema/migrations for profiles, visions, feelings, journal, journey progress/responses, audio, and publication metadata.
- Normalize source datasets into content tables.
- Add deterministic content import and S3-compatible object-storage integration.
- Add API authorization tests for private ownership, editorial roles, and published catalog reads.
- Configure local development and CI migration/test databases.

### Verify

- A clean PostgreSQL instance migrates to the latest schema without manual changes.
- Seed import is idempotent and meets the counts in `data-backend-spec.md`.
- API tests prove that one user cannot read or modify another user’s private records.

### Exit criteria

The Flutter app can read published content and perform authenticated owner-scoped writes against the reproducible API.

## Phase 3 — Locale gate, Google Auth, and onboarding

### Work

- Implement language-neutral `VI`/`EN` entry screen with device-locale suggestion.
- Configure Google sign-in, verify identity in the API, and issue revocable Soul sessions.
- Implement preferred-name, intention, reminders, and completion screens.
- Persist profile and onboarding progress; resume interrupted onboarding.
- Remove demo auth from release builds.

### Verify

- Widget tests cover both locale branches and preferred-name validation.
- Integration test covers sign-in callback and profile creation/update.
- Canceling OAuth returns to a recoverable state.

### Exit criteria

New and returning users reach the correct destination with the chosen locale and preferred name.

## Phase 4 — Today and 28-day journey

### Work

- Build personalized Today screen, mood selection, progress, and today’s rhythm.
- Render journey tasks from backend content rather than hardcoded day-one copy.
- Implement gratitude forms, one-small-action flow, completion, and journal creation.
- Add local cache and retry queue for progress/response writes.
- Add reminder permission flow and locale-specific notification scheduling.

### Verify

- Day content, completion rules, and persisted progress work for representative early, middle, and final days.
- Offline completion syncs once without duplicate entries.
- Vietnamese and English content never mix.

### Exit criteria

A user can complete and revisit all supported task types in the 28-day journey.

## Phase 5 — Vision Board

### Work

- Implement category selection, guided prompt, one-to-three feelings, image upload, preview, and save.
- Render multiple Visions as a board.
- Implement Vision detail and reliable router-based back navigation.
- Assign playlists from Category mappings only.

### Verify

- Widget tests enforce feeling limits and category soundtrack behavior.
- Image upload uses the private user folder and survives app restart.
- Creating multiple Visions renders all of them and back returns to the board.

### Exit criteria

The full Vision create/read/archive flow works with private synced data.

## Phase 6 — Audio and Vision Session

### Work

- Implement `AudioService`, mini player, global toggle, interruptions, and lifecycle handling.
- Upload verified owned/licensed assets and persist license metadata.
- Filter tracks by Category, locale, ownership, and publication status.
- Build the three-minute Vision Session with playlist progress.

### Verify

- Locale eligibility unit tests reject cross-language spoken audio.
- Background/foreground, headphones, calls, and pause/resume behavior are tested on devices.
- No external discovery URL is used as native playback media.

### Exit criteria

Eligible audio plays reliably and the user never receives a mismatched spoken language.

## Phase 7 — Journal, Explore, and profile

### Work

- Build sticky-note list and detail views.
- Build Explore with locale/editorial filters and official external links.
- Implement profile, preferred-name edit, language switching, reminders, sign out, and account deletion entry points.
- Re-render cached and remote content immediately after locale change.

### Verify

- Journal privacy and offline behavior pass integration tests.
- Explore excludes mismatched/unverified content.
- Locale changes update all navigation, semantics, notifications, and content.

### Exit criteria

All four tabs and avatar settings meet the MVP product specification.

## Phase 8 — Quality and release readiness

### Work

- Complete accessibility, error, empty, loading, and offline states.
- Add crash reporting/privacy configuration only after consent and data review.
- Optimize startup, image loading, catalog queries, and audio buffering.
- Prepare app icons, splash, privacy copy, store metadata, and internal distribution builds.

### Verify

- Full automated suite and manual bilingual regression pass.
- No analyzer warnings, exposed secrets, open authorization findings, or unlicensed production audio.
- Cold start, navigation, image upload, and audio meet agreed performance budgets.

### Exit criteria

Signed Android and iOS internal-test builds are installable and pass the release checklist.

## Recommended first implementation slice

Start with Phases 0–3, ending in a real API-authenticated bilingual onboarding flow and a placeholder Today shell. This validates the highest-risk foundations—routing, localization, Google identity, application sessions, profile identity, and authorization—before feature volume grows.

## Open decisions before Phase 1 completes

- Final iOS bundle ID and Android application ID.
- API host and PostgreSQL environments: development, staging, production.
- S3-compatible object-storage provider and buckets for each environment.
- Admin delivery timing: import CLI first, focused admin UI after core content endpoints.
- Licensed font files and usage rights.
- Notification default times and whether reminders are opt-in by default.
- Audio files and license evidence for each native track.
