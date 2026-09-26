# Soul_Screen_List_User_Flow_Data_List_MVP_v1.0

Source: `Soul_Screen_List_User_Flow_Data_List_MVP_v1.0.docx`

SOUL

Screen List · User Flow · Data List

MVP v1.0 — UX / BA / Development Specification

| Product | Soul |
| --- | --- |
| Scope | Mobile-first MVP |
| Primary outputs | Screen inventory, user flows, backend data entities |
| Navigation | Today · Vision · Journal · Me |

## 1. Document Purpose

Tài liệu này chuyển Product Specification của Soul thành lớp triển khai cụ thể cho UX/UI, BA và Development. Trọng tâm là xác định đầy đủ các screen/state cần có, luồng người dùng cốt lõi và cấu trúc dữ liệu cần thiết để triển khai MVP.

- Guided-first: người dùng được dẫn từng bước, tránh blank canvas.
- Daily ritual là core loop; reminder là một phần của product logic chứ không chỉ utility.
- Vision Board dùng template/form có sẵn.
- Vision Session chỉ sử dụng audio Soul sở hữu hoặc có license.
- YouTube/Spotify nằm trong Soul Library như curated external content.
- Multilingual được thiết kế từ data layer ngay từ đầu.
## 2. Screen List

| ID | Module | Screen | Primary purpose |
| --- | --- | --- | --- |
| OB-01 | Onboarding | Splash | Logo Soul + app loading |
| OB-02 | Onboarding | Welcome | Giới thiệu giá trị cốt lõi |
| OB-03 | Onboarding | Intention Selection | Chọn lý do sử dụng Soul |
| OB-04 | Onboarding | Life Area Selection | Chọn lĩnh vực muốn tập trung |
| OB-05 | Onboarding | Morning Reminder | Chọn giờ thực hành buổi sáng |
| OB-06 | Onboarding | Evening Reminder | Chọn giờ reflection buổi tối |
| OB-07 | Onboarding | Language Setup | App + affirmation/audio language |
| OB-08 | Onboarding | Journey Ready | Xác nhận bắt đầu hành trình 28 ngày |
| AU-01 | Account | Sign Up / Login | Đăng ký, đăng nhập |
| AU-02 | Account | Forgot Password | Khôi phục mật khẩu |
| HM-01 | Today | Home / Today | Màn hình trung tâm mỗi ngày |
| HM-02 | Today | Mood Check-in | Ghi nhận cảm xúc |
| JR-01 | Journey | Journey Overview | Tổng quan 28 ngày và tiến độ |
| JR-02 | Journey | Day Introduction | Giới thiệu chủ đề trong ngày |
| JR-03 | Journey | Daily Practice | Thực hiện bài tập có hướng dẫn |
| JR-04 | Journey | Gratitude Form | Form biết ơn dạng guided |
| JR-05 | Journey | Reflection | Reflection cuối bài |
| JR-06 | Journey | Daily Intention | Small action / intention |
| JR-07 | Journey | Day Completed | Xác nhận hoàn thành + progress |
| JR-08 | Journey | Journey Completed | Hoàn thành 28 ngày |
| JR-09 | Journey | Restart Journey | Bắt đầu vòng lặp mới |
| VS-01 | Vision | Vision Board | Danh sách vision cá nhân |
| VS-02 | Vision | Select Life Area | Chọn category |
| VS-03 | Vision | Guided Vision Questions | Điền form theo template |
| VS-04 | Vision | Desired Feelings | Chọn cảm xúc mong muốn |
| VS-05 | Vision | Vision Statement | Statement Soul đề xuất |
| VS-06 | Vision | Vision Image | Upload/chọn hình ảnh |
| VS-07 | Vision | Vision Sound | Chọn native/licensed sound |
| VS-08 | Vision | Vision Preview | Preview trước khi lưu |
| VS-09 | Vision | Vision Detail | Xem/chỉnh sửa vision |
| SS-01 | Session | Vision Session Setup | Chọn vision + thời lượng |
| SS-02 | Session | Vision Session Player | Ảnh + affirmation + audio |
| SS-03 | Session | Session Reflection | Small action sau session |
| SS-04 | Session | Session Complete | Hoàn tất session |
| SL-01 | Soul Library | Library Home | Explore nội dung curated |
| SL-02 | Soul Library | Category Listing | Browse theo topic/mood |
| SL-03 | Soul Library | Content Detail | Chi tiết content |
| SL-04 | Soul Library | Native Audio Player | Phát Soul/licensed audio |
| SL-05 | Soul Library | External Content | YouTube/Spotify deep link/embed |
| JN-01 | Journal | Journal Home | Tổng hợp journal |
| JN-02 | Journal | Daily Gratitude History | Lịch sử biết ơn |
| JN-03 | Journal | Reflection History | Reflection theo ngày |
| FL-01 | Future Letter | Future Letter List | Danh sách thư tương lai |
| FL-02 | Future Letter | Create Letter | Viết thư |
| FL-03 | Future Letter | Select Open Date | Chọn ngày mở |
| FL-04 | Future Letter | Seal Letter | Animation đóng thư |
| FL-05 | Future Letter | Locked Letter Detail | Trạng thái thư chưa mở |
| FL-06 | Future Letter | Open Letter | Đọc thư đến hạn |
| FL-07 | Future Letter | Reply to Past Self | Reflection sau khi đọc |
| NT-01 | Notifications | Notification Permission | Xin quyền push |
| NT-02 | Notifications | Reminder Settings | Quản lý reminder |
| PR-01 | Profile | Me | Profile + stats |
| PR-02 | Profile | Journey History | Lịch sử journey |
| PR-03 | Profile | Language Settings | Cài ngôn ngữ |
| PR-04 | Profile | Audio Settings | Audio/voice preferences |
| PR-05 | Profile | Privacy | Quyền riêng tư và dữ liệu |
| PR-06 | Profile | Subscription | Soul+ / monetization |
| SYS-01 | System | Empty State | Không có dữ liệu |
| SYS-02 | System | Offline / Error | Lỗi mạng/hệ thống |
| SYS-03 | System | Permission Error | Notification/photo permission |
| SYS-04 | System | Delete Confirmation | Xác nhận xóa dữ liệu |

