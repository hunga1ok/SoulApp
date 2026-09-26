# Soul_Feature_Specification_MVP_v1.0

Source: `Soul_Feature_Specification_MVP_v1.0.docx`

SOUL

Feature Specification & MVP Implementation Document

Guided Gratitude • Manifestation • Vision • Reflection

| Document version | 1.0 |
| --- | --- |
| Product stage | MVP |
| Primary platforms | iOS / Android, mobile-first |
| Initial languages | Vietnamese / English |
| Document purpose | Product, UX/UI, content, backend and QA implementation specification |
| Updated | 24 September 2026 |

## 1. Product Definition

Soul is a guided personal ritual app that helps users practice gratitude, create and revisit life visions, reflect through journaling, and communicate with their future selves. The product is designed around ready-made formats, guided steps, curated content, reminders and repeatable daily rituals rather than open-ended blank canvases.

| Core proposition Users do not need to know how to practice gratitude, build a vision board, write an affirmation or choose the right audio. Soul prepares the structure and guides them through it: Select → Fill → Follow. |
| --- |

### 1.1 Product objectives

- Make gratitude and manifestation practices easy to start and repeat.
- Reduce cognitive effort by providing templates, examples, prompts and structured flows.
- Build a consistent daily practice through reminders and a 28-day journey.
- Create emotional attachment through Vision Sessions, journal history and Future Letters.
- Support localization from the first release rather than retrofitting translation later.
- Avoid unnecessary copyright risk by clearly separating Soul-owned/licensed media from external curated content.
### 1.2 Non-goals for MVP

- Social feed or community features.
- AI therapist or medical/clinical mental-health treatment claims.
- Public profiles, follower systems or leaderboards.
- Building a general music streaming product.
- Re-hosting, downloading or extracting third-party YouTube/Spotify media.
- Complex AI-generated journeys before the base program and retention loop are validated.
## 2. Information Architecture

| Primary tab | Purpose | Main actions |
| --- | --- | --- |
| Today | Daily practice hub | Continue journey, check mood, complete tasks, open recommended vision |
| Vision | Guided vision building | Create/edit vision, browse board, start Vision Session |
| Journal | Reflection archive | Review gratitude entries, reflections, Future Me and Future Letters |
| Explore | Curated Soul Library | Browse Soul audio, guided content, YouTube/Spotify recommendations |
| Me | Preferences and progress | Reminder settings, language, streak, account and privacy |

| Navigation note If 5 bottom tabs feel too dense in design testing, “Explore” can sit inside Vision/Journal or under a Home secondary entry. The data model should still treat Soul Library as a standalone content module. |
| --- |

## 3. Onboarding Specification

| Step | Screen | Required data | Primary CTA |
| --- | --- | --- | --- |
| 1 | Welcome | None | Begin |
| 2 | User intention | One or more intentions | Continue |
| 3 | Life focus areas | One or more focus areas | Continue |
| 4 | Morning reminder | Time or skip | Continue |
| 5 | Evening reminder | Time or skip | Continue |
| 6 | Language | App language; optional affirmation/audio preference | Continue |
| 7 | Journey ready | Create initial UserJourney | Start Day 1 |

### 3.1 Suggested intention options

- Practice gratitude
- Manifest my goals
- Feel calmer and more grounded
- Build a positive daily ritual
- Understand myself better
- Reconnect with what matters to me
### 3.2 Acceptance criteria

- User can complete onboarding without enabling notifications.
- Selected timezone is device-derived and stored with user preferences.
- Language selection affects UI and content independently when supported.
- Finishing onboarding creates an active 28-day journey at Day 1.
- Returning users do not see onboarding again unless they reset preferences/account.
## 4. Feature: 28-Day Guided Gratitude Journey

The 28-day journey is the primary habit and retention engine. The editorial framework may be inspired by gratitude practices associated with The Magic, but Soul must use its own original wording, UX structure, examples and instructional content unless appropriate rights are obtained.

### 4.1 Day structure

| Block | Description | Typical input |
| --- | --- | --- |
| Introduction | Day title, short context, expected duration | None |
| Morning gratitude | Structured gratitude exercise | Repeated gratitude items + reason |
| Specific daily practice | Unique practice for the day | Checklist, short answer, selection or action |
| Daytime reminder | Contextual nudge | Notification only |
| Evening reflection | Best moment / gratitude close | Short text + optional mood |
| Completion | Progress update | Automatic after required tasks |

### 4.2 Practice form rule

Avoid single blank text areas unless the activity genuinely requires free writing. Prefer decomposed prompts. Example:

I am grateful for: [________________]
Because: [________________]

Add another +

### 4.3 Journey state

UserJourney
- id
- user_id
- journey_id
- current_day
- started_at
- completed_at
- status: ACTIVE | PAUSED | COMPLETED
- cycle_number

