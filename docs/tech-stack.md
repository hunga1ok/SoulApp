# Soul technology stack

Reviewed: 2026-09-26

## 1. System boundary

Decision 2026-09-26: the MVP is **app-only**.

```text
SoulApp (Flutter) ─ Drift/SQLite + app files (user data)
                  └ bundled JSON content (read-only catalog)
```

- No backend, account, or sign-in. User data never leaves the device.
- The supplied spreadsheets and DOCX files are authoring sources, not runtime assets; a build-time step turns them into the bundled JSON.
- Sections 3–4 describe the backend and admin that return together with cross-device sync. `SoulApi` is kept as that reference design.

## 2. Mobile application — required for MVP

| Area | Choice | Purpose |
|---|---|---|
| Framework | Flutter 3.44.8 / Dart 3.12.2 | One iOS/Android codebase using the installed baseline. |
| State and dependency injection | `flutter_riverpod` | Screen state, controllers, and dependency wiring. |
| Navigation | `go_router` | Onboarding guards, deep links, and reliable back stacks. |
| Localization | `flutter_localizations`, `intl`, generated ARB | One widget tree for Vietnamese and English. |
| Small preferences | `shared_preferences` | Locale, preferred name, audio toggle, and onboarding checkpoint. |
| Local database | `drift` (+ `drift_flutter`, `drift_dev`/`build_runner`), `uuid` | Typed SQLite for journey progress, Journal, Visions, Future Letters, reminders; versioned migrations. Regenerate with `dart run build_runner build`; generated `*.g.dart` files are committed. |
| App files | `path_provider` | Vision images and attachments in the app support directory. |
| Audio | `just_audio`, `audio_session` | Playlist playback, audio focus, interruptions, and lifecycle. |
| Vision image | `image_picker` | Select or capture the optional Vision image. |
| Reminders | `flutter_local_notifications`, `flutter_timezone` (+ `timezone` when scheduling) | Notification permission and device IANA timezone at onboarding; locale-aware local reminders in the Journey phase. |
| External content | `url_launcher` | Open approved YouTube/Spotify links outside native playback. |
| Tests | `flutter_test`, `integration_test`, golden tests | Unit, widget, device-flow, and bilingual visual regression. |

Deferred with sync: `dio` (API client), `google_sign_in`, and `flutter_secure_storage`. `dio` and `flutter_secure_storage` were removed from the app on 2026-09-26; all three return with the sync backend. Do not introduce a second state-management or service-locator package.

## 3. Backend API — deferred (returns with cross-device sync)

| Area | Choice | Purpose |
|---|---|---|
| Runtime | Current Node.js LTS | Stable TypeScript runtime and deployment ecosystem. |
| Framework | NestJS + TypeScript | Modular REST API, guards, validation, and OpenAPI support. |
| API contract | REST `/v1` + OpenAPI | Simple mobile/admin integration and generated documentation. |
| Database | PostgreSQL, provisioned by the project owner | User data, content catalog, mappings, progress, and metadata. |
| ORM/migrations | Drizzle ORM + `drizzle-kit` | SQL-visible schema, typed queries, and versioned migrations. |
| Validation | Nest DTOs + `class-validator`/`class-transformer` | Reject malformed input at the API boundary. |
| Authentication | Google OIDC verification + backend-issued access/refresh tokens | Google proves identity; Soul owns its application session. |
| Authorization | Nest guards/services + ownership checks in every query | Private data is never protected only by client behavior. |
| File storage | S3-compatible storage (AWS S3, Cloudflare R2, or MinIO) | Private Vision images and controlled audio delivery via signed URLs. |
| Logging | `nestjs-pino` | Structured request/error logs without sensitive payloads. |
| Tests | Jest + Supertest | Service, authorization, and HTTP contract tests. |
| Packaging | Docker + Docker Compose | Reproducible local API/PostgreSQL/storage development. |

