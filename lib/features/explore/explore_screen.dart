import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../l10n/app_localizations.dart';

enum _ExploreTab { all, audio, meditation, podcast, frequency }

enum _AudioSubCategory { all, music, ambience, guided }

enum _ExploreItemType { youtube, spotify }

class _ExternalItem {
  const _ExternalItem({
    required this.id,
    required this.titles,
    required this.creator,
    required this.categories,
    required this.minutes,
    required this.type,
    required this.url,
    this.isFrequency = false,
  });

  final String id;
  final Map<SoulLocale, String> titles;
  final String creator;
  final Map<SoulLocale, String> categories;
  final int minutes;
  final _ExploreItemType type;
  final String url;
  final bool isFrequency;

  String titleFor(SoulLocale locale) =>
      titles[locale] ?? titles[SoulLocale.en]!;

  String categoryFor(SoulLocale locale) =>
      categories[locale] ?? categories[SoulLocale.en]!;

  String durationFor(SoulLocale locale) => switch (locale) {
    SoulLocale.vi => '$minutes phút',
    SoulLocale.en => '$minutes min',
    SoulLocale.ko => '$minutes분',
    SoulLocale.ja => '$minutes分',
    SoulLocale.fr => '$minutes min',
    SoulLocale.zh => '$minutes 分钟',
  };
}

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  _ExploreTab _selectedTab = _ExploreTab.all;
  _AudioSubCategory _audioSubFilter = _AudioSubCategory.all;

  static const List<_ExternalItem> _externalItems = [
    // YouTube Meditations
    _ExternalItem(
      id: 'YT-001',
      titles: {
        SoulLocale.vi: 'Thiền biết ơn & Sức mạnh của lòng trân trọng',
        SoulLocale.en: 'Gratitude Meditation & the Power of Appreciation',
        SoulLocale.ko: '감사 명상 & 감사의 힘',
        SoulLocale.ja: '感謝の瞑想と感謝の力',
        SoulLocale.fr: 'Méditation de gratitude & pouvoir de l’appréciation',
        SoulLocale.zh: '感恩冥想与珍惜的力量',
      },
      creator: 'Mindful Science',
      categories: {
        SoulLocale.vi: 'Thiền định',
        SoulLocale.en: 'Meditation',
        SoulLocale.ko: '명상',
        SoulLocale.ja: '瞑想',
        SoulLocale.fr: 'Méditation',
        SoulLocale.zh: '冥想',
      },
      minutes: 15,
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=3mFVCX2wmqw',
    ),
    _ExternalItem(
      id: 'YT-002',
      titles: {
        SoulLocale.vi: 'Thiền biết ơn buổi sáng tràn ngập niềm vui',
        SoulLocale.en: 'Joyful Morning Gratitude Meditation',
        SoulLocale.ko: '기쁨으로 가득한 아침 감사 명상',
        SoulLocale.ja: '喜びに満ちた朝の感謝瞑想',
        SoulLocale.fr: 'Méditation matinale de gratitude joyeuse',
        SoulLocale.zh: '充满喜悦的晨间感恩冥想',
      },
      creator: 'Great Meditation',
      categories: {
        SoulLocale.vi: 'Khởi đầu ngày mới',
        SoulLocale.en: 'Morning Start',
        SoulLocale.ko: '아침의 시작',
        SoulLocale.ja: '一日の始まり',
        SoulLocale.fr: 'Début de journée',
        SoulLocale.zh: '开启新的一天',
      },
      minutes: 10,
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=3-H4vNvealw',
    ),
    _ExternalItem(
      id: 'YT-003',
      titles: {
        SoulLocale.vi: 'Khẳng định tích cực về lòng biết ơn trong 21 ngày',
        SoulLocale.en: '21-Day Positive Gratitude Affirmations',
        SoulLocale.ko: '21일 긍정 감사 확언',
        SoulLocale.ja: '21日間のポジティブな感謝アファメーション',
        SoulLocale.fr: 'Affirmations positives de gratitude sur 21 jours',
        SoulLocale.zh: '21天感恩积极肯定语',
      },
      creator: 'Bob Baker Affirmations',
      categories: {
        SoulLocale.vi: 'Affirmations',
        SoulLocale.en: 'Affirmations',
        SoulLocale.ko: '긍정 확언',
        SoulLocale.ja: 'アファメーション',
        SoulLocale.fr: 'Affirmations',
        SoulLocale.zh: '积极肯定',
      },
      minutes: 12,
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=iHLQOHZJync',
    ),
    _ExternalItem(
      id: 'YT-004',
      titles: {
        SoulLocale.vi: 'Thiền về sự đủ đầy & Tư duy thịnh vượng',
        SoulLocale.en: 'Abundance & Prosperity Mindset Meditation',
        SoulLocale.ko: '풍요와 번영의 마인드셋 명상',
        SoulLocale.ja: '豊かさと繁栄のマインドセット瞑想',
        SoulLocale.fr: 'Méditation sur l’abondance et la prospérité',
        SoulLocale.zh: '丰盛与富足心态冥想',
      },
      creator: 'Proctor Gallagher Institute',
      categories: {
        SoulLocale.vi: 'Đủ đầy & Thịnh vượng',
        SoulLocale.en: 'Abundance & Prosperity',
        SoulLocale.ko: '풍요 & 번영',
        SoulLocale.ja: '豊かさと繁栄',
        SoulLocale.fr: 'Abondance & Prospérité',
        SoulLocale.zh: '丰盛与富足',
      },
      minutes: 18,
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=RKOlsS4QCRU',
    ),
    // Spotify Podcasts
    _ExternalItem(
      id: 'SP-011',
      titles: {
        SoulLocale.vi: 'Tâm lý học về con người tương lai của bạn',
        SoulLocale.en: 'The Psychology of Your Future Self',
        SoulLocale.ko: '미래의 나에 대한 심리학',
        SoulLocale.ja: '未来の自分の心理学',
        SoulLocale.fr: 'La psychologie de votre futur vous',
        SoulLocale.zh: '未来自我的心理学',
      },
      creator: 'Dan Gilbert (TED Talks Daily)',
      categories: {
        SoulLocale.vi: 'Tâm lý & Tầm nhìn',
        SoulLocale.en: 'Psychology & Vision',
        SoulLocale.ko: '심리 & 비전',
        SoulLocale.ja: '心理とビジョン',
        SoulLocale.fr: 'Psychologie & Vision',
        SoulLocale.zh: '心理与愿景',
      },
      minutes: 12,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/5ESaeSaf4Rz56snsmlcBFs',
    ),
    _ExternalItem(
      id: 'SP-004',
      titles: {
        SoulLocale.vi: 'Thiền yêu thương bản thân & Nâng cao giá trị nội tại',
        SoulLocale.en: 'Self-Love Meditation & Building Inner Worth',
        SoulLocale.ko: '자기 사랑 명상 & 내면의 가치 높이기',
        SoulLocale.ja: '自己愛の瞑想と内なる価値を高める',
        SoulLocale.fr: 'Méditation d’amour de soi & valeur intérieure',
        SoulLocale.zh: '自爱冥想与提升内在价值',
      },
      creator: 'Wake Me Up Podcast',
      categories: {
        SoulLocale.vi: 'Yêu thương bản thân',
        SoulLocale.en: 'Self-Love',
        SoulLocale.ko: '자기 사랑',
        SoulLocale.ja: 'セルフラブ',
        SoulLocale.fr: 'Amour de soi',
        SoulLocale.zh: '关爱自我',
      },
      minutes: 13,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/4lpvFIhoUtCAWaWZniSb3K',
    ),
    _ExternalItem(
      id: 'SP-022',
      titles: {
        SoulLocale.vi:
            'Cách lòng biết ơn chữa lành một gia đình qua nghịch cảnh',
        SoulLocale.en: 'How Gratitude Healed a Family Through Adversity',
        SoulLocale.ko: '역경 속에서 가족을 치유한 감사의 힘',
        SoulLocale.ja: '逆境の中で家族を癒した感謝の力',
        SoulLocale.fr: 'Comment la gratitude a guéri une famille',
        SoulLocale.zh: '感恩如何在逆境中疗愈一个家庭',
      },
      creator: 'The Gratitude Podcast',
      categories: {
        SoulLocale.vi: 'Câu chuyện cảm hứng',
        SoulLocale.en: 'Inspiring Stories',
        SoulLocale.ko: '영감을 주는 이야기',
        SoulLocale.ja: 'インスピレーション物語',
        SoulLocale.fr: 'Histoires inspirantes',
        SoulLocale.zh: '灵感故事',
      },
      minutes: 25,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/0b70Fnl008FTCKDlOGYt3L',
    ),
    _ExternalItem(
      id: 'SP-008',
      titles: {
        SoulLocale.vi: 'Cách trở thành phiên bản tương lai & Nhật ký tương lai',
        SoulLocale.en: 'How to Become Your Future Self & Future Journaling',
        SoulLocale.ko: '미래의 내가 되는 법 & 미래 일기 쓰기',
        SoulLocale.ja: '未来の自分になる方法とフューチャージャーナリング',
        SoulLocale.fr: 'Devenir son futur soi & journal du futur',
        SoulLocale.zh: '如何成为未来的自己与未来日记',
      },
      creator: 'How to Like Your Life',
      categories: {
        SoulLocale.vi: 'Phát triển cá nhân',
        SoulLocale.en: 'Personal Growth',
        SoulLocale.ko: '자기 계발',
        SoulLocale.ja: '自己成長',
        SoulLocale.fr: 'Développement personnel',
        SoulLocale.zh: '个人成长',
      },
      minutes: 20,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/02JjKe5oUPOZWSsPflSGXF',
    ),
    // Frequency
    _ExternalItem(
      id: 'FRQ-001',
      titles: {
        SoulLocale.vi: '432Hz Bình an & Cân bằng năng lượng',
        SoulLocale.en: '432Hz Deep Peace & Energy Balance',
        SoulLocale.ko: '432Hz 평온 & 에너지 밸런스',
        SoulLocale.ja: '432Hz 深い安らぎとエネルギーバランス',
        SoulLocale.fr: '432Hz Paix profonde & équilibre énergétique',
        SoulLocale.zh: '432Hz 宁静与能量平衡',
      },
      creator: 'DanaMusic Healing',
      categories: {
        SoulLocale.vi: 'Tần số 432Hz',
        SoulLocale.en: '432Hz Frequency',
        SoulLocale.ko: '432Hz 주파수',
        SoulLocale.ja: '432Hz 周波数',
        SoulLocale.fr: 'Fréquence 432Hz',
        SoulLocale.zh: '432Hz 频率',
      },
      minutes: 7,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/track/3oRhjjiLO6rdZOPFz6cJhJ',
      isFrequency: true,
    ),
    _ExternalItem(
      id: 'FRQ-004',
      titles: {
        SoulLocale.vi: '528Hz Chữa lành & Tình yêu thương thuần khiết',
        SoulLocale.en: '528Hz Healing & Pure Love Frequency',
        SoulLocale.ko: '528Hz 치유 & 순수한 사랑의 주파수',
        SoulLocale.ja: '528Hz 癒しと純粋な愛の周波数',
        SoulLocale.fr: '528Hz Guérison & amour pur',
        SoulLocale.zh: '528Hz 疗愈与纯净之爱',
      },
      creator: 'The Mountain Soundscape',
      categories: {
        SoulLocale.vi: 'Tần số 528Hz',
        SoulLocale.en: '528Hz Frequency',
        SoulLocale.ko: '528Hz 주파수',
        SoulLocale.ja: '528Hz 周波数',
        SoulLocale.fr: 'Fréquence 528Hz',
        SoulLocale.zh: '528Hz 频率',
      },
      minutes: 5,
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/track/0i6EOz53YsgC13IZGz8XTW',
      isFrequency: true,
    ),
  ];

  Future<void> _openUrl(String? url, SoulLocale locale) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // Fallback to platform default / in-app browser
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(switch (locale) {
              SoulLocale.vi => 'Không thể mở liên kết. Vui lòng thử lại sau.',
              SoulLocale.en => 'Could not open link. Please try again later.',
              SoulLocale.ko => '링크를 열 수 없습니다. 잠시 후 다시 시도해 주세요.',
              SoulLocale.ja => 'リンクを開けませんでした。後でもう一度お試しください。',
              SoulLocale.fr =>
                'Impossible d’ouvrir le lien. Veuillez réessayer plus tard.',
              SoulLocale.zh => '无法打开链接，请稍后再试。',
            }),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final audio = ref.watch(audioPlaybackProvider);
    final audioCatalog = ref.watch(audioCatalogProvider).valueOrNull;
    final locale = state.locale ?? SoulLocale.vi;
    final isVi = locale == SoulLocale.vi;

    final allAssets = audioCatalog?.assets ?? const <SoulAudioAsset>[];

    // Filter Soul Audio
    final filteredSoulAudio =
        allAssets.where((asset) {
          if (asset.delivery != AudioDelivery.published) return false;
          switch (_audioSubFilter) {
            case _AudioSubCategory.all:
              return true;
            case _AudioSubCategory.music:
              return asset.type == 'music';
            case _AudioSubCategory.ambience:
              return asset.type == 'ambience' ||
                  asset.type == 'noise' ||
                  asset.type == 'sound_bath';
            case _AudioSubCategory.guided:
              return asset.type == 'guided';
          }
        }).toList();

    // Featured Soul Audio for the "All" tab
    final featuredSoulAudio = [
      for (final id in const ['SO-11', 'SO-03', 'SO-16', 'GA-18'])
        if (audioCatalog?.asset(id) case final item?) item,
    ];

    // Filter external items
    final filteredExternal =
        _externalItems.where((item) {
          switch (_selectedTab) {
            case _ExploreTab.all:
              return true;
            case _ExploreTab.audio:
              return false;
            case _ExploreTab.meditation:
              return item.type == _ExploreItemType.youtube;
            case _ExploreTab.podcast:
              return item.type == _ExploreItemType.spotify && !item.isFrequency;
            case _ExploreTab.frequency:
              return item.isFrequency;
          }
        }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.sm,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        // Title & Description
        Text(
          l10n.exploreTitle,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: SoulSpace.xxs),
        Text(
          l10n.exploreBody,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: SoulColors.muted),
        ),
        const SizedBox(height: SoulSpace.md),

        // Soul Cards Banner
        InkWell(
          onTap: () => context.push('/cards'),
          borderRadius: BorderRadius.circular(SoulRadius.card),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  SoulColors.plum,
                  SoulColors.plum.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(SoulRadius.card),
              boxShadow: [
                BoxShadow(
                  color: SoulColors.plum.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(SoulSpace.lg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SoulColors.rose.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(SoulRadius.button),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: SoulColors.surface,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: SoulSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.soulCardsTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: SoulColors.surface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.soulCardsSubtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: SoulColors.surface.withValues(alpha: 0.85),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: SoulColors.surface,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (_selectedTab == _ExploreTab.all) ...[
          const SizedBox(height: SoulSpace.sm),

          // Comfort Zone Banner
          InkWell(
            onTap: () => context.push('/comfort-zone'),
            borderRadius: BorderRadius.circular(SoulRadius.card),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3E5C76), Color(0xFF5A7D73)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                boxShadow: [
                  BoxShadow(
                    color: SoulColors.plum.withValues(alpha: 0.14),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.cottage_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.comfortZoneTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.comfortZoneBannerSubtitle,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: SoulSpace.lg),

        // Filter tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TabChip(
                label: l10n.exploreTabAll,
                selected: _selectedTab == _ExploreTab.all,
                onTap: () => setState(() => _selectedTab = _ExploreTab.all),
              ),
              _TabChip(
                label: l10n.exploreTabAudio,
                selected: _selectedTab == _ExploreTab.audio,
                onTap: () => setState(() => _selectedTab = _ExploreTab.audio),
              ),
              _TabChip(
                label: l10n.exploreTabMeditation,
                selected: _selectedTab == _ExploreTab.meditation,
                onTap:
                    () => setState(() => _selectedTab = _ExploreTab.meditation),
              ),
              _TabChip(
                label: l10n.exploreTabPodcast,
                selected: _selectedTab == _ExploreTab.podcast,
                onTap: () => setState(() => _selectedTab = _ExploreTab.podcast),
              ),
              _TabChip(
                label: l10n.exploreTabFrequency,
                selected: _selectedTab == _ExploreTab.frequency,
                onTap:
                    () => setState(() => _selectedTab = _ExploreTab.frequency),
              ),
            ],
          ),
        ),
        const SizedBox(height: SoulSpace.md),

        // Sub-filters when on Audio Tab
        if (_selectedTab == _ExploreTab.audio) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _SubTabChip(
                  label: l10n.allAudio,
                  selected: _audioSubFilter == _AudioSubCategory.all,
                  onTap:
                      () => setState(
                        () => _audioSubFilter = _AudioSubCategory.all,
                      ),
                ),
                _SubTabChip(
                  label: l10n.audioMusicTab,
                  selected: _audioSubFilter == _AudioSubCategory.music,
                  onTap:
                      () => setState(
                        () => _audioSubFilter = _AudioSubCategory.music,
                      ),
                ),
                _SubTabChip(
                  label: l10n.audioNature,
                  selected: _audioSubFilter == _AudioSubCategory.ambience,
                  onTap:
                      () => setState(
                        () => _audioSubFilter = _AudioSubCategory.ambience,
                      ),
                ),
                _SubTabChip(
                  label: l10n.audioGuidedTab,
                  selected: _audioSubFilter == _AudioSubCategory.guided,
                  onTap:
                      () => setState(
                        () => _audioSubFilter = _AudioSubCategory.guided,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SoulSpace.md),
        ],

        // Curated Library Note
        SoulCard(
          color: SoulColors.lilac,
          padding: const EdgeInsets.all(SoulSpace.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: SoulColors.plum,
                size: 20,
              ),
              const SizedBox(width: SoulSpace.sm),
              Expanded(
                child: Text(
                  l10n.audioLibraryNote,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SoulColors.softInk,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SoulSpace.lg),

        // If "All" Tab: show Featured Soul Audio section
        if (_selectedTab == _ExploreTab.all &&
            featuredSoulAudio.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  switch (locale) {
                    SoulLocale.vi => 'Âm thanh Soul nổi bật',
                    SoulLocale.en => 'Featured Soul Audio',
                    SoulLocale.ko => '추천 Soul 오디오',
                    SoulLocale.ja => '注目のSoulオーディオ',
                    SoulLocale.fr => 'Audio Soul à la une',
                    SoulLocale.zh => '精选 Soul 音频',
                  },
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SoulColors.plum,
                  ),
                ),
              ),
              TextButton(
                onPressed:
                    () => setState(() => _selectedTab = _ExploreTab.audio),
                child: Text(switch (locale) {
                  SoulLocale.vi => 'Xem tất cả',
                  SoulLocale.en => 'View all',
                  SoulLocale.ko => '전체 보기',
                  SoulLocale.ja => 'すべて見る',
                  SoulLocale.fr => 'Tout voir',
                  SoulLocale.zh => '查看全部',
                }, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: SoulSpace.xs),
          for (final asset in featuredSoulAudio)
            _buildSoulAudioRow(asset, locale, audio, state, isVi, l10n),
          const SizedBox(height: SoulSpace.lg),
          Text(
            switch (locale) {
              SoulLocale.vi => 'Gợi ý từ cộng đồng',
              SoulLocale.en => 'Community Recommendations',
              SoulLocale.ko => '커뮤니티 추천',
              SoulLocale.ja => 'コミュニティのおすすめ',
              SoulLocale.fr => 'Recommandations de la communauté',
              SoulLocale.zh => '社区推荐',
            },
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: SoulColors.plum,
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
        ],

        // If "Audio" Tab: show all filtered Soul Audio
        if (_selectedTab == _ExploreTab.audio) ...[
          for (final asset in filteredSoulAudio)
            _buildSoulAudioRow(asset, locale, audio, state, isVi, l10n),
        ],

        // External items (YouTube, Spotify, etc.)
        for (final item in filteredExternal) ...[
          InkWell(
            onTap: () => _openUrl(item.url, locale),
            borderRadius: BorderRadius.circular(SoulRadius.card),
            child: SoulCard(
              color: SoulColors.surface,
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          item.type == _ExploreItemType.youtube
                              ? const Color(0xFFFFEBEE)
                              : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.type == _ExploreItemType.youtube
                          ? Icons.play_arrow_rounded
                          : Icons.graphic_eq_rounded,
                      color:
                          item.type == _ExploreItemType.youtube
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF2E7D32),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: SoulSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SoulSpace.xxs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: SoulColors.surface,
                                borderRadius: BorderRadius.circular(
                                  SoulRadius.button,
                                ),
                                border: Border.all(color: SoulColors.line),
                              ),
                              child: Text(
                                item.type == _ExploreItemType.youtube
                                    ? 'YOUTUBE'
                                    : 'SPOTIFY',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color:
                                      item.type == _ExploreItemType.youtube
                                          ? const Color(0xFFD32F2F)
                                          : const Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                            const SizedBox(width: SoulSpace.xs),
                            Expanded(
                              child: Text(
                                item.categoryFor(locale),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: SoulColors.muted),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.titleFor(locale),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.creator} · ${item.durationFor(locale)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: SoulColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: SoulSpace.xs),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.type == _ExploreItemType.youtube
                                      ? l10n.exploreOpenYouTube
                                      : l10n.exploreOpenSpotify,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: SoulColors.plum,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 12,
                                  color: SoulColors.plum,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
        ],
      ],
    );
  }

  Widget _buildSoulAudioRow(
    SoulAudioAsset asset,
    SoulLocale locale,
    AudioPlaybackController audio,
    AppState state,
    bool isVi,
    AppLocalizations l10n,
  ) {
    final path = asset.pathFor(locale);
    final title = asset.titleFor(locale);
    final isPlaying = path != null && audio.isCurrentTrack(path);

    final subtitle = asset.subtitleFor(locale);

    final icon =
        asset.isGuided
            ? Icons.record_voice_over_rounded
            : (asset.type == 'music'
                ? Icons.music_note_rounded
                : Icons.water_drop_rounded);

    return Padding(
      padding: const EdgeInsets.only(bottom: SoulSpace.sm),
      child: SoulAudioRow(
        icon: icon,
        title: title,
        subtitle: subtitle,
        isPlaying: isPlaying,
        onPlayPause:
            path == null
                ? null
                : () async {
                  if (!state.soundEnabled) {
                    await state.setSoundEnabled(true);
                  }
                  await audio.playTrack(
                    path: path,
                    title: title,
                    subtitle: subtitle,
                    isAsset: true,
                    loop: !asset.isGuided,
                  );
                },
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: SoulSpace.xs),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: SoulColors.lilac,
        checkmarkColor: SoulColors.plum,
        backgroundColor: SoulColors.surface,
        side: BorderSide(color: selected ? SoulColors.plum : SoulColors.line),
        labelStyle: TextStyle(
          color: selected ? SoulColors.plum : SoulColors.softInk,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SubTabChip extends StatelessWidget {
  const _SubTabChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: SoulSpace.xs),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: SoulColors.rose,
        backgroundColor: SoulColors.softFill,
        side: BorderSide(
          color: selected ? SoulColors.plum : Colors.transparent,
        ),
        labelStyle: TextStyle(
          color: selected ? SoulColors.plum : SoulColors.muted,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
