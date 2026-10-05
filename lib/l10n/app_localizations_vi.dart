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
  String get whatShouldWeCallYou => 'Bạn muốn được gọi với tên là gì?';

  @override
  String get nameHint => 'Tên bạn muốn được gọi';

  @override
  String get saveAndContinue => 'Lưu và tiếp tục';

  @override
  String get todayRhythm => 'Nhịp của hôm nay';

  @override
  String get oneSmallAction => 'Một hành động nhỏ';

  @override
  String get smallActionText => 'Hãy hít một hơi thật dịu trước khi bước tiếp.';

  @override
  String get recent => 'Gần đây';

  @override
  String get oneNote => '1 ghi chú';

  @override
  String get gratitudeToday => 'BIẾT ƠN · HÔM NAY';

  @override
  String get gratitudeNote => 'Tôi biết ơn cuộc sống này';

  @override
  String get gratitudeJournalTitle => 'Ghi chú biết ơn';

  @override
  String get gratitudeJournalHint =>
      'Hãy viết như đang ghi note trên điện thoại. Một ý nghĩ, một khoảnh khắc hoặc một danh sách đều được.';

  @override
  String get gratitudeNoteLabel => 'Hôm nay bạn biết ơn điều gì?';

  @override
  String get saveNote => 'Lưu ghi chú';

  @override
  String get gratitudeNotesEmpty => 'Những ghi chú của bạn sẽ xuất hiện ở đây.';

  @override
  String get yourVisions => 'Những tầm nhìn của bạn';

  @override
  String get createVision => 'Tạo một tầm nhìn';

  @override
  String get visionEmptyTitle => 'Dành chỗ cho điều quan trọng';

  @override
  String get visionEmptyBody =>
      'Một tầm nhìn có thể bắt đầu từ một cảm xúc thật lòng.';

  @override
  String get audioPending => 'Đang chờ bản audio hoàn chỉnh';

  @override
  String get visionAudio => 'Âm thanh cho tầm nhìn';

  @override
  String get visionAudioBody =>
      'Chọn nhạc từ Soul, một file trên thiết bị hoặc ghi âm riêng cho tầm nhìn này.';

  @override
  String get visionAudioEmpty => 'Chưa có âm thanh nào được thêm.';

  @override
  String get visionAudioPersonal => 'Chỉ có trên thiết bị này';

  @override
  String get addAudio => 'Thêm audio';

  @override
  String get audioLibrary => 'Thư viện audio';

  @override
  String get chooseFromAudioLibrary => 'Chọn từ thư viện Soul';

  @override
  String get chooseAudioFile => 'Chọn file audio từ thiết bị';

  @override
  String get recordAudio => 'Tự ghi âm';

  @override
  String get stopRecording => 'Dừng và lưu bản ghi';

  @override
  String get myRecording => 'Bản ghi của tôi';

  @override
  String get removeAudio => 'Bỏ audio';

  @override
  String get audioGuided => 'Audio hướng dẫn';

  @override
  String get audioMusic => 'Âm nhạc cho tầm nhìn';

  @override
  String get audioRest => 'Thư giãn, thiên nhiên & tắm âm thanh';

  @override
  String get audioLibraryNote =>
      'Toàn bộ track hiện có được liệt kê ở đây. Chỉ track đã duyệt và có licence mới phát được.';

  @override
  String get exploreTitle => 'Một nhịp điệu dịu dàng hơn';

  @override
  String get exploreBody =>
      'Toàn bộ âm thanh và bài hướng dẫn hiện có. Các bản thử nghiệm đang chờ thay bằng bản thu hoàn chỉnh.';

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
  String get authTagline => 'Một khoảng riêng tư dành cho bạn.';

  @override
  String get morningGratitude => 'Biết ơn buổi sáng';

  @override
  String get neutralInstrumentalFiveMinutes => 'Nhạc không lời · 5 phút';

  @override
  String get play => 'Phát';

  @override
  String get vietnameseLanguage => 'Tiếng Việt';

  @override
  String get englishLanguage => 'Tiếng Anh';

  @override
  String get languageEndonymVi => 'Tiếng Việt';

  @override
  String get languageEndonymEn => 'English';

  @override
  String get retry => 'Thử lại';

  @override
  String get loading => 'Đang tải';

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
  String get intentionTitle => 'Điều gì đưa bạn đến đây?';

  @override
  String get intentionBody =>
      'Chọn điều bạn mong muốn nhất lúc này. Không có câu trả lời sai.';

  @override
  String get intentionChooseOne => 'Chọn ít nhất một điều nhé.';

  @override
  String get remindersTitle => 'Một nhịp nhỏ cho mỗi ngày.';

  @override
  String get remindersBody =>
      'Chọn hai thời điểm dịu dàng để bắt đầu và khép lại ngày.';

  @override
  String get reminderMorning => 'Buổi sáng';

  @override
  String get reminderEvening => 'Buổi tối';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return 'Đổi giờ nhắc $reminder, hiện là $time';
  }

  @override
  String get skipForNow => 'Để sau';

  @override
  String get journeyReadyTitle => 'Hành trình 28 ngày đã sẵn sàng.';

  @override
  String get journeyReadyBody =>
      'Bạn không cần hoàn hảo. Chỉ cần bắt đầu từ ngày hôm nay.';

  @override
  String get beginDayOne => 'Bắt đầu Ngày 1';

  @override
  String get chooseCategoryTitle => 'Chọn một lĩnh vực';

  @override
  String get chooseCategoryBody =>
      'Bạn muốn dành sự chú ý cho điều gì lúc này?';

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
      'Chọn một gợi ý hoặc thêm câu trả lời của bạn.';

  @override
  String get visionQuickStart => 'Tiếp tục với cảm xúc';

  @override
  String get feelingsTitle =>
      'Bạn muốn cảm thấy thế nào khi điều đó đang diễn ra?';

  @override
  String get feelingsHint => 'Chọn từ 1 đến 3 cảm xúc.';

  @override
  String get feelingsLimitReached =>
      'Bạn đã chọn 3 cảm xúc. Bỏ chọn một cảm xúc để chọn cái khác.';

  @override
  String get statementTitle => 'Tầm nhìn của bạn';

  @override
  String get statementBody =>
      'Soul đã gợi ý một câu từ lựa chọn của bạn. Bạn có thể sửa lại cho đúng với mình.';

  @override
  String get statementLabel => 'Câu tầm nhìn';

  @override
  String get statementEmpty => 'Viết tầm nhìn của bạn trong một hoặc hai câu.';

  @override
  String statementTooLong(int max) {
    return 'Tối đa $max ký tự thôi nhé.';
  }

  @override
  String get visionImageTitle => 'Đưa tầm nhìn vào cảm nhận';

  @override
  String get visionImageBody =>
      'Thêm một bức ảnh nếu bạn muốn. Không bắt buộc.';

  @override
  String get chooseFromLibrary => 'Chọn từ thư viện';

  @override
  String get takePhoto => 'Chụp ảnh';

  @override
  String get removePhoto => 'Bỏ ảnh';

  @override
  String get visionPhoto => 'Ảnh tầm nhìn';

  @override
  String get photoUnavailable => 'Không hiển thị được ảnh này.';

  @override
  String get reviewVisionTitle => 'Xem lại tầm nhìn';

  @override
  String get saveToVisionBoard => 'Lưu vào vision board';

  @override
  String get visionSaveFailed =>
      'Chưa lưu được tầm nhìn. Lựa chọn của bạn vẫn còn đây — bạn thử lại nhé.';

  @override
  String get archiveVision => 'Lưu trữ tầm nhìn';

  @override
  String get archiveVisionTitle => 'Lưu trữ tầm nhìn này?';

  @override
  String get archiveVisionBody =>
      'Tầm nhìn sẽ rời khỏi board nhưng không bị xóa.';

  @override
  String get archive => 'Lưu trữ';

  @override
  String get visionNotFound => 'Tầm nhìn này không còn trên board của bạn.';
}