### 2.1. Design Priority

| Priority | Scope |
| --- | --- |
| P0 | Onboarding → Today → Journey → Vision Builder → Vision Session → Reminder |
| P1 | Journal → Future Letter → Soul Library |
| P2 | Profile, history, settings, empty/error states |

## 3. Navigation Model

Bottom navigation của MVP gồm bốn tab chính:

| Today \| Vision \| Journal \| Me |
| --- |

Soul Library chưa cần là tab thứ 5 ở MVP. Người dùng có thể truy cập Library từ Today recommendation, Vision Sound, Journal recommendation hoặc mục Explore trong Me. Nếu content library trở thành một hành vi sử dụng lớn ở phase sau, có thể nâng lên navigation riêng.

## 4. Master User Flow

| Open Soul<br>├── First-time User<br>│ └── Welcome → Intention → Life Areas → Reminder Setup → Language → Journey Ready → Day 1<br>└── Returning User<br> └── Today → Journey / Vision / Journal → Practice / Session / Reflection → Complete → Reminder next day |
| --- |

## 5. Onboarding Flow

| Splash → Welcome → What brings you to Soul? → Select focus areas → Choose morning practice time → Choose evening reflection time → Select language → Request notification permission → 28-Day Journey Ready → Start Day 1 |
| --- |

## 6. Daily Journey Flow

| Push Reminder → Open App → Today → Day X/28 → Continue Practice → Day Introduction → Guided Step 1 → Guided Step 2 → Guided Step N → Mood / Reflection → Today's Small Action → Complete Practice → Update Progress → Return Today |
| --- |

## 7. Gratitude Practice Flow

| Start → Soul explains practice → “I'm grateful for...” → “Because...” → Add → Next item → Required count reached → Review gratitude list → Complete |
| --- |

## 8. Missed Day Flow

| User misses a day → Next app open → “Your journey is still here.” → Continue from unfinished day<br>Rule: không reset Journey trừ khi user chủ động chọn Restart. |
| --- |

## 9. Journey Completion Flow

| Complete Day 28 → Journey Celebration → Summary → Reflection → Start New Journey / Return Home |
| --- |

## 10. Vision Board Creation Flow

| Vision Board → + Create Vision → Choose Life Area → Guided Questions → Select Desired Feelings → Soul Generates Vision Statement → Use / Edit → Choose Image → Choose Sound → Preview Vision → Save |
| --- |

## 11. Vision Editing Flow

