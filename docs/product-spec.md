# Soul mobile product specification

## 1. Product intent

Soul is a private, bilingual wellbeing application that helps a user practice gratitude, shape personal visions, listen to suitable soundscapes, and revisit meaningful notes. The experience should feel calm, warm, personal, and low-pressure.

## 2. MVP platforms and languages

- Flutter mobile app for iOS, Android, and tablets/iPads (responsive layouts up to wide tablet viewports).
- App-only: no backend, no account; all user data stays on the device (decision 2026-09-26, see `requirements.md` §0). Cross-device sync is deferred.
- Multi-language support: Vietnamese (`vi`), English (`en`), French (`fr`), Japanese (`ja`), Korean (`ko`), and Chinese (`zh`).
- Device locale suggests the initial language on a language-neutral gate screen; user tap confirms it.
- Language can be changed anytime from profile settings.

## 3. Primary navigation

Five bottom tabs:

1. Today
2. Soul Cards (Rút thẻ thông điệp)
3. Vision
4. Journal
5. Explore

### Header controls

The top navigation bar contains:
- Left: Optically aligned horizontal Soul logo.
- Right:
  - **Mood / Theme Indicator**: Shows an emotion icon matching the user's active mood check-in; tapping opens the theme & emotion picker.
  - **Global Sound Toggle**: Enables/disables audio across the app.
  - **Profile Avatar**: Opens Profile, stats, settings, language chooser, and widget configuration.

Comfort Zone (Góc bình yên / Little Corner) is directly accessible from the Today screen with dedicated deep links into 28 sanctuary rooms.

## 4. Onboarding

### Flow

1. Language-neutral locale chooser: `Tiếng Việt` or `English` (device-suggested language is highlighted as primary CTA; user tap confirms and persists).
2. Preferred name: “Soul should call you…”.
3. Primary intention for using Soul.
4. Morning and evening reminder preferences.
5. Journey-ready confirmation.
6. Enter Today.

Google sign-in is deferred until cross-device sync returns.

### Acceptance criteria

- No language-specific sentence appears before language choice.
- Returning users skip completed onboarding.
- Preferred name is required, trimmed, limited to 40 characters, editable later, and used in greetings.

## 5. Today

- Personalized greeting using preferred name.
- Current day in the 28-day gratitude journey with progress ring.
- **Mood Check-in & Dynamic Visual Themes ("Cảm xúc của bạn lúc này")**:
  - Selecting an emotion binds to a tailored visual palette / theme across the app.
  - Next to the speaker button in the header, a mood badge appears with the emotion's icon; tapping it allows the user to switch themes or update their emotion.
  - Once selected for the day, the mood card automatically collapses/hides to keep the screen uncluttered. It automatically resets on the next calendar day, with an option to expand and change anytime.
- **"Today’s Rhythm" (Nhịp hôm nay) optimized order**:
  Arranged deliberately to drive daily engagement, habit formation, and app retention:
  1. **Gratitude Practice of the Day**: Morning arrival, mindful prompt, and core task.
  2. **Home Screen Widget Card**: Prompt to install/check the Living Home Widget to keep gratitude visible on the phone home screen.
  3. **Soul Cards Draw (Rút thẻ thông điệp)**: Direct card draw widget from the active deck.
  4. **Comfort Zone / Little Corner (Góc bình yên)**: Shortcut card to enter relaxation rooms and unwind.
  5. **Small Actions & Reflection**: Daily actionable kindness and evening preview.
- Completing a practice creates or updates the corresponding journey progress and journal data.

### Journey continuity & 28-day loop

- Each day contains an introduction, morning gratitude, a specific daily practice, an optional contextual reminder, evening reflection, and completion.
- Task forms are schema-driven and prefer guided/decomposed prompts over blank canvases.
- Missing a day never resets progress or produces guilt/streak-loss copy. The return action is “Continue Day X”; catch-up is optional.
- **28-Day Cycle Loop**: Completing Day 28 triggers a celebration milestone summary. Upon finishing Day 28, the user can review achievements and choose to loop back to Day 1 to begin a fresh 28-day gratitude journey, retaining all past journal entries and vision boards.

