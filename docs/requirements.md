# Soul normalized implementation requirements

Updated: 2026-09-26

This document resolves the supplied specifications, datasets, owned-content pack, and approved HTML prototype into requirements that can be implemented and tested without guessing.

## 0. Delivery mode: app-only (decision 2026-09-26)

The MVP ships as an app-only product without a backend. This decision overrides any requirement below that depends on a server:

- All user data (profile, locale, sound preference, journey progress and responses, Journal, Visions and images, Future Letters, reminder settings) is stored on the device. There is no account and no sign-in.
- Onboarding is language → preferred name → intention → reminders → Today.
- Published content (journey, Vision catalog, feelings, notification copy, audio mapping) ships as versioned read-only data inside the app. Audio is bundled in the app while its total size stays within about 50 MB; beyond that it moves to a remote manifest of files on a static host, with one or two bundled `neutral` fallback tracks.
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
- Header actions are:
  1. Mood / Theme badge indicator (shows current emotion icon; tapping opens theme & mood switcher).
  2. Global sound toggle button (plays/mutes audio across the app).
  3. Avatar (opens Profile and settings).
  All header actions maintain at least a 44 by 44 logical-pixel touch target.
- Bottom navigation has five destinations: Today, Soul Cards (Rút thẻ), Vision, Journal, Explore.
- Profile/settings opens from the avatar and is not a sixth bottom tab.
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

### REQ-UX-005 Tablet and iPad responsiveness

- Support responsive layout scaling from compact phones up to 1024+ pt tablets and iPads.
- On tablet viewports, grid items (Vision collage cards, Comfort Zone rooms, Soul Cards) reflow into multi-column responsive arrangements.
- Form inputs, Journal paper surfaces, and onboarding cards respect max-width constraints (540–640 pt) centered on screen to avoid uncomfortable eye-scanning distance.
- Full compatibility with portrait, landscape, and iPad split-screen multitasking.

### REQ-UX-006 Today rhythm hierarchy (Nhịp hôm nay)

To maximize active daily habit formation, user engagement, and retention, items within "Today's Rhythm" are sequenced in deliberate priority order:
1. Core Gratitude Practice of the day.
2. Home Screen Widget Tracker setup / status card.
3. Soul Cards message draw (Rút thẻ thông điệp).
4. Comfort Zone / Little Corner shortcut (Góc bình yên).
5. Small actions & evening reflection preview.

### REQ-UX-007 Mood check-in and dynamic visual themes

- Mood check-in connects to a visual theme / color atmosphere across the app.
- When the user selects a mood, the emotion icon displays prominently in the header adjacent to the sound button; tapping it allows switching themes or updating mood.
- Upon daily mood selection, the prompt card on Today auto-collapses to keep the screen clean, with an expand toggle for manual updates.
- Mood selection state resets cleanly at 00:00 every calendar day.

### REQ-UX-008 Comfort Zone (Góc bình yên — Không gian an trú)

- Hub with 28 mindful rooms organized into 5 categories: Cozy Indoor, Nature Escape, Little Companions, Dreamy Moments, Seasonal Sanctuary.
- Interactive scene canvas with daylight/night artwork transitions and peaceful animations.
- Center-blur countdown timer: Floating frosted glass countdown bubble centered on screen with crisp, high-contrast white typography.
- Signature audio soundscape loaded automatically upon entry with quick audio switcher modal.

## 3. Localization and content

### REQ-L10N-001 Language gate