| Vision Detail → Edit → Goal / Statement / Feelings / Image / Sound / Affirmations → Save |
| --- |

## 12. Vision Session Flow

| Vision Board → Start Vision Session → Session Setup → All / Selected Visions → Select Duration → Breathing Intro → Vision 1 → Vision 2 → Vision N → Today's Small Action → Session Complete |
| --- |

## 13. Soul Library Flow

| Explore → Choose topic → Content Listing → Content Detail → Resolve source<br>SOUL / LICENSED → Native player<br>YOUTUBE → Watch on YouTube / official embed<br>SPOTIFY → Listen on Spotify |
| --- |

## 14. Future Letter Flow

| Journal → Letters to Future Me → Write a Letter → Optional image / voice / linked Vision → Select Open Date → Preview → Seal → Locked<br>On open date: Push → Open Letter → Read → Mood → Reply to Past Self → Save Reflection |
| --- |

## 15. Reminder Runtime Flow

| Reminder Engine → Get current Journey Day → Get incomplete task → Get user locale → Get notification template → Schedule push<br>If target task is already completed → cancel/skip related reminder. |
| --- |

## 16. Core UX & Business Rules

| Area | Rule |
| --- | --- |
| Journey | Một Journey Day chỉ complete khi tất cả required tasks của ngày hoàn tất. |
| Missed day | Không reset streak/journey theo hướng gây áp lực; user tiếp tục đúng ngày chưa hoàn thành. |
| Vision Builder | Không dùng blank canvas làm entry point; luôn dẫn bằng category, question, option và statement suggestion. |
| Vision Session | Chỉ dùng audio Soul Original hoặc Licensed. |
| Third-party media | YouTube/Spotify được lưu dưới dạng metadata + external link/embed; không re-host file. |
| Notifications | Nếu task đã complete thì không gửi reminder cho task đó. |
| Language | UI, content và audio language tách preference riêng. |
| Offline | Không được mất dữ liệu form đã nhập; draft local rồi sync khi online. |
| Privacy | Journal, Future Letter và Vision mặc định private. |
| Content | Text journey được quản trị từ CMS, không hard-code trong app. |

## 17. Data List / Data Dictionary

Thiết kế dữ liệu ưu tiên PostgreSQL/Supabase-style relational schema. Các field nội dung hiển thị đa ngôn ngữ không hard-code theo cột _vi/_en; nội dung được ánh xạ qua translation layer.

### users

Thông tin tài khoản người dùng

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| email | varchar | nullable nếu guest |
| display_name | varchar |  |
| avatar_url | text |  |
| locale | varchar | vi/en |
| timezone | varchar | IANA timezone |
| onboarding_completed | boolean |  |
| created_at | timestamp |  |
| updated_at | timestamp |  |

### user_preferences

Thiết lập cá nhân và reminder

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID | FK users |
| app_language | varchar |  |
| affirmation_language | varchar |  |
| audio_language | varchar |  |
| morning_reminder_enabled | boolean |  |
| morning_reminder_time | time |  |
| daytime_reminder_enabled | boolean |  |
| daytime_reminder_time | time |  |
| evening_reminder_enabled | boolean |  |
| evening_reminder_time | time |  |
| notification_enabled | boolean |  |
| sound_enabled | boolean |  |
| haptic_enabled | boolean |  |

### life_areas

Danh mục mục tiêu/khía cạnh cuộc sống

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| code | varchar | LOVE, CAREER, MONEY... |
| icon | varchar |  |
| sort_order | integer |  |
| is_active | boolean |  |

### user_focus_areas

Mapping user ↔ life area

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID | FK users |
| life_area_id | UUID | FK life_areas |
| priority | integer |  |

### journeys

Master program

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| code | varchar | e.g. SOUL_28_GRATITUDE |
| total_days | integer |  |
| version | integer |  |
| status | enum |  |
| repeatable | boolean |  |
| created_at | timestamp |  |

### journey_days

Ngày trong program

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| journey_id | UUID | FK journeys |
| day_number | integer |  |
| estimated_minutes | integer |  |
| theme | varchar |  |
| sort_order | integer |  |

### journey_tasks