### Audio rule

- Spoken audio matches the active app locale (`vi`, `en`, `ko`, `ja`, `fr`, `zh`). Cross-language spoken playback is never automatically surfaced.
- Language-neutral ambient soundscapes and musical arrangements play across all locales.
- Strict audio authenticity: 100% pre-recorded real-world sounds (gentle rain on window, ocean surf, cozy fireplace, forest birds) and professionally composed royalty-free master tracks (Kevin MacLeod). Zero algorithmic or synthetic noise generators.

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

## 6.1. Comfort Zone / Little Corner (Góc bình yên — Không gian an trú)

A dedicated sanctuary experience designed to bring instant calm, grounding, and peace:

- **28 Curated Mindful Rooms** spanning 5 distinct atmosphere categories:
  1. *Cozy Indoor (Góc nhỏ bình yên)*: Window reading nooks, tea table, fireplace hearth, starry midnight desks.
  2. *Nature Escape (Những nơi muốn trốn đến)*: Wildflower hills, misty pine forests, moonlit lakes, wooden cabins.
  3. *Little Companions (Bình yên bên những người bạn nhỏ)*: Sunlit cats purring, playful puppies welcoming you home, quiet sunset shoulder rests.
  4. *Dreamy Moments (Những khoảnh khắc muốn giữ lại)*: Rainy vintage cafes, night city overlooks, nostalgic train cars.
  5. *Seasonal Sanctuary (Không gian theo mùa)*: Winter hearth & chimes, Autumn Thanksgiving gratitude, Peaceful Tết spring mornings.
- **Interactive Scene Canvas**: Rich dynamic visual artwork adapting to daylight/night transitions with peaceful ambient animations.
- **Center Blur Countdown Timer**:
  - Focus and relaxation countdown timer (e.g. 5, 10, 15, 25, 60 minutes).
  - Floating translucent frosted glass bubble centered directly on screen, displaying high-contrast, crisp white digits without obstructing scene artwork.
- **Atmosphere & Soundscape Controls**:
  - Automatically loads the room's signature soundscape upon entry (when audio is enabled).
  - Audio selector modal lets users swap between all 10 nature ambient beds (`SO-03` to `SO-10`, `SO-24` to `SO-28`) and 13 melodic instruments (`SO-11` to `SO-23`).

## 6.2. Living Home Widget (Widget màn hình chính)

Brings daily gratitude and mindfulness directly to the phone's lock screen and home screen:

- **Live Daily Affirmation & Journey Tracker**: Displays today's gratitude intention, day progress indicator, and active mood reflection.
- **Seamless System Integration**: Syncs with Android AppWidget and iOS WidgetKit via `HomeWidgetService`.
- **In-App Widget Studio**: Preview widget themes (warm paper, deep plum, lilac dawn, soft pearl) and one-tap install guide from Today screen and Profile settings.

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

## 16. Subscription & Pricing Plans Presentation

- Clean, balanced card presentation for subscription tiers (Monthly, Annual, Lifetime).
- Visual alignment: Equal margins, balanced card padding, unified font sizing across localized currencies and labels, eliminating awkward indentation or disproportionately small font scaling.
- Highlight badges (e.g. "Tiết kiệm 30%", "Phổ biến nhất") aligned symmetrically without shifting tier descriptions.

## 17. Tablet & iPad Compatibility

- Adaptive layouts designed for phone (360–430 pt), foldable devices, and iPad/Android tablets (768–1024+ pt).
- Multi-column responsive grids on large screens for Vision Board collage, Comfort Zone Hub, and Explore items.
- Centered readable content width for Journal paper and onboarding forms (max-width constraints preventing excessive line stretching).
- Fully supports landscape orientation and iPad split-screen multitasking.

## 18. MVP exclusions

- AI image generation.
- Social feed, sharing, comments, or public profiles.
- Algorithmic or synthetic audio generation (all sounds are authentic recordings).
- In-app payment processing (mock/presentation preview mode only during MVP; backend processing deferred).
- Backend, account, cross-device sync, and Admin CMS (deferred, not excluded permanently).
