import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../data/repositories/vision_repository.dart';
import '../../l10n/app_localizations.dart';
import 'vision_controllers.dart';
import 'vision_widgets.dart';

/// One Vision: photo, statement, feelings and archive.
class VisionDetailScreen extends ConsumerWidget {
  const VisionDetailScreen({super.key, required this.id, this.initialVision});

  final String id;
  final Vision? initialVision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vision =
        initialVision == null
            ? ref.watch(visionProvider(id))
            : AsyncData<Vision?>(initialVision);
    final catalog = ref.watch(activeVisionCatalogProvider);
    void back() => context.go('/app/vision');

    Widget body;
    String? title;
    if (vision.hasError || catalog.hasError) {
      body = SoulErrorState(
        onRetry: () {
          ref.invalidate(visionProvider(id));
          ref.invalidate(activeVisionCatalogProvider);
        },
      );
    } else if (!vision.hasValue || !catalog.hasValue) {
      body = const SoulLoadingState();
    } else if (vision.value == null) {
      body = SoulEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: l10n.visionNotFound,
        message: '',
      );
    } else {
      final item = vision.value!;
      final category = catalog.value!.category(item.categoryCode);
      title = category?.name;
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
                catalog.value!.feeling(code)?.label ?? code,
            ],
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
              await archiveVision(ref, id);
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
        appBar: SoulAppBar(title: title ?? '', onBack: back),
        body: body,
      ),
    );
  }
}
