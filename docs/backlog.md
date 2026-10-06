# Soul — Backlog triển khai cuối

> Cập nhật: 2026-09-26
> Phạm vi MVP: Flutter mobile app **app-only**: dữ liệu lưu trên máy, không backend, không đăng nhập (quyết định 2026-09-26, xem `requirements.md` §0). Backend API, PostgreSQL, Object Storage và Admin Portal hoãn tới khi làm sync.
> Nguồn yêu cầu chuẩn: [`requirements.md`](./requirements.md). Các tài liệu gốc đã chuẩn hóa nằm tại [`source-specs/`](./source-specs/).

## 1. Quy ước tracking

### Trạng thái

- `[ ]`: Chưa bắt đầu.
- `[~]`: Đang thực hiện.
- `[x]`: Đã hoàn tất và đạt Definition of Done.
- `[!]`: Bị chặn bởi phụ thuộc hoặc quyết định bên ngoài.
- `[-]`: Hoãn, ngoài phạm vi MVP app-only.

### Mức ưu tiên

- **P0**: Bắt buộc để phát hành MVP.
- **P1**: Mở rộng ngay sau khi luồng lõi ổn định; không chặn bản MVP đầu tiên nếu được Product xác nhận.
- **P2**: Hậu MVP.

### Quy tắc sử dụng backlog

- Prototype HTML/CSS/JS hiện tại là chuẩn UI/UX và tương tác trực quan; `requirements.md` là chuẩn nghiệp vụ.
- Một ticket chỉ được chuyển thành `[x]` khi toàn bộ Acceptance Criteria (AC), kiểm thử và trạng thái lỗi/rỗng/loading liên quan đều đạt.
- Mọi nội dung hiển thị phải có cả `vi` và `en`; không tạo hai cây màn hình riêng cho hai ngôn ngữ.
- App-only: dữ liệu người dùng lưu local (Drift/SQLite + file ảnh + SharedPreferences) theo schema sẵn sàng cho sync (UUID, `created_at`/`updated_at`, archive thay vì xóa cứng). Nội dung là content bundle JSON chỉ đọc.
- Không dùng Supabase. PostgreSQL, Object Storage, xác thực Google và dịch vụ thông báo được cấu hình độc lập.
- Không cho người dùng chọn thủ công sound của Vision. Playlist gồm nhiều sound được hệ thống gán theo `vision_category` và ngôn ngữ.

## 2. Mốc triển khai

| Mốc | Kết quả bắt buộc | Điều kiện hoàn tất |
|---|---|---|
| M0 — Baseline | Prototype, specs, dataset và yêu cầu đã chuẩn hóa | DOC-001 → DOC-003 hoàn tất |
| M1 — App shell | App song ngữ, onboarding, 4 tab, profile qua avatar, content bundle và DB local | Epic 1, 2A, 3 hoàn tất |
| M2 — Daily journey | Dataset 28 ngày, Today, lưu tiến trình, notification | Epic 4–6 hoàn tất |
| M3 — Vision & audio | Tạo Vision, ảnh, playlist theo category, Vision Session | Epic 7–8 hoàn tất |
| M4 — Reflection | Journal, sticky note, Future Letter | Epic 9 hoàn tất |
| M5 — Profile & mở rộng | Profile/settings; Explore và analytics P1 (Admin CMS hoãn) | Epic 10, 12 theo phạm vi release |
| M6 — Release | Security, accessibility, regression, store build | QAR-001 → QAR-009 hoàn tất |

---

## Epic 0 — Tài liệu và quản trị repository

- [x] `DOC-001` **P0 — Kiểm kê và chuẩn hóa tài liệu nguồn**
  - Phạm vi: đọc/render toàn bộ DOCX, đọc toàn bộ XLSX active, chuyển thành Markdown có thể tìm kiếm.
  - Đầu ra: `docs/source-specs/` và `manifest.json`.
  - AC: đủ 3 DOCX và 3 workbook active; tên sheet, bảng và thứ tự nội dung không bị mất.

- [x] `DOC-002` **P0 — Phân tích prototype làm chuẩn UI/UX**
  - Nguồn: `index.html`, `en.html`, `styles.css`, `app.js`, `app-en.js` và thư mục `Logo/`.
  - AC: ghi nhận token, typography, navigation, component, trạng thái tương tác và khác biệt vi/en cần hợp nhất.

- [x] `DOC-003` **P0 — Chuẩn hóa product requirements và quyết định mới nhất**
  - Đầu ra: `requirements.md`, `product-spec.md`, `tech-stack.md`, backlog này.
  - AC: không còn mâu thuẫn về 4 tab, profile qua avatar, luồng ngôn ngữ, preferred name và quy tắc sound theo category.

- [~] `REP-001` **P0 — Hoàn thiện README khởi chạy dự án**
  - AC: có prerequisites, setup mobile/API/admin/database, biến môi trường, migration, seed và lệnh test.
  - Tiến độ 2026-09-26: README mobile/API setup, config boundary và verification commands đã được thay thế; phần Admin/DB migration sẽ bổ sung khi các deployable đó tồn tại.
  - Chuyển app-only 2026-09-26: README chỉ còn setup mobile; không cần API/DB để chạy app.

- [~] `REP-002` **P0 — Chuẩn hóa `.gitignore` và secret policy**
  - AC: không commit secret, signing key, Google config production, file audio có hạn chế bản quyền hoặc dữ liệu người dùng.
  - Tiến độ 2026-09-26: Flutter/API ignore `.env`, signing keys và Google config production; policy cho audio/user data sẽ đi cùng storage pipeline.
  - Tiến độ 2026-09-26 (đợt 1): sửa `.gitignore` của SoulApi để commit các template `.env.*.example` (trước đây bị bỏ qua) trong khi `.env.local` vẫn bị ignore.

- [~] `REP-003` **P0 — Thiết lập CI cơ bản**
  - AC: chạy format, lint, unit test và build check cho Flutter, Backend, Admin trên pull request.
  - Tiến độ 2026-09-26: SoulApp và SoulApi đã tách thành repo riêng (submodule của workspace `Soul`), mỗi repo có `.github/workflows/verify.yml` riêng. SoulApp: format/analyze/test (loại trừ golden)/build web trên Ubuntu + job golden trên macOS. SoulApi: lint, drift check, migrate DB trống + test, build với Postgres service. Workflow chưa chạy thật vì repo chưa push; job Admin chờ `SoulAdmin`.
  - Chuyển app-only 2026-09-26: workflow SoulApi không còn là điều kiện của MVP; job Admin hoãn.


- [x] `REP-004` **P0 — Chốt application identifiers**
  - Phụ thuộc: `EXT-001`.
  - AC: Android application ID và iOS bundle ID thống nhất giữa app, Google OAuth và build pipeline.
  - Hoàn tất 2026-09-26: owner đã chốt `com.manifest.soul`; Android namespace/application ID, iOS/macOS bundle IDs và OAuth redirect examples đã đồng bộ. Google OAuth clients vẫn cần được tạo với identifier này ở `EXT-004`.

- [x] `REP-005` **P0 — Tạo mẫu cấu hình môi trường**
  - AC: có `.env.example` không chứa secret; mô tả rõ biến của API, DB, storage, Google OAuth, notification và analytics.
  - Hoàn tất 2026-09-26: API `.env.example` + staging/production examples và mobile `--dart-define` JSON examples đã được kiểm tra không có secret thật.
  - Chuyển app-only 2026-09-26: đã xóa `config/app.*.json.example` và `AppConfiguration` của mobile vì không còn API/Google config; tạo lại khi có remote content manifest.

- [-] `REP-006` **P0 — Tách môi trường local/staging/production**
  - AC: app không thể vô tình dùng production từ debug build; database/storage namespace tách biệt.
  - Tiến độ 2026-09-26: mobile reject `APP_ENV=production` trong debug/profile và đã có template tách môi trường; DB/storage namespaces chờ hạ tầng `EXT-002`/`EXT-003`.
  - Chuyển app-only 2026-09-26: không còn môi trường server cho MVP; chỉ còn debug và signed release build. Tách DB/storage theo môi trường hoãn cùng backend.

## Epic 1 — Flutter foundation và design system

- [~] `APP-001` **P0 — Bootstrap kiến trúc Flutter theo feature**
  - AC: có lớp `app`, `core`, `features`, `data`, `domain`, `presentation`; dependency chỉ đi theo hướng đã định trong architecture.
  - Tiến độ 2026-09-26: đã dựng `app`, `core` và các feature UI đầu tiên; tiếp tục tách data/domain/presentation khi API repositories được thêm.
  - Tiến độ 2026-09-26 (đợt 2): thêm lớp `lib/data/` (`api/` Dio client + auth interceptor + map error envelope, `local/` credential store trên secure storage, `models/` `Me`/`Session`, `repositories/` auth/profile), `lib/core/errors/` (`ApiException` + map code → copy vi/en) và `lib/core/localization/` (`SoulLocale`); `features/auth/` chứa session controller. Hướng phụ thuộc: widget → controller → repository → API. Chưa tách lớp domain/presentation riêng vì theo `architecture.md` chưa có business logic cần lớp domain.
  - Chuyển app-only 2026-09-26: đã gỡ lớp `lib/data/api`, `lib/data/local/credential_store.dart`, `lib/core/errors`, `lib/core/config` và `features/auth`; lớp `data/` sẽ dựng lại cho Drift + content bundle (`LOC-001..002`).

- [~] `APP-002` **P0 — Thiết lập Riverpod và state conventions**
  - AC: có mẫu AsyncValue/loading/error/retry; không giữ state nghiệp vụ quan trọng trong widget cục bộ.
  - Tiến độ 2026-09-26: Riverpod đã bootstrap `AppState`; chuẩn AsyncValue được thực hiện cùng remote repositories.
  - Tiến độ 2026-09-26 (đợt 2): quy ước đã dùng thật: state phiên là `AsyncNotifier<Me?>` (`SessionController`; loading/error khi khôi phục phiên có màn `SoulLoadingState`/`SoulErrorState` + thử lại), thao tác form là `Notifier<AsyncValue<void>>` autoDispose (`SignInController`, `PreferredNameController`); controller ném `ApiException`, widget map `code` sang thông báo đã bản địa hóa; cập nhật optimistic + hoàn tác cho locale/âm thanh. Tên, locale server và âm thanh không còn nằm trong `AppState`/SharedPreferences (chỉ còn locale cache cho lúc khởi động). Còn lại: áp dụng cùng mẫu cho các màn remote khác khi có API.
  - Chuyển app-only 2026-09-26: `SessionController`/`AsyncNotifier<Me?>` đã bị gỡ; tên, locale và âm thanh quay về `AppState` + SharedPreferences, ghi local không cần optimistic/rollback. Mẫu `AsyncValue` sẽ áp dụng cho repository Drift.

