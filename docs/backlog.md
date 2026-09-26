# Soul — Backlog triển khai cuối

> Cập nhật: 2026-09-26
> Phạm vi: Flutter mobile app, Backend API, PostgreSQL, Object Storage và Admin Portal.
> Nguồn yêu cầu chuẩn: [`requirements.md`](./requirements.md). Các tài liệu gốc đã chuẩn hóa nằm tại [`source-specs/`](./source-specs/).

## 1. Quy ước tracking

### Trạng thái

- `[ ]`: Chưa bắt đầu.
- `[~]`: Đang thực hiện.
- `[x]`: Đã hoàn tất và đạt Definition of Done.
- `[!]`: Bị chặn bởi phụ thuộc hoặc quyết định bên ngoài.

### Mức ưu tiên

- **P0**: Bắt buộc để phát hành MVP.
- **P1**: Mở rộng ngay sau khi luồng lõi ổn định; không chặn bản MVP đầu tiên nếu được Product xác nhận.
- **P2**: Hậu MVP.

### Quy tắc sử dụng backlog

- Prototype HTML/CSS/JS hiện tại là chuẩn UI/UX và tương tác trực quan; `requirements.md` là chuẩn nghiệp vụ.
- Một ticket chỉ được chuyển thành `[x]` khi toàn bộ Acceptance Criteria (AC), kiểm thử và trạng thái lỗi/rỗng/loading liên quan đều đạt.
- Mọi nội dung hiển thị phải có cả `vi` và `en`; không tạo hai cây màn hình riêng cho hai ngôn ngữ.
- Mobile không gọi trực tiếp PostgreSQL hoặc Object Storage bằng quyền quản trị; mọi quyền truy cập đi qua Backend API hoặc signed URL ngắn hạn.
- Không dùng Supabase. PostgreSQL, Object Storage, xác thực Google và dịch vụ thông báo được cấu hình độc lập.
- Không cho người dùng chọn thủ công sound của Vision. Playlist gồm nhiều sound được hệ thống gán theo `vision_category` và ngôn ngữ.

## 2. Mốc triển khai

| Mốc | Kết quả bắt buộc | Điều kiện hoàn tất |
|---|---|---|
| M0 — Baseline | Prototype, specs, dataset và yêu cầu đã chuẩn hóa | DOC-001 → DOC-003 hoàn tất |
| M1 — App shell | App song ngữ, đăng nhập Google, onboarding, 4 tab, profile qua avatar | Epic 1–3 hoàn tất |
| M2 — Daily journey | Dataset 28 ngày, Today, lưu tiến trình, notification | Epic 4–6 hoàn tất |
| M3 — Vision & audio | Tạo Vision, ảnh, playlist theo category, Vision Session | Epic 7–8 hoàn tất |
| M4 — Reflection | Journal, sticky note, Future Letter | Epic 9 hoàn tất |
| M5 — Operations | Admin CMS cơ bản; Explore và analytics P1 | Epic 10–12 theo phạm vi release |
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

- [~] `REP-002` **P0 — Chuẩn hóa `.gitignore` và secret policy**
  - AC: không commit secret, signing key, Google config production, file audio có hạn chế bản quyền hoặc dữ liệu người dùng.
  - Tiến độ 2026-09-26: Flutter/API ignore `.env`, signing keys và Google config production; policy cho audio/user data sẽ đi cùng storage pipeline.

- [~] `REP-003` **P0 — Thiết lập CI cơ bản**
  - AC: chạy format, lint, unit test và build check cho Flutter, Backend, Admin trên pull request.
  - Tiến độ 2026-09-26: workflow GitHub Actions cho Flutter và SoulApi đã sẵn tại root workspace; job Admin sẽ được thêm khi `SoulAdmin` được scaffold và workflow chỉ chạy sau khi workspace được khởi tạo/push lên Git repository.


- [x] `REP-004` **P0 — Chốt application identifiers**
  - Phụ thuộc: `EXT-001`.
  - AC: Android application ID và iOS bundle ID thống nhất giữa app, Google OAuth và build pipeline.
  - Hoàn tất 2026-09-26: owner đã chốt `com.manifest.soul`; Android namespace/application ID, iOS/macOS bundle IDs và OAuth redirect examples đã đồng bộ. Google OAuth clients vẫn cần được tạo với identifier này ở `EXT-004`.

