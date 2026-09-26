# SoulApp — Claude Code Instructions

@AGENTS.md

The rules above are the canonical agent instructions for this repository. The notes below add Claude-specific context; keep both files consistent when a rule changes.

## Repository boundary

- This repository contains only the Flutter client. The MVP is app-only: no backend, account, or sync (see `docs/requirements.md` §0). It is checked out next to its siblings inside the `Soul/` workspace:
  - `../SoulApi/` — NestJS REST API, a separate Git repository. Paused; kept as the reference design for future sync.
  - `../` (`Soul/`) — documentation repository: source datasets in `Specs/`, the interactive web prototype (`index.html`, `app.js`, `styles.css`, …), and brand assets in `Logo/`.
- `docs/` in this repository is the product contract (requirements, product spec, architecture, tech stack, data/backend spec, plan, backlog). Deferred API work also reads these documents.
- Commit changes to each repository separately. Never stage sibling-repository files from here.

## Layout

- `lib/app/` — app widget, router, app-level state.
- `lib/core/` — design tokens (`design_system/`) and localization helpers (`localization/`).
- `lib/features/<feature>/` — feature-first screens (onboarding, shell, today, vision, journal, explore, profile).
- `lib/l10n/` — ARB files. Edit `app_en.arb` (template) and `app_vi.arb`, then run `flutter gen-l10n`; never hand-edit the generated `app_localizations*.dart`.

## Commands

```bash
flutter pub get
flutter gen-l10n
flutter run
```

Verification (same as `.github/workflows/verify.yml`):

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

The backend rules and commands in `AGENTS.md` apply only when the deferred sync backend resumes. For the commands the API supports (npm, not pnpm), see `../SoulApi/CLAUDE.md`.
