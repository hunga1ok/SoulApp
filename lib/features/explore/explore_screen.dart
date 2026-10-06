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
    required this.title,
    required this.creator,
    required this.category,
    required this.duration,
    required this.type,
    required this.url,
  });

  final String id;
  final String title;
  final String creator;
  final String category;
  final String duration;
  final _ExploreItemType type;
  final String url;
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
      title: 'Thiền biết ơn & Sức mạnh của lòng trân trọng',
      creator: 'Mindful Science',
      category: 'Thiền định',
      duration: '15 phút',
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=3mFVCX2wmqw',
    ),
    _ExternalItem(
      id: 'YT-002',
      title: 'Thiền biết ơn buổi sáng tràn ngập niềm vui',
      creator: 'Great Meditation',
      category: 'Khởi đầu ngày mới',
      duration: '10 phút',
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=3-H4vNvealw',
    ),
    _ExternalItem(
      id: 'YT-003',
      title: 'Khẳng định tích cực về lòng biết ơn trong 21 ngày',
      creator: 'Bob Baker Affirmations',
      category: 'Affirmations',
      duration: '12 phút',
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=iHLQOHZJync',
    ),
    _ExternalItem(
      id: 'YT-004',
      title: 'Thiền về sự đủ đầy & Tư duy thịnh vượng',
      creator: 'Proctor Gallagher Institute',
      category: 'Đủ đầy & Thịnh vượng',
      duration: '18 phút',
      type: _ExploreItemType.youtube,
      url: 'https://www.youtube.com/watch?v=RKOlsS4QCRU',
    ),
    // Spotify Podcasts
    _ExternalItem(
      id: 'SP-011',
      title: 'Tâm lý học về con người tương lai của bạn',
      creator: 'Dan Gilbert (TED Talks Daily)',
      category: 'Tâm lý & Tầm nhìn',
      duration: '12 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/5ESaeSaf4Rz56snsmlcBFs',
    ),
    _ExternalItem(
      id: 'SP-004',
      title: 'Thiền yêu thương bản thân & Nâng cao giá trị nội tại',
      creator: 'Wake Me Up Podcast',
      category: 'Yêu thương bản thân',
      duration: '13 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/4lpvFIhoUtCAWaWZniSb3K',
    ),
    _ExternalItem(
      id: 'SP-022',
      title: 'Cách lòng biết ơn chữa lành một gia đình qua nghịch cảnh',
      creator: 'The Gratitude Podcast',
      category: 'Câu chuyện cảm hứng',
      duration: '25 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/0b70Fnl008FTCKDlOGYt3L',
    ),
    _ExternalItem(
      id: 'SP-008',
      title: 'Cách trở thành phiên bản tương lai & Nhật ký tương lai',
      creator: 'How to Like Your Life',
      category: 'Phát triển cá nhân',
      duration: '20 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/episode/02JjKe5oUPOZWSsPflSGXF',
    ),
    // Frequency
    _ExternalItem(
      id: 'FRQ-001',
      title: '432Hz Bình an & Cân bằng năng lượng',
      creator: 'DanaMusic Healing',
      category: 'Tần số 432Hz',
      duration: '7 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/track/3oRhjjiLO6rdZOPFz6cJhJ',
    ),
    _ExternalItem(
      id: 'FRQ-004',
      title: '528Hz Chữa lành & Tình yêu thương thuần khiết',
      creator: 'The Mountain Soundscape',
      category: 'Tần số 528Hz',
      duration: '5 phút',
      type: _ExploreItemType.spotify,
      url: 'https://open.spotify.com/track/0i6EOz53YsgC13IZGz8XTW',
    ),
  ];

  Future<void> _openUrl(String? url) async {
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
          const SnackBar(
            content: Text('Không thể mở liên kết. Vui lòng thử lại sau.'),
            duration: Duration(seconds: 2),
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
              return item.type == _ExploreItemType.spotify &&
                  !item.category.contains('Tần số');
            case _ExploreTab.frequency:
              return item.category.contains('Tần số');
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
                  isVi ? 'Âm thanh Soul nổi bật' : 'Featured Soul Audio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SoulColors.plum,
                  ),
                ),
              ),
              TextButton(
                onPressed:
                    () => setState(() => _selectedTab = _ExploreTab.audio),
                child: Text(
                  isVi ? 'Xem tất cả' : 'View all',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: SoulSpace.xs),
          for (final asset in featuredSoulAudio)
            _buildSoulAudioRow(asset, locale, audio, state, isVi, l10n),
          const SizedBox(height: SoulSpace.lg),
          Text(
            isVi ? 'Gợi ý từ cộng đồng' : 'Community Recommendations',
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
            onTap: () => _openUrl(item.url),
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
                                item.category,
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
                          item.title,
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
                                '${item.creator} · ${item.duration}',
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

    final subtitle =
        asset.isGuided
            ? (isVi ? 'Bài dẫn thiền định song ngữ' : 'Guided Meditation')
            : (asset.type == 'music'
                ? (isVi ? 'Nhạc tĩnh lặng & Tần số' : 'Healing Soundscape')
                : (isVi
                    ? 'Âm thanh tự nhiên & Thư giãn'
                    : 'Nature & Ambience'));

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