### 4.4 Missed-day behavior

- Do not reset the user to Day 1 automatically.
- Do not use guilt-based copy such as “You broke your streak.”
- When the user returns, offer “Continue Day X” as the primary action.
- Allow optional catch-up but do not require completing multiple days in one session.
## 5. Feature: Today

| Section | Behavior |
| --- | --- |
| Greeting | Localized greeting based on local time |
| Journey progress | Day X of 28 and completion state |
| Current task | Primary CTA resumes first incomplete required task |
| Mood check-in | Optional quick mood selector |
| Vision of the day | One relevant vision card if user has visions |
| Tonight | Shows evening practice before completion window |

### 5.1 Core user stories

- As a user, I can see exactly what I need to do today without planning it myself.
- As a user, I can resume the current task from where I stopped.
- As a user, I can complete morning and evening components independently.
- As a user, I can see progress without being pressured by productivity-style metrics.
## 6. Feature: Guided Vision Board

The Vision Board solves a “blank canvas” problem. Soul should guide the user through category selection, structured questions, desired emotions, a vision statement, visuals and a compatible native Soul sound.

### 6.1 Vision builder flow

| Step | Specification |
| --- | --- |
| 1. Life area | Love, Money, Career, Home, Travel, Health, Family, Personal Growth, Inner Peace |
| 2. Guided template | Predefined statements and fill-in fields; allow custom option |
| 3. Desired feelings | Select up to 3 emotional outcomes |
| 4. Vision statement | Soul proposes editable statement from selections |
| 5. Visual | Upload user image or choose from licensed/Soul image library |
| 6. Sound | Recommend only Soul-owned or appropriately licensed native audio |
| 7. Save | Create Vision card and add to board |

### 6.2 Vision object

Vision
- id
- user_id
- category_id
- title
- goal_data_json
- statement
- desired_feelings[]
- image_source
- image_url
- native_audio_id (nullable)
- created_at
- updated_at
- archived_at (nullable)

### 6.3 Acceptance criteria

- User can create a complete vision without writing a long free-form statement.
- All template content is localized.
- User may edit the generated statement before saving.
- External YouTube/Spotify items are never selectable as Vision Session soundtrack.
- Deleting a vision does not delete linked historical journal entries; use archive/soft delete where appropriate.
## 7. Feature: Vision Session

A Vision Session is a guided 3–5 minute native ritual combining the user’s saved vision images, Soul-owned/licensed audio, affirmation text and gentle transitions.

| Phase | Approx. timing | Content |
| --- | --- | --- |
| Arrival | 0:00–0:30 | Breathing / settle in |
| Vision 1 | 0:30–1:15 | Image + statement/affirmation |
| Vision 2 | 1:15–2:00 | Image + statement/affirmation |
| Vision 3 | 2:00–2:45 | Image + statement/affirmation |
| Action | Final 30–45 sec | One small action for today |
| Complete | End | Save session completion |

| Media rule Only media owned by Soul or licensed for this specific in-app use may be synchronized with Vision Session visuals. Spotify content must not be used as a soundtrack to a slideshow/visual session under its current developer policy restrictions. |
| --- |

## 8. Feature: Soul Library / Explore

Soul Library is a curated content layer for users who want additional support beyond the daily ritual. It combines Soul-native audio with external recommendations such as YouTube videos and Spotify podcast/music links while keeping ownership and playback behavior explicit.

### 8.1 Content types

| Type | Source | Playback behavior | MVP use |
| --- | --- | --- | --- |
| Soul Sound | SOUL / LICENSED | Native in-app playback | Vision Session, ritual, Explore |
| Guided Audio | SOUL / LICENSED | Native in-app playback | Breathing, gratitude, reflection |
| YouTube Video | YOUTUBE | Official embed or open original platform | Meditation, mindset, educational recommendation |
| Spotify Podcast | SPOTIFY | Deep link / permitted embed | Mindset or reflection recommendation |
| Spotify Music/Playlist | SPOTIFY | Deep link / permitted embed; not Vision soundtrack | Discovery / optional listening |
| Article / Practice | SOUL / EXTERNAL | In-app content or outbound link | Further learning |

### 8.2 Curated recommendation placement

- After completing a daily practice: “Want to go deeper?”
- Inside Explore by topic, mood or life area.
- After a Vision Session as optional supplementary content.
- Inside a Vision detail page as “Recommended for this intention” — external content remains separate from the native session.
### 8.3 External media policy requirements

