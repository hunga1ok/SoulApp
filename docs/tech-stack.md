# Soul technology stack

Reviewed: 2026-09-25

## 1. System boundary

```text
SoulApp (Flutter) ─┐
                  ├─ HTTPS REST API ─ SoulApi ─ PostgreSQL
SoulAdmin (Web) ──┘                     └─ S3-compatible object storage
```

- Mobile and admin never connect directly to PostgreSQL.
- The API owns authentication, authorization, validation, and content rules.
- PostgreSQL stores structured data and metadata; images/audio live in object storage.
- The supplied spreadsheets and DOCX files are authoring sources, not runtime assets.

## 2. Mobile application — required for MVP

| Area | Choice | Purpose |
|---|---|---|
| Framework | Flutter 3.44.8 / Dart 3.12.2 | One iOS/Android codebase using the installed baseline. |
| State and dependency injection | `flutter_riverpod` | Screen state, controllers, and dependency wiring. |
| Navigation | `go_router` | Auth/onboarding guards, deep links, and reliable back stacks. |
| API client | `dio` | REST calls, token interceptor, timeouts, upload progress, and typed error mapping. |
| Localization | `flutter_localizations`, `intl`, generated ARB | One widget tree for Vietnamese and English. |
| Google login | `google_sign_in` | Obtain Google identity proof for backend verification. |
| Secure secrets | `flutter_secure_storage` | Store refresh token/device secrets. |
| Small preferences | `shared_preferences` | Locale, audio toggle, onboarding checkpoint, and non-sensitive settings. |
| Audio | `just_audio`, `audio_session` | Playlist playback, audio focus, interruptions, and lifecycle. |
| Vision image | `image_picker` | Select or capture the optional Vision image. |
| Reminders | `flutter_local_notifications`, `timezone` | Locale-aware local journey reminders. Add in the Journey phase. |
| External content | `url_launcher` | Open approved YouTube/Spotify links outside native playback. |
| Tests | `flutter_test`, `integration_test`, golden tests | Unit, widget, device-flow, and bilingual visual regression. |

Add `sqflite` and `path_provider` only when the first offline write queue is implemented. Do not introduce a second state-management or service-locator package.

## 3. Backend API — required before synced user data

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

### Backend not needed on day one

The Flutter shell, design system, localization, static onboarding, and static content prototypes can be built without a running server. Backend becomes mandatory for real Google sessions, cross-device data, image upload, content publishing, and admin workflows.

## 4. Administration application — recommended, staged

Soul needs content administration because category-to-audio mappings, bilingual copy, journey content, publication state, and license review will change without an app release.

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

Place import logic beside the API and make it repeatable:

- TypeScript CLI using `exceljs` for XLSX and `mammoth` for DOCX.
- Stable source IDs and database upserts.
- Dry-run mode, validation report, and transactional import.
- Reject missing translations, broken category/audio references, duplicate IDs, and unpublished media mappings.

The existing source workbooks remain unchanged and are never parsed by the mobile app.

## 6. Infrastructure and delivery

| Area | MVP decision |
|---|---|
| Source layout | Keep three deployables: `SoulApp/`, `SoulApi/`, and `SoulAdmin/`. |
| Local development | Docker Compose for API dependencies; Flutter runs on simulator/device. |
| CI | GitHub Actions: format, lint/analyze, tests, migrations check, and builds. |
| Environments | Development, staging, production with separate databases and storage buckets. |
| Secrets | CI/deployment secret manager only; commit example configuration without real values. |
| Monitoring | Structured logs first; add error tracking after privacy/consent review. |

Required Flutter configuration:

```json
{
  "API_BASE_URL": "https://api.example.com/v1",
  "GOOGLE_WEB_CLIENT_ID": "example.apps.googleusercontent.com",
  "OAUTH_REDIRECT_SCHEME": "com.manifest.soul"
}
```

Platform-specific Google client IDs belong in the native Android/iOS configuration. No database password, object-storage secret, or JWT signing key may ship in the app.

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
2. API skeleton: health endpoint, configuration, OpenAPI, PostgreSQL migrations.
3. Google auth and preferred-name onboarding end to end.
4. Deterministic content import and read-only catalog endpoints.
5. Today/Journey and Vision user data, image upload, and audio catalog.
6. Focused admin application for content maintenance and publishing.
7. Offline queue, operational monitoring, and release hardening.