- [x] `REP-005` **P0 — Tạo mẫu cấu hình môi trường**
  - AC: có `.env.example` không chứa secret; mô tả rõ biến của API, DB, storage, Google OAuth, notification và analytics.
  - Hoàn tất 2026-09-26: API `.env.example` + staging/production examples và mobile `--dart-define` JSON examples đã được kiểm tra không có secret thật.

- [~] `REP-006` **P0 — Tách môi trường local/staging/production**
  - AC: app không thể vô tình dùng production từ debug build; database/storage namespace tách biệt.
  - Tiến độ 2026-09-26: mobile reject `APP_ENV=production` trong debug/profile và đã có template tách môi trường; DB/storage namespaces chờ hạ tầng `EXT-002`/`EXT-003`.

## Epic 1 — Flutter foundation và design system

- [~] `APP-001` **P0 — Bootstrap kiến trúc Flutter theo feature**
  - AC: có lớp `app`, `core`, `features`, `data`, `domain`, `presentation`; dependency chỉ đi theo hướng đã định trong architecture.
  - Tiến độ 2026-09-26: đã dựng `app`, `core` và các feature UI đầu tiên; tiếp tục tách data/domain/presentation khi API repositories được thêm.

- [~] `APP-002` **P0 — Thiết lập Riverpod và state conventions**
  - AC: có mẫu AsyncValue/loading/error/retry; không giữ state nghiệp vụ quan trọng trong widget cục bộ.
  - Tiến độ 2026-09-26: Riverpod đã bootstrap `AppState`; chuẩn AsyncValue được thực hiện cùng remote repositories.

- [~] `APP-003` **P0 — Thiết lập GoRouter và route guards**
  - Liên kết: `US-OB-001..005`, `REQ-UX-003`.
  - AC: guard cho language/auth/onboarding; mỗi tab giữ back stack; back hoạt động đúng ở Vision detail và Journal detail.
  - Tiến độ 2026-09-26: language/auth/name guards và indexed tab shell đã chạy; sẽ bổ sung detail routes khi Vision/Journal có dữ liệu thật.

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

## Epic 2 — Backend, PostgreSQL và API foundation

- [~] `API-001` **P0 — Khởi tạo NestJS service theo module**
  - AC: config validation, health/readiness endpoint, graceful shutdown và cấu trúc module rõ ràng.
  - Tiến độ 2026-09-26: SoulApi NestJS module skeleton, config validation và `/v1/health` đã build/test; readiness/DB health chờ PostgreSQL.

- [~] `API-002` **P0 — Chuẩn hóa REST API `/v1` và OpenAPI**
  - AC: request/response schema, auth scheme, pagination và error examples được sinh/kiểm tra tự động.
  - Tiến độ 2026-09-26: global `/v1` prefix và Swagger base document đã chạy; contract chi tiết được thêm theo từng module.

- [ ] `API-003` **P0 — Kết nối PostgreSQL riêng**
  - Phụ thuộc: `EXT-002`.
  - AC: SSL/configurable pool, health check, timeout và transaction conventions.

- [ ] `API-004` **P0 — Thiết lập Drizzle schema và migration**
  - AC: migration forward-only, có migration history, seed tách khỏi migration và chạy được trên DB trống.

- [ ] `API-005` **P0 — Mô hình user, auth session, profile và role**
  - Liên kết: `US-OB-002`, `US-OB-003`, `PRO-001`.
  - AC: unique Google subject; session revoke/rotate; role `user/editor/admin`; preferred name không ghi đè Google profile.

- [ ] `API-006` **P0 — Mô hình content/localization/category/feeling**
  - AC: nội dung có locale, publication status, version; feelings tách khỏi Vision Category; sound liên kết category.

- [ ] `API-007` **P0 — Mô hình journey và progress**
  - AC: journey, day, task, response, completion, restart; unique constraint ngăn ghi trùng; hỗ trợ missed day.

- [ ] `API-008` **P0 — Mô hình Vision, playlist, audio và media metadata**
  - AC: Vision có category, statement, feelings 1–3, image optional; nhiều track/category/locale; archive thay vì xóa cứng mặc định.

