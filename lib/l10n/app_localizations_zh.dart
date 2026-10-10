// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Soul';

  @override
  String get today => '今日';

  @override
  String get vision => '愿景';

  @override
  String get journal => '日记';

  @override
  String get explore => '探索';

  @override
  String get continueLabel => '继续';

  @override
  String welcome(Object name) {
    return '欢迎你，$name';
  }

  @override
  String get whatShouldWeCallYou => 'Soul 该如何称呼你？';

  @override
  String get nameHint => '你喜欢的名字或昵称';

  @override
  String get saveAndContinue => '保存并继续';

  @override
  String get todayRhythm => '今日节律';

  @override
  String get oneSmallAction => '一个微小的行动';

  @override
  String get smallActionText => '今天，在心里默默向遇到的人送上感恩，或传递一个温暖的微笑。';

  @override
  String get recent => '近期笔记';

  @override
  String get oneNote => '1 篇笔记';

  @override
  String get gratitudeToday => '感恩 · 今日';

  @override
  String get gratitudeNote => '我感恩这一生';

  @override
  String get gratitudeJournalTitle => '感恩日记';

  @override
  String get gratitudeJournalHint => '每一个感恩的念头，都是播撒在心田里的一颗宁静种子。';

  @override
  String get gratitudeNoteLabel => '今天你为什么心怀感恩？';

  @override
  String get saveNote => '保存笔记';

  @override
  String get gratitudeNotesEmpty => '还没有感恩笔记。点击下方创建你的第一篇吧。';

  @override
  String get yourVisions => '你的愿景板';

  @override
  String get createVision => '创建愿景';

  @override
  String get visionEmptyTitle => '为你的梦想留出空间';

  @override
  String get visionEmptyBody => '真正有意义的愿景，始于你内心深处最真实、最纯粹的渴望。';

  @override
  String get audioPending => '音频即将上线';

  @override
  String get visionAudio => '愿景伴奏';

  @override
  String get visionAudioBody => '从 Soul 曲库选择音乐、从设备导入音频，或录制专属于你的肯定语。';

  @override
  String get visionAudioEmpty => '尚未添加伴奏音频。';

  @override
  String get visionAudioPersonal => '仅保存在此设备上';

  @override
  String get addAudio => '添加音频';

  @override
  String get audioLibrary => '音频库';

  @override
  String get chooseFromAudioLibrary => '从 Soul 音频库选择';

  @override
  String get chooseAudioFile => '从设备选择音频文件';

  @override
  String get recordAudio => '录制语音肯定语';

  @override
  String get stopRecording => '停止并保存录音';

  @override
  String get myRecording => '我的录音';

  @override
  String get removeAudio => '移除音频';

  @override
  String get audioGuided => '引导冥想';

  @override
  String get audioMusic => '疗愈与频率音乐';

  @override
  String get audioRest => '自然之声与深度放松';

  @override
  String get audioLibraryNote => '精选环境音景与 432Hz/528Hz 疗愈频率曲目，助你平静思绪、提升内在能量。';

  @override
  String get nowPlaying => '正在播放';

  @override
  String get stop => '停止';

  @override
  String get allAudio => '全部';

  @override
  String get audioNature => '自然与氛围';

  @override
  String get audioMusicTab => '音乐与音景';

  @override
  String get audioGuidedTab => '引导冥想';

  @override
  String get recommendedForVision => '为此愿景推荐';

  @override
  String get exploreTitle => 'Soul 心灵栖息地';

  @override
  String get exploreBody => '探索疗愈音景、引导冥想与启发智慧，温柔滋养你的内在自我。';

  @override
  String get exploreTabAll => '全部';

  @override
  String get exploreTabAudio => 'Soul 音频';

  @override
  String get exploreTabMeditation => '冥想';

  @override
  String get exploreTabPodcast => '播客';

  @override
  String get exploreTabFrequency => '疗愈频率';

  @override
  String get exploreOpenYouTube => '在 YouTube 上观看';

  @override
  String get exploreOpenSpotify => '在 Spotify 上收听';

  @override
  String get profile => '个人资料与设置';

  @override
  String get soundOn => '声音已开启';

  @override
  String get soundOff => '声音已关闭';

  @override
  String get language => '语言';

  @override
  String get editName => '修改称呼';

  @override
  String get signOut => '退出登录';

  @override
  String get back => '返回';

  @override
  String dayProgress(int day) {
    return '第 $day / 28 天';
  }

  @override
  String get authTagline => '属于你灵魂的私密、温柔空间。';

  @override
  String get morningGratitude => '晨间感恩练习';

  @override
  String get neutralInstrumentalFiveMinutes => '轻柔钢琴 · 5 分钟';

  @override
  String get play => '播放';

  @override
  String get vietnameseLanguage => '越南语';

  @override
  String get englishLanguage => '英语';

  @override
  String get languageEndonymVi => 'Tiếng Việt';

  @override
  String get languageEndonymEn => 'English';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String get pause => '暂停';

  @override
  String get cancel => '取消';

  @override
  String get somethingWentWrong => '出错了，请稍后重试。';

  @override
  String get save => '保存';

  @override
  String nameTooLong(int max) {
    return '请保持在 $max 个字符以内。';
  }

  @override
  String get intentionTitle => '今天是什么指引你来到 Soul？';

  @override
  String get intentionBody => '选择此刻对你最重要的心愿，这里没有标准答案。';

  @override
  String get intentionChooseOne => '请至少选择一项以开始。';

  @override
  String get remindersTitle => '每日的温柔节律';

  @override
  String get remindersBody => '选择两个安静的时刻，开启并温柔收尾你的一天。';

  @override
  String get reminderMorning => '晨间提醒';

  @override
  String get reminderEvening => '晚间回顾';

  @override
  String changeReminderTime(Object reminder, Object time) {
    return '更改$reminder时间，当前为 $time';
  }

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get journeyReadyTitle => '为你的梦想与坚持投资';

  @override
  String get journeyReadyBody =>
      '一份小小的投入，是对自己真挚的承诺——每天忠于梦想、珍惜当下，并以坚定的心走过内在蜕变之旅。';

  @override
  String get beginDayOne => '许下承诺并开启旅程';

  @override
  String get chooseCategoryTitle => '选择一个领域';

  @override
  String get chooseCategoryBody => '此刻，你最想把心意与能量倾注在哪里？';

  @override
  String visionStepLabel(Object category, int step, int total) {
    return '$category · $step/$total';
  }

  @override
  String chooseUpTo(int max) {
    return '最多可选择 $max 项。';
  }

  @override
  String get answerRequiredHint => '选择一个给你灵感的建议，或写下你内心的真实愿望。';

  @override
  String get visionQuickStart => '继续选择感受';

  @override
  String get feelingsTitle => '当这个愿景实现时，你希望拥有怎样的感受？';

  @override
  String get feelingsHint => '选择 1 到 3 个最触动你的感受。';

  @override
  String get feelingsLimitReached => '你已选择了 3 个感受。如需更换，请先取消其中一个。';

  @override
  String get statementTitle => '你的愿景肯定语';

  @override
  String get statementBody => 'Soul 根据你的选择生成了这段充满力量的肯定语。你可以自由润色，让它更贴合你的心意。';

  @override
  String get statementLabel => '愿景宣言';

  @override
  String get statementEmpty => '用 1 到 2 句充满灵感的话写下你的愿景。';

  @override
  String statementTooLong(int max) {
    return '请保持在 $max 个字符以内。';
  }

  @override
  String get visionImageTitle => '让你的愿景栩栩如生';

  @override
  String get visionImageBody => '添加一张给你灵感的照片，帮助你在脑海中描绘画面并感受那份喜悦。';

  @override
  String get chooseFromLibrary => '从相册选择';

  @override
  String get takePhoto => '拍照';

  @override
  String get removePhoto => '移除照片';

  @override
  String get visionPhoto => '愿景照片';

  @override
  String get photoUnavailable => '无法显示此照片。';

  @override
  String get reviewVisionTitle => '预览你的愿景';

  @override
  String get saveToVisionBoard => '保存到愿景板';

  @override
  String get visionSaveFailed => '无法保存你的愿景。你的选择已保留，请重试。';

  @override
  String get archiveVision => '归档愿景';

  @override
  String get archiveVisionTitle => '归档此愿景？';

  @override
  String get archiveVisionBody => '它将从愿景板移出，并安全保存在归档中。';

  @override
  String get archive => '归档';

  @override
  String get visionNotFound => '此愿景已不在你的愿景板上。';

  @override
  String get visionSoundtrack => '伴奏音轨';

  @override
  String get visionBoardSubtitle => '安放你每日奔赴的心愿、感受与理想生活的静谧空间。';

  @override
  String get welcomeTitle1 => '欢迎来到 Soul';

  @override
  String get welcomeSubtitle1 => '一个宁静祥和的心灵栖息地，让你每天驻足、倾听，温柔滋养内在精神。';

  @override
  String get welcomeTitle2 => '感恩练习';

  @override
  String get welcomeSubtitle2 => '通过简单而笃定的日常练习唤醒内在喜悦，转变你的每日心态。';

  @override
  String get welcomeTitle3 => '愿景板与疗愈音景';

  @override
  String get welcomeSubtitle3 => '借助充满灵感的愿景板与疗愈频率音景，让你的梦想清晰可见。';

  @override
  String get startJourney => '开启旅程';

  @override
  String get revisitOnboarding => '重温欢迎导览';

  @override
  String get todayGreeting => '愿你拥有宁静而充实的一天 ✨';

  @override
  String get todayJourneyHeroTitle => '今日 10 件感恩之事';

  @override
  String get todayJourneyHeroSubtitle => '花几分钟晨间时光，细数生活中的美好馈赠，并体会它们为何珍贵。';

  @override
  String get todayStartPractice => '开始练习';

  @override
  String get todayContinuePractice => '继续练习';

  @override
  String get todayPracticeCompleted => '今日已完成 ✨';

  @override
  String get moodCheckInTitle => '此刻你的感受如何？';

  @override
  String get moodPeaceful => '平静 🕊️';

  @override
  String get moodGrateful => '感恩 🌸';

  @override
  String get moodEnergized => '充满活力 ☀️';

  @override
  String get moodRelieved => '释然 🍃';

  @override
  String get moodReflective => '沉思 🌙';

  @override
  String get eveningReflectionTitle => '晚间回顾';

  @override
  String get eveningReflectionBody => '在入睡前，回想今天发生的最令你感到温暖和振奋的一件事。';

  @override
  String get gratitudePracticeTitle => '晨间感恩练习';

  @override
  String get gratitudePracticeIntroTitle => '怀着感恩开启新的一天';

  @override
  String get gratitudePracticeIntroBody => '静下心来觉察今天令你感恩的 10 件事，并写下每一件事对你的意义。';

  @override
  String get gratitudeStartPractice => '开始练习';

  @override
  String gratitudeItemProgress(int current, int total) {
    return '第 $current / $total 项';
  }

  @override
  String get gratitudeFieldPrompt => '我心怀感恩的是...';

  @override
  String get gratitudeFieldPlaceholder => '写下一件今天让你感恩的事';

  @override
  String get gratitudeReasonPrompt => '因为...';

  @override
  String get gratitudeReasonPlaceholder => '为什么这件事对你很重要？';

  @override
  String gratitudeTapThankYou(int count) {
    return '轻触说出“谢谢”（$count/3）';
  }

  @override
  String get gratitudeTapHint => '轻触 3 次，将感恩的喜悦深深锚定在心底';

  @override
  String get gratitudeAddAndNext => '添加并下一项';

  @override
  String get gratitudeReviewTitle => '今日的 10 份感恩';

  @override
  String get gratitudeReviewSubtitle => '在封存今日记录前，回顾你写下的感恩清单。';

  @override
  String get gratitudeCompletePractice => '完成练习';

  @override
  String get gratitudeCompletedTitle => '练习已完成 ✨';

  @override
  String get gratitudeCompletedBody => '你已在今天播下了 10 颗感恩的种子，这些记录已保存到你的日记中。';

  @override
  String get gratitudeBackToToday => '返回今日';

  @override
  String get gratitudeStatusIncomplete => '尚未完成';

  @override
  String get gratitudeStatusCompleted => '已完成 10 / 10 项';

  @override
  String get gratitudeCardTapToStart => '开始晨间练习';

  @override
  String get gratitudeCardTapToReview => '查看今日感恩';

  @override
  String get editEntry => '编辑';

  @override
  String get done => '完成';

  @override
  String gratitudeReasonLabel(String reason) {
    return '原因：$reason';
  }

  @override
  String get gratitudeFinishEarly => '提前结束';

  @override
  String get gratitudeSkipItem => '跳过此项';

  @override
  String get gratitudeSkipProgress => '跳过当前进度';

  @override
  String get gratitudeSkippedTitle => '已跳过练习';

  @override
  String get gratitudeSkippedBody => '你已跳过今天的感恩练习，随时可以回来继续完成。';

  @override
  String gratitudeReviewTitleCount(int count) {
    return '今日的 $count 份感恩';
  }

  @override
  String gratitudeCompletedBodyCount(int count) {
    return '你已在今天播下了 $count 颗感恩的种子，这些记录已保存到你的日记中。';
  }

  @override
  String gratitudeStatusCompletedCount(int count) {
    return '已完成 $count 项感恩';
  }

  @override
  String get gratitudeLevelLow => '感谢';

  @override
  String get gratitudeLevelMedium => '由衷感激';

  @override
  String get gratitudeLevelHigh => '深深感恩';

  @override
  String get gratitudeTapLevelHint => '选择感恩的深度';

  @override
  String get signOutConfirmTitle => '退出 Soul？';

  @override
  String get signOutConfirmBody => '确定要退出吗？你将返回欢迎页面。';

  @override
  String get addNote => '添加新笔记';

  @override
  String get newGratitudeNote => '新建感恩笔记';

  @override
  String get notePromptPlaceholder => '今天你为什么心怀感恩？';

  @override
  String get noteReasonPlaceholder => '为什么它对你很重要？（可选）';

  @override
  String get deleteNote => '删除笔记';

  @override
  String get deleteNoteConfirmTitle => '删除这篇笔记？';

  @override
  String get deleteNoteConfirmBody => '这篇笔记将从你的日记中永久移除。';

  @override
  String get noteSaved => '笔记已保存到日记';

  @override
  String get noteDeleted => '笔记已删除';

  @override
  String notesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 篇笔记',
      one: '1 篇笔记',
    );
    return '$_temp0';
  }

  @override
  String get reminderSettingsTitle => '通知提醒';

  @override
  String get reminderSettingsSubtitle => 'Soul 会在你选定的时间发送温柔提醒。';

  @override
  String get settingsSectionTitle => '设置';

  @override
  String get accountSectionTitle => '账户';

  @override
  String get saveSettings => '保存更改';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get close => '关闭';

  @override
  String get customNoteDefaultTheme => '感恩时刻';

  @override
  String gratitudeSentenceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条感恩',
      one: '1 条感恩',
    );
    return '$_temp0';
  }

  @override
  String get allGratitudesInNote => '笔记内容';

  @override
  String get sentencePreview => '完整句子预览：';

  @override
  String get soulCardsTitle => 'Soul 灵感卡';

  @override
  String get soulCardsSubtitle => '为你的灵魂抽取一张指引寄语';

  @override
  String dailyDrawRemaining(int count) {
    return '今日剩余 $count 次抽取机会';
  }

  @override
  String get dailyDrawLimitReached => '今日已抽取 2 张寄语卡';

  @override
  String get dailyDrawLimitHint => '静心体会今天的寄语吧，明天可以再次抽取。';

  @override
  String get drawCardAction => '抽取卡片';

  @override
  String get drawAnotherCard => '再抽一张';

  @override
  String get reviewTodayCards => '查看今日寄语';

  @override
  String get cardDrawSuccess => '给你的指引寄语';

  @override
  String get todayCardDrawBanner => 'Soul 寄语';

  @override
  String get chooseDeckPrompt => '选择一副牌组，倾听它的讯息';

  @override
  String get tapCardToReveal => '轻触卡片揭晓你的寄语';

  @override
  String get saveToJournalAction => '保存到日记';

  @override
  String get savedToJournalSuccess => '寄语已保存到日记';

  @override
  String get cardDrawHistory => '抽取记录';

  @override
  String deckCardCount(int count) {
    return '$count 张卡片';
  }

  @override
  String get soulCardsTab => 'Soul 灵感卡';

  @override
  String get dailyDrawLimitDialogTitle => '已达今日上限';

  @override
  String get dailyDrawLimitDialogMessage =>
      '你今天已经收到了 2 条指引寄语。请静心感受今日的讯息，明天再来抽取吧。';

  @override
  String get understood => '知道了';

  @override
  String get chooseDeckSubtitle => '选择一副牌组以接收你的指引寄语';

  @override
  String get drawFromThisDeck => '从此牌组抽取';

  @override
  String get gratitudeJournalPrompt =>
      '今天，你继续踏上感恩之旅。请带着觉知回顾生活中令你感恩的事物，无论多么微小。建议句式：\n“我感恩……因为……”\n写完后，带着深深的感激之情重新品读你写下的文字。';

  @override
  String get gratitudeJournalPlaceholder =>
      '像写安静的日记一样，记录今天令你感恩的事吧……\n\n例如：\n我感恩今天早晨那杯温热的咖啡，因为它带给我清醒与宁静。\n我感恩朋友的微笑，因为它温暖了我的心房……';

  @override
  String get addPhoto => '添加照片';

  @override
  String get changePhoto => '更换照片';

  @override
  String get insertPromptTemplate => '插入模板';

  @override
  String get saveAndCompleteJournal => '完成并保存日记';

  @override
  String get gratitudePromptTemplateText => '我感恩……因为……';

  @override
  String get chooseTheme => '选择主题';

  @override
  String get editNote => '编辑笔记';

  @override
  String get noteUpdated => '笔记已更新';

  @override
  String get gratitudeGuidanceTitle => '今日练习指引';

  @override
  String get showGuidance => '查看指引';

  @override
  String get hideGuidance => '隐藏指引';

  @override
  String get comfortZoneTitle => 'Little Corner';

  @override
  String get comfortZoneSubtitle => 'A Little World Where You Feel Safe';

  @override
  String get comfortZoneBannerSubtitle =>
      'A Little World Where You Feel Safe — 伴随动态光影与疗愈之声的宁静角落';

  @override
  String comfortZoneAllSpaces(int count) {
    return '全部 ($count)';
  }

  @override
  String get comfortZoneFavorites => '收藏';

  @override
  String get comfortZoneFavoritesEmpty => '还没有收藏的空间。点击任意空间上的爱心图标即可保存在这里。';

  @override
  String get comfortZoneEnterSpace => '进入空间';

  @override
  String get comfortZoneAmbientSound => '环境音与音乐';

  @override
  String get comfortZoneGuidedAudio => '引导音频';

  @override
  String get comfortZoneZenMode => '禅意视图';

  @override
  String get comfortZoneExitZenMode => '显示控制栏';

  @override
  String get comfortZoneBreathingGuide => '呼吸引导';

  @override
  String get comfortZoneBreatheIn => '轻轻吸气...';

  @override
  String get comfortZoneBreatheHold => '柔和屏息...';

  @override
  String get comfortZoneBreatheOut => '缓缓呼气...';

  @override
  String get comfortZoneRecentSpace => '最近造访';

  @override
  String comfortZoneScenesCount(int count) {
    return '$count 个空间';
  }

  @override
  String get comfortZonePreviousSpace => '上一个空间';

  @override
  String get comfortZoneNextSpace => '下一个空间';

  @override
  String get notificationPreviewSectionTitle => 'Soul 通知格式预览';

  @override
  String notificationMorningTitle(String name) {
    return '早安，$name 🌿';
  }

  @override
  String get notificationMorningBody => '深呼吸一下。今天你想播下哪一颗微小的感恩种子？';

  @override
  String notificationEveningTitle(String name) {
    return '温柔地结束今天吧，$name 🌙';
  }

  @override
  String get notificationEveningBody => '入睡前，留住今天降临在你身上的一个宁静瞬间或微小善意。';

  @override
  String get notificationPrivacyNote => '严格隐私保护：锁屏通知绝不会显示你的私人日记或未来信件内容。';

  @override
  String get notificationSendTest => '发送测试通知';

  @override
  String get notificationTestSent => '已发送示例通知！请查看设备通知栏。';

  @override
  String get homeWidgetTitle => '主屏幕小组件';

  @override
  String get homeWidgetSubtitle =>
      '将你喜爱的 Little Corner 空间、疗愈音频与频率、我的愿景、每日感恩或 Soul 灵感卡固定在手机主屏幕上。';

  @override
  String get homeWidgetBannerSubtitle => '在主屏幕上固定 Little Corner、疗愈之声与愿景';

  @override
  String get homeWidgetModeLabel => '小组件显示内容';

  @override
  String get homeWidgetModeComfortZone => 'Little Corner';

  @override
  String get homeWidgetModeSound => '疗愈音频与频率';

  @override
  String get homeWidgetModeVision => '我的愿景';

  @override
  String get homeWidgetModeGratitude => '每日感恩';

  @override
  String get homeWidgetModeCard => 'Soul 卡片寄语';

  @override
  String get homeWidgetSelectSpace => '选择 Little Corner 空间';

  @override
  String get homeWidgetSelectSound => '选择疗愈音频 / 频率';

  @override
  String get homeWidgetSpaceFooter => '轻触进入你的宁静角落 ✦';

  @override
  String get homeWidgetSoundFooter => '轻触聆听疗愈频率 ✦';

  @override
  String get homeWidgetThemeLabel => '小组件外观';

  @override
  String get homeWidgetThemePlum => '暮色紫梅';

  @override
  String get homeWidgetThemePaper => '暖米纸笺';

  @override
  String get homeWidgetThemeRose => '晨雾玫瑰';

  @override
  String get homeWidgetPinButton => '将小组件添加到主屏幕';

  @override
  String get homeWidgetSyncButton => '立即更新小组件';

  @override
  String get homeWidgetSyncedSuccess => '主屏幕小组件内容已更新！';

  @override
  String get homeWidgetHowToHint =>
      '提示：你可以点击上方的添加按钮，或长按手机主屏幕空白处 → 选择“小组件 (Widgets)” → 选择 Soul 放置到桌面。';

  @override
  String get moodThemeButtonTooltip => '心情与主题';

  @override
  String get moodThemeSheetTitle => '情绪与氛围主题';

  @override
  String get moodThemeSheetSubtitle => '选择您此刻的心情，让Soul的色彩与音乐与您的内心共鸣。';

  @override
  String moodThemeChangedToast(String moodName) {
    return 'Soul已将空间切换至$moodName ✨';
  }

  @override
  String get moodPeacefulDesc => '平和宁静，抚平思绪 · 432Hz';

  @override
  String get moodGratefulDesc => '温暖爱意，心怀感恩 · 528Hz';

  @override
  String get moodEnergizedDesc => '清新振奋，积极活力';

  @override
  String get moodRelievedDesc => '释怀轻松，自在呼吸';

  @override
  String get moodReflectiveDesc => '深沉静谧，抚慰夜晚';

  @override
  String todayMoodSummary(String moodName) {
    return '今日心情：$moodName';
  }

  @override
  String get changeMood => '更改';
}