- [~] `APP-003` **P0 — Thiết lập GoRouter và route guards**
  - Liên kết: `US-OB-001..005`, `REQ-UX-003`.
  - AC: guard cho language/auth/onboarding; mỗi tab giữ back stack; back hoạt động đúng ở Vision detail và Journal detail.
  - Tiến độ 2026-09-26: language/auth/name guards và indexed tab shell đã chạy; sẽ bổ sung detail routes khi Vision/Journal có dữ liệu thật.
  - Chuyển app-only 2026-09-26: guard chỉ còn language → preferred name → app; bỏ `/splash` và `/auth`. Router chỉ refresh khi input điều hướng đổi.
  - Tiến độ 2026-09-26 (app-only đợt 1): guard onboarding: ngôn ngữ → tên → ý định → nhắc nhở → sẵn sàng → Today, theo checkpoint lưu local.

- [~] `APP-004` **P0 — Localization vi/en bằng ARB**
  - Liên kết: `REQ-L10N-002`.
  - AC: một widget tree; không hard-code text người dùng; fallback locale an toàn; đổi ngôn ngữ không cần đăng nhập lại.
  - Tiến độ 2026-09-26: ARB vi/en, generated localization và đổi locale local đã hoạt động cho shell.

- [~] `APP-005` **P0 — Implement design tokens theo prototype**
  - Liên kết: `REQ-UX-001`.
  - AC: màu, spacing, radius, shadow và typography bám prototype; serif cho tiêu đề cảm xúc, sans-serif cho control; không dùng màu vàng sticky note cũ.
  - Tiến độ 2026-09-26: màu, spacing, typography, surface và component state nền tảng đã được tạo.
  - Tiến độ 2026-09-26: đã bổ sung token theo `styles.css` (brand system): màu CTA/soft/selected/input/sticky note, `SoulRadius`, `SoulShadows`, `SoulSizes` (touch target tối thiểu 48, nút 52), `SoulTypography` (serif cho tiêu đề cảm xúc, sans-serif cho control); sticky note là giấy trắng ấm kẻ ngang, không vàng, không có đường dọc. Còn lại: chưa bundle font thương hiệu Playfair Display/DM Sans (cần tải asset và kiểm tra license) nên hiện dùng serif/sans-serif hệ thống; nền gradient của hero/onboarding chưa làm; chưa so sánh trực quan trên thiết bị Android/iOS.

- [x] `APP-006` **P0 — Xây shared component library**
  - AC: button, chip, card, sheet, dialog, input, empty/error/loading, progress, sticky note, audio row và app bar dùng chung.
  - Hoàn tất 2026-09-26: `lib/core/design_system/components/` có `SoulButton` (primary/secondary), `SoulChip`, `SoulCard`, `showSoulBottomSheet`, `showSoulConfirmDialog`, `SoulTextField`, `SoulEmptyState`/`SoulErrorState` (có retry)/`SoulLoadingState`, `SoulProgressBar`, `SoulStickyNote`, `SoulAudioRow`, `SoulAppBar`; onboarding, shell, Today, Vision, Journal, Explore và Profile đã dùng các component này thay cho style lặp. Chip, dialog, error/loading chưa có màn hình tiêu thụ thật (sẽ dùng ở Vision builder và remote screens) nhưng đã có widget test và golden vi/en.

- [~] `APP-007` **P0 — Chuẩn hóa logo và asset pipeline**
  - AC: logo nền trong suốt, crop bỏ khoảng trắng, căn trái chính xác; đủ density Android/iOS; có placeholder khi asset lỗi.
  - Tiến độ 2026-09-26: đã dùng logo ngang transparent cropped trong app header/gate; app icon pipeline còn chờ asset final.

- [~] `APP-008` **P0 — Responsive, SafeArea và accessibility layout**
  - AC: không tràn ở màn hình nhỏ, text scale 200%, bàn phím, landscape hợp lý; touch target tối thiểu 44–48 px.
  - Tiến độ 2026-09-26: màn onboarding cuộn được trong SafeArea (kể cả khi bàn phím mở), Vision/Explore/Journal không còn layout cố định; widget test xác nhận không overflow ở 320x568 (100% và 200%), 390x844 @200% và landscape 568x320 cho language gate, auth, preferred name, 4 tab và profile ở cả vi/en; test guideline tap target Android (48) / iOS (44) và nhãn semantics đạt cho onboarding và shell; nhãn logo/nút đều lấy từ ARB; tab được chọn dùng icon đặc để không chỉ dựa vào màu. Còn lại: nhãn bottom navigation được giới hạn ở 130% text scale (giống tab bar hệ điều hành) để không bị cắt — cần Product xác nhận; chưa kiểm tra trên thiết bị/simulator Android và iOS thật; contrast chưa đạt 4.5:1 ở hai token lấy từ prototype (`muted` trên nền paper ≈ 3.96:1; chữ trắng trên điểm cuối gradient CTA `#AA7188` ≈ 3.87:1) — cần Product/Design quyết định chỉnh màu; chưa kiểm tra reduced motion.

- [x] `APP-009` **P0 — Nền tảng widget/golden tests**
  - AC: có test harness vi/en, light theme, kích thước điện thoại chuẩn và snapshot cho component lõi.
  - Hoàn tất 2026-09-26: `test/helpers/soul_test_harness.dart` (`pumpSoulWidget`, `pumpSoulApp`) dựng ProviderScope + SharedPreferences mock + `soulTheme` + localization vi/en với kích thước điện thoại, text scale và device locale tùy chọn. Có widget test cho language gate, preferred name, tab shell, từng component, và golden vi/en cho 13 component lõi trong `test/core/design_system/goldens/`. Lưu ý: golden được tạo trên macOS với font test Ahem; CI Linux có thể lệch pixel và cần tạo lại golden trên cùng nền tảng nếu cần.

- [~] `APP-010` **P0 — App shell 4 tab và header toàn app**
  - Liên kết: `REQ-UX-003`, `US-PRO-001`, `US-AUD-001`.
  - AC: tab `Hôm nay/Today`, `Tầm nhìn/Vision`, `Nhật ký/Journal`, `Khám phá/Explore`; avatar mở profile; nút âm thanh nằm cạnh avatar.
  - Tiến độ 2026-09-26: 4 tabs, avatar profile và global sound toggle đã có; sẽ nối persistence/audio service thật ở các ticket Audio.

## Epic 2A — Lưu trữ local và content bundle (app-only)

- [~] `LOC-001` **P0 — Sinh content bundle JSON từ dataset**
  - Phạm vi: journey 28 ngày, Vision catalog (category, câu hỏi, gợi ý, feelings, statement), intention, notification copy, audio mapping; tách vi/en; có `contentVersion`.
  - AC: chạy lặp lại cho kết quả giống hệt; fail khi thiếu bản dịch, sai tham chiếu, trùng code; app đọc bundle qua repository chỉ đọc, không parse XLSX/DOCX lúc chạy. Đã chốt 2026-09-26: generator là lệnh `content:export` trong CLI của SoulApi (dùng lại parser/validate đã test, chỉ là công cụ build, không cần chạy server); JSON sinh ra được commit vào `SoulApp/assets/content/`; `npm run content:export -- --check` báo lỗi khi bản commit cũ hơn `Specs/` (chạy thủ công vì CI của từng repo không có đủ `Specs/` và SoulApp).
  - Tiến độ 2026-09-26 (app-only đợt 1): mới có `assets/content/intentions.json` (4 ý định vi/en lấy từ prototype vì dataset không có) và `ContentRepository` đọc bundle. Generator từ `Specs/` chưa làm.
  - Tiến độ 2026-09-26 (app-only đợt 2): `npm run content:export` (SoulApi) sinh `assets/content/vision.json`: 9 category, 34 feelings, 81 câu hỏi, 372 gợi ý, 17 template (ST01 còn draft nên không xuất); chỉ bản ghi published có tham chiếu published, thứ tự ổn định, `--check` báo file cũ. Còn: journey 28 ngày (chờ duyệt bản dịch `DAT-004`), notification copy, audio mapping.

- [~] `LOC-002` **P0 — Database local bằng Drift**
  - AC: bảng journey run, task response, journal entry, Vision + feelings + answers, Future Letter, reminder settings theo `data-backend-spec.md`; UUID tạo trên máy, `created_at`/`updated_at`, archive thay vì xóa cứng; unique chống ghi trùng; migration có test từ DB trống và giữa các version.
  - Tiến độ 2026-09-26 (app-only đợt 1): thêm Drift (`lib/data/local/soul_database.dart`, schema v1) với `user_journeys` (UUID, `started_on` theo ngày local + timezone, partial unique index chỉ một run `active`/journey) và `reminder_preferences` (CHECK bật thì phải có giờ). Test unit phủ idempotent, unique index và CHECK. Còn lại: bảng task response, Journal, Vision, Future Letter (thêm cùng feature tương ứng) và test migration khi có schema v2.
  - Tiến độ 2026-09-26 (app-only đợt 2): schema v2 thêm `visions` (statement 1–500, `image_path` tương đối, archive), `vision_feelings` (vị trí 1–3, CHECK + unique), `vision_answers`; bật `PRAGMA foreign_keys`. Migration theo `drift_dev make-migrations` (`drift_schemas/`), test tự động schema v1→v2 và giữ nguyên dữ liệu cũ.

- [~] `LOC-003` **P0 — Lưu ảnh trong thư mục app**
  - AC: copy/nén ảnh vào app support directory, DB lưu đường dẫn tương đối; thay/xóa ảnh không để lại file mồ côi; ảnh không nằm trong thư mục người dùng khác truy cập được.
  - Tiến độ 2026-09-26 (app-only đợt 2): `ImageStore` copy ảnh vào `visions/<uuid>.<ext>` trong app support directory khi lưu Vision, DB lưu đường dẫn tương đối; lưu thất bại thì xóa bản copy. Ảnh được nén khi chọn (tối đa 2048 px, chất lượng 85). Còn: dọn file khi thay/bỏ ảnh của Vision đã lưu (cùng `VIS-010`).

