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

  @override
  String get save => 'Save';

  @override
  String nameTooLong(int max) {
    return 'Please keep it to $max characters or fewer.';
  }

  @override
  String get intentionTitle => 'What brings you here today?';

  @override
  String get intentionBody =>
      'Choose what matters most to you right now. There\'s no wrong answer.';

  @override
  String get intentionChooseOne => 'Choose at least one.';

  @override
  String get remindersTitle => 'A small rhythm for each day.';

  @override
  String get remindersBody =>
      'Choose two gentle moments to begin and close your day.';

  @override
  String get reminderMorning => 'Morning';

  @override
  String get reminderEvening => 'Evening';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return 'Change $reminder time, currently $time';
  }

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get journeyReadyTitle => 'Your 28-day journey is ready.';

  @override
  String get journeyReadyBody =>
      'You do not need to be perfect. Just begin with today.';

  @override
  String get beginDayOne => 'Begin Day 1';

  @override
  String get chooseCategoryTitle => 'Choose an area';

  @override
  String get chooseCategoryBody =>
      'Where would you like to place your attention right now?';

  @override
  String visionStepLabel(Object category, int step, int total) {
    return '$category · $step/$total';
  }

  @override
  String chooseUpTo(int max) {
    return 'Choose up to $max.';
  }

  @override
  String get answerRequiredHint => 'Choose an option or add your own answer.';

  @override
  String get feelingsTitle => 'How do you want to feel when this is happening?';

  @override
  String get feelingsHint => 'Choose 1 to 3 feelings.';

  @override
  String get feelingsLimitReached =>
      'You have chosen 3 feelings. Deselect one to choose another.';

  @override
  String get statementTitle => 'Your vision';

  @override
  String get statementBody =>
      'Soul drafted this from your choices. Make it your own.';

  @override
  String get statementLabel => 'Vision statement';

  @override
  String get statementEmpty => 'Write your vision in one or two sentences.';

  @override
  String statementTooLong(int max) {
    return 'Please keep it to $max characters or fewer.';
  }

  @override
  String get visionImageTitle => 'Make it feel real';

  @override
  String get visionImageBody => 'Add a photo if you like. It\'s optional.';

  @override
  String get chooseFromLibrary => 'Choose from library';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get visionPhoto => 'Vision photo';

  @override
  String get photoUnavailable => 'This photo can\'t be shown.';

  @override
  String get reviewVisionTitle => 'Review your vision';

  @override
  String get saveToVisionBoard => 'Save to vision board';

  @override
  String get visionSaveFailed =>
      'Your vision wasn\'t saved. Your choices are still here — please try again.';

  @override
  String get archiveVision => 'Archive vision';

  @override
  String get archiveVisionTitle => 'Archive this vision?';

  @override
  String get archiveVisionBody =>
      'It will leave your board but won\'t be deleted.';

  @override
  String get archive => 'Archive';

  @override
  String get visionNotFound => 'This vision is no longer on your board.';
}