- Do not download, import, cache, store or create offline copies of YouTube audiovisual content without required permission.
- Use YouTube’s official player/embed behavior when embedding and preserve required platform functionality/branding.
- Do not extract YouTube audio into Soul audio files.
- Do not use Spotify content as synchronized audio for Vision slideshows, video-like sequences or similar visual media.
- Do not rely on Spotify as the commercial native streaming engine for Soul without separate policy/legal review and any necessary approval.
- Prefer outbound deep links or official embeds for third-party content.
- Store metadata and link references, not third-party media files, unless Soul has explicit licensing rights.
- Display creator/source attribution clearly.
| Implementation disclaimer Platform policies can change. Treat these requirements as a product guardrail, not final legal advice. Re-check YouTube and Spotify terms before production release or whenever the integration model changes. |
| --- |

### 8.4 Content resource model

ContentResource
- id
- type: AUDIO | PODCAST | VIDEO | GUIDED_PRACTICE | ARTICLE
- source: SOUL | LICENSED | YOUTUBE | SPOTIFY | EXTERNAL
- ownership_type: OWNED | LICENSED | EXTERNAL_LINK
- title
- description
- creator_name
- thumbnail_url
- external_url
- embed_url (nullable)
- native_file_url (nullable; only owned/licensed)
- language
- duration_seconds
- category_id
- mood_tags[]
- vision_tags[]
- is_embeddable
- is_featured
- is_premium
- license_reference (nullable)
- status: DRAFT | PUBLISHED | ARCHIVED
- created_at
- updated_at

## 9. Feature: Journal & Future Letter

| Module | Behavior |
| --- | --- |
| Daily Gratitude | Automatically stores gratitude practice answers by date |
| Reflection | Stores mood and end-of-day reflection |
| Future Me | Guided prompts for future-self visualization |
| Future Letter | Sealed letter scheduled to unlock later |

### 9.1 Future Letter flow

- Choose unlock date: 1 month, 3 months, 6 months, 1 year or custom.
- Write letter; optionally attach image, voice note or linked vision if supported.
- Confirm “Seal letter.”
- Store unlock_at timestamp.
- At unlock time, send notification and show unopened envelope state.
- After opening, optionally ask for mood and response to past self.
## 10. Feature: Reminder & Notification Engine

| Reminder type | Trigger | Example intent |
| --- | --- | --- |
| MORNING_RITUAL | User morning time + active journey | Start today’s practice |
| DAILY_TASK | Configured task schedule | Remember today’s specific practice |
| EVENING_REFLECTION | User evening time | Close the day with reflection |
| VISION_SESSION | User-selected recurring time | Reconnect with saved visions |
| FUTURE_LETTER | unlock_at reached | Open message from past self |
| JOURNEY_RETURN | User inactive for configurable period | Continue without guilt |

### 10.1 Reminder rules

- Respect device timezone and user notification permission.
- Do not send duplicate notifications for already completed tasks.
- If the app is opened from a notification, deep-link directly to the relevant task/resource.
- Copy must be localized.
- Avoid guilt, fear or loss-framed copy.
- User can disable each reminder category independently where practical.
## 11. Multilingual Architecture

Localization must cover interface copy, journey content, vision templates, notification templates and content metadata. Audio language is treated separately because not every audio item will exist in every language.

| Layer | Examples | Locale behavior |
| --- | --- | --- |
| UI | Buttons, menus, settings | App locale |
| Program content | Journey title, instruction, examples | Content locale |
| Vision templates | Questions, options, affirmations | Content locale |
| Notifications | Push title/body | App locale |
| Audio metadata | Title, description | Content locale |
| Guided voice | Spoken content | Audio language preference |

content
- id
- content_type
- content_key

content_translation
- content_id
- locale
- title
- description
- instruction
- example
- status

## 12. Admin CMS Requirements

| CMS module | Admin capabilities |
| --- | --- |
| Journey | Create/edit day, task order, required/optional flag, schedule, translations |
| Vision Templates | Manage categories, guided questions, options and statements |
| Soul Library | Create/edit resources, tags, source, ownership type, links, licenses |
| Notifications | Manage localized templates by trigger |
| Audio | Upload owned/licensed file, artwork, duration and rights metadata |
| Localization | Review translation completeness and publish state |

### 12.1 Rights and source fields

- Every native audio asset requires ownership_type.
- LICENSED media should include license_reference or internal rights record identifier.
- External content requires source + canonical URL + creator/source attribution.
- CMS must prevent EXTERNAL_LINK items from populating native_file_url.
- CMS should warn if a Spotify/YouTube external item is assigned to a Vision Session slot.
## 13. Analytics & Success Metrics

| Metric | Definition / reason |
| --- | --- |
| Activation | Completed onboarding + Day 1 |
| D3 journey continuation | Early habit signal |
| D7 retention | Returns within first week |
| Practice days / WAU | North-star behavioral indicator |
| Day 28 completion | Program completion |
| Vision creation rate | % activated users creating ≥1 vision |
| Vision Session completion | Completed sessions / started sessions |
| External content CTR | Open/deep-link rate for curated resources |
| Future Letter creation/open rate | Long-term emotional feature engagement |