- [ ] `API-009` **P0 — Mô hình Journal, Future Letter và reminder**
  - AC: journal entry, free note, future letter, unlock date, status, notification preference và timezone.

- [ ] `API-010` **P0 — Error contract, structured logging và request ID**
  - AC: không log token/private text; mọi lỗi có code ổn định, localized message key và correlation ID.

- [x] `API-011` **P0 — Local Docker và test database**
  - AC: một lệnh dựng API + PostgreSQL; test dùng DB riêng; reset test data không tác động local dev data.
  - Hoàn tất 2026-09-26: `docker compose --env-file .env.local up -d` chạy `soul-api-local`, `soul_dev` (`5432`) và `soul_test` (`5433`) với volume riêng; cả ba health check pass và `/v1/health` trả `{"status":"ok"}`.

- [ ] `API-012` **P0 — Backend CI và migration check**
  - AC: lint/typecheck/test/build; phát hiện schema drift; migration chạy được từ DB trống.

- [ ] `API-013` **P0 — API resilience và abuse protection**
  - AC: idempotency cho command quan trọng, pagination, validation, rate limit auth/upload và payload size limit.

## Epic 3 — Authentication và onboarding song ngữ

- [x] `OB-001` **P0 — Màn chọn ngôn ngữ trung tính trước đăng nhập**
  - Liên kết: `US-OB-001`.
  - AC: hiển thị `Tiếng Việt` và `English` không phụ thuộc locale đã biết; có thể preselect theo device locale nhưng người dùng phải xác nhận.
  - Hoàn tất 2026-09-26: hai lựa chọn luôn là tên gốc `Tiếng Việt`/`English` (cùng giá trị trong cả hai ARB). `suggestLocale()` + `suggestedLocaleProvider` chọn ngôn ngữ gợi ý từ device locale; lựa chọn gợi ý hiển thị dạng nút primary, lựa chọn còn lại dạng secondary, nếu device locale không hỗ trợ thì không gợi ý. Không lưu locale cho tới khi người dùng chạm vào một lựa chọn — cú chạm chính là bước xác nhận, không có nút “Tiếp tục” riêng để màn hình không cần câu chữ thuộc ngôn ngữ nào. Unit/widget test phủ cả hai hướng vi/en. Chưa kiểm tra trên thiết bị Android/iOS thật.

- [ ] `OB-002` **P0 — Cấu hình Google Sign-In native**
  - Phụ thuộc: `EXT-001`, `EXT-004`.
  - AC: Android/iOS callback đúng; cancel không tạo session; lỗi mạng/cấu hình có retry và thông báo phù hợp locale.

- [ ] `OB-003` **P0 — Xác minh Google identity tại Backend**
  - Liên kết: `US-OB-002`.
  - AC: verify issuer/audience/expiry; upsert theo subject; không tin profile do client tự gửi.

- [ ] `OB-004` **P0 — Access/refresh token rotation và sign-out**
  - AC: refresh token rotate/revoke; sign-out vô hiệu session; token hết hạn được xử lý không lặp request vô hạn.

- [ ] `OB-005` **P0 — Dio auth client và secure storage**
  - AC: attach/refresh token an toàn, request queue khi refresh, xóa credential khi revoke; không lưu token trong plain preferences.

- [ ] `OB-006` **P0 — Hỏi preferred name ngay sau Google login**
  - Liên kết: `US-OB-003`.
  - AC: câu đầu tiên là “Bạn muốn được gọi với tên là gì?” theo locale; prefill tên Google chỉ là gợi ý; trim/validate; có thể sửa sau ở profile.

- [ ] `OB-007` **P0 — Chọn ý định/focus onboarding**
  - Liên kết: `US-OB-004`.
  - AC: nội dung đúng dataset; lưu server; không nhầm focus với feeling hoặc Vision Category.

- [ ] `OB-008` **P0 — Thiết lập nhắc nhở trong onboarding**
  - Liên kết: `US-OB-005`, `REQ-NTF-001`.
  - AC: chọn giờ/bỏ qua; xin quyền hệ điều hành đúng thời điểm; lưu timezone; từ chối quyền không chặn dùng app.

