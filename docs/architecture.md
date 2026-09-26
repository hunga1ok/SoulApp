# Flutter architecture

## 1. Goals

- Keep feature work independently testable.
- Separate widgets from local database, file storage, and audio implementations.
- Run app-only: no backend; all user data lives on the device (decision 2026-09-26, `requirements.md` §0).
- Support Vietnamese and English without duplicated screen trees.
- Preserve a small architecture appropriate for an MVP.

Flutter’s architecture guidance recommends separating the UI and data layers. Soul adopts that boundary without adding a separate domain layer until business logic genuinely requires it.

## 2. Proposed package structure

```text
lib/
  app/
    app.dart
    router.dart
    bootstrap.dart
  core/
    design_system/
    localization/
    audio/
    errors/
  data/
    local/          # Drift database, DAOs, image files
    content/        # read-only bundled content catalog
    repositories/
    models/
  features/
    onboarding/
    today/
    journey/
    vision/
    journal/
    explore/
    profile/
  l10n/
    app_vi.arb
    app_en.arb
```

Each feature owns its screens, widgets, controller/view model, and feature-specific models. Shared persistence implementations live in `data/`; shared visual primitives live in `core/design_system/`.

## 3. State and dependency direction

```text
Widget → Controller/ViewModel → Repository → Local database / content bundle
```

- Widgets render state and forward user intent.
- Controllers own screen state and business decisions.
- Repositories translate app operations into local persistence. A future sync layer plugs in behind the same repositories.
- No widget performs direct database, file, or audio-player calls.

Use Riverpod `Notifier` and `AsyncNotifier` for dependency injection and screen state. Do not use its experimental persistence APIs, build a second service locator, or introduce another state framework. See `tech-stack.md` for the accepted dependency set.

## 4. Navigation

Use declarative routing with guarded route groups:

```text
/language
/onboarding/name
/onboarding/intention
/onboarding/reminders
/today
/vision
/vision/create
/vision/:id
/vision/:id/session
/journal
/journal/:id
/explore
/profile
```

Route guards derive from locally stored onboarding progress (locale, preferred name, later steps). Back navigation uses the router stack; feature screens must not implement ad hoc global navigation callbacks.

## 5. Localization

- Use Flutter-generated localization classes from ARB files.
- No visible text is hardcoded in widgets, including semantics, errors, buttons, notifications, and empty states.
- Store locale as `vi` or `en` on the device.
- Before an explicit selection, use device locale only to highlight a suggestion.
- Content records carry localized fields or locale-specific rows; never translate content inside widgets.

## 6. Design system

Create a small token set derived from the approved prototype:

- Warm paper background and dark plum/navy text.
- Rose, lilac, cream, and restrained gold accents.
- Serif display typography for emotional headings; sans-serif for controls and body copy.
- Shared spacing, corner radius, elevation, and 44–48 px touch-target tokens.
- Components: app shell, primary/secondary buttons, sticky note, Vision card, sound row, mood chip, category tile, progress indicator, bottom navigation.

Avoid one-off colors and dimensions in feature widgets.

## 7. Data and offline behavior

The device is the source of truth; the app works fully offline.

| Data | Storage |
|---|---|
| Locale, preferred name, global sound, onboarding checkpoint | `shared_preferences` |
| Journey runs, task responses, Journal, Visions and feelings, Future Letters, reminder settings | Drift (SQLite) database |
| Vision images and attachments | Files in the app support directory; the database stores a relative path |
| Journey, Vision catalog, feelings, intentions, notification copy, audio mapping | Versioned read-only JSON bundled as app assets |

- Content is never written into the user database; user records reference content by stable code.
- Sync-ready schema: client-generated UUID primary keys, `created_at`/`updated_at`, archive instead of hard delete, and one response per task and run. The table shapes follow `data-backend-spec.md` so a future sync backend can map them directly.
- Schema changes use Drift versioned migrations with migration tests.
- Private data never leaves the device. Journal and Future Letter text never appears in logs or notification previews.

## 8. Audio architecture

An `AudioService` exposes play, pause, stop, current track, and playback state. It filters eligible tracks before playback:

```text
eligible = track.locale == activeLocale || track.locale == neutral
```

Spoken audio requires an exact locale match. Instrumental tracks may be `neutral`. Category-to-track mapping comes from the content bundle, not widget constants. How audio files are delivered (bundled or downloaded from a remote manifest) is not decided yet.

## 9. Configuration

The app-only build needs no runtime configuration. If a remote content/audio manifest is adopted, its public base URL is supplied through `--dart-define-from-file` with a checked-in placeholder example. Never ship secrets in the app.

## 10. Testing strategy

- Unit tests: locale eligibility, category soundtrack selection, onboarding state, repositories and Drift migrations against an in-memory database.
- Widget tests: language gate, preferred-name validation, tab navigation, Vision creation, sticky-note detail.
- Integration tests: Vision image storage, journey completion, app relaunch persistence, reminder scheduling.
- Golden tests: critical Vietnamese and English screens at representative phone sizes.
