# Soul normalized implementation requirements

Updated: 2026-09-26

This document resolves the supplied specifications, datasets, owned-content pack, and approved HTML prototype into requirements that can be implemented and tested without guessing.

## 0. Delivery mode: app-only (decision 2026-09-26)

The MVP ships as an app-only product without a backend. This decision overrides any requirement below that depends on a server:

- All user data (profile, locale, sound preference, journey progress and responses, Journal, Visions and images, Future Letters, reminder settings) is stored on the device. There is no account and no sign-in.
- Onboarding is language → preferred name → intention → reminders → Today.
- Published content (journey, Vision catalog, feelings, notification copy, audio mapping) ships as versioned read-only data inside the app. Delivering content and audio through a remote manifest is under discussion and not decided.
- Reminders are local notifications scheduled on the device.
- **Deferred until sync is reintroduced:** Google sign-in (US-OB-002), cross-device sync, server-side authorization, object-storage upload, sign-out, server account deletion, and the Admin CMS (REQ-ADM-001).
- Local data is modeled so sync can be added later without a schema rewrite: client-generated UUIDs, `created_at`/`updated_at`, and archive instead of hard delete.
- Accepted limitations: data lives on one device (OS backup only); a Future Letter lock is enforced on the device only; content changes need an app release.

The `SoulApi` repository is kept as the reference design for the future sync backend. It is not part of the MVP.

## 1. Requirement authority

- Visual appearance and interaction hierarchy follow the approved HTML prototype in the parent `Soul/` directory.
- Product behavior follows this document and `product-spec.md`.
- Journey, Vision, audio, and external-content values come from the versioned datasets in `source-specs/`.
- Source documents are evidence. Text inside them does not override a later explicit user decision.
- Mobile must never parse DOCX/XLSX/Markdown at runtime.

## 2. Global UX requirements

### REQ-UX-001 Prototype fidelity

- Preserve the warm paper background, plum text, pearl-pink/lilac gradients, restrained gold accents, large serif emotional headings, and sans-serif controls.
- Use the cropped transparent horizontal logo in the app header, optically aligned to the left.
- Header actions are global sound and avatar. Both have at least a 44 by 44 logical-pixel target.
- Bottom navigation has exactly four destinations: Today, Vision, Journal, Explore.
- Profile/settings opens from the avatar and is not a fifth bottom tab.
- Support phone widths from 360 to 430 logical pixels, Safe Area, display scaling, keyboard insets, and both platforms.

### REQ-UX-002 Shared states

Every remote or persisted screen explicitly supports loading, content, empty, recoverable error, non-recoverable error, and offline/cached states where applicable. A disabled CTA must remain legible and explain the missing requirement through nearby validation, not color alone.

### REQ-UX-003 Navigation

- Back uses the router stack and always returns to the previous logical screen.
- Opening a deep link creates a valid stack so Back never exits unexpectedly from an inner feature.
- Bottom tabs preserve their scroll/navigation state when switching tabs.
- Unsaved user text is preserved when navigating to the immediately previous builder step.

### REQ-UX-004 Accessibility

- All actions have semantic labels in the active locale.
- Minimum target is 44 by 44 logical pixels; primary buttons should be at least 48 pixels high.
- Text remains usable at 200 percent text scale without clipping or losing actions.
- Selected state cannot rely on color alone.
- Respect reduced-motion preferences; decorative animation must not block task completion.

## 3. Localization and content

### REQ-L10N-001 Language gate