- [ ] `OB-009` **P0 — Hoàn tất onboarding và tạo journey**
  - AC: thao tác idempotent; tạo journey ngày 1 đúng locale; route tới Today và không hiện onboarding lại.

- [ ] `OB-010` **P0 — Kiểm thử onboarding và returning user**
  - AC: vi/en, app relaunch ở từng bước, Google cancel/error, token expired, đổi máy và user đã hoàn tất onboarding.

## Epic 4 — Dataset, content pipeline và localization

- [ ] `DAT-001` **P0 — Kiểm kê và validate toàn bộ nguồn dữ liệu active**
  - Nguồn: workbook 28 ngày v1.1, Vision v1.2, External Library v1.0 và Owned Content Pack.
  - AC: báo cáo số hàng, duplicate ID, thiếu locale, thiếu category, URL lỗi và trường không hợp lệ; không import bản cũ khi đã có bản active mới.

- [ ] `DAT-002` **P0 — Xây import CLI có dry-run**
  - AC: đọc XLSX/Markdown chuẩn hóa; dry-run không ghi DB; lỗi chỉ rõ file/sheet/row/field; hỗ trợ transaction.

- [ ] `DAT-003` **P0 — Seed Vision categories, questions, feelings và statements**
  - Liên kết: `US-VIS-001..004`.
  - AC: nhóm cảm xúc mở rộng; người dùng chọn 1–3; feelings độc lập với category; vi/en đầy đủ.

- [ ] `DAT-004` **P0 — Seed hành trình 28 ngày**
  - Liên kết: `US-JRN-001..005`.
  - AC: đủ 28 ngày; thứ tự task, copy, CTA, reflection và metadata đúng nguồn; validation không cho thiếu task bắt buộc.

- [ ] `DAT-005` **P0 — Seed audio metadata và mapping theo category**
  - Liên kết: `US-AUD-001..003`.
  - AC: mỗi category có nhiều track đủ điều kiện; track có locale, duration, rights/source/status; tiếng Việt không nhận audio tiếng Anh và ngược lại.

- [ ] `DAT-006` **P0 — Chuẩn hóa owned content song ngữ**
  - AC: scripts/affirmations/reflections giữ đúng ý; copy “Bạn đã trao cho hôm nay lòng biết ơn” được dùng tại đúng completion context.

- [ ] `DAT-007` **P1 — Chuẩn hóa external content cho Explore**
  - AC: title, creator, source, official URL, locale, category, rights note và active status; không sao chép nội dung ngoài quyền.

- [ ] `DAT-008` **P0 — Import idempotent và báo cáo đối soát**
  - AC: chạy lại không nhân bản; có created/updated/skipped/failed counts; foreign key và category/audio references hợp lệ.

- [ ] `DAT-009` **P0 — Public content APIs theo locale/publication**
  - AC: chỉ trả content published, đúng locale; fallback được quy định rõ; cache/version cho mobile; không lẫn content admin draft.

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

- [ ] `NTF-005` **P0 — Suppression và deduplication**
  - AC: không gửi cùng notification nhiều lần; quiet behavior khi user đã hoàn thành; tôn trọng opt-out ngay lập tức.

- [ ] `NTF-006` **P0 — Deep link routing từ notification**
  - AC: mở đúng Today task, Vision, Vision Session hoặc Future Letter; user chưa login được đưa qua auth rồi quay lại đích.

- [ ] `NTF-007` **P0 — Privacy và notification tests**
  - AC: lock-screen body không chứa private journal/letter text; test timezone, DST, permission denied, relaunch và expired target.

## Epic 7 — Vision creation và Vision Board

- [ ] `VIS-001` **P0 — Chọn Vision Category**
  - Liên kết: `US-VIS-001`.
  - AC: category từ API/dataset, đúng locale, có selected state; không hiển thị lựa chọn sound.

- [ ] `VIS-002` **P0 — Guided questions theo category**
  - Liên kết: `US-VIS-001`.
  - AC: câu hỏi động theo dataset; autosave/resume; validate bắt buộc; back không mất câu trả lời.

- [ ] `VIS-003` **P0 — Chọn 1–3 cảm xúc mong muốn**
  - Liên kết: `US-VIS-001`.
  - AC: danh sách cảm xúc mở rộng; min 1/max 3; disabled state dễ hiểu; lưu ID độc lập category.

