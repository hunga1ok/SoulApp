import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/comfort_zone_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/comfort_zone_repository.dart';
import '../../l10n/app_localizations.dart';
import '../comfort_zone/comfort_scene_canvas.dart';

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

        // Soul Cards Banner (Featured on "All" tab)
        if (_selectedTab == _ExploreTab.all) ...[
          _SoulCardsAnimatedBanner(locale: locale),
          const SizedBox(height: SoulSpace.sm),
        ],

        // Comfort Zone Banner (Pinned permanently across all tabs)
        if (_selectedTab == _ExploreTab.all)
          _ComfortZoneAnimatedBanner(locale: locale)
        else
          InkWell(
            onTap: () => context.push('/comfort-zone'),
            borderRadius: BorderRadius.circular(SoulRadius.card),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFF9F2), // soft morning cream
                    Color(0xFFFDF1E6), // warm honey peach
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFFE2C4A2).withValues(alpha: 0.8),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(SoulRadius.card),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD99C4B).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.xs + 2,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E0),
                      border: Border.all(
                        color: const Color(0xFFE8C8A0).withValues(alpha: 0.8),
                        width: 0.8,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.push_pin_rounded,
                      color: Color(0xFFC7782A),
                      size: 11,
                    ),
                  ),
                  const SizedBox(width: SoulSpace.xs),
                  const Icon(
                    Icons.cottage_rounded,
                    color: Color(0xFFB86A2E),
                    size: 17,
                  ),
                  const SizedBox(width: SoulSpace.xs),
                  Expanded(
                    child: Text(
                      '${l10n.comfortZoneTitle} · ${switch (locale) {
                        SoulLocale.vi => '28 không gian an yên',
                        SoulLocale.en => '28 safe spaces',
                        SoulLocale.ko => '28개 안식처',
                        SoulLocale.ja => '28の空間',
                        SoulLocale.fr => '28 espaces sereins',
                        SoulLocale.zh => '28个治愈空间',
                      }}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SoulColors.plum,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: SoulColors.plum.withValues(alpha: 0.45),
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
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

/// Luxurious animated banner for Soul Cards with cosmic starlight & floating tarot card.
class _SoulCardsAnimatedBanner extends StatefulWidget {
  const _SoulCardsAnimatedBanner({required this.locale});

  final SoulLocale locale;

  @override
  State<_SoulCardsAnimatedBanner> createState() =>
      _SoulCardsAnimatedBannerState();
}

class _SoulCardsAnimatedBannerState extends State<_SoulCardsAnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _canAnimate {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (_canAnimate) {
      _controller.repeat();
    } else {
      _controller.value = 0.35;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations && _controller.isAnimating) {
      _controller.stop();
    } else if (!disableAnimations && _canAnimate && !_controller.isAnimating) {
      _controller.repeat();
    }

    final cosmicBadge = switch (widget.locale) {
      SoulLocale.vi => 'THÔNG ĐIỆP VŨ TRỤ',
      SoulLocale.en => 'COSMIC GUIDANCE',
      SoulLocale.ko => '우주의 메시지',
      SoulLocale.ja => '宇宙のメッセージ',
      SoulLocale.fr => 'MESSAGE COSMIQUE',
      SoulLocale.zh => '宇宙的指引',
    };

