// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Soul';

  @override
  String get today => '今日';

  @override
  String get vision => 'ビジョン';

  @override
  String get journal => 'ジャーナル';

  @override
  String get explore => '探索';

  @override
  String get continueLabel => '次へ';

  @override
  String welcome(Object name) {
    return 'ようこそ、$nameさん';
  }

  @override
  String get whatShouldWeCallYou => 'Soulから何とお呼びしましょうか？';

  @override
  String get nameHint => 'お名前またはニックネーム';

  @override
  String get saveAndContinue => '保存して次へ';

  @override
  String get todayRhythm => '今日のリズム';

  @override
  String get oneSmallAction => 'ひとつの小さな行動';

  @override
  String get smallActionText => '今日出会う誰かに、心の中でそっと感謝を送るか、温かい笑顔を向けてみましょう。';

  @override
  String get recent => '最近のノート';

  @override
  String get oneNote => '1件のノート';

  @override
  String get gratitudeToday => '感謝 · 今日';

  @override
  String get gratitudeNote => 'この人生に感謝しています';

  @override
  String get gratitudeJournalTitle => '感謝ジャーナル';

  @override
  String get gratitudeJournalHint => '感謝の想いはすべて、あなたの心に蒔かれる安らぎの種です。';

  @override
  String get gratitudeNoteLabel => '今日、何に感謝していますか？';

  @override
  String get saveNote => 'ノートを保存';

  @override
  String get gratitudeNotesEmpty => 'まだノートがありません。下のボタンから最初のノートを作成しましょう。';

  @override
  String get yourVisions => 'あなたのビジョンボード';

  @override
  String get createVision => 'ビジョンを作成';

  @override
  String get visionEmptyTitle => '夢のための空間を作りましょう';

  @override
  String get visionEmptyBody => '意味のあるビジョンは、あなたの心の奥底にある純粋な願いから始まります。';

  @override
  String get audioPending => 'オーディオ準備中';

  @override
  String get visionAudio => 'ビジョン・サウンドトラック';

  @override
  String get visionAudioBody =>
      'Soulの音楽や端末内のオーディオファイルを選ぶか、あなた自身のアファメーションを録音しましょう。';

  @override
  String get visionAudioEmpty => 'サウンドトラックはまだ追加されていません。';

  @override
  String get visionAudioPersonal => 'この端末のみに保存';

  @override
  String get addAudio => 'オーディオを追加';

  @override
  String get audioLibrary => 'オーディオライブラリ';

  @override
  String get chooseFromAudioLibrary => 'Soulライブラリから選択';

  @override
  String get chooseAudioFile => '端末からオーディオファイルを選択';

  @override
  String get recordAudio => '音声アファメーションを録音';

  @override
  String get stopRecording => '録音を停止して保存';

  @override
  String get myRecording => 'マイ録音';

  @override
  String get removeAudio => 'オーディオを削除';

  @override
  String get audioGuided => 'ガイド付き瞑想';

  @override
  String get audioMusic => 'ヒーリング＆周波数音楽';

  @override
  String get audioRest => '自然音＆深いリラクゼーション';

  @override
  String get audioLibraryNote =>
      '心を鎮め、魂を高めるために厳選されたアンビエントサウンドと432Hz/528Hz周波数トラック。';

  @override
  String get nowPlaying => '再生中';

  @override
  String get stop => '停止';

  @override
  String get allAudio => 'すべて';

  @override
  String get audioNature => '自然音＆アンビエンス';

  @override
  String get audioMusicTab => '音楽＆サウンドスケープ';

  @override
  String get audioGuidedTab => 'ガイド付き瞑想';

  @override
  String get recommendedForVision => 'このビジョンへのおすすめ';

  @override
  String get exploreTitle => 'Soul サンクチュアリ';

  @override
  String get exploreBody => '内なる自分を育むヒーリングサウンド、ガイド付き瞑想、心に響く知恵を見つけましょう。';

  @override
  String get exploreTabAll => 'すべて';

  @override
  String get exploreTabAudio => 'Soul オーディオ';

  @override
  String get exploreTabMeditation => '瞑想';

  @override
  String get exploreTabPodcast => 'ポッドキャスト';

  @override
  String get exploreTabFrequency => '周波数';

  @override
  String get exploreOpenYouTube => 'YouTubeで見る';

  @override
  String get exploreOpenSpotify => 'Spotifyで聴く';

  @override
  String get profile => 'プロフィールと設定';

  @override
  String get soundOn => 'サウンド ON';

  @override
  String get soundOff => 'サウンド OFF';

  @override
  String get language => '言語';

  @override
  String get editName => '呼び名を編集';

  @override
  String get signOut => 'サインアウト';

  @override
  String get back => '戻る';

  @override
  String dayProgress(int day) {
    return '28日中の$day日目';
  }

  @override
  String get authTagline => 'あなたの魂のための、静かでプライベートな聖域。';

  @override
  String get morningGratitude => '朝の感謝ワーク';

  @override
  String get neutralInstrumentalFiveMinutes => '穏やかなピアノ · 5分';

  @override
  String get play => '再生';

  @override
  String get vietnameseLanguage => 'ベトナム語';

  @override
  String get englishLanguage => '英語';

  @override
  String get languageEndonymVi => 'Tiếng Việt';

  @override
  String get languageEndonymEn => 'English';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get pause => '一時停止';

  @override
  String get cancel => 'キャンセル';

  @override
  String get somethingWentWrong => '問題が発生しました。もう一度お試しください。';

  @override
  String get save => '保存';

  @override
  String nameTooLong(int max) {
    return '$max文字以内で入力してください。';
  }

  @override
  String get intentionTitle => '今日、どんな想いでSoulを訪れましたか？';

  @override
  String get intentionBody => '今あなたにとって最も大切なものを選んでください。間違いはありません。';

  @override
  String get intentionChooseOne => '始めるには少なくとも1つ選択してください。';

  @override
  String get remindersTitle => '毎日の小さなリズム';

  @override
  String get remindersBody => '一日を穏やかに始め、優しく締めくくる2つの時間を選びましょう。';

  @override
  String get reminderMorning => '朝のリマインダー';

  @override
  String get reminderEvening => '夜の振り返り';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return '$reminderの時間を変更（現在 $time）';
  }

  @override
  String get skipForNow => '今はスキップ';

  @override
  String get journeyReadyTitle => 'あなたの夢と継続する力に投資しましょう';

  @override
  String get journeyReadyBody =>
      '小さな投資は、毎日自分の夢に向き合い、今この瞬間を大切にし、確かな決意をもって内なる変化の旅を歩むという自分自身への心の約束です。';

  @override
  String get beginDayOne => 'コミットして旅を始める';

  @override
  String get chooseCategoryTitle => 'テーマを選択';

  @override
  String get chooseCategoryBody => '今、あなたの意図とエネルギーをどこに向けたいですか？';

  @override
  String visionStepLabel(Object category, int step, int total) {
    return '$category · $step/$total';
  }

  @override
  String chooseUpTo(int max) {
    return '最大$maxつまで選択できます。';
  }

  @override
  String get answerRequiredHint => 'インスピレーションを与える提案を選ぶか、あなた自身の願いを書き留めましょう。';

  @override
  String get visionQuickStart => '感情の選択へ進む';

  @override
  String get feelingsTitle => 'このビジョンが叶ったとき、どんな気持ちを感じたいですか？';

  @override
  String get feelingsHint => '最も心に響く感情を1〜3つ選んでください。';

  @override
  String get feelingsLimitReached => '3つの感情が選択されています。変更する場合は1つ解除してください。';

  @override
  String get statementTitle => 'あなたのビジョン・アファメーション';

  @override
  String get statementBody =>
      'あなたの選択をもとにSoulがアファメーションを作成しました。心にフィットするよう自由に整えてください。';

  @override
  String get statementLabel => 'ビジョン・ステートメント';

  @override
  String get statementEmpty => '1〜2文であなたのビジョンを書きましょう。';

  @override
  String statementTooLong(int max) {
    return '$max文字以内で入力してください。';
  }

  @override
  String get visionImageTitle => 'ビジョンに命を吹き込む';

  @override
  String get visionImageBody => '心に情景を描き、その感情を味わえるよう、インスピレーションを与える写真を追加しましょう。';

  @override
  String get chooseFromLibrary => 'ライブラリから選択';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get removePhoto => '写真を削除';

  @override
  String get visionPhoto => 'ビジョン写真';

  @override
  String get photoUnavailable => 'この写真は表示できません。';

  @override
  String get reviewVisionTitle => 'ビジョンの確認';

  @override
  String get saveToVisionBoard => 'ビジョンボードに保存';

  @override
  String get visionSaveFailed => 'ビジョンを保存できませんでした。選択内容は保持されていますので、もう一度お試しください。';

  @override
  String get archiveVision => 'ビジョンをアーカイブ';

  @override
  String get archiveVisionTitle => 'このビジョンをアーカイブしますか？';

  @override
  String get archiveVisionBody => 'ボードから外れ、アーカイブに安全に保管されます。';

  @override
  String get archive => 'アーカイブ';

  @override
  String get visionNotFound => 'このビジョンはボード上にありません。';

  @override
  String get visionSoundtrack => 'コンパニオン・サウンドトラック';

  @override
  String get visionBoardSubtitle => 'あなたが日々歩み出している意図、感情、そして人生のための聖域。';

  @override
  String get welcomeTitle1 => 'Soulへようこそ';

  @override
  String get welcomeSubtitle1 => '毎日少し立ち止まり、耳を傾け、あなたの心を優しく育む穏やかな聖域です。';

  @override
  String get welcomeTitle2 => '感謝の実践';

  @override
  String get welcomeSubtitle2 => '内なる喜びを呼び覚ますシンプルで心地よい習慣で、日々のマインドセットを整えましょう。';

  @override
  String get welcomeTitle3 => 'ビジョンボード＆サウンドスケープ';

  @override
  String get welcomeSubtitle3 => '心躍るビジョンボードと癒やしの周波数サウンドで、あなたの夢を鮮明に描きましょう。';

  @override
  String get startJourney => '旅を始める';

  @override
  String get revisitOnboarding => 'ウェルカムツアーをもう一度見る';

  @override
  String get todayGreeting => '穏やかで心満たされる一日になりますように ✨';

  @override
  String get todayJourneyHeroTitle => '今日の10の感謝';

  @override
  String get todayJourneyHeroSubtitle => '朝の数分間、人生の恵みを数え、それがなぜ大切なのかを味わいましょう。';

  @override
  String get todayStartPractice => 'ワークを始める';

  @override
  String get todayContinuePractice => 'ワークを続ける';

  @override
  String get todayPracticeCompleted => '今日のワーク完了 ✨';

  @override
  String get moodCheckInTitle => '今の気分はいかがですか？';

  @override
  String get moodPeaceful => '穏やか 🕊️';

  @override
  String get moodGrateful => '感謝 🌸';

  @override
  String get moodEnergized => '元気 ☀️';

  @override
  String get moodRelieved => 'ほっとする 🍃';

  @override
  String get moodReflective => '静かな内省 🌙';

  @override
  String get eveningReflectionTitle => '夜の振り返り';

  @override
  String get eveningReflectionBody => '眠りにつく前に、今日起きた最も心温まる出来事をひとつ思い出してみましょう。';

  @override
  String get gratitudePracticeTitle => '朝の感謝ワーク';

  @override
  String get gratitudePracticeIntroTitle => '感謝とともに一日を始めましょう';

  @override
  String get gratitudePracticeIntroBody =>
      '今日感謝している10のことを見つけ、それぞれがなぜ大切なのかを書き留めましょう。';

  @override
  String get gratitudeStartPractice => '実践を始める';

  @override
  String gratitudeItemProgress(int current, int total) {
    return '$total件中 $current件目';
  }

  @override
  String get gratitudeFieldPrompt => '感謝していること...';

  @override
  String get gratitudeFieldPlaceholder => '今日感謝していることを書きましょう';

  @override
  String get gratitudeReasonPrompt => 'その理由は...';

  @override
  String get gratitudeReasonPlaceholder => 'なぜそれがあなたにとって大切なのですか？';

  @override
  String gratitudeTapThankYou(int count) {
    return '「ありがとう」と伝える ($count/3)';
  }

  @override
  String get gratitudeTapHint => '3回タップして感謝の気持ちを心に刻みましょう';

  @override
  String get gratitudeAddAndNext => '追加して次へ';

  @override
  String get gratitudeReviewTitle => '今日の10の感謝';

  @override
  String get gratitudeReviewSubtitle => '今日の記録を完了する前にリストを振り返りましょう。';

  @override
  String get gratitudeCompletePractice => '実践を完了する';

  @override
  String get gratitudeCompletedTitle => '実践が完了しました ✨';

  @override
  String get gratitudeCompletedBody =>
      '今日という日に10個の感謝の種を蒔きました。内容はジャーナルに保存されました。';

  @override
  String get gratitudeBackToToday => '今日へ戻る';

  @override
  String get gratitudeStatusIncomplete => '未完了';

  @override
  String get gratitudeStatusCompleted => '10件中10件完了';

  @override
  String get gratitudeCardTapToStart => '朝のワークを始める';

  @override
  String get gratitudeCardTapToReview => '今日の感謝を見る';

  @override
  String get editEntry => '編集';

  @override
  String get done => '完了';

  @override
  String gratitudeReasonLabel(String reason) {
    return '理由: $reason';
  }

  @override
  String get gratitudeFinishEarly => '早めに終了する';

  @override
  String get gratitudeSkipItem => 'この項目をスキップ';

  @override
  String get gratitudeSkipProgress => 'スキップする';

  @override
  String get gratitudeSkippedTitle => '実践をスキップしました';

  @override
  String get gratitudeSkippedBody => '今日の感謝ワークをスキップしました。いつでも戻って実践できます。';

  @override
  String gratitudeReviewTitleCount(int count) {
    return '今日の$countつの感謝';
  }

  @override
  String gratitudeCompletedBodyCount(int count) {
    return '今日という日に$count個の感謝の種を蒔きました。内容はジャーナルに保存されました。';
  }

  @override
  String gratitudeStatusCompletedCount(int count) {
    return '$count件の感謝を完了';
  }

  @override
  String get gratitudeLevelLow => 'ありがとう';

  @override
  String get gratitudeLevelMedium => '心から感謝';

  @override
  String get gratitudeLevelHigh => '深い感謝';

  @override
  String get gratitudeTapLevelHint => '感謝の深さを選んでください';

  @override
  String get signOutConfirmTitle => 'Soulからサインアウトしますか？';

  @override
  String get signOutConfirmBody => 'サインアウトしてもよろしいですか？ウェルカム画面に戻ります。';

  @override
  String get addNote => '新しいノートを追加';

  @override
  String get newGratitudeNote => '新しい感謝ノート';

  @override
  String get notePromptPlaceholder => '今日、何に感謝していますか？';

  @override
  String get noteReasonPlaceholder => 'なぜそれが大切なのですか？（任意）';

  @override
  String get deleteNote => 'ノートを削除';

  @override
  String get deleteNoteConfirmTitle => 'このノートを削除しますか？';

  @override
  String get deleteNoteConfirmBody => 'このノートはジャーナルから完全に削除されます。';

  @override
  String get noteSaved => 'ジャーナルに保存しました';

  @override
  String get noteDeleted => 'ノートを削除しました';

  @override
  String notesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のノート',
      one: '1件のノート',
    );
    return '$_temp0';
  }

  @override
  String get reminderSettingsTitle => 'リマインダー通知';

  @override
  String get reminderSettingsSubtitle => '設定した時間にSoulが優しいリマインダーをお届けします。';

  @override
  String get settingsSectionTitle => '設定';

  @override
  String get accountSectionTitle => 'アカウント';

  @override
  String get saveSettings => '変更を保存';

  @override
  String get settingsSaved => '設定を保存しました';

  @override
  String get close => '閉じる';

  @override
  String get customNoteDefaultTheme => '感謝の瞬間';

  @override
  String gratitudeSentenceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countつの感謝',
      one: '1つの感謝',
    );
    return '$_temp0';
  }

  @override
  String get allGratitudesInNote => 'ノートの内容';

  @override
  String get sentencePreview => '文章のプレビュー:';

  @override
  String get soulCardsTitle => 'Soul カード';

  @override
  String get soulCardsSubtitle => 'あなたの魂への導きのメッセージを受け取る';

  @override
  String dailyDrawRemaining(int count) {
    return '今日あと$count回引けます';
  }

  @override
  String get dailyDrawLimitReached => '今日のメッセージ（2枚）を受け取りました';

  @override
  String get dailyDrawLimitHint => '今日のメッセージをゆっくり味わいましょう。明日また引くことができます。';

  @override
  String get drawCardAction => 'カードを引く';

  @override
  String get drawAnotherCard => 'もう一枚引く';

  @override
  String get reviewTodayCards => '今日のメッセージを見る';

  @override
  String get cardDrawSuccess => 'あなたへの導きのメッセージ';

  @override
  String get todayCardDrawBanner => 'Soul メッセージ';

  @override
  String get chooseDeckPrompt => 'メッセージを受け取るデッキを選んでください';

  @override
  String get tapCardToReveal => 'カードをタップしてメッセージを開く';

  @override
  String get saveToJournalAction => 'ジャーナルに保存';

  @override
  String get savedToJournalSuccess => 'メッセージをジャーナルに保存しました';

  @override
  String get cardDrawHistory => '引いた履歴';

  @override
  String deckCardCount(int count) {
    return '$count枚のカード';
  }

  @override
  String get soulCardsTab => 'Soul カード';

  @override
  String get dailyDrawLimitDialogTitle => '本日の上限に達しました';

  @override
  String get dailyDrawLimitDialogMessage =>
      '今日はすでに2つのメッセージを受け取りました。今日のメッセージを心に留め、また明日お越しください。';

  @override
  String get understood => '了解しました';

  @override
  String get chooseDeckSubtitle => '導きのメッセージを受け取るデッキを選択してください';

  @override
  String get drawFromThisDeck => 'このデッキから引く';

  @override
  String get gratitudeJournalPrompt =>
      '今日も感謝の旅を続けましょう。どんなに小さなことでも、感謝していることに心を向けてみてください。おすすめの書き方:\n「私は…に感謝しています。なぜなら…だからです。」\n書き終えたら、深い感謝の気持ちで読み返してみましょう。';

  @override
  String get gratitudeJournalPlaceholder =>
      '静かな日記帳のように、今日感謝していることを書き留めましょう...\n\n例:\n今朝の温かいコーヒーが心にゆとりと安らぎをくれたことに感謝しています。\n友人の笑顔が心を温めてくれたことに感謝しています...';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get changePhoto => '写真を変更';

  @override
  String get insertPromptTemplate => 'テンプレートを挿入';

  @override
  String get saveAndCompleteJournal => '完了してジャーナルを保存';

  @override
  String get gratitudePromptTemplateText => '私は…に感謝しています。なぜなら…だからです。';

  @override
  String get chooseTheme => 'テーマを選択';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get noteUpdated => 'ノートを更新しました';

  @override
  String get gratitudeGuidanceTitle => '今日のワークガイド';

  @override
  String get showGuidance => 'ガイドを表示';

  @override
  String get hideGuidance => 'ガイドを隠す';

  @override
  String get comfortZoneTitle => 'Little Corner';

  @override
  String get comfortZoneSubtitle => 'A Little World Where You Feel Safe';

  @override
  String get comfortZoneBannerSubtitle =>
      'A Little World Where You Feel Safe — アニメーションと癒やしの音に包まれる安らぎの空間';

  @override
  String comfortZoneAllSpaces(int count) {
    return 'すべて ($count)';
  }

  @override
  String get comfortZoneFavorites => 'お気に入り';

  @override
  String get comfortZoneFavoritesEmpty =>
      'お気に入りの空間はまだありません。ハートアイコンをタップしてここに保存しましょう。';

  @override
  String get comfortZoneEnterSpace => '空間に入る';

  @override
  String get comfortZoneAmbientSound => '環境音＆音楽';

  @override
  String get comfortZoneGuidedAudio => 'ガイド音声';

  @override
  String get comfortZoneZenMode => '禅モード';

  @override
  String get comfortZoneExitZenMode => 'コントロールを表示';

  @override
  String get comfortZoneBreathingGuide => '呼吸ガイド';

  @override
  String get comfortZoneBreatheIn => 'ゆっくりと息を吸って...';

  @override
  String get comfortZoneBreatheHold => 'そっと息を止めて...';

  @override
  String get comfortZoneBreatheOut => 'ゆっくりと息を吐いて...';

  @override
  String get comfortZoneRecentSpace => '最近訪れた空間';

  @override
  String comfortZoneScenesCount(int count) {
    return '$countつの空間';
  }

  @override
  String get comfortZonePreviousSpace => '前の空間';

  @override
  String get comfortZoneNextSpace => '次の空間';

  @override
  String get notificationPreviewSectionTitle => 'Soul通知フォーマットのプレビュー';

  @override
  String notificationMorningTitle(String name) {
    return 'おはようございます、$nameさん 🌿';
  }

  @override
  String get notificationMorningBody => '深く息を吸いましょう。今日はどんな小さな感謝の種を蒔きたいですか？';

  @override
  String notificationEveningTitle(String name) {
    return '今日を優しく締めくくりましょう、$nameさん 🌙';
  }

  @override
  String get notificationEveningBody =>
      '眠りにつく前に、今日訪れた穏やかな瞬間や小さな優しさを心に留めてみましょう。';

  @override
  String get notificationPrivacyNote =>
      'プライバシー保護：ロック画面の通知に日記や未来への手紙の内容が表示されることはありません。';

  @override
  String get notificationSendTest => 'テスト通知を送信';

  @override
  String get notificationTestSent => 'サンプル通知を送信しました！端末の通知バーをご確認ください。';

  @override
  String get homeWidgetTitle => 'ホーム画面ウィジェット';

  @override
  String get homeWidgetSubtitle =>
      'Little Cornerの空間、癒やしのサウンド＆周波数、ビジョン、今日の感謝、Soulカードをホーム画面に配置しましょう。';

  @override
  String get homeWidgetBannerSubtitle => 'Little Corner・癒やしの音・ビジョンをホーム画面に表示';

  @override
  String get homeWidgetModeLabel => 'ウィジェットの表示内容';

  @override
  String get homeWidgetModeComfortZone => 'Little Corner';

  @override
  String get homeWidgetModeSound => 'サウンド＆周波数';

  @override
  String get homeWidgetModeVision => 'マイビジョン';

  @override
  String get homeWidgetModeGratitude => '今日の感謝';

  @override
  String get homeWidgetModeCard => 'Soulカードメッセージ';

  @override
  String get homeWidgetSelectSpace => 'Little Cornerの空間を選択';

  @override
  String get homeWidgetSelectSound => '癒やしのサウンド／周波数を選択';

  @override
  String get homeWidgetSpaceFooter => 'タップして安らぎの空間へ入る ✦';

  @override
  String get homeWidgetSoundFooter => 'タップして癒やしの周波数を聴く ✦';

  @override
  String get homeWidgetThemeLabel => 'ウィジェットのスタイル';

  @override
  String get homeWidgetThemePlum => 'プラムダスク';

  @override
  String get homeWidgetThemePaper => 'ウォームペーパー';

  @override
  String get homeWidgetThemeRose => 'ローズドーン';

  @override
  String get homeWidgetPinButton => 'ホーム画面にウィジェットを追加';

  @override
  String get homeWidgetSyncButton => 'ウィジェットを今すぐ更新';

  @override
  String get homeWidgetSyncedSuccess => 'ホーム画面ウィジェットを更新しました！';

  @override
  String get homeWidgetHowToHint =>
      'ヒント：上の追加ボタンをタップするか、ホーム画面の空きスペースを長押し →「ウィジェット」→「Soul」を選択して配置できます。';

  @override
  String get moodThemeButtonTooltip => '気分とテーマ';

  @override
  String get moodThemeSheetTitle => '気分と雰囲気テーマ';

  @override
  String get moodThemeSheetSubtitle => '今の気分を選んで、Soulの色彩と音楽を心に寄り添わせましょう。';

  @override
  String moodThemeChangedToast(String moodName) {
    return 'Soulの空間を$moodNameに切り替えました ✨';
  }

  @override
  String get moodPeacefulDesc => '穏やかで心が落ち着く · 432Hz';

  @override
  String get moodGratefulDesc => '温かい感謝と愛 · 528Hz';

  @override
  String get moodEnergizedDesc => '新鮮で前向きなエネルギー';

  @override
  String get moodRelievedDesc => '安心感と軽やかな呼吸';

  @override
  String get moodReflectiveDesc => '静かな思索と夜の安らぎ';
}