- The first screen contains only the logo and the choices `Tiếng Việt` and `English` (each language's own name, identical in every locale); no language-specific sentence appears before selection.
- Device locale may pre-highlight a choice (shown as the primary button) but must never commit it automatically; the locale is committed only when the user taps a choice.
- The selected locale is persisted locally immediately.

### REQ-L10N-002 Multi-language application tree

- All 6 supported languages (`vi`, `en`, `fr`, `ja`, `ko`, `zh`) share the same routes, widgets, state machines, and validations.
- UI copy comes from generated ARB resources.
- Journey, Vision, notification, card decks, comfort zone rooms, and content-resource copy come from localized content bundles, never from widget constants.
- Missing content translation is an editorial error; the app must not silently mix locales.

### REQ-L10N-003 Audio language and authenticity

- Spoken audio is eligible only when matching the active content/audio locale (`vi`, `en`, `ko`, `ja`, `fr`, `zh`).
- Language-neutral instrumental, ambient, and nature audio plays across all locales.
- **Strict Audio Authenticity (REQ-AUD-005)**: 100% of background soundbeds and music tracks must be pre-recorded real-world nature audio (rain on window, rolling waves, gentle fireplace, birdsong) or licensed master musical recordings (Kevin MacLeod). Algorithmic, synthetic, or noise-generator audio is strictly banned.

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
2. Day X of 28, day title, calm progress ring, and primary resume CTA.
3. Mood check-in ("Cảm xúc của bạn lúc này") with auto-collapse upon selection and top-bar mood badge indicator.
4. "Today’s Rhythm" (Nhịp hôm nay), prioritized for retention and habit engagement:
   - Core gratitude practice.
   - Living Home Widget card (Widget màn hình chính).
   - Soul Cards message draw (Rút thẻ thông điệp).
   - Comfort Zone / Little Corner shortcut (Góc bình yên).
   - Small actions & evening preview.
5. Vision of the day when at least one active Vision exists.

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

### US-JRN-004 Missed day and 28-day renewal loop

- Missing a calendar day never resets the journey or uses guilt/streak-loss copy.
- Return CTA is `Continue Day X` for the first incomplete day.
- Catch-up is optional and never requires multiple days in one session.
- Day completes only after all required tasks complete.
- **28-Day Renewal Cycle**: Upon completing Day 28, a celebratory milestone modal summarizes practices completed. The user is offered the choice to loop back to Day 1 to begin a new 28-day gratitude cycle, preserving all existing journal entries, visions, and card draws in local storage.

### US-JRN-005 Persistence and offline

- Persist completed tasks and user-written responses in the local database after app restart.
- Day content is bundled and always readable offline.
- Writes are idempotent (one response per task and run) so repeated taps never duplicate records.
- When sync is added later, never silently overwrite user-written text during conflict resolution.

## 6. Soul Cards (Rút thẻ thông điệp)

### US-CRD-001 Browse decks and draw card

- Entry is available as the 2nd destination in bottom navigation.
- 3 decks: Sự nghiệp & Phát triển (`career`), Chữa lành & Bình an (`healing`), Tình yêu & Mối quan hệ (`relationship`).
- Each deck contains 50 curated card images in WebP format (150 cards total).
- Card messages are bilingual; the message displayed matches the active app locale (`vi` or `en`).
- Interactive 3D flip card animation presents the front artwork and back reflection message.

### US-CRD-002 Daily draw limit

- Users may draw a maximum of 2 cards per calendar day across all decks combined.
- Draws are recorded with timestamp and date locally.
- On the 3rd draw attempt on the same day, the app presents a gentle alert dialog reminding the user that they have drawn enough cards for today, encouraging mindful contemplation without hard blockage on viewing already drawn cards.

## 7. Guided Vision Board

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

### US-VIS-003 Vision Board collage and detail

- Zero Visions shows a guided create state, not an empty blank canvas.
- One or more Visions render as an authentic **Vision Board Collage**:
  - Arranged in an artistic 2-column masonry / staggered collage grid.
  - Cards with photos render as polaroid-style framed clippings.
  - Cards without user photos have their statement printed directly on the category's signature gradient canvas (with watermark background icon and washi tape accent).
  - Cards feature a washi tape accent and subtle paper shadow evoking a physical pinboard.
  - A layout switcher icon allows toggling between 2-column Collage Board and single-column List View.
- Tapping a card opens detail with full statement, feelings, image, assigned playlist, edit, archive, and session CTA.
- Back always returns to the same board state and scroll position.

### US-VIS-004 Edit and archive

- User may edit goal answers, statement, feelings, and image.
- Category change re-resolves the playlist; feelings change does not.
- Archive/soft delete removes a Vision from the active board without deleting historical journal/session records.
- Permanent deletion, if later offered, requires explicit confirmation.

## 8. Native audio and Vision Session

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

## 9. Journal and Future Letter

### US-JOU-001 Journal notes

- Gratitude practice answers and reflections are automatically available by date.
- User may write freely as in a natural journal notebook without being forced into rigid decomposed sentence fields.
- Daily journey itinerary prompt is housed in a collapsible dropdown header to preserve visual space for writing.
- Theme selector is integrated as a dropdown on the journal paper sheet alongside "Insert template" and "Add photo" actions.
- Note UI is clean and open: no nested card outlines, no redundant "Note content" labels, and no superfluous close buttons.
- Historical notes support full viewing, in-place editing (updating text and images), and deletion.
- Notes are private and stored on the device; they work fully offline.

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

## 10. Explore

### US-EXP-001 Browse curated content

- Explore follows the prototype: featured recommendation plus list/filter views.
- Content may be Soul Sound, Guided Audio, YouTube, Spotify, article, or guided practice.
- Filter by publication state and active locale before display.
- Native content plays in Soul only when owned/licensed; external content opens the canonical official URL/embed.
- Show source/creator attribution for external items.
- Never download, cache, rip, or rehost third-party audiovisual media.

## 11. Profile and settings

### US-PRO-001 Avatar profile

- Avatar opens the user space shown in the prototype.
- Show journey days, active Vision count, and journal count.
- Provide preferred name, language, per-category reminder settings, global sound, privacy, and delete-all-local-data entry points. Sign-out and account deletion are deferred with sync.
- Language change updates UI immediately and reloads localized content without reinstall.
- Deleting local data requires explicit confirmation, removes every private record and stored image, cancels scheduled reminders, and returns to the language gate.

## 12. Notifications

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