- [ ] `LOC-004` **P0 — Xóa toàn bộ dữ liệu local**
  - AC: confirm rõ hậu quả; xóa DB, ảnh, preferences, hủy lịch nhắc; quay về màn chọn ngôn ngữ; có test.

- [ ] `LOC-005` **P1 — Backup/khôi phục khi đổi máy**
  - AC: tài liệu hóa hành vi iCloud Backup/Android Auto Backup với DB và ảnh; cân nhắc export/import thủ công nếu backup OS không đủ.

## Epic 2 — Backend, PostgreSQL và API foundation (hoãn — app-only)

> 2026-09-26: MVP chuyển sang app-only, toàn bộ epic này hoãn tới khi làm sync. Các ticket `[x]` đã hoàn tất trong repo `SoulApi` và được giữ làm thiết kế tham chiếu; ticket chưa xong chuyển sang `[-]`.

- [x] `API-001` **P0 — Khởi tạo NestJS service theo module**
  - AC: config validation, health/readiness endpoint, graceful shutdown và cấu trúc module rõ ràng.
  - Tiến độ 2026-09-26: SoulApi NestJS module skeleton, config validation và `/v1/health` đã build/test; readiness/DB health chờ PostgreSQL.
  - Hoàn tất 2026-09-26: thêm `/v1/health/ready` kiểm tra PostgreSQL (timeout 2s, lỗi trả 503 `SERVICE_UNAVAILABLE`), `enableShutdownHooks` + đóng pool khi shutdown, cấu trúc `common/`, `config/`, `database/`, `health/`.

- [-] `API-002` **P0 — Chuẩn hóa REST API `/v1` và OpenAPI**
  - AC: request/response schema, auth scheme, pagination và error examples được sinh/kiểm tra tự động.
  - Tiến độ 2026-09-26: global `/v1` prefix và Swagger base document đã chạy; contract chi tiết được thêm theo từng module.
  - Tiến độ 2026-09-26 (đợt 1): OpenAPI đã có schema `ErrorEnvelope` cho error examples; còn thiếu pagination contract và kiểm tra contract tự động (làm cùng endpoint đầu tiên có danh sách).

- [x] `API-003` **P0 — Kết nối PostgreSQL riêng**
  - Phụ thuộc: `EXT-002`.
  - AC: SSL/configurable pool, health check, timeout và transaction conventions.
  - Hoàn tất 2026-09-26: `DatabaseModule` dùng `pg` pool với `DATABASE_SSL` (bắt buộc `require` ở production), `DATABASE_POOL_MAX`, `DATABASE_STATEMENT_TIMEOUT_MS`, connection timeout; quy ước transaction `db.transaction(tx)` ghi trong code. Kiểm chứng trên DB local/test; DB staging/production vẫn chờ `EXT-002`.

- [x] `API-004` **P0 — Thiết lập Drizzle schema và migration**
  - AC: migration forward-only, có migration history, seed tách khỏi migration và chạy được trên DB trống.
  - Hoàn tất 2026-09-26: schema Drizzle trong `src/database/schema/`, migration forward-only trong `drizzle/` (history ở `drizzle.__drizzle_migrations`), `db:generate`/`db:migrate`/`db:check`; test rebuild DB test từ trống rồi migrate trước mỗi lần chạy và kiểm tra migrate lại là no-op. Chưa có seed (thuộc Epic 4).

- [x] `API-005` **P0 — Mô hình user, auth session, profile và role**
  - Liên kết: `US-OB-002`, `US-OB-003`, `PRO-001`.
  - AC: unique Google subject; session revoke/rotate; role `user/editor/admin`; preferred name không ghi đè Google profile.
  - Hoàn tất 2026-09-26: `users` (unique `google_subject`, role `user/editor/admin`), `profiles` (preferred name tách khỏi `google_display_name`), `auth_sessions` (chỉ lưu hash refresh token, `family_id`, `revoked_at`, `replaced_by_session_id` cho rotate/revoke). Logic rotate/revoke thuộc `OB-004`.
  - Hoàn tất 2026-09-26: access token HS256 gắn session family; refresh token dùng một lần, chỉ lưu SHA-256, xoay vòng bằng UPDATE nguyên tử (hai refresh đồng thời chỉ một thành công); dùng lại token cũ thu hồi cả family; logout thu hồi family và vô hiệu access token ngay. Client (OB-005) chỉ refresh một lần cho mọi request 401 và không lặp vô hạn. Đã kiểm chứng bằng e2e test và smoke test server thật.

- [x] `API-006` **P0 — Mô hình content/localization/category/feeling**
  - AC: nội dung có locale, publication status, version; feelings tách khỏi Vision Category; sound liên kết category.
  - Hoàn tất 2026-09-26: category/feeling/question/statement template/audio đều có `code` ổn định, `status` draft/published/archived, `version` và bảng `*_translations` theo locale; feelings độc lập với category (`category_feeling_suggestions` chỉ là gợi ý); `category_audio_tracks` gắn sound theo category; DB chặn audio spoken `neutral` và publish audio khi chưa duyệt quyền.

- [x] `API-007` **P0 — Mô hình journey và progress**
  - AC: journey, day, task, response, completion, restart; unique constraint ngăn ghi trùng; hỗ trợ missed day.
  - Hoàn tất 2026-09-26: `journeys`, `journey_days`, `journey_tasks` (+ translations), `user_journeys` (chỉ một run `active`/user, restart giữ lịch sử), `user_journey_days`, `task_responses` (unique theo run+task và theo `client_request_id`), `journey_progress_events` để audit. Missed day được suy ra từ `started_on` + timezone; logic ở `JRN-010`.

- [x] `API-008` **P0 — Mô hình Vision, playlist, audio và media metadata**
  - AC: Vision có category, statement, feelings 1–3, image optional; nhiều track/category/locale; archive thay vì xóa cứng mặc định.
  - Hoàn tất 2026-09-26: `visions` (category, statement 1–500 ký tự, ảnh optional qua `media_objects`, archive thay vì xóa, idempotent theo `client_request_id`), `vision_feelings` với constraint trigger deferred bắt buộc 1–3 feelings, `vision_answers`, `media_objects` chỉ lưu object key; playlist resolve từ category.

- [x] `API-009` **P0 — Mô hình Journal, Future Letter và reminder**
  - AC: journal entry, free note, future letter, unlock date, status, notification preference và timezone.
  - Hoàn tất 2026-09-26: `journal_entries` (free note + projection, unique `source_task_response_id` chống trùng), `future_letters` (draft/sealed/opened, `unlock_at` + timezone, DB chặn `opened_at` trước `unlock_at`), `reminder_preferences` (theo kind, giờ local + timezone, bật thì bắt buộc có giờ).

- [x] `API-010` **P0 — Error contract, structured logging và request ID**
  - AC: không log token/private text; mọi lỗi có code ổn định, localized message key và correlation ID.
  - Hoàn tất 2026-09-26: error envelope `{ error: { code, messageKey, message, requestId, details } }` với `ErrorCode` ổn định; `X-Request-Id` nhận từ client hoặc tự sinh; log pino không ghi body, query string hay header xác thực; lỗi 5xx và 404 không lộ chi tiết nội bộ/URL. Đã kiểm chứng bằng e2e test và smoke test trên server build.

- [x] `API-011` **P0 — Local Docker và test database**
  - AC: một lệnh dựng API + PostgreSQL; test dùng DB riêng; reset test data không tác động local dev data.
  - Hoàn tất 2026-09-26: `docker compose --env-file .env.local up -d` chạy `soul-api-local`, `soul_dev` (`5432`) và `soul_test` (`5433`) với volume riêng; cả ba health check pass và `/v1/health` trả `{"status":"ok"}`.

- [-] `API-012` **P0 — Backend CI và migration check**
  - AC: lint/typecheck/test/build; phát hiện schema drift; migration chạy được từ DB trống.
  - Tiến độ 2026-09-26 (đợt 1): workflow SoulApi chạy lint/typecheck, `db:check` (phát hiện schema drift), migrate DB Postgres trống + test, build. Chuyển `[x]` sau khi workflow chạy xanh trên GitHub.

- [-] `API-013` **P0 — API resilience và abuse protection**
  - AC: idempotency cho command quan trọng, pagination, validation, rate limit auth/upload và payload size limit.
  - Tiến độ 2026-09-26 (đợt 2): đã có rate limit theo IP cho `/v1/auth/*` (`AUTH_RATE_LIMIT_PER_MINUTE`), validation whitelist toàn cục, idempotency ở DB (`client_request_id`). Còn thiếu: pagination, payload size limit tường minh, rate limit upload, cấu hình `trust proxy` khi deploy.

## Epic 3 — Onboarding song ngữ (app-only)

- [x] `OB-001` **P0 — Màn chọn ngôn ngữ trung tính ở màn đầu tiên**
  - Liên kết: `US-OB-001`.
  - AC: hiển thị `Tiếng Việt` và `English` không phụ thuộc locale đã biết; có thể preselect theo device locale nhưng người dùng phải xác nhận.
  - Hoàn tất 2026-09-26: hai lựa chọn luôn là tên gốc `Tiếng Việt`/`English` (cùng giá trị trong cả hai ARB). `suggestLocale()` + `suggestedLocaleProvider` chọn ngôn ngữ gợi ý từ device locale; lựa chọn gợi ý hiển thị dạng nút primary, lựa chọn còn lại dạng secondary, nếu device locale không hỗ trợ thì không gợi ý. Không lưu locale cho tới khi người dùng chạm vào một lựa chọn — cú chạm chính là bước xác nhận, không có nút “Tiếp tục” riêng để màn hình không cần câu chữ thuộc ngôn ngữ nào. Unit/widget test phủ cả hai hướng vi/en. Chưa kiểm tra trên thiết bị Android/iOS thật.

- [-] `OB-002` **P0 — Cấu hình Google Sign-In native**
  - Phụ thuộc: `EXT-001`, `EXT-004`.
  - AC: Android/iOS callback đúng; cancel không tạo session; lỗi mạng/cấu hình có retry và thông báo phù hợp locale.
  - Chuyển app-only 2026-09-26: hoãn cùng sync.

