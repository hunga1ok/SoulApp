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
  String get oneNote => '1 note';

  @override
  String get gratitudeToday => 'BIẾT ƠN · HÔM NAY';

  @override
  String get gratitudeNote => 'Tôi biết ơn cuộc sống này';

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
  String get exploreTitle => 'Một nhịp điệu dịu dàng hơn';

  @override
  String get exploreBody =>
      'Những thực hành và câu chuyện được chọn lọc sẽ ở đây.';

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
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get developmentAuthHint =>
      'Chế độ phát triển: nút này mô phỏng callback Google.';

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
}
