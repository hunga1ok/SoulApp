# Soul mobile product specification

## 1. Product intent

Soul is a private, bilingual wellbeing application that helps a user practice gratitude, shape personal visions, listen to suitable soundscapes, and revisit meaningful notes. The experience should feel calm, warm, personal, and low-pressure.

## 2. MVP platforms and languages

- Flutter mobile app for iOS and Android, app-only: no backend, no account; all user data stays on the device (decision 2026-09-26, see `requirements.md` §0). Cross-device sync is deferred.
- Vietnamese (`vi`) and English (`en`) at launch.
- Device locale suggests the initial language. The user explicitly confirms it.
- Language can be changed later from profile settings.

## 3. Primary navigation

Five bottom tabs:

1. Today
2. Soul Cards (Rút thẻ thông điệp)
3. Vision
4. Journal
5. Explore

Profile and settings open from the avatar in the app header. Global sound can be toggled beside the avatar.

## 4. Onboarding

### Flow

1. Language-neutral locale chooser: `Tiếng Việt` or `English` (endonyms; the device-suggested language is highlighted, and the user's tap confirms).
2. Preferred name: “Soul should call you…”.
3. Primary intention for using Soul.
4. Morning and evening reminder preferences.
5. Journey-ready confirmation.
6. Enter Today.

Google sign-in is deferred until cross-device sync returns.

### Acceptance criteria

- No Vietnamese or English sentence appears before language choice.
- Returning users skip completed onboarding.
- Preferred name is required, trimmed, limited to 40 characters, editable later, and used in greetings.

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

## 6. Soul Cards (Rút thẻ thông điệp)

- Dedicated tab in the primary navigation.
- 3 decks:
  1. Sự nghiệp & Phát triển (`career`)
  2. Chữa lành & Bình an (`healing`)
  3. Tình yêu & Mối quan hệ (`relationship`)
- 150 card assets (50 cards per deck) optimized in WebP format.
- Bilingual messages (Vietnamese and English) matching the user's active app locale.
- Interactive 3D flip card animation upon drawing.
- Daily draw policy: maximum 2 draws per calendar day across decks; drawing a 3rd time displays an alert dialog reminding the user to reflect on drawn messages.
- Deck Hub displays visual deck cards with illustration art, card count, and draw CTA.

## 7. Vision Board

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

- **Authentic Collage Board**: Visions display in an artistic 2-column masonry / staggered collage grid, resembling a real-world moodboard / pinboard with washi tape accents and soft paper shadows.
- **Text on Background**: Visions without user photos have their statement printed directly on the category's signature gradient canvas (with category badge, watermark icon, translucent feeling chips, and audio pill) instead of separated white boxes.
- **Polaroid Photo Cards**: Visions with photos are framed as clean polaroid-style cards with photo, caption, feelings, and soundtrack.
- **Layout Switcher**: Users can toggle between the 2-column Collage Board (default) and single-column List View.
- Tapping a Vision opens its statement, feelings, image, and assigned playlist.
- Vision goal/statement, feelings, and image can be edited; changing category reassigns its playlist.
- Archive is a soft delete and does not delete linked historical entries.
- Back navigation reliably returns to the board.

## 8. Vision Session

- Guided three-to-five-minute session for the current, selected, or all active Visions.
- Sequence: arrival, Vision image and statement/affirmation, one small action, completion.
- Play, pause, progress, and safe interruption behavior.
- Only Soul-owned or separately licensed audio plays natively.
- The app remembers global sound preference but does not autoplay spoken audio unexpectedly.

## 9. Journal

- **Streamlined Writing Flow**: Clean, open paper surface for freeform journaling. Users write their authentic thoughts directly on the page without restrictive multi-step form fields.
- **Collapsible Daily Guidance**: Guided 28-day itinerary prompt collapses cleanly into a subtle dropdown header, giving maximum visual priority to the journal paper.
- **Theme Dropdown & Tools**: Theme selection is integrated as a compact dropdown alongside "Insert template" and "Add photo" actions directly on the paper canvas.
- **Minimalist Aesthetic**: Eliminates nested rounded boxes, card outlines around text, and redundant labels like "Note content".
- **Note Editing & Management**: Past notes can be viewed, edited (updating text and images), or safely deleted.
- Notes are private and stored on the device; they work fully offline. Sync is deferred.

### Future Letter

- Users can write and seal a private letter that unlocks in one, three, six, or twelve months, or on a valid custom future date.
- An optional image, voice note, or linked Vision may be attached when supported.
- Before unlock, the list shows only a sealed-envelope state and date; notification previews never expose letter text.
- After unlock, users may record an optional mood and response to their past self.

## 10. Explore

- Curated content filtered by locale and editorial status.
- External YouTube and Spotify items open via official deep links or supported embeds.
- External media is never downloaded, rehosted, or presented as a native Soul soundtrack without a separate license.

## 11. Profile and settings

- Preferred name.
- Language.
- Global audio toggle.
- Reminder times and permission status.
- Journey, Vision, and journal counts.
- Delete all local data (sign-out and account deletion are deferred with sync).

## 12. Notifications

- Morning ritual, daily task, evening reflection, Vision Session, Future Letter, and gentle journey-return reminders.
- Each category can be disabled independently where practical.
- Completed tasks do not receive duplicate reminders.
- Tapping a notification opens the relevant guarded app destination.
- Copy is localized and avoids guilt, fear, loss, and private journal/letter text.

## 13. Administration

Deferred for the app-only MVP: content is authored in `Specs/` and shipped as a versioned content bundle inside the app, so content changes need an app release. A focused admin application returns together with a backend.

## 14. Analytics

When consent and privacy policy permit, emit versioned funnel events for onboarding, journey tasks, Visions, Vision Sessions, content opens, native audio, Future Letters, and notifications. Analytics payloads never contain free-form private content.

## 15. Privacy and safety

- Vision images, journal entries, responses, and progress are user-owned private data.
- Do not make medical, therapeutic, scientific-frequency, financial-outcome, or manifestation-guarantee claims.
- Store only the user data required for the documented experience.

## 16. MVP exclusions

- AI image generation.
- Social feed, sharing, comments, or public profiles.
- User-selected Vision soundtrack catalogs.
- In-app subscription and payment.
- Backend, account, cross-device sync, and Admin CMS (deferred, not excluded permanently).
