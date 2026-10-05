import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/vision_audio_repository.dart';
import '../../data/repositories/vision_repository.dart';
import '../../l10n/app_localizations.dart';
import 'vision_controllers.dart';
import 'vision_widgets.dart';

class VisionDetailScreen extends ConsumerStatefulWidget {
  const VisionDetailScreen({super.key, required this.id, this.initialVision});
  final String id;
  final Vision? initialVision;

  @override
  ConsumerState<VisionDetailScreen> createState() => _VisionDetailScreenState();
}

class _VisionDetailScreenState extends ConsumerState<VisionDetailScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _add({
    required String title,
    required String path,
    required bool isAsset,
  }) async {
    await ref
        .read(visionAudioRepositoryProvider)
        .add(widget.id, title: title, path: path, isAsset: isAsset);
    ref.invalidate(visionAudioSelectionsProvider(widget.id));
  }

  Future<void> _record() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isRecording) {
      final recordedPath = await _recorder.stop();
      if (mounted) setState(() => _isRecording = false);
      if (recordedPath != null) {
        await _add(title: l10n.myRecording, path: recordedPath, isAsset: false);
      }
      return;
    }
    if (!await _recorder.hasPermission()) {
      return;
    }
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(path.join(documents.path, 'vision_audio'));
    await directory.create(recursive: true);
    await _recorder.start(
      const RecordConfig(),
      path: path.join(
        directory.path,
        'vision-${widget.id}-${DateTime.now().millisecondsSinceEpoch}.m4a',
      ),
    );
    if (mounted) setState(() => _isRecording = true);
  }

  Future<void> _chooseFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    final file = result?.files.singleOrNull;
    if (file?.path != null) {
      await _add(title: file!.name, path: file.path!, isAsset: false);
    }
  }

  Future<void> _showAdd(AudioCatalog catalog) => showSoulBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(context)!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.addAudio, style: Theme.of(context).textTheme.headlineSmall),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.library_music_outlined),
            title: Text(l10n.chooseFromAudioLibrary),
            onTap: () {
              Navigator.pop(sheetContext);
              _showLibrary(catalog);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.folder_open_outlined),
            title: Text(l10n.chooseAudioFile),
            onTap: () {
              Navigator.pop(sheetContext);
              _chooseFile();
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              _isRecording
                  ? Icons.stop_circle_outlined
                  : Icons.mic_none_outlined,
            ),
            title: Text(_isRecording ? l10n.stopRecording : l10n.recordAudio),
            onTap: () {
              Navigator.pop(sheetContext);
              _record();
            },
          ),
        ],
      );
    },
  );

  Future<void> _showLibrary(AudioCatalog catalog) => showSoulBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      final locale = ref.read(appStateProvider).locale ?? SoulLocale.vi;
      final l10n = AppLocalizations.of(context)!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.audioLibrary,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          for (final asset in catalog.assets)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.graphic_eq),
              title: Text(asset.titleFor(locale)),
              subtitle:
                  asset.delivery == AudioDelivery.published
                      ? null
                      : Text(l10n.audioPending),
              trailing: const Icon(Icons.add),
              onTap:
                  asset.pathFor(locale) == null
                      ? null
                      : () {
                        Navigator.pop(sheetContext);
                        _add(
                          title: asset.titleFor(locale),
                          path: asset.pathFor(locale)!,
                          isAsset: true,
                        );
                      },
            ),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vision =
        widget.initialVision == null
            ? ref.watch(visionProvider(widget.id))
            : AsyncData<Vision?>(widget.initialVision);
    final catalog = ref.watch(activeVisionCatalogProvider);
    final audioCatalog = ref.watch(audioCatalogProvider);
    final selections = ref.watch(visionAudioSelectionsProvider(widget.id));
    final playback = ref.watch(audioPlaybackProvider);
    void back() => context.go('/app/vision');
    final hasError =
        vision.hasError ||
        catalog.hasError ||
        audioCatalog.hasError ||
        selections.hasError;
    final loading =
        !vision.hasValue || !catalog.hasValue || !audioCatalog.hasValue;
    Widget body;
    String title = '';
    if (hasError) {
      body = SoulErrorState(
        onRetry: () {
          ref.invalidate(visionProvider(widget.id));
          ref.invalidate(activeVisionCatalogProvider);
          ref.invalidate(audioCatalogProvider);
          ref.invalidate(visionAudioSelectionsProvider(widget.id));
        },
      );
    } else if (loading) {
      body = const SoulLoadingState();
    } else if (vision.value == null) {
      body = SoulEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: l10n.visionNotFound,
        message: '',
      );
    } else {
      final item = vision.value!;
      final visionCatalog = catalog.value!;
      title = visionCatalog.category(item.categoryCode)?.name ?? '';
      final locale = ref.read(appStateProvider).locale ?? SoulLocale.vi;
      final isVi = Localizations.localeOf(context).languageCode == 'vi';
      final selectionList =
          selections.valueOrNull ?? const <VisionAudioSelection>[];

      // Pre-attached soundtrack resolution
      final defaultAsset =
          audioCatalog.value!.playableSoundsFor(item.categoryCode).firstOrNull;
      final defaultTitle =
          defaultAsset?.titleFor(locale) ??
          (isVi ? 'Âm thanh tĩnh lặng' : 'Calm ambience');
      final defaultPath = defaultAsset?.pathFor(locale);
      final categoryTheme = CategoryArtTheme.forCategory(item.categoryCode);

      final hasPersonalSelection = selectionList.isNotEmpty;
      final activeSoundTitle =
          hasPersonalSelection ? selectionList.first.title : defaultTitle;
      final activeSoundPath =
          hasPersonalSelection ? selectionList.first.path : defaultPath;
      final activeSoundIsAsset =
          hasPersonalSelection ? selectionList.first.isAsset : true;
      final activeSoundSubtitle =
          hasPersonalSelection
              ? (selectionList.first.isAsset
                  ? (isVi ? 'Âm thanh từ thư viện' : 'Library audio')
                  : (isVi ? 'Âm thanh cá nhân' : 'Personal audio'))
              : categoryTheme.frequencyTag(isVi);

      final isSoundActivePlaying =
          activeSoundPath != null &&
          playback.isPlaying &&
          playback.assetPath == activeSoundPath;

      body = ListView(
        padding: const EdgeInsets.fromLTRB(
          SoulSpace.lg,
          SoulSpace.xs,
          SoulSpace.lg,
          SoulSpace.xl,
        ),
        children: [
          if (item.imagePath != null)
            VisionPhoto(relativePath: item.imagePath, height: 210)
          else
            CategoryArtBanner(
              categoryCode: item.categoryCode,
              categoryName: title,
              height: 160,
              showTag: true,
            ),
          const SizedBox(height: SoulSpace.md),
          SoulCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      size: 24,
                      color: SoulColors.ctaStart,
                    ),
                    const SizedBox(width: SoulSpace.xs),
                    Text(
                      isVi ? 'TUYÊN NGÔN TẦM NHÌN' : 'VISION MANIFESTO',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 1.2,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: SoulColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SoulSpace.sm),
                Text(
                  item.statement,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: SoulColors.plum,
                  ),
                ),
                const SizedBox(height: SoulSpace.md),
                FeelingLabels(
                  labels: [
                    for (final code in item.feelingCodes)
                      visionCatalog.feeling(code)?.label ?? code,
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SoulSpace.md),
          SoulCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.visionAudio,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isVi
                                ? 'Âm thanh chữa lành gắn liền với tầm nhìn'
                                : 'Healing soundtrack connected to your vision',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: SoulColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      onPressed: () => _showAdd(audioCatalog.value!),
                      icon: const Icon(Icons.tune_rounded, size: 16),
                      label: Text(
                        isVi ? 'Đổi / Thêm' : 'Change / Add',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SoulSpace.sm),
                Container(
                  padding: const EdgeInsets.all(SoulSpace.sm),
                  decoration: BoxDecoration(
                    color:
                        isSoundActivePlaying
                            ? SoulColors.selectedFill
                            : SoulColors.softFill,
                    borderRadius: BorderRadius.circular(SoulRadius.row),
                    border: Border.all(
                      color:
                          isSoundActivePlaying
                              ? SoulColors.selectedBorder
                              : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0E000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isSoundActivePlaying
                              ? Icons.graphic_eq_rounded
                              : Icons.music_note_rounded,
                          color: SoulColors.ctaStart,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: SoulSpace.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeSoundTitle,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: SoulColors.plum,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeSoundSubtitle,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: SoulColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SoulSpace.xs),
                      Material(
                        color: SoulColors.ctaStart,
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: IconButton(
                          tooltip:
                              isSoundActivePlaying
                                  ? (isVi ? 'Tạm dừng' : 'Pause')
                                  : (isVi ? 'Phát âm thanh' : 'Play audio'),
                          icon: Icon(
                            isSoundActivePlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            if (activeSoundPath == null) return;
                            if (activeSoundIsAsset) {
                              ref
                                  .read(audioPlaybackProvider)
                                  .toggleAsset(activeSoundPath);
                            } else {
                              ref
                                  .read(audioPlaybackProvider)
                                  .toggleFile(activeSoundPath);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectionList.length > 1) ...[
                  const SizedBox(height: SoulSpace.sm),
                  Text(
                    isVi ? 'Âm thanh khác đã lưu:' : 'Other saved audio:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.xs),
                  for (final selection in selectionList.skip(1)) ...[
                    _SelectionRow(
                      selection: selection,
                      isPlaying:
                          playback.isPlaying &&
                          playback.assetPath == selection.path,
                      enabled:
                          !selection.isAsset ||
                          audioCatalog.value!.assets.any(
                            (asset) =>
                                asset.pathFor(locale) == selection.path &&
                                asset.delivery == AudioDelivery.published,
                          ),
                      onPlayPause:
                          () =>
                              selection.isAsset
                                  ? ref
                                      .read(audioPlaybackProvider)
                                      .toggleAsset(selection.path)
                                  : ref
                                      .read(audioPlaybackProvider)
                                      .toggleFile(selection.path),
                      onRemove: () async {
                        await ref
                            .read(visionAudioRepositoryProvider)
                            .remove(widget.id, selection.id);
                        ref.invalidate(
                          visionAudioSelectionsProvider(widget.id),
                        );
                      },
                    ),
                    const SizedBox(height: SoulSpace.xs),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: SoulSpace.xl),
          SoulButton(
            label: l10n.archiveVision,
            variant: SoulButtonVariant.secondary,
            onPressed: () async {
              final confirmed = await showSoulConfirmDialog(
                context: context,
                title: l10n.archiveVisionTitle,
                message: l10n.archiveVisionBody,
                confirmLabel: l10n.archive,
              );
              if (!confirmed) return;
              await archiveVision(ref, widget.id);
              if (context.mounted) back();
            },
          ),
        ],
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) back();
      },
      child: Scaffold(
        appBar: SoulAppBar(title: title, onBack: back),
        body: body,
      ),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({
    required this.selection,
    required this.isPlaying,
    required this.enabled,
    required this.onPlayPause,
    required this.onRemove,
  });
  final VisionAudioSelection selection;
  final bool isPlaying;
  final bool enabled;
  final VoidCallback onPlayPause;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SoulAudioRow(
          title: selection.title,
          subtitle:
              enabled
                  ? AppLocalizations.of(context)!.visionAudioPersonal
                  : AppLocalizations.of(context)!.audioPending,
          isPlaying: isPlaying,
          onPlayPause: enabled ? onPlayPause : null,
        ),
      ),
      IconButton(
        onPressed: onRemove,
        tooltip: AppLocalizations.of(context)!.removeAudio,
        icon: const Icon(Icons.close),
      ),
    ],
  );
}