### 13.1 Suggested event taxonomy

onboarding_started
onboarding_completed
journey_started
journey_day_started
journey_task_completed
journey_day_completed
mood_logged
vision_created
vision_updated
vision_session_started
vision_session_completed
content_resource_viewed
external_resource_opened
native_audio_started
native_audio_completed
future_letter_created
future_letter_opened
notification_opened

## 14. Privacy, Safety & Content Guardrails

- Journal and Future Letter content should be private by default.
- Avoid claims that Soul treats, cures or prevents mental-health conditions.
- Avoid claims that manifestation guarantees money, relationships, health outcomes or other life results.
- Use language around reflection, intention, gratitude, visualization and taking small actions.
- Provide clear controls for notification permissions and account deletion.
- Do not expose private journal or letter content in push notification bodies.
## 15. MVP Scope & Priority

| Priority | Capability |
| --- | --- |
| P0 | Authentication / account |
| P0 | Onboarding + preferences |
| P0 | Today screen |
| P0 | 28-day journey engine + content |
| P0 | Reminder engine |
| P0 | Guided Vision Builder + Vision Board |
| P0 | Vision Session with owned/licensed native audio |
| P0 | Journal + Future Letter |
| P0 | Vietnamese + English localization |
| P0 | Admin CMS basics |
| P1 | Soul Library with external YouTube/Spotify recommendations |
| P1 | Basic content tagging/recommendation rules |
| P1 | Analytics dashboard/events |
| P2 | AI affirmation generation |
| P2 | AI personalized journeys |
| P2 | Weekly Soul Reflection |

## 16. Delivery Epics

| Epic | Primary deliverable | Dependencies |
| --- | --- | --- |
| E1 Foundation | Auth, profile, preferences, navigation, localization base | None |
| E2 Journey | 28-day engine, forms, progress, Today | E1 |
| E3 Notifications | Reminder scheduling + deep links | E1, E2 |
| E4 Vision | Vision templates, builder, board | E1 |
| E5 Native Audio | Audio catalog/player + rights metadata | E1 |
| E6 Vision Session | Guided session renderer using Vision + Native Audio | E4, E5 |
| E7 Journal | Gratitude history, reflection, Future Letter | E1, E2 |
| E8 Soul Library | Curated external/native resources + CMS | E1, E5 |
| E9 CMS | Journey, translation, media, notifications admin | E2–E8 |
| E10 Analytics/QA | Events, instrumentation, release validation | All |

## 17. MVP Release Acceptance Checklist

- New user can complete onboarding and start Day 1 in one session.
- User can complete a full day with morning and evening tasks and see persisted state after app restart.
- Reminders fire at configured local times and open the correct destination.
- User can create a vision using only templates/selections plus minimal text input.
- User can run a Vision Session without any third-party streaming dependency.
- External YouTube/Spotify resources open via approved link/embed behavior and are clearly attributed.
- No external third-party media file is downloaded into Soul storage by the app workflow.
- User can create, seal and later open a Future Letter.
- Vietnamese and English UI/content switch without reinstalling the app.
- CMS can update journey copy, templates, notification copy and library resources without app release.
- Core analytics events are emitted and identifiable by user/session where consent and privacy policy allow.
- Private journal/letter text is not exposed in push notification previews by default.
## 18. Third-Party Platform Policy References

The following references were reviewed when defining the external media guardrails in this specification. They should be re-checked before implementation and release because platform terms can change.

- YouTube API Services — Developer Policies: Includes restrictions on downloading, importing, caching or storing copies of YouTube audiovisual content without prior written approval. https://developers.google.com/youtube/terms/developer-policies
- YouTube API Services — Required Minimum Functionality: Defines requirements relevant to embedded YouTube player behavior. https://developers.google.com/youtube/terms/required-minimum-functionality
- Spotify Developer Policy: Includes restrictions on synchronized use of Spotify sound recordings with visual media and commercial streaming uses. https://developer.spotify.com/policy
- Spotify Widget / Embed Terms: Includes widget usage and synchronization restrictions. https://developer.spotify.com/documentation/embeds/terms
## 19. Product Summary

Soul should feel less like a collection of wellness tools and more like a guided daily ritual system. The product’s differentiation comes from reducing uncertainty: it prepares the practice, the format, the prompt, the reminder and — where Soul has appropriate media rights — the sound. External platforms extend discovery without becoming the core playback engine.

| MVP product statement Soul helps people build a daily ritual of gratitude, visualization and reflection through step-by-step programs, ready-made templates, native sounds, curated recommendations and reminders — so they always know what to do next. |
| --- |
