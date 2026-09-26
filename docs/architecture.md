# Flutter architecture

## 1. Goals

- Keep feature work independently testable.
- Separate widgets from API, storage, and audio implementations.
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
    config/
    design_system/
    localization/
    audio/
    errors/
  data/
    api/
    local/
    repositories/
    models/
  features/
    onboarding/
    auth/
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

Each feature owns its screens, widgets, controller/view model, and feature-specific models. Shared backend implementations live in `data/`; shared visual primitives live in `core/design_system/`.

## 3. State and dependency direction

```text
Widget → Controller/ViewModel → Repository interface → REST API/Local implementation
```

- Widgets render state and forward user intent.
- Controllers own screen state and business decisions.
- Repositories translate app operations into local or remote persistence.
- No widget performs direct HTTP, object-storage, or audio-player calls.

Use Riverpod `Notifier` and `AsyncNotifier` for dependency injection and screen state. Do not use its experimental persistence APIs, build a second service locator, or introduce another state framework. See `tech-stack.md` for the accepted dependency set.

## 4. Navigation

Use declarative routing with guarded route groups:

```text
/language
/auth
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

Route guards derive from authentication and onboarding completion. Back navigation uses the router stack; feature screens must not implement ad hoc global navigation callbacks.

## 5. Localization

- Use Flutter-generated localization classes from ARB files.
- No visible text is hardcoded in widgets, including semantics, errors, buttons, notifications, and empty states.
- Store locale as `vi` or `en` in the user profile and cache it locally for startup.
- Before an explicit selection, use device locale only to highlight a suggestion.
- Content records carry localized fields or locale-specific rows; never translate backend content inside widgets.

## 6. Design system

Create a small token set derived from the approved prototype:

- Warm paper background and dark plum/navy text.
- Rose, lilac, cream, and restrained gold accents.
- Serif display typography for emotional headings; sans-serif for controls and body copy.
- Shared spacing, corner radius, elevation, and 44–48 px touch-target tokens.
- Components: app shell, primary/secondary buttons, sticky note, Vision card, sound row, mood chip, category tile, progress indicator, bottom navigation.

Avoid one-off colors and dimensions in feature widgets.

## 7. Data and offline behavior

- The backend API backed by PostgreSQL is the source of truth for authenticated user data and published content.
- Cache locale, preferred name, audio preference, current content catalog, and pending writes locally.
- MVP offline behavior supports reading cached content and queueing journal/progress writes.
- Resolve conflicts with server timestamps; user-written text is never silently overwritten.

## 8. Audio architecture

An `AudioService` exposes play, pause, stop, current track, and playback state. It filters eligible tracks before playback:

```text
eligible = track.locale == activeLocale || track.locale == neutral
```

Spoken audio requires an exact locale match. Instrumental tracks may be `neutral`. Category-to-track mapping comes from backend content, not widget constants.

## 9. Configuration

Supply the API base URL and public Google client configuration using `--dart-define-from-file`. Never put database, storage, or JWT signing secrets in the mobile app. Maintain checked-in example configuration with placeholder values only.

## 10. Testing strategy

- Unit tests: locale eligibility, category soundtrack selection, onboarding state, repository mapping.
- Widget tests: language gate, preferred-name validation, tab navigation, Vision creation, sticky-note detail.
- Integration tests: Google-auth callback boundary, Vision image upload, journey completion, offline retry.
- Golden tests: critical Vietnamese and English screens at representative phone sizes.
