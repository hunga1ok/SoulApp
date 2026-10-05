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
        !vision.hasValue ||
        !catalog.hasValue ||
        !audioCatalog.hasValue ||
        !selections.hasValue;
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
      body = ListView(
        padding: const EdgeInsets.fromLTRB(
          SoulSpace.lg,
          SoulSpace.xs,
          SoulSpace.lg,
          SoulSpace.xl,
        ),
        children: [
          if (item.imagePath != null) ...[
            VisionPhoto(relativePath: item.imagePath, height: 220),
            const SizedBox(height: SoulSpace.lg),
          ],
          Text(item.statement, style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: SoulSpace.md),
          FeelingLabels(
            labels: [
              for (final code in item.feelingCodes)
                visionCatalog.feeling(code)?.label ?? code,
            ],
          ),
          const SizedBox(height: SoulSpace.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.visionAudio,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                tooltip: l10n.addAudio,
                onPressed: () => _showAdd(audioCatalog.value!),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          Text(
            l10n.visionAudioBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SoulSpace.sm),
          if (selections.value!.isEmpty) Text(l10n.visionAudioEmpty),
          for (final selection in selections.value!) ...[
            _SelectionRow(
              selection: selection,
              isPlaying:
                  playback.isPlaying && playback.assetPath == selection.path,
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
                ref.invalidate(visionAudioSelectionsProvider(widget.id));
              },
            ),
            const SizedBox(height: SoulSpace.sm),
          ],
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
