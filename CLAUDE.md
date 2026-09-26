# SoulApp — Claude Code Instructions

@AGENTS.md

The rules above are the canonical agent instructions for this repository. The notes below add Claude-specific context; keep both files consistent when a rule changes.

## Repository boundary

- This repository contains only the Flutter client. It is checked out next to its siblings inside the `Soul/` workspace:
  - `../SoulApi/` — NestJS REST API, a separate Git repository.
  - `../` (`Soul/`) — documentation repository: source datasets in `Specs/`, the interactive web prototype (`index.html`, `app.js`, `styles.css`, …), and brand assets in `Logo/`.
- `docs/` in this repository is the shared product contract for both app and API (requirements, product spec, architecture, tech stack, data/backend spec, plan, backlog). API work also reads these documents.
- Commit changes to each repository separately. Never stage sibling-repository files from here.

## Layout

- `lib/app/` — app widget, router, app-level state.
- `lib/core/` — configuration (`config/`) and design tokens (`design_system/`).
- `lib/features/<feature>/` — feature-first screens (onboarding, shell, today, vision, journal, explore, profile).
- `lib/l10n/` — ARB files. Edit `app_en.arb` (template) and `app_vi.arb`, then run `flutter gen-l10n`; never hand-edit the generated `app_localizations*.dart`.
- `config/app.<env>.json.example` — public build-time values for `--dart-define-from-file`. The real JSON files are Git-ignored.

## Commands

```bash
flutter pub get
flutter gen-l10n
cp config/app.development.json.example config/app.development.json
flutter run --dart-define-from-file=config/app.development.json
```

Verification (same as `.github/workflows/verify.yml`):

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The backend commands listed in `AGENTS.md` are the target baseline. For the commands the API actually supports today (npm, not pnpm), see `../SoulApi/CLAUDE.md`.