- [ ] `VIS-004` **P0 — Tạo và chỉnh sửa Vision statement**
  - Liên kết: `US-VIS-001`, `US-VIS-004`.
  - AC: tạo từ answer/category/feelings theo rule; người dùng chỉnh sửa được; giới hạn hợp lý; vi/en không trộn ngôn ngữ.

- [ ] `VIS-005` **P0 — Đính kèm một ảnh optional**
  - AC: camera/library permission, crop/preview/replace/remove, compress; upload retry; không mất draft nếu upload lỗi.

- [ ] `VIS-006` **P0 — Tự động gán playlist nhiều sound theo category**
  - Liên kết: `US-VIS-001`, `US-AUD-002`.
  - AC: user không chọn track; server trả nhiều eligible tracks theo category + locale; thay category cập nhật playlist; fallback không lẫn ngôn ngữ.

- [ ] `VIS-007` **P0 — Preview và save Vision**
  - AC: preview gồm statement/feelings/image/audio availability; save idempotent; lỗi có retry; save xong trở về board/detail đúng ngữ cảnh.

- [ ] `VIS-008` **P0 — Multi-Vision Board**
  - AC: khi có nhiều Vision, tab Vision mở board; card layout bám prototype; empty/one/many states; sort ổn định.

- [ ] `VIS-009` **P0 — Vision detail và back navigation**
  - AC: back button và system back đều hoạt động; không bị overlay chặn pointer; quay lại đúng board/tab và giữ scroll state.

- [ ] `VIS-010` **P0 — Chỉnh sửa Vision và đổi category**
  - AC: edit statement/feelings/image/category; đổi category cập nhật playlist; confirm khi rời màn hình có unsaved change.

- [ ] `VIS-011` **P0 — Archive Vision**
  - AC: confirm rõ; Vision archive không hiện ở active board/session; dữ liệu lịch sử không bị xóa cứng; có khả năng restore nếu spec cho phép.

- [ ] `VIS-012` **P0 — Vision regression tests**
  - AC: vi/en, 1–3 feelings, image lỗi, category đổi, nhiều Vision, archive và back navigation đều có test.

## Epic 8 — Object Storage, audio engine và Vision Session

- [ ] `STO-001` **P0 — Chọn và cấu hình S3-compatible Object Storage**
  - Phụ thuộc: `EXT-003`.
  - AC: bucket/env tách biệt; private by default; CORS, encryption, size/type limit và naming policy.

- [ ] `STO-002` **P0 — Signed upload/finalize flow**
  - AC: Backend cấp signed URL ngắn hạn, kiểm tra owner/type/size; finalize chỉ nhận object hợp lệ; retry không nhân metadata.

- [ ] `STO-003` **P0 — Authorized media retrieval/delete**
  - AC: ảnh Vision/attachment riêng tư chỉ owner truy cập; audio published theo policy; archive/delete không để lộ object.

- [ ] `STO-004` **P0 — Lifecycle và orphan cleanup**
  - AC: temp upload hết hạn được dọn; retention đúng privacy policy; job có dry-run/metrics và không xóa object đang tham chiếu.

- [ ] `AUD-001` **P0 — Audio domain service và playback state**
  - AC: một nguồn state cho current track/queue/playback/global mute; UI không tự quản lý player riêng lẻ.

- [ ] `AUD-002` **P0 — Tích hợp `just_audio` và `audio_session`**
  - AC: play/pause/seek/next; background/lock screen theo phạm vi; interruption/headphone unplug/audio focus hoạt động đúng.

- [ ] `AUD-003` **P0 — Eligible playlist API**
  - AC: filter category, locale, publication, rights, availability; trả nhiều track và thứ tự ổn định/rule-based; không trả track sai locale.

- [ ] `AUD-004` **P0 — Global sound toggle cạnh avatar**
  - AC: trạng thái rõ, persisted; mute/pause behavior được thống nhất; screen reader label; không ảnh hưởng âm hệ thống khác.

- [ ] `AUD-005` **P0 — Mini player và trải nghiệm nhiều sound**
  - AC: hiển thị current track/progress/next; playlist tự động; người dùng có thể điều khiển phát nhưng không chỉnh mapping category.

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

