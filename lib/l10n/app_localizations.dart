import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul'**
  String get appTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get vision;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcome(Object name);

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What would you like Soul to call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your preferred name'**
  String get nameHint;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get saveAndContinue;

  /// No description provided for @todayRhythm.
  ///
  /// In en, this message translates to:
  /// **'Today\'s rhythm'**
  String get todayRhythm;

  /// No description provided for @oneSmallAction.
  ///
  /// In en, this message translates to:
  /// **'One small action'**
  String get oneSmallAction;

  /// No description provided for @smallActionText.
  ///
  /// In en, this message translates to:
  /// **'Take one gentle breath before moving on.'**
  String get smallActionText;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @oneNote.
  ///
  /// In en, this message translates to:
  /// **'1 note'**
  String get oneNote;

  /// No description provided for @gratitudeToday.
  ///
  /// In en, this message translates to:
  /// **'GRATITUDE · TODAY'**
  String get gratitudeToday;

  /// No description provided for @gratitudeNote.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for this life.'**
  String get gratitudeNote;

  /// No description provided for @yourVisions.
  ///
  /// In en, this message translates to:
  /// **'Your visions'**
  String get yourVisions;

  /// No description provided for @createVision.
  ///
  /// In en, this message translates to:
  /// **'Create a vision'**
  String get createVision;

  /// No description provided for @visionEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Make room for what matters'**
  String get visionEmptyTitle;

  /// No description provided for @visionEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A vision can begin with one honest feeling.'**
  String get visionEmptyBody;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'A gentler way forward'**
  String get exploreTitle;

  /// No description provided for @exploreBody.
  ///
  /// In en, this message translates to:
  /// **'Curated practices and stories will live here.'**
  String get exploreBody;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile & settings'**
  String get profile;

  /// No description provided for @soundOn.
  ///
  /// In en, this message translates to:
  /// **'Sound on'**
  String get soundOn;

  /// No description provided for @soundOff.
  ///
  /// In en, this message translates to:
  /// **'Sound off'**
  String get soundOff;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit preferred name'**
  String get editName;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @dayProgress.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of 28'**
  String dayProgress(int day);

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'A private, gentle space for you.'**
  String get authTagline;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @developmentAuthHint.
  ///
  /// In en, this message translates to:
  /// **'Development mode: signs in through the local API\'s development login.'**
  String get developmentAuthHint;

  /// No description provided for @morningGratitude.
  ///
  /// In en, this message translates to:
  /// **'Morning Gratitude'**
  String get morningGratitude;

  /// No description provided for @neutralInstrumentalFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Neutral instrumental · 5 min'**
  String get neutralInstrumentalFiveMinutes;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @vietnameseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnameseLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Language gate option. Always the Vietnamese endonym, identical in every locale.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageEndonymVi;

  /// Language gate option. Always the English endonym, identical in every locale.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEndonymEn;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Please keep it to {max} characters or fewer.'**
  String nameTooLong(int max);

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Soul can\'t connect right now. Check your connection and try again.'**
  String get errorNetwork;

  /// No description provided for @errorSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorSessionEnded;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this.'**
  String get errorForbidden;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check what you entered and try again.'**
  String get errorValidation;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Soul is briefly unavailable. Please try again soon.'**
  String get errorServiceUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