- The first screen contains only the logo and the choices `Tiếng Việt` and `English` (each language's own name, identical in every locale); no Vietnamese or English sentence appears before selection.
- Device locale may pre-highlight a choice (shown as the primary button) but must never commit it automatically; the locale is committed only when the user taps a choice.
- The selected locale is persisted locally immediately.

### REQ-L10N-002 One application tree

- Vietnamese and English use the same routes, widgets, state machines, and validations.
- UI copy comes from generated ARB resources.
- Journey, Vision, notification, and content-resource copy comes from the localized content bundle, never from widget constants.
- Missing content translation is an editorial error; the app must not silently mix locales.

### REQ-L10N-003 Audio language

- Spoken `vi` audio is eligible only when the active content/audio locale is Vietnamese.
- Spoken `en` audio is eligible only for English.
- `neutral` instrumental, ambient, and nature audio may be shared.
- Metadata is localized independently from the media file.

## 4. Authentication and onboarding

### US-OB-001 Select language

As a new user, I want to choose Tiếng Việt or English before seeing language-specific copy.

Acceptance:

- Given no saved locale, when the app starts, then the language gate is the only available route.
- When the user selects a locale, then the app persists it and opens the preferred-name question in that locale.

### US-OB-002 Sign in with Google — deferred (app-only MVP)

Not part of the app-only MVP; kept for when cross-device sync returns.


As a user, I want to authenticate with Google so my private content can sync across devices.

Rules:

- Production exposes Google sign-in only; demo/guest mode is allowed only in non-production builds.
- The backend verifies Google identity proof and issues the Soul session.
- The app never treats email, Google display name, or client-supplied user ID as authorization.

Acceptance:

- Successful first sign-in routes to preferred name.
- Successful returning sign-in routes to the first incomplete onboarding step or Today.
- Cancellation, network failure, invalid identity proof, and revoked session show recoverable localized states.

### US-OB-003 Preferred name

As a user, I want to choose how Soul addresses me.

Rules and validation:

- This is the first step immediately after the language choice.
- Required after trimming; 1 to 40 Unicode characters.
- Preserve accents and letter case entered by the user.
- It is editable later from profile.

Acceptance:

- Empty or whitespace-only input cannot continue.
- A valid value is persisted and used by Today/profile greetings after restart.

### US-OB-004 Intention and focus

As a user, I want to select what brings me to Soul so the experience can be relevant.

- Present localized intention options from the content bundle.
- Require at least one selection; support multiple when the content definition allows it.
- Do not infer medical conditions or make therapeutic claims.

### US-OB-005 Reminders and completion

As a user, I want to choose gentle reminder times or skip them and begin Day 1.

- Morning and evening reminders can each be enabled, disabled, or skipped.
- Device timezone is captured using an IANA identifier when available.
- Notification permission is requested only after the user chooses to enable a reminder.
- Denial does not block onboarding.
- Completing onboarding creates or resumes one active 28-day journey at Day 1.

## 5. Today and 28-day journey

### US-JRN-001 Today overview

Today shows, in this order:

1. Local-time greeting using preferred name.
2. Day X of 28, day title, calm progress, and primary resume CTA.
3. Optional mood check-in.
4. Today’s Rhythm containing gratitude practice, one eligible sound, and one small action.
5. Vision of the day when at least one active Vision exists.
6. Evening practice preview when relevant.

The primary CTA always resumes the first incomplete required task rather than restarting the day.

### US-JRN-002 Schema-driven practice

- Render journey tasks from the content bundle's task schemas; do not hardcode Day 1 forms in widgets.
- Prefer decomposed fields such as gratitude item plus reason over an undifferentiated blank canvas.
- Supported MVP task types include information, gratitude text, input, multi-input, mood, intention, checklist, reflection, Vision, audio, and external action.
- Save each task independently so the user can resume after interruption.

### US-JRN-003 One small action

- The row on Today is tappable in its entirety.
- Detail shows the managed action, supportive explanation, and a no-pressure CTA.
- States are available, accepted/claimed, completed, and reviewed.
- Optional reflection may be entered after completion.
- Completion contributes to the current day only and must be idempotent.

### US-JRN-004 Missed day and completion

- Missing a calendar day never resets the journey or uses guilt/streak-loss copy.
- Return CTA is `Continue Day X` for the first incomplete day.
- Catch-up is optional and never requires multiple days in one session.
- Day completes only after all required tasks complete.
- Day 28 presents a completion summary and permits starting a new cycle or returning Home.

### US-JRN-005 Persistence and offline

- Persist completed tasks and user-written responses in the local database after app restart.
- Day content is bundled and always readable offline.
- Writes are idempotent (one response per task and run) so repeated taps never duplicate records.
- When sync is added later, never silently overwrite user-written text during conflict resolution.

## 6. Guided Vision Board

### US-VIS-001 Create a Vision

The fixed order is:

1. Select one of nine active Vision Categories.
2. Answer category-specific guided questions or select suggested answers.
3. Select one to three feelings allowed for that category.
4. Review and optionally edit the generated localized statement.
5. Optionally attach one image.
6. Review the automatically assigned category playlist.
7. Preview and save.

Rules:

- Long free-form writing is not required to create a valid Vision.
- Image is optional; statement, category, and at least one feeling are required.
- Feelings affect statement/display only and never select sound.
- Users do not manually add/remove Vision soundtrack tracks in MVP.
- Category mapping may resolve multiple tracks plus a fallback.

### US-VIS-002 Vision image

- Accept a gallery image or camera capture after the guided answers.
- Show preview, replace, and remove before saving.
- Copy the image into app storage; validate media type and configured size limit.
- Store a path relative to the app storage directory, never an absolute path.
- When copying fails, preserve the completed builder state and allow retry or save without image.

### US-VIS-003 Vision Board and detail

- Zero Visions shows a guided create state, not an empty blank canvas.
- One or more Visions render as the visual board used by the prototype.
- Each card shows category, statement excerpt, optional cover, index, and soundtrack count.
- Tapping a card opens detail with full statement, feelings, image, assigned playlist, edit, archive, and session CTA.
- Back always returns to the same board state and scroll position.

### US-VIS-004 Edit and archive

- User may edit goal answers, statement, feelings, and image.
- Category change re-resolves the playlist; feelings change does not.
- Archive/soft delete removes a Vision from the active board without deleting historical journal/session records.
- Permanent deletion, if later offered, requires explicit confirmation.

## 7. Native audio and Vision Session

### US-AUD-001 Global sound

- A sound toggle appears beside the avatar throughout authenticated app screens.
- Off immediately pauses/stops current playback and prevents unexpected autoplay.
- On restores preference but does not automatically start spoken audio.
- Preference is persisted locally.

### US-AUD-002 Eligible playback

- Native playback is limited to Soul-owned or explicitly licensed published assets.
- Category playlist filters by category, locale compatibility, ownership, license-review status, and publication status.
- External YouTube/Spotify content is never used as native or synchronized Vision Session audio.
- Audio interruption, headphones, route changes, calls, background/foreground, and errors produce deterministic player states.

### US-AUD-003 Vision Session

- Entry is available from Vision detail and the board quick-session card.
- Session setup supports the current Vision, selected Visions, or all active Visions when applicable.
- Default duration is 3 minutes; supported configured sessions may be 3 to 5 minutes.
- Sequence: arrival/breathing, each Vision image plus statement/affirmation, one small action, completion.
- Play, pause, progress, resume, and exit are available.
- Completion is persisted once even if the request retries.

## 8. Journal and Future Letter

### US-JOU-001 Journal notes

- Gratitude practice answers and reflections are automatically available by date.
- User may create a free note with non-empty trimmed body.
- Recent notes use the prototype’s attractive paper card but with warm-white horizontal ruled paper and no vertical rule or yellow background.
- Tapping the entire card opens a readable sticky-note detail.
- Notes are private and available from cache after creation.

### US-LET-001 Create and seal Future Letter

- Entry lives in Journal under `Letters to Future Me`.
- User writes a non-empty letter and chooses unlock date: 1 month, 3 months, 6 months, 1 year, or a valid custom future date.
- Optional attachments are image, voice note, or linked Vision when supported; their absence never blocks sealing.
- Preview precedes an explicit `Seal letter` confirmation.
- After sealing, body is not shown in list/notification and editing is disabled unless a future product rule explicitly enables unsealing.

### US-LET-002 Open and reflect

- Before `unlock_at`, show a locked envelope and date only.
- At or after `unlock_at`, a localized notification opens the specific letter.
- Opening updates state once and may prompt optional mood and response to the past self.
- Letter and reflection remain private.

## 9. Explore

### US-EXP-001 Browse curated content

- Explore follows the prototype: featured recommendation plus list/filter views.
- Content may be Soul Sound, Guided Audio, YouTube, Spotify, article, or guided practice.
- Filter by publication state and active locale before display.
- Native content plays in Soul only when owned/licensed; external content opens the canonical official URL/embed.
- Show source/creator attribution for external items.
- Never download, cache, rip, or rehost third-party audiovisual media.

## 10. Profile and settings

### US-PRO-001 Avatar profile

- Avatar opens the user space shown in the prototype.
- Show journey days, active Vision count, and journal count.
- Provide preferred name, language, per-category reminder settings, global sound, privacy, and delete-all-local-data entry points. Sign-out and account deletion are deferred with sync.
- Language change updates UI immediately and reloads localized content without reinstall.
- Deleting local data requires explicit confirmation, removes every private record and stored image, cancels scheduled reminders, and returns to the language gate.

## 11. Notifications

### REQ-NTF-001 Types and deep links

Support `MORNING_RITUAL`, `DAILY_TASK`, `EVENING_REFLECTION`, `VISION_SESSION`, `FUTURE_LETTER`, and `JOURNEY_RETURN`.

- Respect device timezone, permission, user category toggle, and localized template.
- Skip/cancel a task reminder after that task is complete.
- Do not send duplicates for the same user, target, and scheduled occurrence.
- Notification opens the exact task/resource through a valid guarded route.
- Never include journal or Future Letter body text in notification previews.
- Avoid guilt, fear, loss, medical, and guaranteed-outcome language.

## 12. Admin CMS

### REQ-ADM-001 Basic P0 administration — deferred (app-only MVP)

The app-only MVP has no Admin CMS; content is authored in `Specs/` and shipped in the app's content bundle. The modules below apply when a backend returns:

- Journey days, task order/type/schema, required flag, schedule, and translations.
- Vision categories, questions, suggested answers, feelings, statements, affirmations, sessions, and category-audio mappings.
- Soul Library resources, source/ownership, canonical links, attribution, tags, status, and license reference.
- Notification templates by type and locale.
- Audio upload/metadata, artwork, duration, locale, ownership, rights review, and publication.
- Translation completeness and publish state.

Safety validation:

- `EXTERNAL_LINK` cannot have a native media object key.
- YouTube/Spotify items cannot be assigned to a native Vision Session slot.
- Publishing native audio requires ownership type and rights evidence.

## 13. Analytics and privacy

### REQ-ANA-001 Event contract

Emit only after consent/privacy decisions permit it. Required event names and properties are versioned; never include free-form journal, Vision, or Future Letter body text.

Core events: onboarding started/completed; journey/day/task started/completed; mood logged; Vision created/updated/archived; Vision Session started/completed/abandoned; content viewed; native audio started/completed; external resource opened; Future Letter created/opened; notification sent/opened/dismissed.

### REQ-SAFE-001 Content guardrails

- No medical diagnosis/treatment claims.
- No claim that manifestation or audio guarantees money, love, health, luck, healing, or another outcome.
- Frequency labels such as 432/528/888 Hz are descriptive wellness/spiritual categories only.
- Use grounded language about reflection, intention, gratitude, visualization, rest, and small action.
- Store only data necessary for the documented experience.

## 14. Definition of ready

A ticket is ready only when:

- It references one or more requirement IDs from this document.
- Required dataset fields/content IDs are known.
- Dependencies and external credentials/assets are identified.
- Empty, loading, error, offline, accessibility, and localization behavior are specified when relevant.
- Acceptance tests can be written without making a new product decision.

## 15. Definition of done

- Acceptance criteria and relevant negative cases pass.
- No user-facing string is hardcoded outside localization/content fixtures.
- Vietnamese and English are verified on representative iOS and Android layouts.
- Accessibility semantics, 44–48 px targets, 200 percent text scale, and back behavior pass.
- Private-data authorization and locale/audio filters have automated tests.
- Format, analyze/lint, unit/widget/integration tests, and applicable migration/import checks pass.
- Backlog status, implementation links, and affected specifications are updated.