- [-] `OB-003` **P0 — Xác minh Google identity tại Backend**
  - Liên kết: `US-OB-002`.
  - AC: verify issuer/audience/expiry; upsert theo subject; không tin profile do client tự gửi.
  - Tiến độ 2026-09-26 (đợt 2): `POST /v1/auth/google` xác minh ID token bằng `google-auth-library` (issuer, audience = `GOOGLE_CLIENT_IDS`, chữ ký, expiry), upsert user theo Google subject, từ chối mọi field identity/role do client gửi (400). E2E test dùng verifier giả; còn chờ OAuth client thật (`EXT-004`) để kiểm chứng với token Google thật. Có `POST /v1/auth/dev` cho dev, config từ chối bật trên staging/production.
  - Chuyển app-only 2026-09-26: hoãn; endpoint đã có trong SoulApi.

- [x] `OB-004` **P0 — Access/refresh token rotation và sign-out**
  - AC: refresh token rotate/revoke; sign-out vô hiệu session; token hết hạn được xử lý không lặp request vô hạn.
  - Chuyển app-only 2026-09-26: phần backend đã xong trong SoulApi nhưng không dùng trong MVP.

- [-] `OB-005` **P0 — Dio auth client và secure storage**
  - AC: attach/refresh token an toàn, request queue khi refresh, xóa credential khi revoke; không lưu token trong plain preferences.
  - Tiến độ 2026-09-26 (đợt 2): thêm `dio` + `flutter_secure_storage`. Access token chỉ trong bộ nhớ, refresh token chỉ trong secure storage (`CredentialStore`). `AuthInterceptor` gắn `Authorization: Bearer`; khi 401 chỉ refresh một lần dùng chung cho mọi request đồng thời (request mới phát sinh trong lúc refresh sẽ chờ), retry request gốc đúng một lần; refresh bị từ chối (401/403) thì xóa credential và chuyển app về trạng thái đăng xuất, không lặp; lỗi tạm thời (mạng/429/5xx) giữ credential. Error envelope map sang `ApiException(code)`, UI map code sang copy vi/en. Khôi phục phiên khi mở app (refresh → `GET /me`) có màn loading và retry. Unit test bằng fake HTTP adapter phủ: refresh đơn cho 401 đồng thời, 401 đến muộn dùng token mới, retry một lần, refresh thất bại → đăng xuất, lỗi tạm thời giữ token, luôn lưu refresh token mới, map envelope. Còn lại: chưa chạy với SoulApi thật (endpoint auth thuộc `OB-003`/`OB-004` chưa có trong SoulApi); chưa kiểm tra Keychain/Keystore trên thiết bị Android/iOS thật; Android emulator gọi API local qua HTTP cần cấu hình cleartext cho debug.
  - Tiến độ 2026-09-26 (đợt 2): SoulApi auth đã có (`3632ee6`); smoke test server thật xác nhận response khớp model Dart (login dev, `/me`, PATCH profile, refresh, reuse → 401). Còn thiếu: chạy app trên Android/iOS thật để kiểm Keychain/Keystore.
  - Chuyển app-only 2026-09-26: đã gỡ khỏi app (Dio client, auth interceptor, secure storage, session restore); code còn trong lịch sử git SoulApp ở commit `513b01f` và `fa99345` để khôi phục khi làm sync.

- [~] `OB-006` **P0 — Hỏi preferred name ngay sau khi chọn ngôn ngữ**
  - Liên kết: `US-OB-003`.
  - AC: câu đầu tiên là “Bạn muốn được gọi với tên là gì?” theo locale; prefill tên Google chỉ là gợi ý; trim/validate; có thể sửa sau ở profile.
  - Tiến độ 2026-09-26 (đợt 2): sau đăng nhập, nếu profile server chưa có `preferredName` thì router đưa tới màn tên; ô nhập được điền sẵn `googleDisplayName` chỉ như gợi ý (không lưu cho tới khi người dùng bấm lưu); trim, 1–50 ký tự (code point, theo contract API); lưu bằng `PATCH /v1/me/profile`; lỗi server hiện thông báo vi/en và nút “Thử lại”; sửa lại được từ Profile (`/profile/name`). Widget test vi/en phủ prefill, validate, lưu, lỗi + thử lại và sửa từ Profile. Còn lại: đăng nhập thật bằng Google chờ `OB-002`/`EXT-004` (debug build hiện dùng development login `POST /auth/dev` của backend, release build để nút Google disabled); `requirements.md` (US-OB-003) vẫn ghi giới hạn 1–40 ký tự, khác contract API 1–50 — cần Product chốt; chưa kiểm tra trên thiết bị Android/iOS thật.
  - Tiến độ 2026-09-26 (đợt 2): thống nhất độ dài preferred name 1–40 ký tự Unicode theo `requirements.md` ở cả app và API (trước đó hợp đồng ghi nhầm 1–50). Backend `PATCH /v1/me/profile` trim/validate và đã test tên tiếng Việt 40 ký tự.
  - Chuyển app-only 2026-09-26: màn tên mở ngay sau khi chọn ngôn ngữ, lưu tên đã trim (1–40 ký tự) vào SharedPreferences; không còn prefill tên Google và trạng thái lỗi server. Sửa được từ Profile. Widget test vi/en phủ validate, lưu, relaunch giữa chừng và sửa từ Profile. Còn lại: kiểm tra trên thiết bị Android/iOS thật.

- [x] `OB-007` **P0 — Chọn ý định/focus onboarding**
  - Liên kết: `US-OB-004`.
  - AC: nội dung đúng dataset; lưu server; không nhầm focus với feeling hoặc Vision Category.
  - Chuyển app-only 2026-09-26: lựa chọn intention lấy từ content bundle, lưu local.
  - Hoàn tất 2026-09-26 (app-only đợt 1): màn “Điều gì đưa bạn đến đây?” đọc 4 ý định từ content bundle theo locale, chọn nhiều, bắt buộc ít nhất một (nút tắt kèm lời nhắc), lưu mã ổn định vào SharedPreferences; tách biệt với feeling và Vision Category. Quyết định 2026-09-26: bỏ copy prototype “Soul sẽ điều chỉnh hành trình…” vì ý định chưa thay đổi hành trình; dùng “Chọn điều bạn mong muốn nhất lúc này. Không có câu trả lời sai.” / “Choose what matters most to you right now. There's no wrong answer.” Ý định sẽ dùng cho gợi ý Explore (`EXP-004`).

- [~] `OB-008` **P0 — Thiết lập nhắc nhở trong onboarding**
  - Liên kết: `US-OB-005`, `REQ-NTF-001`.
  - AC: chọn giờ/bỏ qua; xin quyền hệ điều hành đúng thời điểm; lưu timezone; từ chối quyền không chặn dùng app.
  - Chuyển app-only 2026-09-26: dùng local notification (`EXT-011` đã chốt: local).
  - Tiến độ 2026-09-26 (app-only đợt 1): màn nhắc nhở buổi sáng 07:00 / buổi tối 21:30 (mặc định prototype), bật/tắt và đổi giờ từng loại, “Để sau” lưu cả hai là tắt và không xin quyền; “Tiếp tục” lưu vào Drift kèm IANA timezone (`flutter_timezone`) rồi mới xin quyền (`flutter_local_notifications`, Android 13 `POST_NOTIFICATIONS`); từ chối quyền vẫn đi tiếp. Chưa lập lịch thông báo (thuộc `NTF-002`). Còn lại: kiểm tra hộp thoại quyền trên thiết bị Android 13+ và iOS thật.

- [x] `OB-009` **P0 — Hoàn tất onboarding và tạo journey**
  - AC: thao tác idempotent; tạo journey ngày 1 đúng locale; route tới Today và không hiện onboarding lại.
  - Chuyển app-only 2026-09-26: tạo journey run trong DB local (Drift), idempotent khi bấm lặp hoặc relaunch.
  - Hoàn tất 2026-09-26 (app-only đợt 1): “Bắt đầu Ngày 1” tạo run `GRATITUDE_28` trong Drift (idempotent trong transaction; relaunch giữa chừng không tạo run thứ hai), rồi đánh dấu onboarding xong và router đưa tới Today; onboarding không hiện lại. Lỗi ghi DB hiện thông báo + “Thử lại”.

- [~] `OB-010` **P0 — Kiểm thử onboarding và returning user**
  - AC: vi/en, app relaunch ở từng bước, Google cancel/error, token expired, đổi máy và user đã hoàn tất onboarding.
  - Chuyển app-only 2026-09-26: phạm vi test còn: vi/en, relaunch ở từng bước, user đã hoàn tất onboarding; bỏ các case Google/token/đổi máy.
  - Tiến độ 2026-09-26 (app-only đợt 1): widget test vi/en cho toàn luồng ý định → nhắc nhở → bắt đầu → Today, bỏ qua nhắc nhở, từ chối quyền, relaunch ở từng bước, không overflow ở 320x568 @200% và đạt guideline tap target/label cho cả 3 màn mới. Còn lại: chạy trên thiết bị thật.

## Epic 4 — Dataset, content pipeline và localization

> 2026-09-26: app-only. Dataset vẫn được validate bằng CLI của SoulApi (`DAT-001..002`), nhưng đầu ra cho MVP là content bundle JSON trong app (`LOC-001`) thay vì seed PostgreSQL. Các ticket "Seed" nghĩa là đưa vào content bundle.

- [x] `DAT-001` **P0 — Kiểm kê và validate toàn bộ nguồn dữ liệu active**
  - Nguồn: workbook 28 ngày v1.1, Vision v1.2, External Library v1.0 và Owned Content Pack.
  - AC: báo cáo số hàng, duplicate ID, thiếu locale, thiếu category, URL lỗi và trường không hợp lệ; không import bản cũ khi đã có bản active mới.
  - Hoàn tất 2026-09-26: `npm run content:import -- --validate` đọc Vision v1.2, 28 ngày v1.1, External v1.0 và Owned Content Pack (ID audio/affirmation); báo cáo số hàng mỗi sheet, duplicate ID, thiếu bản dịch, tham chiếu category/question/audio sai, enum, URL không HTTPS, placeholder template; mỗi lỗi có file › sheet › row › field. Chỉ đọc đúng các file active. Kết quả hiện tại: 2 lỗi — `ST01` dùng placeholder `{communication_style}` không có câu hỏi tương ứng; dataset 28 ngày không có bản tiếng Anh (tiêu đề ngày/task là tiếng Anh, nội dung là tiếng Việt).

