# Flutter architecture

## 1. Goals

- Keep feature work independently testable.
- Separate widgets from local database, file storage, and audio implementations.
- Run app-only: no backend; all user data lives on the device (decision 2026-09-26, `requirements.md` §0).
- Support 6 locales: Vietnamese (`vi`), English (`en`), French (`fr`), Japanese (`ja`), Korean (`ko`), Chinese (`zh`) without duplicated screen trees.
- Run app-only: no backend; all user data lives on the device (decision 2026-09-26, `requirements.md` §0).
- Adapt seamlessly to mobile phones and tablets (including iPad & Android tablets) with responsive content bounds.
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
    design_system/  # Design tokens, mood themes, responsive dimensions, shared widgets
    localization/   # Locale providers, 6 supported languages
    audio/          # Audio playback controller, authentic soundscapes, sleep timer
    platform/       # Home widget update service (Android AppWidget & iOS WidgetKit)
    errors/
  data/
    local/          # Drift database, DAOs, image files, SharedPreferences
    content/        # Bundled content catalog (journey, vision, comfort zone, cards)
    repositories/
    models/
  features/
    onboarding/
    today/          # Home feed with optimized content hierarchy & living widget card
    comfort_zone/   # 28 mindful rooms across 5 themes, ambient audio, countdown timer
    cards/          # 3 card decks, 3D flip draw, daily draw quota
    journey/        # 28-day gratitude journey, milestone loop renewal
    vision/         # Vision board collage, creation builder, session
    journal/        # Offline journaling, paper themes, sticky notes
    widget_setup/   # Living Home Widget setup walkthrough
    explore/
    profile/
    subscription/   # Pricing tiers and premium membership preview
  l10n/
    app_vi.arb
    app_en.arb
    app_fr.arb
    app_ja.arb
    app_ko.arb
    app_zh.arb
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
/comfort-zone
/comfort-zone/room/:id
/widget-setup
/cards
/cards/draw/:deckCode
/vision
/vision/create
/vision/:id
/vision/:id/session
/journal
/journal/:id
/explore
/profile
/pricing
```

Route guards derive from locally stored onboarding progress (locale, preferred name, later steps). Back navigation uses the router stack; feature screens must not implement ad hoc global navigation callbacks.

## 5. Localization

- Use Flutter-generated localization classes from ARB files across 6 supported locales: Vietnamese (`vi`), English (`en`), French (`fr`), Japanese (`ja`), Korean (`ko`), Chinese (`zh`).
- No visible text is hardcoded in widgets, including semantics, errors, buttons, notifications, and empty states.
- Store locale in `shared_preferences`.
- Before an explicit selection, use device locale only to highlight a suggestion.
- Content records carry localized fields or locale-specific rows; never translate content inside widgets.

## 6. Design system & responsive layouts

Create a small token set derived from the approved prototype:

- Warm paper background and dark plum/navy text.
- Rose, lilac, cream, and restrained gold accents.
- Dynamic Emotion Themes: Theme colors adapt dynamically according to today's mood check-in (Joyful, Peaceful, Grateful, Overwhelmed, etc.).
- Serif display typography for emotional headings; sans-serif for controls and body copy.
- Shared spacing, corner radius, elevation, and 44–48 px touch-target tokens.
- Tablet & iPad Responsiveness:
  - Max content bounds via `SoulDimensions.maxContentWidth` (centered layout with letterboxing on large displays).
  - Responsive grid columns (1 to 4 columns depending on available width for Comfort Zone, Vision collage, and Card Decks).
  - Adaptive bottom sheets converting to floating modals/dialogs on tablet viewports.
- Components: app shell, primary/secondary buttons, sticky note, Vision card, sound row, mood chip, category tile, progress indicator, bottom navigation.

Avoid one-off colors and dimensions in feature widgets.

## 7. Data and offline behavior

The device is the source of truth; the app works fully offline.

| Data | Storage |
|---|---|
| Locale, preferred name, global sound, onboarding checkpoint, today mood status, card draw counts | `shared_preferences` |
| Journey runs, task responses, Journal, Visions and feelings, Future Letters, reminder settings | Drift (SQLite) database |
| Vision images and attachments | Files in the app support directory; the database stores a relative path |
| Journey, Vision catalog, Comfort Zone catalog (28 rooms), feelings, intentions, cards metadata, audio mapping | Versioned read-only JSON / Dart bundles compiled in app assets |
| Living Home Widget | Shared data payload via `home_widget` package synced to Android AppWidget and iOS WidgetKit |

- Content is never written into the user database; user records reference content by stable code.
- Sync-ready schema: client-generated UUID primary keys, `created_at`/`updated_at`, archive instead of hard delete, and one response per task and run. The table shapes follow `data-backend-spec.md` so a future sync backend can map them directly.
- Dynamic Mood Check-in: Checks in daily; auto-collapses to a compact status badge upon completion; resets automatically at local midnight.
- 28-Day Gratitude Journey Renewal: Completing Day 28 triggers a milestone completion celebration and permits restarting at Day 1 for a new cycle while preserving all historical journal entries.
- Schema changes use Drift versioned migrations with migration tests.
- Private data never leaves the device. Journal and Future Letter text never appears in logs or notification previews.

## 8. Audio architecture

An `AudioService` and `AudioPlaybackController` expose play, pause, stop, current track, and playback state. It filters eligible tracks before playback:

```text
eligible = track.locale == activeLocale || track.locale == neutral
```

- Spoken audio requires an exact locale match. Instrumental tracks may be `neutral`.
- Comfort Zone Soundscapes: Looping authentic nature audio and licensed compositions (Kevin MacLeod via Incompetech / Archive.org).
- Strict Audio Authenticity: 100% pre-recorded real-world recordings; strictly 0% algorithmic/synthetic noise generators.
- Center-blur Countdown Timer: Minimalist glassmorphism countdown display with white typography for deep focus and meditation sessions.

## 9. Configuration

The app-only build needs no runtime configuration. If a remote content/audio manifest is adopted, its public base URL is supplied through `--dart-define-from-file` with a checked-in placeholder example. Never ship secrets in the app.

## 10. Testing strategy

- Unit tests: locale eligibility, category soundtrack selection, onboarding state, repositories, card controllers, and Drift migrations against an in-memory database.
- Widget tests: language gate, preferred-name validation, tab navigation, Vision creation, Comfort Zone interaction, and sticky-note detail.
- Integration tests: Vision image storage, journey completion, app relaunch persistence, reminder scheduling.
- Golden tests: critical screens across Vietnamese, English, and other supported locales at representative phone and tablet sizes.