Task cấu hình theo ngày

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| journey_day_id | UUID | FK journey_days |
| task_type | enum | INFO, GRATITUDE, TEXT_INPUT, MULTI_INPUT, MOOD, INTENTION, CHECKLIST, REFLECTION, VISION, AUDIO, EXTERNAL_ACTION |
| period | enum | MORNING, DAYTIME, EVENING, ANYTIME |
| required | boolean |  |
| sort_order | integer |  |
| config_json | jsonb | dynamic form config |

### user_journeys

Instance Journey của user

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| journey_id | UUID |  |
| current_day | integer |  |
| started_at | timestamp |  |
| last_activity_at | timestamp |  |
| completed_at | timestamp | nullable |
| status | enum | ACTIVE, PAUSED, COMPLETED, ABANDONED |
| iteration | integer | vòng lặp số mấy |

### user_journey_tasks

Kết quả task của user

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_journey_id | UUID |  |
| journey_task_id | UUID |  |
| status | enum |  |
| response_json | jsonb |  |
| started_at | timestamp |  |
| completed_at | timestamp |  |

### gratitude_entries

Dữ liệu gratitude core

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| user_journey_id | UUID | nullable |
| journey_day | integer | nullable |
| gratitude_text | text |  |
| reason_text | text |  |
| created_at | timestamp |  |

### mood_entries

Mood check-in

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| mood_score | smallint |  |
| mood_label | varchar |  |
| source | enum | TODAY, JOURNEY, VISION_SESSION, FUTURE_LETTER |
| note | text |  |
| created_at | timestamp |  |

### visions

Vision cá nhân

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| life_area_id | UUID |  |
| title | varchar |  |
| goal_text | text |  |
| statement | text |  |
| image_url | text |  |
| sound_resource_id | UUID | nullable |
| status | enum |  |
| created_at | timestamp |  |
| updated_at | timestamp |  |

### feelings

Dictionary cảm xúc

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| code | varchar | FREE, SECURE, LOVED, CALM... |
| sort_order | integer |  |
| is_active | boolean |  |

### vision_feelings

Mapping Vision ↔ feeling

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| vision_id | UUID |  |
| feeling_id | UUID |  |

### vision_templates

Template Vision theo life area

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| life_area_id | UUID |  |
| sort_order | integer |  |
| status | enum |  |

### vision_questions

Câu hỏi trong builder

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| vision_template_id | UUID |  |
| question_type | enum |  |
| required | boolean |  |
| sort_order | integer |  |
| config_json | jsonb |  |

### vision_answers

Suggested answers

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| question_id | UUID |  |
| code | varchar |  |
| sort_order | integer |  |

### affirmations

Kho affirmation

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| life_area_id | UUID | nullable |
| mood_tag | varchar |  |
| content_key | varchar | translation key |
| status | enum |  |

### vision_sessions

Session visualization

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| duration_seconds | integer |  |
| sound_resource_id | UUID |  |
| started_at | timestamp |  |
| completed_at | timestamp |  |
| action_text | text |  |

### vision_session_items

Danh sách vision trong session

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| session_id | UUID |  |
| vision_id | UUID |  |
| sequence | integer |  |
| duration_seconds | integer |  |

### content_resources

Soul Library unified content

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| content_type | enum | AUDIO, PODCAST, VIDEO, ARTICLE, GUIDED_PRACTICE |
| source | enum | SOUL, YOUTUBE, SPOTIFY, EXTERNAL |
| ownership_type | enum | OWNED, LICENSED, EXTERNAL_LINK |
| external_url | text | nullable |
| embed_url | text | nullable |
| media_url | text | native/owned only |
| thumbnail_url | text |  |
| creator_name | varchar |  |
| language | varchar |  |
| duration_seconds | integer |  |
| is_embeddable | boolean |  |
| is_premium | boolean |  |
| status | enum |  |
| license_reference | text |  |
| created_at | timestamp |  |

### content_resource_tags

Tag recommendation

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| content_resource_id | UUID |  |
| tag | varchar | calm, confidence, abundance... |

### journal_entries

Journal chung

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| type | enum | FREE, DAILY_REFLECTION, FUTURE_SELF, JOURNEY_REFLECTION |
| title | varchar |  |
| body | text |  |
| mood_score | smallint | nullable |
| related_vision_id | UUID | nullable |
| created_at | timestamp |  |
| updated_at | timestamp |  |

### future_letters