- [x] `DAT-002` **P0 — Xây import CLI có dry-run**
  - AC: đọc XLSX/Markdown chuẩn hóa; dry-run không ghi DB; lỗi chỉ rõ file/sheet/row/field; hỗ trợ transaction.
  - Hoàn tất 2026-09-26: `npm run content:import` (`--validate`, `--dry-run` chạy trong transaction rồi rollback, `--json`); lỗi cấu trúc chặn toàn bộ import, lỗi cấp bản ghi giữ bản ghi ở `draft`. Đọc XLSX trực tiếp vì workbook dùng OOXML có tiền tố namespace mà `exceljs` không đọc được.

- [x] `DAT-003` **P0 — Seed Vision categories, questions, feelings và statements**
  - Liên kết: `US-VIS-001..004`.
  - AC: nhóm cảm xúc mở rộng; người dùng chọn 1–3; feelings độc lập với category; vi/en đầy đủ.
  - Hoàn tất 2026-09-26: import 9 category, 34 feelings, 81 câu hỏi, 372 đáp án gợi ý, 18 statement template song ngữ; feelings độc lập category (gợi ý qua `category_feeling_suggestions`); 1–3 feelings do DB enforce. `ST01` giữ `draft` cho đến khi sửa dataset.

- [!] `DAT-004` **P0 — Seed hành trình 28 ngày**
  - Quyết định 2026-09-26: chọn phương án agent soạn bản nháp EN (và tiêu đề VI) để người song ngữ duyệt; nháp nằm trong `Specs/drafts/`, chỉ ghi vào workbook sau khi duyệt. Duyệt nội dung là điều kiện phát hành (`QAR-005`).
  - Liên kết: `US-JRN-001..005`.
  - AC: đủ 28 ngày; thứ tự task, copy, CTA, reflection và metadata đúng nguồn; validation không cho thiếu task bắt buộc.
  - Bị chặn 2026-09-26: dataset 28 ngày không có bản tiếng Anh cho instruction/reflection/affirmation/notification và không có tiêu đề tiếng Việt cho ngày/task; import sẽ trộn ngôn ngữ. Chờ Product chọn: bổ sung EN + tiêu đề VI vào workbook, duyệt bản nháp do agent soạn, hoặc phát hành chỉ tiếng Việt.

- [ ] `DAT-005` **P0 — Seed audio metadata và mapping theo category**
  - Liên kết: `US-AUD-001..003`.
  - AC: mỗi category có nhiều track đủ điều kiện; track có locale, duration, rights/source/status; tiếng Việt không nhận audio tiếng Anh và ngược lại.

- [ ] `DAT-006` **P0 — Chuẩn hóa owned content song ngữ**
  - AC: scripts/affirmations/reflections giữ đúng ý; copy “Bạn đã trao cho hôm nay lòng biết ơn” được dùng tại đúng completion context.

- [ ] `DAT-007` **P1 — Chuẩn hóa external content cho Explore**
  - AC: title, creator, source, official URL, locale, category, rights note và active status; không sao chép nội dung ngoài quyền.

- [~] `DAT-008` **P0 — Import idempotent và báo cáo đối soát**
  - AC: chạy lại không nhân bản; có created/updated/skipped/failed counts; foreign key và category/audio references hợp lệ.
  - Tiến độ 2026-09-26 (đợt 2): upsert theo code ổn định, chạy lại không nhân bản, chỉ tăng `version` khi nội dung đổi (kể cả bản dịch); báo cáo created/updated/unchanged; lỗi chặn = failed. Còn thiếu: tham chiếu audio (chờ `DAT-005`).

- [-] `DAT-009` **P0 — Public content APIs theo locale/publication**
  - AC: chỉ trả content published, đúng locale; fallback được quy định rõ; cache/version cho mobile; không lẫn content admin draft.
  - Tiến độ 2026-09-26 (đợt 2): `GET /v1/content/vision?locale=vi|en` chỉ trả bản ghi published có bản dịch đúng locale, không fallback sang ngôn ngữ khác; ETag + `If-None-Match` → 304 để mobile cache. Còn thiếu: API cho journey/audio.
  - Chuyển app-only 2026-09-26: API hoãn; thay bằng content bundle đọc offline trong app (`LOC-001`).

- [ ] `DAT-010` **P0 — Dataset regression tests**
  - AC: test đủ 28 ngày, tối thiểu một playlist hợp lệ/category/locale, không orphan reference và không duplicate stable ID.

## Epic 5 — Today và hành trình 28 ngày

- [ ] `JRN-001` **P0 — Today shell và điều hướng daily flow**
  - Liên kết: `US-JRN-001`, `REQ-UX-003`.
  - AC: UI bám prototype; resume đúng task; back không mất dữ liệu; tab bar không che CTA.

- [ ] `JRN-002` **P0 — Greeting, ngày hiện tại và tiến độ**
  - AC: dùng preferred name; hiển thị day/progress từ server; timezone đúng; loading/error/offline rõ ràng.

- [ ] `JRN-003` **P0 — Task renderer theo schema**
  - AC: renderer hỗ trợ gratitude, mood, prompt/reflection, small action, affirmation, sound và completion; unknown type fail-safe.

- [ ] `JRN-004` **P0 — Gratitude flow**
  - Liên kết: `US-JRN-002`.
  - AC: nhập/lưu/resume/edit theo spec; completion dùng đúng copy; dữ liệu trở thành Journal entry.

- [ ] `JRN-005` **P0 — Mood/emotion flow mở rộng**
  - Liên kết: `US-JRN-002`.
  - AC: hiển thị nhóm cảm xúc phong phú từ dataset; trạng thái chọn rõ; lưu stable ID thay vì label hiển thị.

- [ ] `JRN-006` **P0 — Small Action có thể click và hoàn tất**
  - Liên kết: `US-JRN-003`.
  - AC: toàn card/CTA click được; có pending/completed/undo theo đặc tả; chống double submit; accessibility semantics đầy đủ.

- [ ] `JRN-007` **P0 — Today’s Rhythm có sound**
  - Liên kết: `US-JRN-002`, `US-AUD-002`.
  - AC: track đúng locale và eligibility; play/pause/seek; hoàn tất task sau điều kiện được định nghĩa; tôn trọng global sound toggle.

- [ ] `JRN-008` **P0 — Vision of the day và evening preview**
  - AC: Today hiển thị Vision phù hợp và preview nhắc buổi tối theo Feature Spec; không tạo Vision giả khi user chưa có Vision.

- [ ] `JRN-009` **P0 — Lưu response, progress và Journal projection**
  - AC: autosave có trạng thái; request idempotent; reload/đổi máy khôi phục đúng; không sinh duplicate Journal entry.

- [ ] `JRN-010` **P0 — Missed-day và tiếp tục hành trình**
  - AC: bỏ lỡ ngày không khóa người dùng; ngày hiện tại được xác định nhất quán; copy không gây phán xét; audit được thay đổi progress.

- [ ] `JRN-011` **P0 — Day completion, Day 28 và restart**
  - AC: celebration đúng prototype; ngày kế tiếp mở đúng; Day 28 có completion state; restart cần confirm và không xóa lịch sử ngoài ý muốn.

- [ ] `JRN-012` **P0 — Offline cache và retry cho daily flow**
  - AC: đọc task đã cache, nhập response khi mất mạng, sync lại không nhân bản; chỉ báo “đã lưu” khi local/server state rõ ràng.

- [ ] `JRN-013` **P0 — Test toàn bộ task types và journey transitions**
  - AC: widget/unit/integration test cho vi/en, app kill/relaunch, double tap, offline/online, missed day và Day 28.

## Epic 6 — Notifications và deep links

- [ ] `NTF-001` **P0 — Notification preferences, permission và timezone**
  - Liên kết: `REQ-NTF-001`.
  - AC: enable/disable, giờ sáng/tối, timezone/DST; trạng thái system permission được phản ánh đúng trong profile.

- [ ] `NTF-002` **P0 — Lập lịch nhắc daily journey**
  - AC: morning/daily/evening theo lựa chọn; cập nhật/hủy lịch khi settings đổi; không tạo lịch trùng.

- [ ] `NTF-003` **P0 — Nhắc Vision, Future Letter và quay lại journey**
  - AC: rule/eligibility rõ; không gửi khi đối tượng đã archive/open/complete; nội dung đúng locale.

- [ ] `NTF-004` **P0 — Quản lý notification templates song ngữ**
  - AC: template có key/version/locale/variables/publication status; validate thiếu biến và thiếu bản dịch trước publish.
  - Chuyển app-only 2026-09-26: template nằm trong content bundle; validate thiếu biến/bản dịch lúc sinh bundle.

- [ ] `NTF-005` **P0 — Suppression và deduplication**
  - AC: không gửi cùng notification nhiều lần; quiet behavior khi user đã hoàn thành; tôn trọng opt-out ngay lập tức.

- [ ] `NTF-006` **P0 — Deep link routing từ notification**
  - AC: mở đúng Today task, Vision, Vision Session hoặc Future Letter; user chưa login được đưa qua auth rồi quay lại đích.
  - Chuyển app-only 2026-09-26: không còn bước auth; deep link mở thẳng đích sau onboarding.

- [ ] `NTF-007` **P0 — Privacy và notification tests**
  - AC: lock-screen body không chứa private journal/letter text; test timezone, DST, permission denied, relaunch và expired target.

## Epic 7 — Vision creation và Vision Board

- [~] `VIS-001` **P0 — Chọn Vision Category**
  - Liên kết: `US-VIS-001`.
  - AC: category từ API/dataset, đúng locale, có selected state; không hiển thị lựa chọn sound.
  - Tiến độ 2026-09-26 (app-only đợt 2): 9 lĩnh vực từ content bundle theo locale, không có lựa chọn sound; chạm để chọn và sang bước tiếp. Còn: đánh dấu lựa chọn khi quay lại bước này.

- [~] `VIS-002` **P0 — Guided questions theo category**
  - Liên kết: `US-VIS-001`.
  - AC: câu hỏi động theo dataset; autosave/resume; validate bắt buộc; back không mất câu trả lời.
  - Tiến độ 2026-09-26 (app-only đợt 2): câu hỏi của lĩnh vực hiện theo dataset (9 câu/lĩnh vực, đều bắt buộc), gợi ý dạng chip (chọn một hoặc tối đa N) + ô tự nhập; nút Tiếp tục tắt kèm lời nhắc khi chưa trả lời; Back (header/hệ thống) giữ câu trả lời. Còn: lưu nháp khi app bị tắt giữa chừng. Lưu ý cho Product: 9 câu bắt buộc mỗi lĩnh vực khá dài so với prototype (1 câu tự do + cảm xúc).

