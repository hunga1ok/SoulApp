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
  String get nowPlaying => 'Now Playing';

  @override
  String get stop => 'Stop';

  @override
  String get allAudio => 'All';

  @override
  String get audioNature => 'Nature & Ambience';

  @override
  String get audioMusicTab => 'Music & Soundscapes';

  @override
  String get audioGuidedTab => 'Guided Meditations';

  @override
  String get recommendedForVision => 'Recommended for this Vision';

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
  String get journeyReadyTitle => 'Invest in your dreams and your perseverance';

  @override
  String get journeyReadyBody =>
      'A small investment is a heartfelt promise to yourself — to stay devoted to your dreams each day, cherish the present, and walk your path of inner transformation with true commitment.';

  @override
  String get beginDayOne => 'Commit & Begin Journey';

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
  String get welcomeTitle2 => 'Gratitude Practice';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notes',
      one: '1 note',
    );
    return '$_temp0';
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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gratitudes',
      one: '1 gratitude',
    );
    return '$_temp0';
  }

  @override
  String get allGratitudesInNote => 'Note content';

  @override
  String get sentencePreview => 'Complete sentence preview:';

  @override
  String get soulCardsTitle => 'Soul Cards';

  @override
  String get soulCardsSubtitle => 'Receive a guiding message for your soul';

  @override
  String dailyDrawRemaining(int count) {
    return '$count draws remaining today';
  }

  @override
  String get dailyDrawLimitReached => '2 daily messages drawn today';

  @override
  String get dailyDrawLimitHint =>
      'Take time to reflect on today\'s messages. You can draw again tomorrow.';

  @override
  String get drawCardAction => 'Draw a Card';

  @override
  String get drawAnotherCard => 'Draw Another Card';

  @override
  String get reviewTodayCards => 'View Today\'s Messages';

  @override
  String get cardDrawSuccess => 'Your Guiding Message';

  @override
  String get todayCardDrawBanner => 'Soul Message';

  @override
  String get chooseDeckPrompt => 'Choose a deck to listen to its message';

  @override
  String get tapCardToReveal => 'Tap the card to reveal your message';

  @override
  String get saveToJournalAction => 'Save to Journal';

  @override
  String get savedToJournalSuccess => 'Message saved to journal';

  @override
  String get cardDrawHistory => 'Draw History';

  @override
  String deckCardCount(int count) {
    return '$count cards';
  }

  @override
  String get soulCardsTab => 'Soul Cards';

  @override
  String get dailyDrawLimitDialogTitle => 'Daily Limit Reached';

  @override
  String get dailyDrawLimitDialogMessage =>
      'You have already received 2 guiding messages today. Take time to reflect on today\'s messages. You can draw again tomorrow.';

  @override
  String get understood => 'Understood';

  @override
  String get chooseDeckSubtitle =>
      'Choose a deck to receive your guiding message';

  @override
  String get drawFromThisDeck => 'Draw from this deck';

  @override
  String get gratitudeJournalPrompt =>
      'Today you continue your gratitude journey. Take time and presence of mind to reflect on the things you are grateful for, however small. Suggested pattern:\n\"I am grateful for... because...\"\nThen re-read what you have written with a deep feeling of appreciation.';

  @override
  String get gratitudeJournalPlaceholder =>
      'Write the things you are grateful for today like a quiet journal page...\n\nExample:\nI am grateful for the warm cup of coffee this morning because it gave me alertness and peace.\nI am grateful for a friend\'s smile because it warmed my heart...';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get insertPromptTemplate => 'Insert template';

  @override
  String get saveAndCompleteJournal => 'Complete & Save Journal';

  @override
  String get gratitudePromptTemplateText => 'I am grateful for ... because ...';

  @override
  String get chooseTheme => 'Select theme';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteUpdated => 'Note updated';

  @override
  String get gratitudeGuidanceTitle => 'Today\'s Practice Guidance';

  @override
  String get showGuidance => 'View guidance';

  @override
  String get hideGuidance => 'Hide guidance';

  @override
  String get comfortZoneTitle => 'Little Corner';

  @override
  String get comfortZoneSubtitle => 'A Little World Where You Feel Safe';

  @override
  String get comfortZoneBannerSubtitle =>
      'A Little World Where You Feel Safe — Peaceful sanctuaries with live animations and healing audio';

  @override
  String comfortZoneAllSpaces(int count) {
    return 'All ($count)';
  }

  @override
  String get comfortZoneFavorites => 'Favorites';

  @override
  String get comfortZoneFavoritesEmpty =>
      'No favorite spaces yet. Tap the heart icon on any space to save it here.';

  @override
  String get comfortZoneEnterSpace => 'Enter space';

  @override
  String get comfortZoneAmbientSound => 'Ambient & Music';

  @override
  String get comfortZoneGuidedAudio => 'Guided Audio';

  @override
  String get comfortZoneZenMode => 'Zen view';

  @override
  String get comfortZoneExitZenMode => 'Show controls';

  @override
  String get comfortZoneBreathingGuide => 'Breathing guide';

  @override
  String get comfortZoneBreatheIn => 'Breathe in gently...';

  @override
  String get comfortZoneBreatheHold => 'Hold softly...';

  @override
  String get comfortZoneBreatheOut => 'Breathe out slowly...';

  @override
  String get comfortZoneRecentSpace => 'Recently visited';

  @override
  String comfortZoneScenesCount(int count) {
    return '$count spaces';
  }

  @override
  String get comfortZonePreviousSpace => 'Previous space';

  @override
  String get comfortZoneNextSpace => 'Next space';

  @override
  String get notificationPreviewSectionTitle => 'Soul Notification Format';

  @override
  String notificationMorningTitle(String name) {
    return 'Good morning, $name 🌿';
  }

  @override
  String get notificationMorningBody =>
      'Take a slow breath. What small gratitude would you like to plant for today?';

  @override
  String notificationEveningTitle(String name) {
    return 'Wind down gently, $name 🌙';
  }

  @override
  String get notificationEveningBody =>
      'Before rest, hold onto one peaceful moment or quiet kindness from today.';

  @override
  String get notificationPrivacyNote =>
      'Strict privacy: Lock-screen notifications never expose your private journal notes or future letters.';

  @override
  String get notificationSendTest => 'Send test notification';

  @override
  String get notificationTestSent =>
      'Sample notification sent! Check your device notification shade.';

  @override
  String get homeWidgetTitle => 'Home Screen Widget';

  @override
  String get homeWidgetSubtitle =>
      'Pin your favorite Little Corner sanctuary, Healing Sound & Frequency, Vision, Daily Gratitude, or Soul Card right on your phone\'s home screen.';

  @override
  String get homeWidgetBannerSubtitle =>
      'Pin Little Corner, Healing Sounds & Vision to your phone\'s home screen';

  @override
  String get homeWidgetModeLabel => 'Widget Content Source';

  @override
  String get homeWidgetModeComfortZone => 'Little Corner';

  @override
  String get homeWidgetModeSound => 'Sound & Frequency';

  @override
  String get homeWidgetModeVision => 'My Vision';

  @override
  String get homeWidgetModeGratitude => 'Daily Gratitude';

  @override
  String get homeWidgetModeCard => 'Soul Card Message';

  @override
  String get homeWidgetSelectSpace => 'Choose Little Corner Space';

  @override
  String get homeWidgetSelectSound => 'Choose Healing Sound / Frequency';

  @override
  String get homeWidgetSpaceFooter => 'Tap to enter your safe sanctuary ✦';

  @override
  String get homeWidgetSoundFooter => 'Tap to play healing frequency ✦';

  @override
  String get homeWidgetThemeLabel => 'Widget Style';

  @override
  String get homeWidgetThemePlum => 'Plum Dusk';

  @override
  String get homeWidgetThemePaper => 'Warm Paper';

  @override
  String get homeWidgetThemeRose => 'Rose Dawn';

  @override
  String get homeWidgetPinButton => 'Add Widget to Home Screen';

  @override
  String get homeWidgetSyncButton => 'Sync Widget Now';

  @override
  String get homeWidgetSyncedSuccess => 'Home screen widget updated!';

  @override
  String get homeWidgetHowToHint =>
      'Tip: Tap the Add button above, or long-press an empty area on your phone\'s home screen → select Widgets → choose Soul.';

  @override
  String get moodThemeButtonTooltip => 'Mood & Theme';

  @override
  String get moodThemeSheetTitle => 'Mood & Ambiance';

  @override
  String get moodThemeSheetSubtitle =>
      'Choose your mood to tune Soul\'s colors and music to your heart.';

  @override
  String moodThemeChangedToast(String moodName) {
    return 'Soul tuned the ambiance to $moodName ✨';
  }

  @override
  String get moodPeacefulDesc => 'Serene, calms the mind · 432Hz';

  @override
  String get moodGratefulDesc => 'Warm, loving, appreciative · 528Hz';

  @override
  String get moodEnergizedDesc => 'Fresh, inspiring, positive flow';

  @override
  String get moodRelievedDesc => 'Light, gentle, relaxed breath';

  @override
  String get moodReflectiveDesc => 'Quiet, deep, soothing night';
}