Thư gửi tương lai

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| title | varchar |  |
| body | text |  |
| open_at | timestamp |  |
| status | enum | DRAFT, SEALED, AVAILABLE, OPENED |
| image_url | text | nullable |
| voice_url | text | nullable |
| related_vision_id | UUID | nullable |
| sealed_at | timestamp | nullable |
| opened_at | timestamp | nullable |
| created_at | timestamp |  |

### future_letter_reflections

Phản hồi sau khi mở thư

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| future_letter_id | UUID |  |
| mood_score | smallint |  |
| response_text | text |  |
| created_at | timestamp |  |

### reminders

Reminder runtime

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| user_id | UUID |  |
| type | enum |  |
| scheduled_time | timestamp |  |
| reference_type | varchar |  |
| reference_id | UUID | nullable |
| status | enum |  |
| sent_at | timestamp | nullable |
| opened_at | timestamp | nullable |

### notification_templates

Template notification

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| notification_type | varchar |  |
| content_key_title | varchar |  |
| content_key_body | varchar |  |
| status | enum |  |

### translations

Localization store

| Field | Type | Notes |
| --- | --- | --- |
| id | UUID | PK |
| entity_type | varchar |  |
| entity_id | UUID |  |
| field_name | varchar |  |
| locale | varchar |  |
| value | text |  |

## 18. Analytics Event List

#### Account

signup_completed · login_completed

#### Onboarding

onboarding_started · intention_selected · focus_area_selected · reminder_configured · language_selected · onboarding_completed

#### Journey

journey_started · journey_day_viewed · journey_task_started · journey_task_completed · journey_day_completed · journey_completed · journey_restarted

#### Vision

vision_creation_started · vision_category_selected · vision_created · vision_edited · vision_deleted

#### Session

vision_session_started · vision_session_completed · vision_session_abandoned

#### Content

content_viewed · native_audio_started · native_audio_completed · external_content_clicked

#### Journal

journal_created · reflection_created

#### Future Letter

future_letter_created · future_letter_sealed · future_letter_available · future_letter_opened · future_letter_replied

#### Reminder

notification_sent · notification_opened · notification_dismissed

## 19. CMS Data Scope

| Module | Admin-managed data |
| --- | --- |
| Journey Management | Journey, Day, Task, Task order, required/optional, reminder rule |
| Vision Management | Life area, question, suggested answer, feeling, affirmation |
| Soul Library | Content, YouTube URL, Spotify URL, creator, thumbnail, tags, language, ownership/license |
| Translation | Vietnamese, English và future locales |
| Notification | Notification template, locale, timing type |

## 20. Recommended Entity Relationship

| User<br>├── UserPreference<br>├── UserFocusArea<br>├── UserJourney<br>│ └── UserJourneyTask<br>├── GratitudeEntry<br>├── MoodEntry<br>├── Vision<br>│ ├── VisionFeeling<br>│ └── VisionSessionItem<br>├── VisionSession<br>├── JournalEntry<br>├── FutureLetter<br>│ └── FutureLetterReflection<br>└── Reminder<br><br>Content side<br>Journey → JourneyDay → JourneyTask<br>LifeArea → VisionTemplate → VisionQuestion → VisionAnswer<br>ContentResource → ContentResourceTags<br>Translation → localized entity fields |
| --- |

## 21. Recommended Design Sequence

| Flow | Sequence | Outcome |
| --- | --- | --- |
| Flow 01 — First Session | Onboarding → Day 1 → Complete Practice → Today | Validate activation |
| Flow 02 — Returning Daily User | Notification → Today → Practice → Completion | Validate daily loop |
| Flow 03 — Build My Dream | Vision → Guided Builder → Vision Card → Vision Session | Validate differentiation |
| Flow 04 — Future Emotional Loop | Journal → Future Letter → Seal → Reminder → Open | Validate long-term attachment |

## 22. UI Production Scope

Screen inventory có khoảng 50+ screen/state, nhưng designer không cần tạo 50 layout độc lập. Sau khi component hóa, MVP có thể quy về khoảng 20–25 layout chính; phần còn lại là state, variant hoặc modal của cùng component.

- Ưu tiên component hóa: header, progress, guided question, input card, mood selector, content card, vision card, reminder time picker, audio player, modal confirmation.
- Mỗi screen trong bước wireframe tiếp theo nên có: Screen ID → component → content → CTA → interaction → validation → empty/error state → tracking event.
- Journey forms và Vision Builder cần dùng schema-driven UI để CMS có thể thay đổi content mà không cần release app.