- [x] `VIS-003` **P0 — Chọn 1–3 cảm xúc mong muốn**
  - Liên kết: `US-VIS-001`.
  - AC: danh sách cảm xúc mở rộng; min 1/max 3; disabled state dễ hiểu; lưu ID độc lập category.
  - Hoàn tất 2026-09-26 (app-only đợt 2): 34 cảm xúc, gợi ý của lĩnh vực xếp trước nhưng chọn được tất cả; 1–3, đủ 3 thì các chip khác tắt kèm lời giải thích; lưu mã ổn định theo thứ tự chọn, độc lập lĩnh vực.

- [~] `VIS-004` **P0 — Tạo và chỉnh sửa Vision statement**
  - Liên kết: `US-VIS-001`, `US-VIS-004`.
  - AC: tạo từ answer/category/feelings theo rule; người dùng chỉnh sửa được; giới hạn hợp lý; vi/en không trộn ngôn ngữ.
  - Tiến độ 2026-09-26 (app-only đợt 2): câu tầm nhìn được ghép từ template primary (đủ placeholder) hoặc short, nối danh sách theo ngôn ngữ; sửa được, 1–500 ký tự; đã sửa thì không bị ghép lại. Mọi lĩnh vực × vi/en đều ghép được câu không sót placeholder (test). Còn: sửa sau khi lưu (`VIS-010`).

- [~] `VIS-005` **P0 — Đính kèm một ảnh optional**
  - AC: camera/library permission, crop/preview/replace/remove, compress; upload retry; không mất draft nếu upload lỗi.
  - Chuyển app-only 2026-09-26: ảnh được copy vào thư mục app (`LOC-003`), không upload.
  - Tiến độ 2026-09-26 (app-only đợt 2): chọn từ thư viện hoặc chụp ảnh (`image_picker`), xem trước, bỏ ảnh; ảnh chỉ copy khi lưu; mô tả quyền iOS (tiếng Anh). Còn: crop, bản dịch tiếng Việt cho mô tả quyền iOS (`InfoPlist.strings`), kiểm tra trên thiết bị thật.

- [!] `VIS-006` **P0 — Tự động gán playlist nhiều sound theo category**
  - Liên kết: `US-VIS-001`, `US-AUD-002`.
  - AC: user không chọn track; server trả nhiều eligible tracks theo category + locale; thay category cập nhật playlist; fallback không lẫn ngôn ngữ.
  - Chuyển app-only 2026-09-26: playlist resolve trên máy từ mapping trong content bundle.
  - Bị chặn 2026-09-26: chưa có file audio có giấy phép (`EXT-007`) nên chưa có mapping lĩnh vực → track trong content bundle.

- [~] `VIS-007` **P0 — Preview và save Vision**
  - AC: preview gồm statement/feelings/image/audio availability; save idempotent; lỗi có retry; save xong trở về board/detail đúng ngữ cảnh.
  - Tiến độ 2026-09-26 (app-only đợt 2): bước xem lại gồm câu tầm nhìn, cảm xúc, ảnh; lưu idempotent theo UUID tạo khi mở builder; lỗi giữ nguyên lựa chọn và có Thử lại; lưu xong về board. Còn: hiển thị playlist (chờ `VIS-006`).

- [x] `VIS-008` **P0 — Multi-Vision Board & Creative Collage**
  - AC: khi có nhiều Vision, tab Vision mở board dạng collage 2 cột so le (masonry); thẻ không có ảnh hiển thị text trực tiếp trên nền gradient chủ đề kèm watermark; thẻ có ảnh theo phong cách polaroid; có nút chuyển đổi giữa board và list; sort ổn định.
  - Hoàn tất 2026-10-06: bảng ghép Vision Board 2 cột so le mượt mà, text in trực tiếp trên canvas gradient nghệ thuật khi không có ảnh, khung ảnh polaroid khi có ảnh, chi tiết băng dán washi tape và bóng đổ chân thực; hỗ trợ toggle chuyển đổi giữa Bảng ghép và Danh sách.

- [~] `VIS-009` **P0 — Vision detail và back navigation**
  - AC: back button và system back đều hoạt động; không bị overlay chặn pointer; quay lại đúng board/tab và giữ scroll state.
  - Tiến độ 2026-09-26 (app-only đợt 2): chi tiết Vision mở từ thẻ; nút back và back hệ thống về board (route cha giữ trạng thái). Còn: test back riêng và kiểm tra giữ vị trí cuộn.

- [ ] `VIS-010` **P0 — Chỉnh sửa Vision và đổi category**
  - AC: edit statement/feelings/image/category; đổi category cập nhật playlist; confirm khi rời màn hình có unsaved change.

- [x] `VIS-011` **P0 — Archive Vision**
  - AC: confirm rõ; Vision archive không hiện ở active board/session; dữ liệu lịch sử không bị xóa cứng; có khả năng restore nếu spec cho phép.
  - Hoàn tất 2026-09-26 (app-only đợt 2): lưu trữ có xác nhận, Vision rời board nhưng vẫn còn trong DB (`status = archived`, `archived_at`). Spec không yêu cầu khôi phục.

- [~] `VIS-012` **P0 — Vision regression tests**
  - AC: vi/en, 1–3 feelings, image lỗi, category đổi, nhiều Vision, archive và back navigation đều có test.
  - Tiến độ 2026-09-26 (app-only đợt 2): test vi/en: tạo đủ các bước, giới hạn 3 cảm xúc, lưu DB, mở chi tiết, lưu trữ; back giữ câu trả lời; chọn/bỏ ảnh; không overflow 320x568 @200%; unit test catalog, ghép câu, repository và image store.

## Epic 8 — Audio engine và Vision Session (Object Storage hoãn)

- [-] `STO-001` **P0 — Chọn và cấu hình S3-compatible Object Storage**
  - Phụ thuộc: `EXT-003`.
  - AC: bucket/env tách biệt; private by default; CORS, encryption, size/type limit và naming policy.
  - Chuyển app-only 2026-09-26: hoãn cùng backend.

- [-] `STO-002` **P0 — Signed upload/finalize flow**
  - AC: Backend cấp signed URL ngắn hạn, kiểm tra owner/type/size; finalize chỉ nhận object hợp lệ; retry không nhân metadata.
  - Chuyển app-only 2026-09-26: hoãn cùng backend.

- [-] `STO-003` **P0 — Authorized media retrieval/delete**
  - AC: ảnh Vision/attachment riêng tư chỉ owner truy cập; audio published theo policy; archive/delete không để lộ object.
  - Chuyển app-only 2026-09-26: hoãn cùng backend.

- [-] `STO-004` **P0 — Lifecycle và orphan cleanup**
  - AC: temp upload hết hạn được dọn; retention đúng privacy policy; job có dry-run/metrics và không xóa object đang tham chiếu.
  - Chuyển app-only 2026-09-26: hoãn cùng backend.

- [x] `AUD-001` **P0 — Audio domain service và playback state**
  - AC: một nguồn state cho current track/queue/playback/global mute; UI không tự quản lý player riêng lẻ.
  - Hoàn tất 2026-10-06: `AudioPlaybackController` quản lý thống nhất trạng thái phát (currentTrack, position, duration, isPlaying, isLooping, global mute), đồng bộ trên toàn bộ UI qua Riverpod.

- [x] `AUD-002` **P0 — Tích hợp `just_audio` và `audio_session`**
  - AC: play/pause/seek/next; background/lock screen theo phạm vi; interruption/headphone unplug/audio focus hoạt động đúng.
  - Hoàn tất 2026-10-06: tích hợp đầy đủ `just_audio` kết hợp cấu hình `AudioSession.music()`, hỗ trợ seek relative, loop mode và background playback.

- [x] `AUD-003` **P0 — Eligible playlist resolver**
  - AC: filter category, locale, publication, rights, availability; trả nhiều track và thứ tự ổn định/rule-based; không trả track sai locale.
  - Hoàn tất 2026-10-06: phân loại 24 tracks chuẩn Soul sở hữu (`SO-03..SO-20`, `GA-18..GA-31`) theo nhóm Thiên nhiên, Nhạc & Tần số, Bài dẫn thiền (song ngữ vi/en), lọc chính xác theo locale người dùng.

- [x] `AUD-004` **P0 — Global sound toggle cạnh avatar**
  - AC: trạng thái rõ, persisted; mute/pause behavior được thống nhất; screen reader label; không ảnh hưởng âm hệ thống khác.
  - Hoàn tất 2026-10-06: nút sound toggle cạnh avatar điều khiển trực tiếp mute/pause trạng thái âm thanh toàn cục.

- [x] `AUD-005` **P0 — Mini player và trải nghiệm nhiều sound**
  - AC: hiển thị current track/progress/next; playlist tự động; người dùng có thể điều khiển phát nhưng không chỉnh mapping category.
  - Hoàn tất 2026-10-06: widget `SoulMiniPlayer` nổi phía trên navigation bar xuyên suốt app, kèm sheet điều khiển chi tiết `SoulAudioDetailSheet` (seek, loop, tua 10s, xem tiến trình mm:ss). Tích hợp một chạm phát thanh từ Explore và nghe thử trong Vision modal.

- [ ] `AUD-006` **P0 — Sound trong Today’s Rhythm**
  - AC: đúng track/locale/category rule; loading/error/retry; completion event không bị ghi trùng.

- [ ] `AUD-007` **P0 — Vision Session setup**
  - AC: chọn Vision hiện tại, một số Vision hoặc tất cả Vision; thời lượng 3–5 phút theo spec; hiển thị playlist phù hợp trước khi bắt đầu.

- [ ] `AUD-008` **P0 — Vision Session player/renderer**
  - AC: statement/image/transition/audio đồng bộ; pause/resume/exit; không crash khi Vision thiếu ảnh hoặc track unavailable.

- [ ] `AUD-009` **P0 — Vision Session completion**
  - AC: ghi session completion/duration an toàn; có reflection/CTA theo spec; không ép người dùng chia sẻ.

