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
  /// **'Welcome {name}'**
  String welcome(Object name);

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should Soul call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your preferred name or nickname'**
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
  /// **'Silently send gratitude or share a warm smile with someone you meet today.'**
  String get smallActionText;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent notes'**
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
  /// **'I am grateful for this life'**
  String get gratitudeNote;

  /// No description provided for @gratitudeJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'Gratitude Journal'**
  String get gratitudeJournalTitle;

  /// No description provided for @gratitudeJournalHint.
  ///
  /// In en, this message translates to:
  /// **'Every grateful thought is a gentle seed of peace planted in your heart.'**
  String get gratitudeJournalHint;

  /// No description provided for @gratitudeNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'What are you grateful for today?'**
  String get gratitudeNoteLabel;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get saveNote;

  /// No description provided for @gratitudeNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no notes yet. Tap below to create your very first one.'**
  String get gratitudeNotesEmpty;

  /// No description provided for @yourVisions.
  ///
  /// In en, this message translates to:
  /// **'Your vision board'**
  String get yourVisions;

  /// No description provided for @createVision.
  ///
  /// In en, this message translates to:
  /// **'Create a vision'**
  String get createVision;

  /// No description provided for @visionEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create space for your dreams'**
  String get visionEmptyTitle;

  /// No description provided for @visionEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'A meaningful vision begins with the deepest and truest desires of your heart.'**
  String get visionEmptyBody;

  /// No description provided for @audioPending.
  ///
  /// In en, this message translates to:
  /// **'Audio coming soon'**
  String get audioPending;

  /// No description provided for @visionAudio.
  ///
  /// In en, this message translates to:
  /// **'Vision Soundtrack'**
  String get visionAudio;

  /// No description provided for @visionAudioBody.
  ///
  /// In en, this message translates to:
  /// **'Choose music from Soul, an audio file from your device, or record your own personal affirmation.'**
  String get visionAudioBody;

  /// No description provided for @visionAudioEmpty.
  ///
  /// In en, this message translates to:
  /// **'No companion soundtrack added yet.'**
  String get visionAudioEmpty;

  /// No description provided for @visionAudioPersonal.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only'**
  String get visionAudioPersonal;

  /// No description provided for @addAudio.
  ///
  /// In en, this message translates to:
  /// **'Add audio'**
  String get addAudio;

  /// No description provided for @audioLibrary.
  ///
  /// In en, this message translates to:
  /// **'Audio Library'**
  String get audioLibrary;

  /// No description provided for @chooseFromAudioLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from Soul Library'**
  String get chooseFromAudioLibrary;

  /// No description provided for @chooseAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Choose audio file from device'**
  String get chooseAudioFile;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record voice affirmation'**
  String get recordAudio;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop and save recording'**
  String get stopRecording;

  /// No description provided for @myRecording.
  ///
  /// In en, this message translates to:
  /// **'My Recording'**
  String get myRecording;

  /// No description provided for @removeAudio.
  ///
  /// In en, this message translates to:
  /// **'Remove audio'**
  String get removeAudio;

  /// No description provided for @audioGuided.
  ///
  /// In en, this message translates to:
  /// **'Guided Meditations'**
  String get audioGuided;

  /// No description provided for @audioMusic.
  ///
  /// In en, this message translates to:
  /// **'Healing & Frequency Music'**
  String get audioMusic;

  /// No description provided for @audioRest.
  ///
  /// In en, this message translates to:
  /// **'Nature & Deep Relaxation'**
  String get audioRest;

  /// No description provided for @audioLibraryNote.
  ///
  /// In en, this message translates to:
  /// **'Curated ambient soundscapes and 432Hz/528Hz frequency tracks to calm the mind and elevate your spirit.'**
  String get audioLibraryNote;

  /// No description provided for @exploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Soul Sanctuary'**
  String get exploreTitle;

  /// No description provided for @exploreBody.
  ///
  /// In en, this message translates to:
  /// **'Discover healing soundscapes, guided meditations, and inspiring wisdom to nurture your inner self.'**
  String get exploreBody;

  /// No description provided for @exploreTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get exploreTabAll;

  /// No description provided for @exploreTabAudio.
  ///
  /// In en, this message translates to:
  /// **'Soul Audio'**
  String get exploreTabAudio;

  /// No description provided for @exploreTabMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get exploreTabMeditation;

  /// No description provided for @exploreTabPodcast.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get exploreTabPodcast;

  /// No description provided for @exploreTabFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequencies'**
  String get exploreTabFrequency;

  /// No description provided for @exploreOpenYouTube.
  ///
  /// In en, this message translates to:
  /// **'Watch on YouTube'**
  String get exploreOpenYouTube;

  /// No description provided for @exploreOpenSpotify.
  ///
  /// In en, this message translates to:
  /// **'Listen on Spotify'**
  String get exploreOpenSpotify;

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
  /// **'A private, gentle space for your soul.'**
  String get authTagline;

  /// No description provided for @morningGratitude.
  ///
  /// In en, this message translates to:
  /// **'Morning Gratitude'**
  String get morningGratitude;

  /// No description provided for @neutralInstrumentalFiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Gentle Piano · 5 min'**
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

  /// No description provided for @languageEndonymVi.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageEndonymVi;

  /// No description provided for @languageEndonymEn.
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
  /// **'Loading...'**
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

  /// No description provided for @intentionTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to Soul today?'**
  String get intentionTitle;

  /// No description provided for @intentionBody.
  ///
  /// In en, this message translates to:
  /// **'Choose what matters most to you right now. There is no wrong answer.'**
  String get intentionBody;

  /// No description provided for @intentionChooseOne.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one to begin.'**
  String get intentionChooseOne;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'A small rhythm for each day'**
  String get remindersTitle;

  /// No description provided for @remindersBody.
  ///
  /// In en, this message translates to:
  /// **'Choose two gentle moments to begin and softly close your day.'**
  String get remindersBody;

  /// No description provided for @reminderMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning reminder'**
  String get reminderMorning;

  /// No description provided for @reminderEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening reflection'**
  String get reminderEvening;

  /// No description provided for @changeReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Change {reminder} time, currently {time}'**
  String changeReminderTime(Object reminder, Object time);

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @journeyReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your 28-day journey is ready'**
  String get journeyReadyTitle;

  /// No description provided for @journeyReadyBody.
  ///
  /// In en, this message translates to:
  /// **'You do not need to be perfect. Just begin with 5 mindful minutes today.'**
  String get journeyReadyBody;

  /// No description provided for @beginDayOne.
  ///
  /// In en, this message translates to:
  /// **'Begin Day 1'**
  String get beginDayOne;

  /// No description provided for @chooseCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an area'**
  String get chooseCategoryTitle;

  /// No description provided for @chooseCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'Where would you like to place your intention and energy right now?'**
  String get chooseCategoryBody;

  /// No description provided for @visionStepLabel.
  ///
  /// In en, this message translates to:
  /// **'{category} · {step}/{total}'**
  String visionStepLabel(Object category, int step, int total);

  /// No description provided for @chooseUpTo.
  ///
  /// In en, this message translates to:
  /// **'Choose up to {max}.'**
  String chooseUpTo(int max);

  /// No description provided for @answerRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Choose an inspiring suggestion or write your own heartfelt desire.'**
  String get answerRequiredHint;

  /// No description provided for @visionQuickStart.
  ///
  /// In en, this message translates to:
  /// **'Continue with feelings'**
  String get visionQuickStart;

  /// No description provided for @feelingsTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to feel when this vision comes true?'**
  String get feelingsTitle;

  /// No description provided for @feelingsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 to 3 feelings that resonate most with you.'**
  String get feelingsHint;

  /// No description provided for @feelingsLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You have chosen 3 feelings. Deselect one if you wish to change.'**
  String get feelingsLimitReached;

  /// No description provided for @statementTitle.
  ///
  /// In en, this message translates to:
  /// **'Your vision affirmation'**
  String get statementTitle;

  /// No description provided for @statementBody.
  ///
  /// In en, this message translates to:
  /// **'Soul crafted this empowering statement from your choices. Feel free to refine it to match your heart.'**
  String get statementBody;

  /// No description provided for @statementLabel.
  ///
  /// In en, this message translates to:
  /// **'Vision statement'**
  String get statementLabel;

  /// No description provided for @statementEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write your vision in 1 or 2 inspiring sentences.'**
  String get statementEmpty;

  /// No description provided for @statementTooLong.
  ///
  /// In en, this message translates to:
  /// **'Please keep it to {max} characters or fewer.'**
  String statementTooLong(int max);

  /// No description provided for @visionImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Bring your vision to life'**
  String get visionImageTitle;

  /// No description provided for @visionImageBody.
  ///
  /// In en, this message translates to:
  /// **'Add an inspiring photo to help your mind visualize and feel the emotion.'**
  String get visionImageBody;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get chooseFromLibrary;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @visionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Vision photo'**
  String get visionPhoto;

  /// No description provided for @photoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This photo cannot be shown.'**
  String get photoUnavailable;

  /// No description provided for @reviewVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your vision'**
  String get reviewVisionTitle;

  /// No description provided for @saveToVisionBoard.
  ///
  /// In en, this message translates to:
  /// **'Save to vision board'**
  String get saveToVisionBoard;

  /// No description provided for @visionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your vision could not be saved. Your choices are still preserved — please try again.'**
  String get visionSaveFailed;

  /// No description provided for @archiveVision.
  ///
  /// In en, this message translates to:
  /// **'Archive vision'**
  String get archiveVision;

  /// No description provided for @archiveVisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive this vision?'**
  String get archiveVisionTitle;

  /// No description provided for @archiveVisionBody.
  ///
  /// In en, this message translates to:
  /// **'It will leave your board and be safely moved to your archive.'**
  String get archiveVisionBody;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @visionNotFound.
  ///
  /// In en, this message translates to:
  /// **'This vision is no longer on your board.'**
  String get visionNotFound;

  /// No description provided for @visionSoundtrack.
  ///
  /// In en, this message translates to:
  /// **'Companion soundtrack'**
  String get visionSoundtrack;

  /// No description provided for @visionBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A sanctuary for the intentions, feelings, and life you are stepping into every day.'**
  String get visionBoardSubtitle;

  /// No description provided for @welcomeTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Soul'**
  String get welcomeTitle1;

  /// No description provided for @welcomeSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'A calm, peaceful sanctuary to pause, listen, and gently nurture your spirit every day.'**
  String get welcomeSubtitle1;

  /// No description provided for @welcomeTitle2.
  ///
  /// In en, this message translates to:
  /// **'28-Day Gratitude Journey'**
  String get welcomeTitle2;

  /// No description provided for @welcomeSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Transform your daily mindset through simple, grounding practices that awaken inner joy.'**
  String get welcomeSubtitle2;

  /// No description provided for @welcomeTitle3.
  ///
  /// In en, this message translates to:
  /// **'Vision Board & Soundscapes'**
  String get welcomeTitle3;

  /// No description provided for @welcomeSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Bring your dreams into focus with inspiring vision boards and therapeutic frequency soundscapes.'**
  String get welcomeSubtitle3;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Begin Journey'**
  String get startJourney;

  /// No description provided for @revisitOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Revisit Welcome Tour'**
  String get revisitOnboarding;

  /// No description provided for @todayGreeting.
  ///
  /// In en, this message translates to:
  /// **'Wishing you a peaceful and mindful day ✨'**
  String get todayGreeting;

  /// No description provided for @todayJourneyHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'10 Gratitudes Today'**
  String get todayJourneyHeroTitle;

  /// No description provided for @todayJourneyHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Take a few morning minutes to name the blessings in your life and appreciate why they matter.'**
  String get todayJourneyHeroSubtitle;

  /// No description provided for @todayStartPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get todayStartPractice;

  /// No description provided for @todayContinuePractice.
  ///
  /// In en, this message translates to:
  /// **'Continue Practice'**
  String get todayContinuePractice;

  /// No description provided for @todayPracticeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed today ✨'**
  String get todayPracticeCompleted;

  /// No description provided for @moodCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling right now?'**
  String get moodCheckInTitle;

  /// No description provided for @moodPeaceful.
  ///
  /// In en, this message translates to:
  /// **'Peaceful 🕊️'**
  String get moodPeaceful;

  /// No description provided for @moodGrateful.
  ///
  /// In en, this message translates to:
  /// **'Grateful 🌸'**
  String get moodGrateful;

  /// No description provided for @moodEnergized.
  ///
  /// In en, this message translates to:
  /// **'Energized ☀️'**
  String get moodEnergized;

  /// No description provided for @moodRelieved.
  ///
  /// In en, this message translates to:
  /// **'Relieved 🍃'**
  String get moodRelieved;

  /// No description provided for @moodReflective.
  ///
  /// In en, this message translates to:
  /// **'Reflective 🌙'**
  String get moodReflective;

  /// No description provided for @eveningReflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Evening reflection'**
  String get eveningReflectionTitle;

  /// No description provided for @eveningReflectionBody.
  ///
  /// In en, this message translates to:
  /// **'Before drifting to sleep, reflect on the single most uplifting thing that happened today.'**
  String get eveningReflectionBody;

  /// No description provided for @gratitudePracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning Gratitude'**
  String get gratitudePracticeTitle;

  /// No description provided for @gratitudePracticeIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Begin your day with appreciation'**
  String get gratitudePracticeIntroTitle;

  /// No description provided for @gratitudePracticeIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Take a moment to notice 10 things you feel grateful for today, and write down why each one matters to you.'**
  String get gratitudePracticeIntroBody;

  /// No description provided for @gratitudeStartPractice.
  ///
  /// In en, this message translates to:
  /// **'Begin Practice'**
  String get gratitudeStartPractice;

  /// No description provided for @gratitudeItemProgress.
  ///
  /// In en, this message translates to:
  /// **'Item {current} of {total}'**
  String gratitudeItemProgress(int current, int total);

  /// No description provided for @gratitudeFieldPrompt.
  ///
  /// In en, this message translates to:
  /// **'I am grateful for...'**
  String get gratitudeFieldPrompt;

  /// No description provided for @gratitudeFieldPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Name something you are grateful for today'**
  String get gratitudeFieldPlaceholder;

  /// No description provided for @gratitudeReasonPrompt.
  ///
  /// In en, this message translates to:
  /// **'Because...'**
  String get gratitudeReasonPrompt;

  /// No description provided for @gratitudeReasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Why does this matter to you?'**
  String get gratitudeReasonPlaceholder;

  /// No description provided for @gratitudeTapThankYou.
  ///
  /// In en, this message translates to:
  /// **'Say \"Thank You\" ({count}/3)'**
  String gratitudeTapThankYou(int count);

  /// No description provided for @gratitudeTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap 3 times to anchor the feeling of gratitude'**
  String get gratitudeTapHint;

  /// No description provided for @gratitudeAddAndNext.
  ///
  /// In en, this message translates to:
  /// **'Add & Next'**
  String get gratitudeAddAndNext;

  /// No description provided for @gratitudeReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Your 10 Gratitudes Today'**
  String get gratitudeReviewTitle;

  /// No description provided for @gratitudeReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review your list before sealing it for the day.'**
  String get gratitudeReviewSubtitle;

  /// No description provided for @gratitudeCompletePractice.
  ///
  /// In en, this message translates to:
  /// **'Complete Practice'**
  String get gratitudeCompletePractice;

  /// No description provided for @gratitudeCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Completed ✨'**
  String get gratitudeCompletedTitle;

  /// No description provided for @gratitudeCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You have planted 10 seeds of gratitude into your day. These entries have been saved to your journal.'**
  String get gratitudeCompletedBody;

  /// No description provided for @gratitudeBackToToday.
  ///
  /// In en, this message translates to:
  /// **'Back to Today'**
  String get gratitudeBackToToday;

  /// No description provided for @gratitudeStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Not completed yet'**
  String get gratitudeStatusIncomplete;

  /// No description provided for @gratitudeStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'10 of 10 entries completed'**
  String get gratitudeStatusCompleted;

  /// No description provided for @gratitudeCardTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Start Morning Practice'**
  String get gratitudeCardTapToStart;

  /// No description provided for @gratitudeCardTapToReview.
  ///
  /// In en, this message translates to:
  /// **'View Today\'s Gratitudes'**
  String get gratitudeCardTapToReview;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editEntry;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @gratitudeReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String gratitudeReasonLabel(String reason);

  /// No description provided for @gratitudeFinishEarly.
  ///
  /// In en, this message translates to:
  /// **'Finish early'**
  String get gratitudeFinishEarly;

  /// No description provided for @gratitudeSkipItem.
  ///
  /// In en, this message translates to:
  /// **'Skip this item'**
  String get gratitudeSkipItem;

  /// No description provided for @gratitudeSkipProgress.
  ///
  /// In en, this message translates to:
  /// **'Skip progress'**
  String get gratitudeSkipProgress;

  /// No description provided for @gratitudeSkippedTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Skipped'**
  String get gratitudeSkippedTitle;

  /// No description provided for @gratitudeSkippedBody.
  ///
  /// In en, this message translates to:
  /// **'You skipped today\'s gratitude practice. You can come back and practice anytime.'**
  String get gratitudeSkippedBody;

  /// No description provided for @gratitudeReviewTitleCount.
  ///
  /// In en, this message translates to:
  /// **'Your {count} Gratitudes Today'**
  String gratitudeReviewTitleCount(int count);

  /// No description provided for @gratitudeCompletedBodyCount.
  ///
  /// In en, this message translates to:
  /// **'You have planted {count} seeds of gratitude into your day. These entries have been saved to your journal.'**
  String gratitudeCompletedBodyCount(int count);

  /// No description provided for @gratitudeStatusCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} gratitudes completed'**
  String gratitudeStatusCompletedCount(int count);

  /// No description provided for @gratitudeLevelLow.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get gratitudeLevelLow;

  /// No description provided for @gratitudeLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Deeply thankful'**
  String get gratitudeLevelMedium;

  /// No description provided for @gratitudeLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'Profound gratitude'**
  String get gratitudeLevelHigh;

  /// No description provided for @gratitudeTapLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Select gratitude intensity'**
  String get gratitudeTapLevelHint;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of Soul?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? You will return to the welcome screen.'**
  String get signOutConfirmBody;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add new note'**
  String get addNote;

  /// No description provided for @newGratitudeNote.
  ///
  /// In en, this message translates to:
  /// **'New gratitude note'**
  String get newGratitudeNote;

  /// No description provided for @notePromptPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'What are you grateful for today?'**
  String get notePromptPlaceholder;

  /// No description provided for @noteReasonPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Why does this matter to you? (optional)'**
  String get noteReasonPlaceholder;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNote;

  /// No description provided for @deleteNoteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get deleteNoteConfirmTitle;

  /// No description provided for @deleteNoteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This note will be permanently removed from your journal.'**
  String get deleteNoteConfirmBody;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved to journal'**
  String get noteSaved;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeleted;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesCount(int count);

  /// No description provided for @reminderSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Reminders'**
  String get reminderSettingsTitle;

  /// No description provided for @reminderSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Soul will send gentle reminders at your chosen times.'**
  String get reminderSettingsSubtitle;

  /// No description provided for @settingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSectionTitle;

  /// No description provided for @accountSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSectionTitle;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @customNoteDefaultTheme.
  ///
  /// In en, this message translates to:
  /// **'Grateful Moment'**
  String get customNoteDefaultTheme;

  /// No description provided for @gratitudeSentenceCount.
  ///
  /// In en, this message translates to:
  /// **'{count} gratitudes'**
  String gratitudeSentenceCount(int count);

  /// No description provided for @allGratitudesInNote.
  ///
  /// In en, this message translates to:
  /// **'Gratitudes in this note'**
  String get allGratitudesInNote;

  /// No description provided for @sentencePreview.
  ///
  /// In en, this message translates to:
  /// **'Complete sentence preview:'**
  String get sentencePreview;
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
