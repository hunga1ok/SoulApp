// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Soul';

  @override
  String get today => 'Today';

  @override
  String get vision => 'Vision';

  @override
  String get journal => 'Journal';

  @override
  String get explore => 'Explore';

  @override
  String get continueLabel => 'Continue';

  @override
  String welcome(Object name) {
    return 'Welcome, $name';
  }

  @override
  String get whatShouldWeCallYou => 'What would you like Soul to call you?';

  @override
  String get nameHint => 'Your preferred name';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get todayRhythm => 'Today\'s rhythm';

  @override
  String get oneSmallAction => 'One small action';

  @override
  String get smallActionText => 'Take one gentle breath before moving on.';

  @override
  String get recent => 'Recent';

  @override
  String get oneNote => '1 note';

  @override
  String get gratitudeToday => 'GRATITUDE · TODAY';

  @override
  String get gratitudeNote => 'I am grateful for this life.';

  @override
  String get yourVisions => 'Your visions';

  @override
  String get createVision => 'Create a vision';

  @override
  String get visionEmptyTitle => 'Make room for what matters';

  @override
  String get visionEmptyBody => 'A vision can begin with one honest feeling.';

  @override
  String get exploreTitle => 'A gentler way forward';

  @override
  String get exploreBody => 'Curated practices and stories will live here.';

  @override
  String get profile => 'Profile & settings';

  @override
  String get soundOn => 'Sound on';

  @override
  String get soundOff => 'Sound off';

  @override
  String get language => 'Language';

  @override
  String get editName => 'Edit preferred name';

  @override
  String get signOut => 'Sign out';

  @override
  String get back => 'Back';

  @override
  String dayProgress(int day) {
    return 'Day $day of 28';
  }

  @override
  String get authTagline => 'A private, gentle space for you.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get developmentAuthHint =>
      'Development mode: this button simulates a Google callback.';

  @override
  String get morningGratitude => 'Morning Gratitude';

  @override
  String get neutralInstrumentalFiveMinutes => 'Neutral instrumental · 5 min';

  @override
  String get play => 'Play';

  @override
  String get vietnameseLanguage => 'Vietnamese';

  @override
  String get englishLanguage => 'English';

  @override
  String get languageEndonymVi => 'Tiếng Việt';

  @override
  String get languageEndonymEn => 'English';

  @override
  String get retry => 'Try again';

  @override
  String get loading => 'Loading';

  @override
  String get pause => 'Pause';

  @override
  String get cancel => 'Cancel';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';
}