- [ ] `AUD-010` **P0 — Audio device và interruption tests**
  - AC: speaker/Bluetooth/headphone, phone call, app background/foreground, mute, mất mạng và track lỗi.

- [ ] `AUD-011` **P0 — Audio rights gate**
  - Phụ thuộc: `EXT-007`.
  - AC: chỉ publish/stream asset có quyền; lưu nguồn/giấy phép/expiry; asset hết quyền tự động bị loại khỏi eligible playlist.
  - Chuyển app-only 2026-09-26: gate chạy lúc sinh content bundle: track thiếu quyền không được đưa vào bundle. Cách phân phối file audio (đóng gói hay tải qua remote manifest) chờ `EXT-012`.

## Epic 9 — Journal và Future Letter

- [x] `JOU-001` **P0 — Tự động tạo Journal entry từ daily flow & thực hành biết ơn**
  - Liên kết: `US-JOU-001`.
  - AC: gratitude/reflection/mood phù hợp được projection một lần; giữ ngày/task/source; sync lại không duplicate.
  - Hoàn tất 2026-10-06: tích hợp luồng thực hành biết ơn theo hành trình ngày, lưu bài viết trực tiếp vào nhật ký kèm hướng dẫn và theme tương ứng.

- [x] `JOU-002` **P0 — Tạo và chỉnh sửa freeform note**
  - AC: nhập tự do như nhật ký (không ép điền từng câu rời rạc), dropdown hướng dẫn theo ngày có thể thu gọn/mở rộng, theme selector nhỏ gọn dạng dropdown trên mặt giấy, hỗ trợ sửa note đã lưu và xóa có confirm; autosave hoặc save state rõ; nội dung riêng tư và hoạt động offline.
  - Hoàn tất 2026-10-06: luồng viết nhật ký tự do thanh lịch, hỗ trợ sửa trực tiếp ghi chú cũ và lưu đè/cập nhật, chọn màu nền giấy, xoá ghi chú có hộp thoại xác nhận.

- [x] `JOU-003` **P0 — Recent notes dạng giấy kẻ ngang phong cách tối giản**
  - AC: nền giấy trắng ấm, chỉ có kẻ ngang, không kẻ dọc và không viền bo tròn thừa thãi, lược bỏ các nhãn thừa như "Note content"; toàn card click được; layout bám prototype tối giản.
  - Hoàn tất 2026-10-06: thẻ nhật ký hiển thị clean như một trang sổ tay thực thụ, typography đẹp mắt, căn chỉnh lề hài hòa.

- [x] `JOU-004` **P0 — Sticky note detail và action bar**
  - AC: mở note như sticky note đẹp; transition hợp lý; nút sửa (Edit) và xóa (Delete); system/header back hoạt động; cập nhật tức thì danh sách sau khi sửa/xóa.
  - Hoàn tất 2026-10-06: màn hình chi tiết note với giao diện tờ giấy ghi chú ấm áp, nút thao tác Sửa/Xóa tinh tế ở header.

- [x] `JOU-005` **P0 — Journal privacy, offline và tests**
  - AC: lưu trữ hoàn toàn offline trên SQLite nội bộ; không gửi lên internet; test controller, repository, màn hình danh sách, chi tiết và chỉnh sửa note.
  - Hoàn tất 2026-10-06: hoàn thiện suite test `journal_controller_test.dart` và `journal_screen_test.dart` đạt 100% pass.

- [ ] `LET-001` **P0 — Future Letter list và locked state**
  - Liên kết: `US-LET-001`.
  - AC: upcoming/opened states, unlock date theo timezone; locked letter không lộ body qua API/UI/cache preview.
  - Chuyển app-only 2026-09-26: không có API; body không hiển thị ở UI/preview trước `unlock_at`.

- [ ] `LET-002` **P0 — Soạn thư và chọn thời điểm mở**
  - AC: title/body/unlock option theo spec; validate ngày tương lai; autosave draft; copy song ngữ.

- [ ] `LET-003` **P1 — Attachment và liên kết Vision cho Future Letter**
  - AC: optional, giới hạn file/type/size; quyền riêng tư theo owner; Vision archive không làm hỏng letter.

- [ ] `LET-004` **P0 — Preview và seal Future Letter**
  - AC: confirm nội dung/ngày; seal idempotent; sau seal không sửa trừ khi rule cho phép; không mở sớm ở client hoặc API.

- [ ] `LET-005` **P0 — Unlock notification và deep link**
  - AC: gửi một lần đúng locale/timezone; deep link mở letter sau auth; suppression khi notification tắt không ngăn letter tự unlock.

- [ ] `LET-006` **P0 — Mở thư, mood và reply/reflection**
  - Liên kết: `US-LET-002`.
  - AC: chỉ mở khi đủ thời gian; lưu openedAt; mood/reply theo đặc tả; refresh không tái tạo event mở.

- [ ] `LET-007` **P0 — Future Letter security/offline tests**
  - AC: không thể đổi clock client để mở sớm; authz, timezone/DST, locked cache, relaunch và notification deep link được test.
  - Chuyển app-only 2026-09-26: không chống được việc đổi đồng hồ máy để mở sớm (giới hạn đã chấp nhận, `requirements.md` §0); vẫn test timezone/DST, relaunch và deep link.

## Epic 10 — Explore và Profile/Settings

- [ ] `EXP-001` **P1 — Explore landing, featured và filter**
  - Liên kết: `US-EXP-001`.
  - AC: tab “Tôi” cũ được thay bằng Explore; list theo locale/category; loading/empty/error; UI cùng design system.

- [ ] `EXP-002` **P1 — Native content player/detail**
  - AC: nội dung owned phát trong app, dùng chung audio engine; attribution/metadata; progress không xung đột Vision Session.

- [ ] `EXP-003` **P1 — External official links và attribution**
  - AC: mở official source an toàn; cảnh báo rời app khi cần; không embed/download trái quyền; broken link fallback.

- [ ] `EXP-004` **P1 — Recommendation placements**
  - AC: recommendation theo rule minh bạch, không dựa trên private journal text; không làm gián đoạn daily flow.

- [ ] `EXP-005` **P1 — Editorial và link-health checks**
  - AC: active/published controls; job phát hiện URL hỏng; admin có thể unpublish; không hiển thị draft.

- [ ] `PRO-001` **P0 — Profile mở từ avatar**
  - Liên kết: `US-PRO-001`.
  - AC: avatar ở header là entry duy nhất thay cho tab “Tôi”; mở/đóng/back đúng; giữ trạng thái tab hiện tại.

- [ ] `PRO-002` **P0 — Profile stats và settings**
  - AC: sửa preferred name, language, global sound, reminder/timezone; thống kê journey/Vision cơ bản; lưu có optimistic/error recovery.

- [ ] `PRO-003` **P0 — Privacy và xóa toàn bộ dữ liệu local**
  - Phụ thuộc: `EXT-009`.
  - AC: policy links, sign-out revoke session, request account deletion rõ hậu quả/trạng thái; không xóa ngay thiếu confirm.
  - Chuyển app-only 2026-09-26: thay sign-out/account deletion bằng “Xóa toàn bộ dữ liệu”: confirm rõ hậu quả, xóa DB + ảnh + preferences, hủy lịch nhắc, quay về màn chọn ngôn ngữ. Nút Đăng xuất đã được gỡ khỏi Profile.

- [ ] `PRO-004` **P0 — Đổi ngôn ngữ và refresh content cache**
  - AC: UI đổi ngay; invalidate/refetch content đúng locale; audio đang phát sai locale phải dừng/chuyển an toàn.
  - Chuyển app-only 2026-09-26: đổi ngôn ngữ nạp lại content bundle theo locale; không còn refetch từ server.

- [ ] `PRO-005` **P0 — Profile/settings tests**
  - AC: avatar navigation, rename, vi↔en, sound/reminder toggle, sign-out và app relaunch được test.
  - Chuyển app-only 2026-09-26: bỏ case sign-out; thêm case xóa dữ liệu local. Đã có test đổi ngôn ngữ và bật/tắt âm thanh lưu local (`test/app/local_settings_test.dart`).

## Epic 11 — Admin Portal và content operations (hoãn — app-only)

> 2026-09-26: không có Admin Portal trong MVP; nội dung sửa ở `Specs/` rồi sinh lại content bundle.

- [-] `ADM-001` **P0 — Khởi tạo Next.js Admin Portal**
  - Liên kết: `REQ-ADM-001`.
  - AC: TypeScript, authenticated layout, shared API client, error boundary và environment config.

- [-] `ADM-002` **P0 — Admin authentication bằng secure cookie**
  - AC: HttpOnly/Secure/SameSite phù hợp; CSRF protection; session timeout; không lưu admin token trong localStorage.

- [-] `ADM-003` **P0 — Role-based access control**
  - AC: editor/admin permission rõ; Backend enforce quyền, không chỉ ẩn UI; unauthorized actions có audit-safe response.

- [-] `ADM-004` **P0 — Journey Content Manager**
  - AC: CRUD/reorder/preview/publish 28 ngày, task và localization; validation ngăn publish ngày thiếu nội dung.

- [-] `ADM-005` **P0 — Vision Content Manager**
  - AC: quản lý category, questions, feelings, statement templates và vi/en; preview mapping trước publish.

- [-] `ADM-006` **P0 — Audio/media manager**
  - AC: upload metadata, rights/source/expiry, locale, category mappings, active/published; preview track; không cho publish thiếu quyền.

- [-] `ADM-007` **P0 — Notification/localization manager**
  - AC: quản lý templates vi/en, variables, schedule defaults; preview; validation parity trước publish.

- [-] `ADM-008` **P0 — External resource manager**
  - AC: URL/source/creator/locale/category/status; validate URL; publish/unpublish; attribution bắt buộc.

- [-] `ADM-009` **P0 — Publish workflow và validation summary**
  - AC: draft→published; hiển thị toàn bộ lỗi trước publish; version/timestamp/editor; mobile không nhận draft.

- [-] `ADM-010` **P2 — Audit history và rollback UI**
  - AC: xem diff/version, ai thay đổi/khi nào; rollback tạo version mới và không sửa history.

- [-] `ADM-011` **P0 — Admin authorization và content regression tests**
  - AC: role matrix, CSRF, validation, locale parity, publish visibility và failed upload được test.

## Epic 12 — Analytics, quality, security và release