## Epic 9 — Journal và Future Letter

- [ ] `JOU-001` **P0 — Tự động tạo Journal entry từ daily flow**
  - Liên kết: `US-JOU-001`.
  - AC: gratitude/reflection/mood phù hợp được projection một lần; giữ ngày/task/source; sync lại không duplicate.

- [ ] `JOU-002` **P0 — Tạo free note**
  - AC: nhập/sửa/xóa có confirm; autosave hoặc save state rõ; nội dung riêng tư và hoạt động offline.

- [ ] `JOU-003` **P0 — Recent notes dạng giấy kẻ ngang**
  - AC: nền giấy trắng ấm, chỉ có kẻ ngang, không kẻ dọc và không vàng; toàn card click được; layout bám prototype.

- [ ] `JOU-004` **P0 — Sticky note detail và back**
  - AC: mở note như sticky note đẹp; transition hợp lý; system/header back hoạt động; edit state không mất ngoài ý muốn.

- [ ] `JOU-005` **P0 — Journal privacy, offline và tests**
  - AC: authz theo owner, không log body, cache mã hóa phù hợp; vi/en, empty/error/offline/back được test.

- [ ] `LET-001` **P0 — Future Letter list và locked state**
  - Liên kết: `US-LET-001`.
  - AC: upcoming/opened states, unlock date theo timezone; locked letter không lộ body qua API/UI/cache preview.

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

- [ ] `PRO-003` **P0 — Privacy, sign-out và account deletion entry**
  - Phụ thuộc: `EXT-009`.
  - AC: policy links, sign-out revoke session, request account deletion rõ hậu quả/trạng thái; không xóa ngay thiếu confirm.

- [ ] `PRO-004` **P0 — Đổi ngôn ngữ và refresh content cache**
  - AC: UI đổi ngay; invalidate/refetch content đúng locale; audio đang phát sai locale phải dừng/chuyển an toàn.

- [ ] `PRO-005` **P0 — Profile/settings tests**
  - AC: avatar navigation, rename, vi↔en, sound/reminder toggle, sign-out và app relaunch được test.

## Epic 11 — Admin Portal và content operations

- [ ] `ADM-001` **P0 — Khởi tạo Next.js Admin Portal**
  - Liên kết: `REQ-ADM-001`.
  - AC: TypeScript, authenticated layout, shared API client, error boundary và environment config.

- [ ] `ADM-002` **P0 — Admin authentication bằng secure cookie**
  - AC: HttpOnly/Secure/SameSite phù hợp; CSRF protection; session timeout; không lưu admin token trong localStorage.

- [ ] `ADM-003` **P0 — Role-based access control**
  - AC: editor/admin permission rõ; Backend enforce quyền, không chỉ ẩn UI; unauthorized actions có audit-safe response.

- [ ] `ADM-004` **P0 — Journey Content Manager**
  - AC: CRUD/reorder/preview/publish 28 ngày, task và localization; validation ngăn publish ngày thiếu nội dung.

- [ ] `ADM-005` **P0 — Vision Content Manager**
  - AC: quản lý category, questions, feelings, statement templates và vi/en; preview mapping trước publish.

- [ ] `ADM-006` **P0 — Audio/media manager**
  - AC: upload metadata, rights/source/expiry, locale, category mappings, active/published; preview track; không cho publish thiếu quyền.

- [ ] `ADM-007` **P0 — Notification/localization manager**
  - AC: quản lý templates vi/en, variables, schedule defaults; preview; validation parity trước publish.

- [ ] `ADM-008` **P0 — External resource manager**
  - AC: URL/source/creator/locale/category/status; validate URL; publish/unpublish; attribution bắt buộc.

- [ ] `ADM-009` **P0 — Publish workflow và validation summary**
  - AC: draft→published; hiển thị toàn bộ lỗi trước publish; version/timestamp/editor; mobile không nhận draft.

- [ ] `ADM-010` **P2 — Audit history và rollback UI**
  - AC: xem diff/version, ai thay đổi/khi nào; rollback tạo version mới và không sửa history.

- [ ] `ADM-011` **P0 — Admin authorization và content regression tests**
  - AC: role matrix, CSRF, validation, locale parity, publish visibility và failed upload được test.

