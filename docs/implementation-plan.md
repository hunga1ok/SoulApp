# Flutter implementation plan

> Decision 2026-09-26: the MVP is app-only (no backend, account, or sync; see `requirements.md` §0). Phases 2–3 were rewritten accordingly; backend work is deferred until sync returns.

## Delivery principles

- Ship vertical slices that can be demonstrated on a device.
- Keep one bilingual screen tree; do not maintain separate Vietnamese and English apps.
- Keep local data sync-ready (UUIDs, timestamps, archive) so a backend can be added later without a schema rewrite.
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
- Add `go_router`, Riverpod, generated localization, and small-preference persistence as defined in `tech-stack.md`.
- Create design tokens and shared components from the approved web prototype.
- Add Vietnamese and English ARB resources.
- Copy approved logo assets into Flutter assets and configure app icons/splash separately.

### Verify

- App launches on one Android and one iOS target.
- A component gallery renders both locales and large text without overflow.
- No visible string is hardcoded in feature widgets.

### Exit criteria

The shell, theme, localization, routing, and dependency boundaries are stable enough for feature work.

## Phase 2 — Content bundle and local database

### Work

- Validate the active datasets and generate versioned JSON content (journey, Vision catalog, feelings, intentions, notification copy, audio mapping) into app assets.
- Load the bundled catalog through a read-only content repository.
- Add the Drift database with sync-ready tables for journey runs/responses, Journal, Visions and feelings, Future Letters, and reminder settings.
- Store Vision images in the app support directory.

### Verify

- Content generation is deterministic and fails on missing translations, broken references, and duplicate codes.
- Drift migrations are tested from an empty database and between versions.
- Data survives app relaunch.

### Exit criteria

Features can read published content and write private user data on the device.

## Phase 3 — Locale gate and onboarding

### Work

- Implement language-neutral `Tiếng Việt`/`English` entry screen with device-locale suggestion.
- Implement preferred-name, intention, reminders, and completion screens.
- Persist onboarding progress on the device; resume interrupted onboarding.

### Verify

- Widget tests cover both locale branches and preferred-name validation.
- Relaunching at each step resumes at the correct screen.

### Exit criteria

New and returning users reach the correct destination with the chosen locale and preferred name.

## Phase 4 — Today and 28-day journey

### Work

- Build personalized Today screen, mood selection, progress, and today’s rhythm.
- Render journey tasks from the content bundle rather than hardcoded day-one copy.
- Implement gratitude forms, one-small-action flow, completion, and journal creation.
- Persist progress and responses in the local database with idempotent writes.
- Add reminder permission flow and locale-specific notification scheduling.

### Verify

- Day content, completion rules, and persisted progress work for representative early, middle, and final days.
- Repeated taps and relaunches never create duplicate entries.
- Vietnamese and English content never mix.

### Exit criteria

A user can complete and revisit all supported task types in the 28-day journey.

## Phase 5 — Vision Board

### Work

- Implement category selection, guided prompt, one-to-three feelings, local image, preview, and save.
- Render multiple Visions as a board.
- Implement Vision detail and reliable router-based back navigation.
- Assign playlists from Category mappings only.

### Verify

- Widget tests enforce feeling limits and category soundtrack behavior.
- The Vision image is stored in app storage and survives app restart.
- Creating multiple Visions renders all of them and back returns to the board.

### Exit criteria

The full Vision create/read/archive flow works with private on-device data.

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
- Implement profile, preferred-name edit, language switching, reminders, and delete-all-local-data.
- Re-render content immediately after locale change.

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
- No analyzer warnings, exposed secrets, private text in logs or notifications, or unlicensed production audio.
- Cold start, navigation, image loading, and audio meet agreed performance budgets.

### Exit criteria

Signed Android and iOS internal-test builds are installable and pass the release checklist.

## Recommended first implementation slice

Start with Phases 0–3, ending in a complete on-device bilingual onboarding flow backed by the content bundle and local database. This validates routing, localization, content generation, and local persistence before feature volume grows.

## Open decisions before Phase 1 completes

- Final iOS bundle ID and Android application ID.
- Licensed font files and usage rights.
- Notification default times and whether reminders are opt-in by default.
- Audio files and license evidence for each native track.