Use short-lived access tokens and rotating refresh tokens whose server-side values are hashed. The backend verifies Google identity tokens; it must not trust a user ID, email, role, or ownership claim sent by the app.

## 4. Administration application — deferred

The app-only MVP ships content inside the app, so there is no admin application. It returns with the backend, when content must change without an app release.

| Area | Choice | Purpose |
|---|---|---|
| Framework | Next.js App Router + TypeScript | Server-rendered admin UI and clear route protection. |
| UI | Tailwind CSS + `shadcn/ui` | Fast internal-tool implementation with accessible primitives. |
| Server state | TanStack Query | Cache/invalidation for API-backed tables and forms. |
| Forms | React Hook Form + Zod | Typed validation and predictable editing flows. |
| Authentication | Backend Google login + HTTP-only admin session cookie | No database or privileged token in browser code. |
| Authorization | Backend roles: `admin`, `editor` | Restrict publishing, users, and destructive operations. |
| Tests | Vitest + Testing Library; Playwright for critical flows | Validate editing, permissions, and publishing. |

### Admin MVP scope

- Vision categories, feelings, guided questions, and suggested answers.
- Category-to-audio mappings; audio locale, license, review, and publication status.
- 28-day journey copy, tasks, affirmations, and notification copy.
- External content links and editorial state.
- Read-only operational view of users/content errors; no broad user-data browsing by default.

Before the admin UI exists, a deterministic import CLI can seed content. Do not turn spreadsheets into a permanent production CMS.

## 5. Content import

App-only MVP: a deterministic build-time step validates the active datasets and writes versioned JSON assets into the app. The generator is `npm run content:export` in SoulApi, reusing its tested parser and validation as a build tool only; its JSON is committed under `SoulApp/assets/content/`. The importer is described below:

- TypeScript CLI (`npm run content:import` in SoulApi). XLSX is read directly with `jszip` + `fast-xml-parser`: the authoring workbooks use namespace-prefixed OOXML (`<x:workbook>`) that `exceljs` cannot parse. DOCX only needs heading IDs, read from `word/document.xml`; `mammoth` is not needed yet.
- Stable source IDs and database upserts.
- Dry-run mode, validation report, and transactional import.
- Reject missing translations, broken category/audio references, duplicate IDs, and unpublished media mappings.

The existing source workbooks remain unchanged and are never parsed by the mobile app.

## 6. Infrastructure and delivery

| Area | MVP decision |
|---|---|
| Source layout | One deployable for the MVP: `SoulApp/`. `SoulApi/` is kept but paused; `SoulAdmin/` is deferred. |
| Local development | Flutter runs on simulator/device; no services required. |
| CI | GitHub Actions: format, lint/analyze, tests, migrations check, and builds. |
| Environments | Debug and signed release builds; separate server environments return with the backend. |
| Secrets | CI/deployment secret manager only; commit example configuration without real values. |
| Monitoring | Structured logs first; add error tracking after privacy/consent review. |

The app-only build needs no runtime configuration. No secret may ship in the app.

## 7. Deliberately deferred

- Redis and BullMQ: add only when server-side jobs or queues are proven necessary.
- GraphQL: REST/OpenAPI covers the MVP without a second query layer.
- Kubernetes: unnecessary operational weight for the initial product.
- Background audio service/lock-screen controls: wait for an accepted requirement.
- Analytics/attribution SDKs: wait for consent, privacy, and data-retention decisions.
- Microservices: keep a modular monolith until scale or team ownership creates a real boundary.
- A custom CMS framework: the focused admin app is sufficient.

## 8. Recommended delivery order

1. Flutter shell: design system, localization, routing, local preferences.
2. Content bundle: dataset validation and JSON generation, read-only catalog in the app.
3. Local database (Drift) and onboarding: intention, reminders, journey start.
4. Today/Journey, Vision with local images, audio playback, local notifications.
5. Journal and Future Letter.
6. Release hardening.
7. Later: sync backend, sign-in, and admin application.
