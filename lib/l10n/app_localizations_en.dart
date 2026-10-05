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
    return 'Welcome $name';
  }

  @override
  String get whatShouldWeCallYou => 'What should Soul call you?';

  @override
  String get nameHint => 'Your preferred name or nickname';

  @override
  String get saveAndContinue => 'Save and continue';

  @override
  String get todayRhythm => 'Today\'s rhythm';

  @override
  String get oneSmallAction => 'One small action';

  @override
  String get smallActionText =>
      'Silently send gratitude or share a warm smile with someone you meet today.';

  @override
  String get recent => 'Recent notes';

  @override
  String get oneNote => '1 note';

  @override
  String get gratitudeToday => 'GRATITUDE · TODAY';

  @override
  String get gratitudeNote => 'I am grateful for this life';

  @override
  String get gratitudeJournalTitle => 'Gratitude Journal';

  @override
  String get gratitudeJournalHint =>
      'Every grateful thought is a gentle seed of peace planted in your heart.';

  @override
  String get gratitudeNoteLabel => 'What are you grateful for today?';

  @override
  String get saveNote => 'Save note';

  @override
  String get gratitudeNotesEmpty =>
      'You have no notes yet. Tap below to create your very first one.';

  @override
  String get yourVisions => 'Your vision board';

  @override
  String get createVision => 'Create a vision';

  @override
  String get visionEmptyTitle => 'Create space for your dreams';

  @override
  String get visionEmptyBody =>
      'A meaningful vision begins with the deepest and truest desires of your heart.';

  @override
  String get audioPending => 'Audio coming soon';

  @override
  String get visionAudio => 'Vision Soundtrack';

  @override
  String get visionAudioBody =>
      'Choose music from Soul, an audio file from your device, or record your own personal affirmation.';

  @override
  String get visionAudioEmpty => 'No companion soundtrack added yet.';

  @override
  String get visionAudioPersonal => 'Saved on this device only';

  @override
  String get addAudio => 'Add audio';

  @override
  String get audioLibrary => 'Audio Library';

  @override
  String get chooseFromAudioLibrary => 'Choose from Soul Library';

  @override
  String get chooseAudioFile => 'Choose audio file from device';

  @override
  String get recordAudio => 'Record voice affirmation';

  @override
  String get stopRecording => 'Stop and save recording';

  @override
  String get myRecording => 'My Recording';

  @override
  String get removeAudio => 'Remove audio';

  @override
  String get audioGuided => 'Guided Meditations';

  @override
  String get audioMusic => 'Healing & Frequency Music';

  @override
  String get audioRest => 'Nature & Deep Relaxation';

  @override
  String get audioLibraryNote =>
      'Curated ambient soundscapes and 432Hz/528Hz frequency tracks to calm the mind and elevate your spirit.';

  @override
  String get exploreTitle => 'Soul Sanctuary';

  @override
  String get exploreBody =>
      'Discover healing soundscapes, guided meditations, and inspiring wisdom to nurture your inner self.';

  @override
  String get exploreTabAll => 'All';

  @override
  String get exploreTabAudio => 'Soul Audio';

  @override
  String get exploreTabMeditation => 'Meditation';

  @override
  String get exploreTabPodcast => 'Podcasts';

  @override
  String get exploreTabFrequency => 'Frequencies';

  @override
  String get exploreOpenYouTube => 'Watch on YouTube';

  @override
  String get exploreOpenSpotify => 'Listen on Spotify';

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
  String get authTagline => 'A private, gentle space for your soul.';

  @override
  String get morningGratitude => 'Morning Gratitude';

  @override
  String get neutralInstrumentalFiveMinutes => 'Gentle Piano · 5 min';

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
  String get loading => 'Loading...';

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
  String get intentionTitle => 'What brings you to Soul today?';

  @override
  String get intentionBody =>
      'Choose what matters most to you right now. There is no wrong answer.';

  @override
  String get intentionChooseOne => 'Choose at least one to begin.';

  @override
  String get remindersTitle => 'A small rhythm for each day';

  @override
  String get remindersBody =>
      'Choose two gentle moments to begin and softly close your day.';

  @override
  String get reminderMorning => 'Morning reminder';

  @override
  String get reminderEvening => 'Evening reflection';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return 'Change $reminder time, currently $time';
  }

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get journeyReadyTitle => 'Your 28-day journey is ready';

  @override
  String get journeyReadyBody =>
      'You do not need to be perfect. Just begin with 5 mindful minutes today.';

  @override
  String get beginDayOne => 'Begin Day 1';

  @override
  String get chooseCategoryTitle => 'Choose an area';

  @override
  String get chooseCategoryBody =>
      'Where would you like to place your intention and energy right now?';

  @override
  String visionStepLabel(Object category, int step, int total) {
    return '$category · $step/$total';
  }

  @override
  String chooseUpTo(int max) {
    return 'Choose up to $max.';
  }

  @override
  String get answerRequiredHint =>
      'Choose an inspiring suggestion or write your own heartfelt desire.';

  @override
  String get visionQuickStart => 'Continue with feelings';

  @override
  String get feelingsTitle =>
      'How do you want to feel when this vision comes true?';

  @override
  String get feelingsHint =>
      'Choose 1 to 3 feelings that resonate most with you.';

  @override
  String get feelingsLimitReached =>
      'You have chosen 3 feelings. Deselect one if you wish to change.';

  @override
  String get statementTitle => 'Your vision affirmation';

  @override
  String get statementBody =>
      'Soul crafted this empowering statement from your choices. Feel free to refine it to match your heart.';

  @override
  String get statementLabel => 'Vision statement';

  @override
  String get statementEmpty =>
      'Write your vision in 1 or 2 inspiring sentences.';

  @override
  String statementTooLong(int max) {
    return 'Please keep it to $max characters or fewer.';
  }

  @override
  String get visionImageTitle => 'Bring your vision to life';

  @override
  String get visionImageBody =>
      'Add an inspiring photo to help your mind visualize and feel the emotion.';

  @override
  String get chooseFromLibrary => 'Choose from library';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get visionPhoto => 'Vision photo';

  @override
  String get photoUnavailable => 'This photo cannot be shown.';

  @override
  String get reviewVisionTitle => 'Review your vision';

  @override
  String get saveToVisionBoard => 'Save to vision board';

  @override
  String get visionSaveFailed =>
      'Your vision could not be saved. Your choices are still preserved — please try again.';

  @override
  String get archiveVision => 'Archive vision';

  @override
  String get archiveVisionTitle => 'Archive this vision?';

  @override
  String get archiveVisionBody =>
      'It will leave your board and be safely moved to your archive.';

  @override
  String get archive => 'Archive';

  @override
  String get visionNotFound => 'This vision is no longer on your board.';

  @override
  String get visionSoundtrack => 'Companion soundtrack';

  @override
  String get visionBoardSubtitle =>
      'A sanctuary for the intentions, feelings, and life you are stepping into every day.';

  @override
  String get welcomeTitle1 => 'Welcome to Soul';

  @override
  String get welcomeSubtitle1 =>
      'A calm, peaceful sanctuary to pause, listen, and gently nurture your spirit every day.';

  @override
  String get welcomeTitle2 => '28-Day Gratitude Journey';

  @override
  String get welcomeSubtitle2 =>
      'Transform your daily mindset through simple, grounding practices that awaken inner joy.';

  @override
  String get welcomeTitle3 => 'Vision Board & Soundscapes';

  @override
  String get welcomeSubtitle3 =>
      'Bring your dreams into focus with inspiring vision boards and therapeutic frequency soundscapes.';

  @override
  String get startJourney => 'Begin Journey';

  @override
  String get revisitOnboarding => 'Revisit Welcome Tour';

  @override
  String get todayGreeting => 'Wishing you a peaceful and mindful day ✨';

  @override
  String get todayJourneyHeroTitle => '10 Gratitudes Today';

  @override
  String get todayJourneyHeroSubtitle =>
      'Take a few morning minutes to name the blessings in your life and appreciate why they matter.';

  @override
  String get todayStartPractice => 'Start Practice';

  @override
  String get todayContinuePractice => 'Continue Practice';

  @override
  String get todayPracticeCompleted => 'Completed today ✨';

  @override
  String get moodCheckInTitle => 'How are you feeling right now?';

  @override
  String get moodPeaceful => 'Peaceful 🕊️';

  @override
  String get moodGrateful => 'Grateful 🌸';

  @override
  String get moodEnergized => 'Energized ☀️';

  @override
  String get moodRelieved => 'Relieved 🍃';

  @override
  String get moodReflective => 'Reflective 🌙';

  @override
  String get eveningReflectionTitle => 'Evening reflection';

  @override
  String get eveningReflectionBody =>
      'Before drifting to sleep, reflect on the single most uplifting thing that happened today.';

  @override
  String get gratitudePracticeTitle => 'Morning Gratitude';

  @override
  String get gratitudePracticeIntroTitle => 'Begin your day with appreciation';

  @override
  String get gratitudePracticeIntroBody =>
      'Take a moment to notice 10 things you feel grateful for today, and write down why each one matters to you.';

  @override
  String get gratitudeStartPractice => 'Begin Practice';

  @override
  String gratitudeItemProgress(int current, int total) {
    return 'Item $current of $total';
  }

  @override
  String get gratitudeFieldPrompt => 'I am grateful for...';

  @override
  String get gratitudeFieldPlaceholder =>
      'Name something you are grateful for today';

  @override
  String get gratitudeReasonPrompt => 'Because...';

  @override
  String get gratitudeReasonPlaceholder => 'Why does this matter to you?';

  @override
  String gratitudeTapThankYou(int count) {
    return 'Say \"Thank You\" ($count/3)';
  }

  @override
  String get gratitudeTapHint =>
      'Tap 3 times to anchor the feeling of gratitude';

  @override
  String get gratitudeAddAndNext => 'Add & Next';

  @override
  String get gratitudeReviewTitle => 'Your 10 Gratitudes Today';

  @override
  String get gratitudeReviewSubtitle =>
      'Review your list before sealing it for the day.';

  @override
  String get gratitudeCompletePractice => 'Complete Practice';

  @override
  String get gratitudeCompletedTitle => 'Practice Completed ✨';

  @override
  String get gratitudeCompletedBody =>
      'You have planted 10 seeds of gratitude into your day. These entries have been saved to your journal.';

  @override
  String get gratitudeBackToToday => 'Back to Today';

  @override
  String get gratitudeStatusIncomplete => 'Not completed yet';

  @override
  String get gratitudeStatusCompleted => '10 of 10 entries completed';

  @override
  String get gratitudeCardTapToStart => 'Start Morning Practice';

  @override
  String get gratitudeCardTapToReview => 'View Today\'s Gratitudes';

  @override
  String get editEntry => 'Edit';

  @override
  String get done => 'Done';

  @override
  String gratitudeReasonLabel(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get gratitudeFinishEarly => 'Finish early';

  @override
  String get gratitudeSkipItem => 'Skip this item';

  @override
  String get gratitudeSkipProgress => 'Skip progress';

  @override
  String get gratitudeSkippedTitle => 'Practice Skipped';

  @override
  String get gratitudeSkippedBody =>
      'You skipped today\'s gratitude practice. You can come back and practice anytime.';

  @override
  String gratitudeReviewTitleCount(int count) {
    return 'Your $count Gratitudes Today';
  }

  @override
  String gratitudeCompletedBodyCount(int count) {
    return 'You have planted $count seeds of gratitude into your day. These entries have been saved to your journal.';
  }

  @override
  String gratitudeStatusCompletedCount(int count) {
    return '$count gratitudes completed';
  }

  @override
  String get gratitudeLevelLow => 'Thank you';

  @override
  String get gratitudeLevelMedium => 'Deeply thankful';

  @override
  String get gratitudeLevelHigh => 'Profound gratitude';

  @override
  String get gratitudeTapLevelHint => 'Select gratitude intensity';

  @override
  String get signOutConfirmTitle => 'Sign out of Soul?';

  @override
  String get signOutConfirmBody =>
      'Are you sure you want to sign out? You will return to the welcome screen.';

  @override
  String get addNote => 'Add new note';

  @override
  String get newGratitudeNote => 'New gratitude note';

  @override
  String get notePromptPlaceholder => 'What are you grateful for today?';

  @override
  String get noteReasonPlaceholder => 'Why does this matter to you? (optional)';

  @override
  String get deleteNote => 'Delete note';

  @override
  String get deleteNoteConfirmTitle => 'Delete this note?';

  @override
  String get deleteNoteConfirmBody =>
      'This note will be permanently removed from your journal.';

  @override
  String get noteSaved => 'Note saved to journal';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String notesCount(int count) {
    return '$count notes';
  }

  @override
  String get reminderSettingsTitle => 'Notification Reminders';

  @override
  String get reminderSettingsSubtitle =>
      'Soul will send gentle reminders at your chosen times.';

  @override
  String get settingsSectionTitle => 'Settings';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get saveSettings => 'Save changes';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get close => 'Close';

  @override
  String get customNoteDefaultTheme => 'Grateful Moment';

  @override
  String gratitudeSentenceCount(int count) {
    return '$count gratitudes';
  }

  @override
  String get allGratitudesInNote => 'Gratitudes in this note';

  @override
  String get sentencePreview => 'Complete sentence preview:';
}