    return InkWell(
      onTap: () => context.push('/cards'),
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(
            color: const Color(0xFFD8B4D6).withValues(alpha: 0.70),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C4D88).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Base Soft Pastel Celestial Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFFFBF4FD), // luminous pearly blush
                      Color(0xFFF5E8F7), // soft dreamy celestial lilac
                      Color(0xFFFFF0F5), // gentle rose mist
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Animated Living Celestial Stardust & Mystic Tarot Aura Canvas
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _SoulCardsAuraPainter(progress: _controller.value),
                  );
                },
              ),
            ),

            // Foreground Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.md,
              ),
              child: Row(
                children: [
                  // Luminous Glassmorphic Icon Box
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF6E4F5), Color(0xFFFDE8E4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      border: Border.all(
                        color: const Color(0xFFDCA8D4).withValues(alpha: 0.85),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF9C4D88,
                          ).withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF7A3370),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.md),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pill badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF2DCF0,
                            ).withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                            border: Border.all(
                              color: const Color(
                                0xFFD8ACD4,
                              ).withValues(alpha: 0.75),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.stars_rounded,
                                color: Color(0xFF8E3E84),
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  cosmicBadge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF7A2E70),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.soulCardsTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: SoulColors.plum,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.soulCardsSubtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: SoulColors.muted, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Trailing gold chevron
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      border: Border.all(
                        color: const Color(0xFFD8ACD4).withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: SoulColors.plum,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoulCardsAuraPainter extends CustomPainter {
  _SoulCardsAuraPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Soft glowing celestial nebula aura in the right-center
    final auraCenter = Offset(w * 0.74, h * 0.48);
    final auraRadius = math.max(w, h) * 0.55;
    final auraPulse = 0.14 + 0.05 * math.sin(progress * 2 * math.pi);
    final auraPaint =
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.65, 0.0),
            radius: 0.8,
            colors: [
              const Color(0xFFEAA6DF).withValues(alpha: auraPulse * 0.55),
              const Color(0xFFFFD59E).withValues(alpha: auraPulse * 0.35),
              Colors.transparent,
            ],
            stops: const [0.0, 0.45, 1.0],
          ).createShader(
            Rect.fromCircle(center: auraCenter, radius: auraRadius),
          );
    canvas.drawCircle(auraCenter, auraRadius, auraPaint);

    // 2. Animated floating mystic card silhouette on the right side
    final cardCenter = Offset(
      w * 0.77,
      h * 0.50 + math.sin(progress * 2 * math.pi) * 3.5,
    );
    const cardW = 44.0;
    const cardH = 64.0;

    canvas.save();
    canvas.translate(cardCenter.dx, cardCenter.dy);
    canvas.rotate(0.14 + math.sin(progress * 2 * math.pi) * 0.03);

    final cardRect = Rect.fromCenter(
      center: Offset.zero,
      width: cardW,
      height: cardH,
    );
    final cardRRect = RRect.fromRectAndRadius(
      cardRect,
      const Radius.circular(6),
    );

    // Glass fill for card
    final cardFill =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.65)
          ..style = PaintingStyle.fill;
    canvas.drawRRect(cardRRect, cardFill);

    // Golden foil border for card
    final cardBorder =
        Paint()
          ..color = const Color(
            0xFFC78838,
          ).withValues(alpha: 0.45 + 0.20 * math.sin(progress * 2 * math.pi))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
    canvas.drawRRect(cardRRect, cardBorder);

    // Inner sacred diamond on the card
    final diamondPath =
        Path()
          ..moveTo(0, -cardH * 0.26)
          ..lineTo(cardW * 0.28, 0)
          ..lineTo(0, cardH * 0.26)
          ..lineTo(-cardW * 0.28, 0)
          ..close();
    final diamondPaint =
        Paint()
          ..color = const Color(0xFFB57530).withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;
    canvas.drawPath(diamondPath, diamondPaint);

    // Central pulsing star in card
    final starGlow = 0.4 + 0.3 * math.sin(progress * 2 * math.pi);
    final starPaint =
        Paint()
          ..color = const Color(0xFFC78838).withValues(alpha: starGlow)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 2.2, starPaint);

    canvas.restore();

    // 3. Floating stardust & twinkling stars across the banner
    const stars = [
      Offset(0.08, 0.25),
      Offset(0.18, 0.78),
      Offset(0.35, 0.20),
      Offset(0.48, 0.82),
      Offset(0.58, 0.28),
      Offset(0.68, 0.70),
      Offset(0.72, 0.18),
      Offset(0.88, 0.15),
      Offset(0.93, 0.75),
      Offset(0.76, 0.88),
      Offset(0.40, 0.65),
      Offset(0.24, 0.40),
    ];

    for (var i = 0; i < stars.length; i++) {
      final base = stars[i];
      final driftY = math.sin((progress * 2 * math.pi) + (i * 0.8)) * 3.0;
      final driftX = math.cos((progress * 2 * math.pi) + (i * 0.5)) * 2.0;
      final px = (base.dx * w + driftX).clamp(0.0, w);
      final py = (base.dy * h + driftY).clamp(0.0, h);

      final twinkle =
          0.25 +
          0.75 *
              math.pow(
                (math.sin(progress * 2 * math.pi + (i * 1.3)) + 1) / 2,
                2,
              );

      final isGold = i % 2 == 0;
      final starColor =
          isGold
              ? const Color(0xFFC78838).withValues(alpha: twinkle * 0.70)
              : const Color(0xFF8E4A86).withValues(alpha: twinkle * 0.45);

      final radius = (i % 3 == 0) ? 1.8 : 1.2;
      canvas.drawCircle(Offset(px, py), radius, Paint()..color = starColor);

      // Diamond sparkle spikes for key bright stars
      if (i == 2 || i == 7 || i == 0) {
        final spikeLen = (3.5 + 2.0 * twinkle);
        final spikePaint =
            Paint()
              ..color = starColor.withValues(alpha: twinkle * 0.65)
              ..strokeWidth = 0.9;
        canvas.drawLine(
          Offset(px - spikeLen, py),
          Offset(px + spikeLen, py),
          spikePaint,
        );
        canvas.drawLine(
          Offset(px, py - spikeLen),
          Offset(px, py + spikeLen),
          spikePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SoulCardsAuraPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Luxurious animated banner for Comfort Zone with living watercolor canvas & warm hearth aura.
class _ComfortZoneAnimatedBanner extends ConsumerStatefulWidget {
  const _ComfortZoneAnimatedBanner({required this.locale});

  final SoulLocale locale;

  @override
  ConsumerState<_ComfortZoneAnimatedBanner> createState() =>
      _ComfortZoneAnimatedBannerState();
}

class _ComfortZoneAnimatedBannerState
    extends ConsumerState<_ComfortZoneAnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  bool get _canAnimate {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    if (_canAnimate) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.value = 0.5;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations && _pulseController.isAnimating) {
      _pulseController.stop();
    } else if (!disableAnimations &&
        _canAnimate &&
        !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }

    final catalog = ref.watch(comfortZoneCatalogProvider).valueOrNull;
    final prefs = ref.watch(comfortZonePreferencesProvider);

    // Pick user's last visited scene or default to the first comforting scene
    ComfortZoneScene? featuredScene;
    if (catalog != null && catalog.scenes.isNotEmpty) {
      if (prefs.lastVisitedSceneId != null) {
        featuredScene = catalog.scenes.cast<ComfortZoneScene?>().firstWhere(
          (s) => s?.id == prefs.lastVisitedSceneId,
          orElse: () => catalog.scenes.first,
        );
      } else {
        featuredScene = catalog.scenes.first;
      }
    }

    final pinnedBadge = switch (widget.locale) {
      SoulLocale.vi => 'ĐÃ GHIM · 28 KHÔNG GIAN',
      SoulLocale.en => 'PINNED · 28 SPACES',
      SoulLocale.ko => '고정됨 · 28개 안식처',
      SoulLocale.ja => '固定 · 28の空間',
      SoulLocale.fr => 'ÉPINGLÉ · 28 ESPACES',
      SoulLocale.zh => '置顶 · 28个治愈空间',
    };

    return InkWell(
      onTap: () => context.push('/comfort-zone'),
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(
            color: const Color(0xFFE2C4A2).withValues(alpha: 0.80),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD99C4B).withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 1. Base warm morning ivory & sunlit honey gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [
                      Color(0xFFFFFDF8), // warm morning ivory
                      Color(0xFFFFF5E9), // soft sunlit honey
                      Color(0xFFFBEAD8), // gentle apricot warmth
                    ],
                  ),
                ),
              ),
            ),

            // 2. Animated Comfort Scene Canvas (Living breathing window into the safe haven!)
            if (featuredScene != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.72,
                  child: ComfortSceneCanvas(
                    scene: featuredScene,
                    isPlaying: true,
                    showVignette: false,
                  ),
                ),
              ),

            // 3. Elegant Frosted Morning Light Gradient
            // Left side gives pristine contrast for plum typography,
            // Right side allows the living animated room artwork to shine through!
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFFFF9F2).withValues(alpha: 0.96),
                      const Color(0xFFFFF6ED).withValues(alpha: 0.84),
                      const Color(0xFFFFF3E6).withValues(alpha: 0.18),
                    ],
                    stops: const [0.0, 0.52, 1.0],
                  ),
                ),
              ),
            ),

            // 4. Subtle Animated Morning Sunbeam Glow pulsing in the corner
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final glow = 0.15 + 0.10 * _pulseController.value;
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.85, 0.2),
                        radius: 1.1,
                        colors: [
                          const Color(0xFFFFD59E).withValues(alpha: glow),
                          const Color(0xFFFFB74D).withValues(alpha: glow * 0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 5. Foreground Content
            Padding(
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Row(
                children: [
                  // Luminous Amber / Hearth Icon Box
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF0DF), Color(0xFFFDE2C7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      border: Border.all(
                        color: const Color(0xFFE4BD90).withValues(alpha: 0.85),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFD97E36,
                          ).withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.cottage_rounded,
                        color: Color(0xFFB86A2E),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.md),

                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pinned tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFEEBD6,
                            ).withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                            border: Border.all(
                              color: const Color(
                                0xFFE4BD90,
                              ).withValues(alpha: 0.75),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.push_pin_rounded,
                                color: Color(0xFFC7782A),
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  pinnedBadge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFAC5D18),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.comfortZoneTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: SoulColors.plum,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.comfortZoneBannerSubtitle,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: SoulColors.muted, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Trailing gold chevron
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      border: Border.all(
                        color: const Color(0xFFE2C4A2).withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFB86A2E),
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