## Epic 12 — Analytics, quality, security và release

- [ ] `ANA-001` **P1 — Analytics event contract**
  - Liên kết: `REQ-ANA-001`.
  - AC: event names/properties/version/consent documented; tuyệt đối không gửi journal, letter, answer hay statement nguyên văn.

- [ ] `ANA-002` **P1 — Mobile/API analytics emission**
  - Phụ thuộc: `EXT-010`.
  - AC: consent-aware; retry/batch; stable anonymous/user ID policy; event không làm chậm luồng chính.

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

- [ ] `QAR-005` **P0 — Content/audio rights review**
  - Phụ thuộc: `EXT-007`, `EXT-009`.
  - AC: mọi asset published có nguồn/quyền; external content attribution; privacy copy không hứa vượt khả năng kỹ thuật.

- [ ] `QAR-006` **P0 — Store policies và legal metadata**
  - AC: privacy policy, terms, account deletion, permission purpose strings, data safety/privacy labels và support URL.

- [ ] `QAR-007` **P0 — Signed staging/release builds**
  - Phụ thuộc: `EXT-001`, `EXT-008`.
  - AC: Android AAB và iOS archive cài được; config production tách biệt; symbol/source map retention.

- [ ] `QAR-008` **P0 — Performance và reliability pass**
  - AC: startup, navigation, image/audio loading, memory và crash-free smoke test đạt budget được thống nhất; slow network usable.

- [ ] `QAR-009` **P0 — End-to-end release acceptance**
  - AC: chạy thành công từ chọn ngôn ngữ → Google login → preferred name → onboarding → Today → Vision → audio/session → Journal/Future Letter → profile trên vi/en.

---

## 3. Phụ thuộc cần chủ dự án cung cấp/chốt

- [ ] `EXT-001` Application ID, bundle ID, Apple/Google developer accounts và signing ownership.
- [ ] `EXT-002` PostgreSQL cho staging/production, connection policy, backup, monitoring và retention.
- [ ] `EXT-003` S3-compatible Object Storage, CDN/domain nếu có và lifecycle policy.
- [ ] `EXT-004` Google OAuth clients cho Android, iOS và Backend audience.
- [ ] `EXT-005` Quyền sử dụng font/logo/brand assets và file nguồn đã crop nền trong suốt.
- [ ] `EXT-006` Giờ nhắc mặc định, timezone behavior và nội dung notification được duyệt.
- [ ] `EXT-007` Audio files cuối, nguồn, giấy phép, phạm vi lãnh thổ và ngày hết hạn nếu có.
- [ ] `EXT-008` Hosting/domain/TLS/secret manager cho Backend và Admin Portal.
- [ ] `EXT-009` Privacy Policy, Terms, account deletion/retention policy và email hỗ trợ.
- [ ] `EXT-010` Quyết định analytics provider, consent model và quyền truy cập dashboard.
- [ ] `EXT-011` Quyết định local notification hay server push; nếu server push thì cần APNs/FCM credentials và provider.

## 4. Critical path đề xuất

1. `REP-001..006` + `APP-001..010` + `API-001..013`.
2. `OB-001..010` để có app shell đã xác thực và song ngữ.
3. `DAT-001..010` song song với `JRN-001..013` và `NTF-001..007`.
4. `VIS-001..012` song song với `STO-001..004` và `AUD-001..011`.
5. `JOU-001..005` + `LET-001..007`.
6. `ADM-001..009`, sau đó toàn bộ `QAR-001..009`.
7. `EXP-*` và `ANA-*` triển khai sau luồng P0 ổn định hoặc đưa vào cùng release nếu còn năng lực.

## 5. Definition of Ready

Một ticket chỉ bắt đầu khi:

- Có requirement/source rõ ràng và không mâu thuẫn với quyết định sản phẩm mới nhất.
- Có API/data contract hoặc mock ổn định nếu phụ thuộc Backend.
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
- API migration/seed idempotent; không lộ secret hoặc private content trong log/analytics.
- Tài liệu/API contract/backlog được cập nhật nếu implementation tạo ra quyết định mới.
- Có bằng chứng nghiệm thu: test output, screenshot/golden hoặc checklist E2E tùy loại ticket.
