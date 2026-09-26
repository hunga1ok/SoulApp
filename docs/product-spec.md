# Soul mobile product specification

## 1. Product intent

Soul is a private, bilingual wellbeing application that helps a user practice gratitude, shape personal visions, listen to suitable soundscapes, and revisit meaningful notes. The experience should feel calm, warm, personal, and low-pressure.

## 2. MVP platforms and languages

- Flutter mobile app for iOS and Android.
- Vietnamese (`vi`) and English (`en`) at launch.
- Device locale suggests the initial language. The user explicitly confirms it.
- Language can be changed later from profile settings.

## 3. Primary navigation

Four bottom tabs:

1. Today
2. Vision
3. Journal
4. Explore

Profile and settings open from the avatar in the app header. Global sound can be toggled beside the avatar.

## 4. Onboarding and authentication

### Flow

1. Language-neutral locale chooser: `Tiếng Việt` or `English` (endonyms; the device-suggested language is highlighted, and the user's tap confirms).
2. Google sign-in, with demo mode available only in non-production builds.
3. Preferred name: “Soul should call you…”. This is independent of the Google account name.
4. Primary intention for using Soul.
5. Morning and evening reminder preferences.
6. Journey-ready confirmation.
7. Enter Today.

### Acceptance criteria

- No Vietnamese or English sentence appears before language choice.
- Returning authenticated users skip completed onboarding.
- Preferred name is required, trimmed, limited to 40 characters, editable later, and used in greetings.
- OAuth cancellation and retry are handled without losing the chosen locale.

## 5. Today

- Personalized greeting using preferred name.
- Current day in the 28-day gratitude journey.
- Progress and completion state.
- Mood check-in.
- “Today’s rhythm” with gratitude practice, a locale-compatible sound, and one small action.
- A relevant Vision card when the user has active Visions.
- An evening-practice preview when relevant.
- Completing a practice creates or updates the corresponding journey progress and journal data.

### Journey continuity

- Each day contains an introduction, morning gratitude, a specific daily practice, an optional contextual reminder, evening reflection, and completion.
- Task forms are schema-driven and prefer guided/decomposed prompts over blank canvases.
- Missing a day never resets progress or produces guilt/streak-loss copy. The return action is “Continue Day X”; catch-up is optional.
- Day 28 offers a completion summary and the choice to return Home or begin another cycle.

### Audio rule

Vietnamese users may hear Vietnamese spoken audio or language-neutral instrumental audio. English users may hear English spoken audio or language-neutral instrumental audio. Cross-language spoken playback is never automatically surfaced.

## 6. Vision Board

### Create Vision

1. Select one of the nine Vision Categories.
2. Answer the guided prompt.
3. Select one to three feelings from the category’s feeling group.
4. Review and optionally edit the generated statement.
5. Optionally attach one image.
6. Review the automatically assigned category playlist.
7. Preview and save.

### Sound rule

- The playlist is assigned by Vision Category.
- Feelings shape display and statements; they do not select the soundtrack.
- Users do not manually choose Vision Session soundtracks in MVP.
- A category may have multiple owned/licensed tracks and one fallback.

### Board and detail

- Multiple visions display as a Vision Board.
- Tapping a Vision opens its statement, feelings, image, and assigned playlist.
- Vision goal/statement, feelings, and image can be edited; changing category reassigns its playlist.
- Archive is a soft delete and does not delete linked historical entries.
- Back navigation reliably returns to the board.

## 7. Vision Session

- Guided three-to-five-minute session for the current, selected, or all active Visions.
- Sequence: arrival, Vision image and statement/affirmation, one small action, completion.
- Play, pause, progress, and safe interruption behavior.
- Only Soul-owned or separately licensed audio plays natively.
- The app remembers global sound preference but does not autoplay spoken audio unexpectedly.

## 8. Journal

- Gratitude and reflection entries appear as lined-paper sticky notes without a vertical margin line.
- Tapping a note opens a readable detail view.
- Notes are private by default and sync to the authenticated user.
- Offline-created entries remain available and sync when connectivity returns.

### Future Letter

- Users can write and seal a private letter that unlocks in one, three, six, or twelve months, or on a valid custom future date.
- An optional image, voice note, or linked Vision may be attached when supported.
- Before unlock, the list shows only a sealed-envelope state and date; notification previews never expose letter text.
- After unlock, users may record an optional mood and response to their past self.

## 9. Explore

- Curated content filtered by locale and editorial status.
- External YouTube and Spotify items open via official deep links or supported embeds.
- External media is never downloaded, rehosted, or presented as a native Soul soundtrack without a separate license.

## 10. Profile and settings

- Preferred name.
- Language.
- Global audio toggle.
- Reminder times and permission status.
- Journey, Vision, and journal counts.
- Sign out and account deletion entry points.

## 11. Notifications

- Morning ritual, daily task, evening reflection, Vision Session, Future Letter, and gentle journey-return reminders.
- Each category can be disabled independently where practical.
- Completed tasks do not receive duplicate reminders.
- Tapping a notification opens the relevant guarded app destination.
- Copy is localized and avoids guilt, fear, loss, and private journal/letter text.

## 12. Administration

A focused internal admin application is part of the MVP operational scope. It manages Journey content, Vision templates, category-audio mappings, localized notification copy, native audio rights/publication, external-resource metadata, and translation completeness without requiring a mobile release.

## 13. Analytics

When consent and privacy policy permit, emit versioned funnel events for onboarding, journey tasks, Visions, Vision Sessions, content opens, native audio, Future Letters, and notifications. Analytics payloads never contain free-form private content.

## 14. Privacy and safety

- Vision images, journal entries, responses, and progress are user-owned private data.
- Do not make medical, therapeutic, scientific-frequency, financial-outcome, or manifestation-guarantee claims.
- Store only the user data required for the documented experience.

## 15. MVP exclusions

- AI image generation.
- Social feed, sharing, comments, or public profiles.
- User-selected Vision soundtrack catalogs.
- In-app subscription and payment.
- Advanced editorial workflows beyond the focused P0 admin modules.