- [ ] `ANA-001` **P1 — Analytics event contract**
  - Liên kết: `REQ-ANA-001`.
  - AC: event names/properties/version/consent documented; tuyệt đối không gửi journal, letter, answer hay statement nguyên văn.

- [ ] `ANA-002` **P1 — Mobile/API analytics emission**
  - Phụ thuộc: `EXT-010`.
  - AC: consent-aware; retry/batch; stable anonymous/user ID policy; event không làm chậm luồng chính.
  - Chuyển app-only 2026-09-26: chỉ còn phía mobile; provider bên thứ ba theo `EXT-010`.

- [ ] `ANA-003` **P1 — KPI queries/dashboard cơ bản**
  - AC: onboarding completion, day retention/completion, Vision created/session completed và notification engagement; định nghĩa KPI thống nhất.

- [ ] `QAR-001` **P0 — Hoàn thiện loading/empty/error/offline states**
  - AC: mọi màn P0 có trạng thái; error có retry phù hợp; không dùng toast chung chung cho lỗi mất dữ liệu.

- [ ] `QAR-002` **P0 — Accessibility audit**
  - AC: semantics, focus order, contrast, touch targets, screen reader, reduce motion, dynamic text; kiểm thử Android và iOS.

- [ ] `QAR-003` **P0 — Bilingual device regression**
  - AC: vi/en trên kích thước nhỏ/lớn, Android/iOS, timezone khác; không overflow, text sót hoặc audio sai locale.

- [ ] `QAR-004` **P0 — Security và privacy review**
  - Liên kết: `REQ-SAFE-001`.
  - AC: authz object-level, upload validation, secret scan, dependency scan, rate limit, log redaction và account deletion flow.
  - Chuyển app-only 2026-09-26: trọng tâm là dữ liệu local: không log nội dung riêng tư, notification không lộ text, backup OS phù hợp, dependency/secret scan; authz server và rate limit hoãn.

- [ ] `QAR-005` **P0 — Content/audio rights review**
  - Phụ thuộc: `EXT-007`, `EXT-009`.
  - AC: mọi asset published có nguồn/quyền; external content attribution; privacy copy không hứa vượt khả năng kỹ thuật.

- [ ] `QAR-006` **P0 — Store policies và legal metadata**
  - AC: privacy policy, terms, account deletion, permission purpose strings, data safety/privacy labels và support URL.
  - Chuyển app-only 2026-09-26: không có account nên thay account deletion bằng xóa dữ liệu local; data safety/privacy label khai báo dữ liệu chỉ lưu trên máy.

- [ ] `QAR-007` **P0 — Signed staging/release builds**
  - Phụ thuộc: `EXT-001`, `EXT-008`.
  - AC: Android AAB và iOS archive cài được; config production tách biệt; symbol/source map retention.

- [ ] `QAR-008` **P0 — Performance và reliability pass**
  - AC: startup, navigation, image/audio loading, memory và crash-free smoke test đạt budget được thống nhất; slow network usable.

- [ ] `QAR-009` **P0 — End-to-end release acceptance**
  - AC: chạy thành công từ chọn ngôn ngữ → Google login → preferred name → onboarding → Today → Vision → audio/session → Journal/Future Letter → profile trên vi/en.
  - Chuyển app-only 2026-09-26: luồng nghiệm thu bỏ bước Google login.

## Epic 13 — Soul Cards (Rút thẻ thông điệp)

- [x] `CRD-001` **P0 — Card decks & asset catalog**
  - AC: 3 bộ thẻ (`career` - Sự nghiệp, `healing` - Chữa lành, `relationship` - Mối quan hệ); 150 thẻ ảnh WebP nén tối ưu; metadata song ngữ (quotes, actions) nạp tự động theo locale từ local JSON catalog; fallback an toàn.
  - Hoàn tất 2026-10-06: 150 file WebP được tổ chức trong `assets/cards/`, catalog metadata `assets/cards/cards_metadata.json` song ngữ vi/en, `CardDeckRepository` load local offline.

- [x] `CRD-002` **P0 — Decks Hub screen & bottom navigation destination**
  - AC: tab thứ 2 trên thanh điều hướng chính (hoặc tab Rút thẻ trực tiếp); hiển thị 3 bộ thẻ trực quan với hình minh họa, tiêu đề, mô tả và màu sắc chủ đề riêng; người dùng click vào bộ mới chuyển sang màn hình rút thẻ riêng của bộ đó.
  - Hoàn tất 2026-10-06: màn hình `CardDecksHubScreen` với 3 banner bộ thẻ minh họa ấn tượng, gradient và badge chủ đề; route `/cards` và `/cards/draw/:deckCode`.

- [x] `CRD-003` **P0 — Interactive 3D card flip & draw screen**
  - AC: mặt sau thẻ thiết kế huyền bí với hoa văn biểu tượng; chạm để lật thẻ mượt mà với hiệu ứng xoay 3D 180 độ; mặt trước thẻ hiển thị hình minh họa, châm ngôn và lời khuyên hành động; thông điệp căn chính giữa cân đối, không lệch lề.
  - Hoàn tất 2026-10-06: `SoulCardFlipWidget` xoay 3D hai mặt mượt mà sử dụng `Matrix4`, mặt trước căn chỉnh typography và layout cân đối hoàn hảo.

- [x] `CRD-004` **P0 — Daily 2-draw limit & alert dialog**
  - AC: mỗi ngày được rút tối đa 2 lần; giao diện thông báo số lượt còn lại nhẹ nhàng hoặc bỏ qua; chỉ khi người dùng bấm rút lần thứ 3 mới hiển thị dialog cảnh báo hết lượt trong ngày; tự động đặt lại khi sang ngày mới.
  - Hoàn tất 2026-10-06: `SoulCardsController` quản lý lượt rút theo ngày, lưu vào local storage; chặn ở lần thứ 3 với dialog thông báo trang nhã.

- [x] `CRD-005` **P0 — Unit & widget tests cho Soul Cards**
  - AC: test logic controller (hạn mức rút 2 lần, reset theo ngày), repository load thẻ, và widget test cho hub screen & flip interaction.
  - Hoàn tất 2026-10-06: hoàn thiện `soul_cards_controller_test.dart` và `cards_hub_screen_test.dart` đạt 100% pass.

---

## 3. Phụ thuộc cần chủ dự án cung cấp/chốt

- [ ] `EXT-001` Application ID, bundle ID, Apple/Google developer accounts và signing ownership.
- [-] `EXT-002` PostgreSQL cho staging/production, connection policy, backup, monitoring và retention.
- [-] `EXT-003` S3-compatible Object Storage, CDN/domain nếu có và lifecycle policy.
- [-] `EXT-004` Google OAuth clients cho Android, iOS và Backend audience.
- [ ] `EXT-005` Quyền sử dụng font/logo/brand assets và file nguồn đã crop nền trong suốt.
- [ ] `EXT-006` Giờ nhắc mặc định, timezone behavior và nội dung notification được duyệt. Tạm dùng mặc định prototype 07:00 / 21:30 (2026-09-26).
- [ ] `EXT-007` Audio files cuối, nguồn, giấy phép, phạm vi lãnh thổ và ngày hết hạn nếu có.
- [-] `EXT-008` Hosting/domain/TLS/secret manager cho Backend và Admin Portal.
- [ ] `EXT-009` Privacy Policy, Terms, chính sách dữ liệu local/xóa dữ liệu và email hỗ trợ.
- [ ] `EXT-010` Quyết định analytics provider, consent model và quyền truy cập dashboard.
- [x] `EXT-011` Quyết định local notification hay server push; nếu server push thì cần APNs/FCM credentials và provider. Đã chốt 2026-09-26: local notification (app-only).
- [x] `EXT-012` Cách phân phối audio: đóng gói trong app hay tải dần qua remote manifest (file JSON liệt kê resource trên host tĩnh). Đã chốt 2026-09-26: MVP1 đóng gói audio trong app nếu tổng dung lượng ≤ ~50 MB (AAC 64–96 kbps); vượt ngưỡng thì chuyển sang remote manifest và vẫn đóng gói 1–2 track `neutral` dự phòng. Nguồn phát của track được trừu tượng hóa (asset hoặc URL) để chuyển đổi không phải sửa player/playlist.

## 4. Critical path đề xuất

1. `REP-*` + `APP-001..010`.
2. `LOC-001..002` (content bundle + DB local) cùng `OB-001..010`.
3. `DAT-*` còn lại song song với `JRN-001..013` và `NTF-001..007`.
4. `VIS-001..012` + `LOC-003` song song với `AUD-001..011` (sau khi chốt `EXT-012`).
5. `JOU-001..005` + `LET-001..007`.
6. `PRO-*` + `LOC-004`, sau đó toàn bộ `QAR-001..009`.
7. `EXP-*` và `ANA-*` sau luồng P0 ổn định hoặc đưa vào cùng release nếu còn năng lực.
8. Sau MVP: sync backend (Epic 2, `OB-002..005`, `STO-*`) và Admin Portal (Epic 11).

## 5. Definition of Ready

Một ticket chỉ bắt đầu khi:

- Có requirement/source rõ ràng và không mâu thuẫn với quyết định sản phẩm mới nhất.
- Có data contract (schema local hoặc cấu trúc content bundle) ổn định.
- Có trạng thái UI cần thiết: default, loading, empty, error, offline, disabled và success.
- Có copy `vi`/`en`, asset và quyền sử dụng liên quan.
- Các dependency `EXT-*` bắt buộc đã được chốt hoặc có mock/dev substitute an toàn.
- Acceptance Criteria đủ để một agent/dev khác kiểm chứng mà không phải đoán ý.

## 6. Definition of Done

Một ticket chỉ hoàn tất khi:

- Code đã format/lint/typecheck và không làm hỏng build.
- Unit/widget/integration test phù hợp đã chạy và đạt.
- UI bám prototype và design tokens, hoạt động trên Android/iOS mục tiêu.
- `vi`/`en`, accessibility, loading/error/offline và quyền riêng tư đã được kiểm tra.
- Migration DB local và sinh content bundle idempotent; không lộ secret hoặc private content trong log/analytics.
- Tài liệu/API contract/backlog được cập nhật nếu implementation tạo ra quyết định mới.
- Có bằng chứng nghiệm thu: test output, screenshot/golden hoặc checklist E2E tùy loại ticket.
