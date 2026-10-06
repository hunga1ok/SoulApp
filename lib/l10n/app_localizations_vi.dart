// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Soul';

  @override
  String get today => 'Hôm nay';

  @override
  String get vision => 'Tầm nhìn';

  @override
  String get journal => 'Nhật ký';

  @override
  String get explore => 'Khám phá';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String welcome(Object name) {
    return 'Chào $name';
  }

  @override
  String get whatShouldWeCallYou => 'Bạn muốn Soul gọi bạn là gì?';

  @override
  String get nameHint => 'Tên hoặc cách xưng hô bạn yêu thích';

  @override
  String get saveAndContinue => 'Lưu và tiếp tục';

  @override
  String get todayRhythm => 'Nhịp của hôm nay';

  @override
  String get oneSmallAction => 'Một hành động nhỏ';

  @override
  String get smallActionText =>
      'Gửi một lời tri ân thầm lặng hoặc trao nụ cười dịu dàng cho người bạn gặp hôm nay.';

  @override
  String get recent => 'Ghi chú gần đây';

  @override
  String get oneNote => '1 ghi chú';

  @override
  String get gratitudeToday => 'BIẾT ƠN · HÔM NAY';

  @override
  String get gratitudeNote => 'Tôi biết ơn cuộc sống này';

  @override
  String get gratitudeJournalTitle => 'Nhật ký biết ơn';

  @override
  String get gratitudeJournalHint =>
      'Mỗi khoảnh khắc biết ơn là một hạt mầm bình an gieo vào tâm trí.';

  @override
  String get gratitudeNoteLabel => 'Hôm nay bạn biết ơn điều gì?';

  @override
  String get saveNote => 'Lưu ghi chú';

  @override
  String get gratitudeNotesEmpty =>
      'Bạn chưa có ghi chú nào. Hãy chạm nút bên dưới để viết ghi chú đầu tiên nhé.';

  @override
  String get yourVisions => 'Bảng tầm nhìn của bạn';

  @override
  String get createVision => 'Tạo một tầm nhìn';

  @override
  String get visionEmptyTitle => 'Dành chỗ cho những ước mơ';

  @override
  String get visionEmptyBody =>
      'Một tầm nhìn tươi đẹp bắt đầu từ những ước nguyện chân thật nhất của trái tim.';

  @override
  String get audioPending => 'Đang cập nhật audio';

  @override
  String get visionAudio => 'Âm thanh cho tầm nhìn';

  @override
  String get visionAudioBody =>
      'Chọn nhạc từ Soul, chọn file từ máy hoặc tự ghi âm lời khẳng định cho tầm nhìn này.';

  @override
  String get visionAudioEmpty => 'Chưa có âm thanh đồng hành.';

  @override
  String get visionAudioPersonal => 'Chỉ lưu trên thiết bị này';

  @override
  String get addAudio => 'Thêm audio';

  @override
  String get audioLibrary => 'Thư viện âm thanh';

  @override
  String get chooseFromAudioLibrary => 'Chọn từ thư viện Soul';

  @override
  String get chooseAudioFile => 'Chọn file audio từ máy';

  @override
  String get recordAudio => 'Tự ghi âm giọng nói';

  @override
  String get stopRecording => 'Dừng và lưu bản ghi';

  @override
  String get myRecording => 'Bản ghi âm của tôi';

  @override
  String get removeAudio => 'Bỏ audio';

  @override
  String get audioGuided => 'Audio hướng dẫn tĩnh tâm';

  @override
  String get audioMusic => 'Âm nhạc trị liệu & Tần số';

  @override
  String get audioRest => 'Thiên nhiên & Thư giãn sâu';

  @override
  String get audioLibraryNote =>
      'Tuyển tập những thanh âm dịu nhẹ, tần số 432Hz/528Hz giúp tĩnh tâm và nâng cao tần số rung động.';

  @override
  String get nowPlaying => 'Đang phát';

  @override
  String get stop => 'Dừng';

  @override
  String get allAudio => 'Tất cả';

  @override
  String get audioNature => 'Thiên nhiên & Thư giãn';

  @override
  String get audioMusicTab => 'Nhạc & Tần số';

  @override
  String get audioGuidedTab => 'Bài dẫn thiền';

  @override
  String get recommendedForVision => 'Đề xuất cho tầm nhìn này';

  @override
  String get exploreTitle => 'Góc nuôi dưỡng tâm hồn';

  @override
  String get exploreBody =>
      'Khám phá thanh âm chữa lành, bài thiền định và những câu chuyện truyền cảm hứng sống đẹp.';

  @override
  String get exploreTabAll => 'Tất cả';

  @override
  String get exploreTabAudio => 'Âm thanh Soul';

  @override
  String get exploreTabMeditation => 'Bài thiền định';

  @override
  String get exploreTabPodcast => 'Podcast & Cảm hứng';

  @override
  String get exploreTabFrequency => 'Tần số năng lượng';

  @override
  String get exploreOpenYouTube => 'Mở trên YouTube';

  @override
  String get exploreOpenSpotify => 'Nghe trên Spotify';

  @override
  String get profile => 'Hồ sơ & cài đặt';

  @override
  String get soundOn => 'Bật âm thanh';

  @override
  String get soundOff => 'Tắt âm thanh';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get editName => 'Đổi tên xưng hô';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get back => 'Quay lại';

  @override
  String dayProgress(int day) {
    return 'Ngày $day trên 28';
  }

  @override
  String get authTagline =>
      'Một khoảng không gian riêng tư và dịu lành cho tâm hồn bạn.';

  @override
  String get morningGratitude => 'Biết ơn buổi sáng';

  @override
  String get neutralInstrumentalFiveMinutes => 'Piano dịu êm · 5 phút';

  @override
  String get play => 'Phát';

  @override
  String get vietnameseLanguage => 'Tiếng Việt';

  @override
  String get englishLanguage => 'English';

  @override
  String get languageEndonymVi => 'Tiếng Việt';

  @override
  String get languageEndonymEn => 'English';

  @override
  String get retry => 'Thử lại';

  @override
  String get loading => 'Đang tải...';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get cancel => 'Hủy';

  @override
  String get somethingWentWrong => 'Đã có lỗi xảy ra. Bạn thử lại nhé.';

  @override
  String get save => 'Lưu';

  @override
  String nameTooLong(int max) {
    return 'Tên tối đa $max ký tự thôi nhé.';
  }

  @override
  String get intentionTitle => 'Điều gì đưa bạn đến với Soul?';

  @override
  String get intentionBody =>
      'Hãy chọn những điều bạn mong muốn nuôi dưỡng lúc này. Không có câu trả lời nào là sai.';

  @override
  String get intentionChooseOne => 'Chọn ít nhất một điều để bắt đầu nhé.';

  @override
  String get remindersTitle => 'Một nhịp nhỏ cho mỗi ngày';

  @override
  String get remindersBody =>
      'Chọn hai khoảng thời gian dịu dàng để bắt đầu và khép lại ngày an yên.';

  @override
  String get reminderMorning => 'Nhắc nhở buổi sáng';

  @override
  String get reminderEvening => 'Nhìn lại buổi tối';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return 'Đổi giờ nhắc $reminder, hiện là $time';
  }

  @override
  String get skipForNow => 'Để sau';

  @override
  String get journeyReadyTitle => 'Hành trình 28 ngày đã sẵn sàng';

  @override
  String get journeyReadyBody =>
      'Bạn không cần phải hoàn hảo. Chỉ cần mỗi ngày dành ra 5 phút quay về với chính mình.';

  @override
  String get beginDayOne => 'Bắt đầu Ngày 1';

  @override
  String get chooseCategoryTitle => 'Chọn một lĩnh vực';

  @override
  String get chooseCategoryBody =>
      'Bạn muốn hướng trọn sự chú ý và năng lượng vào điều gì lúc này?';

  @override
  String visionStepLabel(Object category, int step, int total) {
    return '$category · $step/$total';
  }

  @override
  String chooseUpTo(int max) {
    return 'Chọn tối đa $max.';
  }

  @override
  String get answerRequiredHint =>
      'Chọn một gợi ý gần gũi hoặc viết mong ước của riêng bạn.';

  @override
  String get visionQuickStart => 'Tiếp tục với cảm xúc';

  @override
  String get feelingsTitle =>
      'Bạn muốn cảm thấy thế nào khi điều đó đang diễn ra?';

  @override
  String get feelingsHint => 'Chọn từ 1 đến 3 cảm xúc sâu lắng nhất.';

  @override
  String get feelingsLimitReached =>
      'Bạn đã chọn đủ 3 cảm xúc. Hãy bỏ bớt một cảm xúc nếu muốn đổi.';

  @override
  String get statementTitle => 'Tuyên ngôn tầm nhìn của bạn';

  @override
  String get statementBody =>
      'Soul đã xâu chuỗi những ước nguyện của bạn thành câu khẳng định này. Bạn hoàn toàn có thể chỉnh sửa lại cho thật vừa vặn.';

  @override
  String get statementLabel => 'Câu khẳng định tầm nhìn';

  @override
  String get statementEmpty =>
      'Hãy viết câu tầm nhìn của bạn trong 1 - 2 câu truyền cảm hứng.';

  @override
  String statementTooLong(int max) {
    return 'Tối đa $max ký tự thôi nhé.';
  }

  @override
  String get visionImageTitle => 'Đưa tầm nhìn vào cảm nhận';

  @override
  String get visionImageBody =>
      'Một bức ảnh đẹp sẽ giúp tâm trí bạn dễ dàng hình dung và rung động hơn.';

  @override
  String get chooseFromLibrary => 'Chọn từ thư viện ảnh';

  @override
  String get takePhoto => 'Chụp ảnh mới';

  @override
  String get removePhoto => 'Xóa ảnh';

  @override
  String get visionPhoto => 'Ảnh tầm nhìn';

  @override
  String get photoUnavailable => 'Không thể hiển thị ảnh này.';

  @override
  String get reviewVisionTitle => 'Xem lại tầm nhìn';

  @override
  String get saveToVisionBoard => 'Lưu vào vision board';

  @override
  String get visionSaveFailed =>
      'Chưa lưu được tầm nhìn. Lựa chọn của bạn vẫn còn nguyên — hãy thử lại nhé.';

  @override
  String get archiveVision => 'Lưu trữ tầm nhìn';

  @override
  String get archiveVisionTitle => 'Lưu trữ tầm nhìn này?';

  @override
  String get archiveVisionBody =>
      'Tầm nhìn sẽ rời khỏi bảng hiện tại và lưu vào kho lưu trữ an toàn.';

  @override
  String get archive => 'Lưu trữ';

  @override
  String get visionNotFound => 'Tầm nhìn này không còn trên bảng của bạn.';

  @override
  String get visionSoundtrack => 'Âm thanh đồng hành';

  @override
  String get visionBoardSubtitle =>
      'Nơi neo giữ những mục tiêu, hình ảnh và cảm xúc tươi đẹp bạn muốn chạm tới mỗi ngày.';

  @override
  String get welcomeTitle1 => 'Chào mừng bạn đến với Soul';

  @override
  String get welcomeSubtitle1 =>
      'Một không gian dịu lành để bạn lắng lại, kết nối sâu sắc và nuôi dưỡng sự bình an trong tâm hồn mỗi ngày.';

  @override
  String get welcomeTitle2 => '28 Ngày Nuôi Dưỡng Lòng Biết Ơn';

  @override
  String get welcomeSubtitle2 =>
      'Thực hành chuyển hóa tư duy từ những điều dung dị, đánh thức nguồn năng lượng an vui và tích cực.';

  @override
  String get welcomeTitle3 => 'Bảng Tầm Nhìn & Âm Thanh Trị Liệu';

  @override
  String get welcomeSubtitle3 =>
      'Hiện thực hóa ước mơ bằng bảng tầm nhìn sống động cùng những bản nhạc tần số nâng cao rung cảm.';

  @override
  String get startJourney => 'Bắt đầu hành trình';

  @override
  String get revisitOnboarding => 'Trải nghiệm lại phần Giới thiệu';

  @override
  String get todayGreeting => 'Chúc bạn một ngày an yên và trọn vẹn ✨';

  @override
  String get todayJourneyHeroTitle => '10 Điều Biết Ơn Hôm Nay';

  @override
  String get todayJourneyHeroSubtitle =>
      'Dành vài phút buổi sáng để gọi tên những phúc lành đang hiện diện và cảm nhận ý nghĩa sâu xa của chúng.';

  @override
  String get todayStartPractice => 'Bắt đầu thực hành';

  @override
  String get todayContinuePractice => 'Tiếp tục thực hành';

  @override
  String get todayPracticeCompleted => 'Đã hoàn thành hôm nay ✨';

  @override
  String get moodCheckInTitle => 'Cảm xúc của bạn lúc này?';

  @override
  String get moodPeaceful => 'Bình an 🕊️';

  @override
  String get moodGrateful => 'Biết ơn 🌸';

  @override
  String get moodEnergized => 'Năng lượng ☀️';

  @override
  String get moodRelieved => 'Nhẹ nhõm 🍃';

  @override
  String get moodReflective => 'Lắng đọng 🌙';

  @override
  String get eveningReflectionTitle => 'Nhìn lại buổi tối';

  @override
  String get eveningReflectionBody =>
      'Trước khi chìm vào giấc ngủ, hãy nghĩ về điều tuyệt vời nhất đã đến với bạn trong ngày hôm nay.';

  @override
  String get gratitudePracticeTitle => 'Buổi sáng biết ơn';

  @override
  String get gratitudePracticeIntroTitle =>
      'Bắt đầu ngày mới bằng sự trân trọng';

  @override
  String get gratitudePracticeIntroBody =>
      'Dành vài phút để nhận ra 10 điều đang nâng đỡ bạn hôm nay, và ghi lại vì sao điều đó có ý nghĩa với bạn.';

  @override
  String get gratitudeStartPractice => 'Bắt đầu bài tập';

  @override
  String gratitudeItemProgress(int current, int total) {
    return 'Điều $current trên $total';
  }

  @override
  String get gratitudeFieldPrompt => 'Tôi biết ơn...';

  @override
  String get gratitudeFieldPlaceholder =>
      'Ghi lại một điều bạn trân trọng hôm nay';

  @override
  String get gratitudeReasonPrompt => 'Vì sao...';

  @override
  String get gratitudeReasonPlaceholder =>
      'Vì sao điều này quan trọng với bạn?';

  @override
  String gratitudeTapThankYou(int count) {
    return 'Nói lời \"Cảm ơn\" ($count/3)';
  }

  @override
  String get gratitudeTapHint => 'Chạm 3 lần để khắc sâu cảm xúc biết ơn';

  @override
  String get gratitudeAddAndNext => 'Thêm & Tiếp tục';

  @override
  String get gratitudeReviewTitle => '10 điều biết ơn của bạn hôm nay';

  @override
  String get gratitudeReviewSubtitle =>
      'Xem lại danh sách trước khi khép lại bài tập.';

  @override
  String get gratitudeCompletePractice => 'Hoàn tất bài tập';

  @override
  String get gratitudeCompletedTitle => 'Hoàn thành bài tập ✨';

  @override
  String get gratitudeCompletedBody =>
      'Bạn đã gieo 10 hạt mầm biết ơn vào ngày mới. Các mục này đã được lưu vào nhật ký của bạn.';

  @override
  String get gratitudeBackToToday => 'Về trang Hôm nay';

  @override
  String get gratitudeStatusIncomplete => 'Chưa hoàn thành';

  @override
  String get gratitudeStatusCompleted => 'Đã hoàn thành 10/10 điều';

  @override
  String get gratitudeCardTapToStart => 'Bắt đầu bài tập sáng';

  @override
  String get gratitudeCardTapToReview => 'Xem lại 10 điều biết ơn';

  @override
  String get editEntry => 'Sửa';

  @override
  String get done => 'Xong';

  @override
  String gratitudeReasonLabel(String reason) {
    return 'Lý do: $reason';
  }

  @override
  String get gratitudeFinishEarly => 'Hoàn thành sớm';

  @override
  String get gratitudeSkipItem => 'Bỏ qua điều này';

  @override
  String get gratitudeSkipProgress => 'Bỏ qua tiến trình';

  @override
  String get gratitudeSkippedTitle => 'Đã bỏ qua bài thực hành';

  @override
  String get gratitudeSkippedBody =>
      'Bạn đã bỏ qua bài thực hành biết ơn hôm nay. Bạn có thể quay lại thực hành bất cứ khi nào sẵn sàng.';

  @override
  String gratitudeReviewTitleCount(int count) {
    return '$count điều biết ơn của bạn hôm nay';
  }

  @override
  String gratitudeCompletedBodyCount(int count) {
    return 'Bạn đã gieo $count hạt mầm biết ơn vào ngày mới. Các mục này đã được lưu vào nhật ký của bạn.';
  }

  @override
  String gratitudeStatusCompletedCount(int count) {
    return 'Đã hoàn thành $count điều biết ơn';
  }

  @override
  String get gratitudeLevelLow => 'Cảm ơn';

  @override
  String get gratitudeLevelMedium => 'Rất cảm ơn';

  @override
  String get gratitudeLevelHigh => 'Biết ơn sâu sắc';

  @override
  String get gratitudeTapLevelHint => 'Chọn mức độ biết ơn';

  @override
  String get signOutConfirmTitle => 'Đăng xuất khỏi Soul?';

  @override
  String get signOutConfirmBody =>
      'Bạn có chắc chắn muốn đăng xuất? Thiết bị sẽ quay về màn hình ban đầu.';

  @override
  String get addNote => 'Thêm ghi chú mới';

  @override
  String get newGratitudeNote => 'Ghi chú biết ơn mới';

  @override
  String get notePromptPlaceholder => 'Hôm nay bạn biết ơn điều gì?';

  @override
  String get noteReasonPlaceholder =>
      'Vì sao điều này có ý nghĩa với bạn? (tùy chọn)';

  @override
  String get deleteNote => 'Xóa ghi chú';

  @override
  String get deleteNoteConfirmTitle => 'Xóa ghi chú này?';

  @override
  String get deleteNoteConfirmBody =>
      'Ghi chú này sẽ bị xóa vĩnh viễn khỏi nhật ký của bạn.';

  @override
  String get noteSaved => 'Đã lưu ghi chú vào nhật ký';

  @override
  String get noteDeleted => 'Đã xóa ghi chú';

  @override
  String notesCount(int count) {
    return '$count ghi chú';
  }

  @override
  String get reminderSettingsTitle => 'Giờ gửi thông báo';

  @override
  String get reminderSettingsSubtitle =>
      'Soul sẽ gửi lời nhắc nhẹ nhàng vào những thời điểm bạn chọn.';

  @override
  String get settingsSectionTitle => 'Cài đặt';

  @override
  String get accountSectionTitle => 'Tài khoản';

  @override
  String get saveSettings => 'Lưu thay đổi';

  @override
  String get settingsSaved => 'Đã lưu cài đặt';

  @override
  String get close => 'Đóng';

  @override
  String get customNoteDefaultTheme => 'Khoảnh khắc biết ơn';

  @override
  String gratitudeSentenceCount(int count) {
    return '$count điều biết ơn';
  }

  @override
  String get allGratitudesInNote => 'Nội dung ghi chú';

  @override
  String get sentencePreview => 'Xem trước câu hoàn chỉnh:';

  @override
  String get soulCardsTitle => 'Rút thẻ thông điệp';

  @override
  String get soulCardsSubtitle =>
      'Lắng nghe thông điệp dẫn dắt cho tâm hồn bạn';

  @override
  String dailyDrawRemaining(int count) {
    return 'Còn $count lần rút hôm nay';
  }

  @override
  String get dailyDrawLimitReached => 'Đã rút đủ 2 thông điệp hôm nay';

  @override
  String get dailyDrawLimitHint =>
      'Hãy lắng đọng và suy ngẫm cùng thông điệp hôm nay. Ngày mai bạn có thể rút tiếp nhé.';

  @override
  String get drawCardAction => 'Rút thông điệp';

  @override
  String get drawAnotherCard => 'Rút thêm thông điệp';

  @override
  String get reviewTodayCards => 'Xem thông điệp hôm nay';

  @override
  String get cardDrawSuccess => 'Thông điệp dành cho bạn';

  @override
  String get todayCardDrawBanner => 'Thông điệp tâm hồn';

  @override
  String get chooseDeckPrompt => 'Chọn một bộ thẻ để lắng nghe thông điệp';

  @override
  String get tapCardToReveal => 'Chạm vào lá bài để mở thông điệp';

  @override
  String get saveToJournalAction => 'Lưu vào nhật ký';

  @override
  String get savedToJournalSuccess => 'Đã lưu thông điệp vào nhật ký';

  @override
  String get cardDrawHistory => 'Lịch sử rút thẻ';

  @override
  String deckCardCount(int count) {
    return '$count lá bài';
  }

  @override
  String get soulCardsTab => 'Rút thẻ';

  @override
  String get dailyDrawLimitDialogTitle => 'Đã đủ 2 thông điệp hôm nay';

  @override
  String get dailyDrawLimitDialogMessage =>
      'Hôm nay bạn đã nhận đủ 2 thông điệp dẫn lối rồi. Hãy lắng đọng và suy ngẫm cùng thông điệp hôm nay nhé. Ngày mai bạn có thể rút tiếp.';

  @override
  String get understood => 'Đã hiểu';

  @override
  String get chooseDeckSubtitle =>
      'Chọn một bộ thẻ để lắng nghe thông điệp dành cho bạn';

  @override
  String get drawFromThisDeck => 'Rút thẻ bộ này';

  @override
  String get gratitudeJournalPrompt =>
      'Ngày hôm nay, bạn bắt đầu trên hành trình biết ơn của mình. Hãy dành thời gian và tâm trí nghĩ về những điều khiến bạn biết ơn, dù là rất nhỏ bé. Cấu trúc gợi ý:\n\"Tôi biết ơn... vì...\"\nSau đó bạn hãy đọc lại những điều bạn vừa viết cùng với lòng biết ơn sâu sắc.';

  @override
  String get gratitudeJournalPlaceholder =>
      'Viết những điều bạn biết ơn hôm nay như một trang nhật ký bình yên...\n\nVí dụ:\nTôi biết ơn tách cà phê ấm áp buổi sáng vì đã mang lại cho tôi sự tỉnh táo và an lành.\nTôi biết ơn nụ cười của một người bạn vì đã sưởi ấm tâm hồn tôi...';

  @override
  String get addPhoto => 'Thêm ảnh';

  @override
  String get changePhoto => 'Đổi ảnh';

  @override
  String get insertPromptTemplate => 'Chèn mẫu câu';

  @override
  String get saveAndCompleteJournal => 'Hoàn thành & Lưu nhật ký';

  @override
  String get gratitudePromptTemplateText => 'Tôi biết ơn ... vì ...';

  @override
  String get chooseTheme => 'Chọn chủ đề';

  @override
  String get editNote => 'Chỉnh sửa ghi chú';

  @override
  String get noteUpdated => 'Đã cập nhật ghi chú';

  @override
  String get gratitudeGuidanceTitle => 'Hướng dẫn thực hành hôm nay';

  @override
  String get showGuidance => 'Xem hướng dẫn';

  @override
  String get hideGuidance => 'Thu gọn hướng dẫn';
}
