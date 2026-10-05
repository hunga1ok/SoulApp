import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../data/content/vision_catalog.dart';
import '../../data/repositories/vision_repository.dart';
import '../../l10n/app_localizations.dart';
import 'vision_controllers.dart';
import 'vision_widgets.dart';

/// Vision tab: a guided empty state, or the board of active Visions.
class VisionScreen extends ConsumerWidget {
  const VisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visions = ref.watch(visionsProvider);
    final catalog = ref.watch(activeVisionCatalogProvider);
    void create() => context.go('/app/vision/new');

    if (visions.hasError || catalog.hasError) {
      return SoulErrorState(
        onRetry: () {
          ref.invalidate(visionsProvider);
          ref.invalidate(activeVisionCatalogProvider);
        },
      );
    }
    if (!visions.hasValue || !catalog.hasValue) return const SoulLoadingState();
    if (visions.value!.isEmpty) {
      return SoulEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: l10n.visionEmptyTitle,
        message: l10n.visionEmptyBody,
        action: SoulButton(label: l10n.createVision, onPressed: create),
      );
    }
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            SoulSpace.lg,
            SoulSpace.md,
            SoulSpace.lg,
            SoulSpace.xl + 72,
          ),
          children: [
            Text(
              l10n.yourVisions,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: SoulSpace.lg),
            for (final vision in visions.value!)
              Padding(
                padding: const EdgeInsets.only(bottom: SoulSpace.md),
                child: _VisionCard(vision: vision, catalog: catalog.value!),
              ),
          ],
        ),
        Positioned(
          right: SoulSpace.lg,
          bottom: SoulSpace.lg,
          child: Semantics(
            button: true,
            label: l10n.createVision,
            child: FloatingActionButton.small(
              tooltip: l10n.createVision,
              backgroundColor: SoulColors.ctaStart,
              foregroundColor: Colors.white,
              onPressed: create,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}

class _VisionCard extends StatelessWidget {
  const _VisionCard({required this.vision, required this.catalog});

  final Vision vision;
  final VisionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final category = catalog.category(vision.categoryCode);
    return SoulCard(
      onTap: () => context.push('/app/vision/${vision.id}', extra: vision),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vision.imagePath != null) ...[
            VisionPhoto(relativePath: vision.imagePath, height: 140),
            const SizedBox(height: SoulSpace.sm),
          ],
          Text(
            [
              if (category?.icon != null) category!.icon!,
              category?.name ?? vision.categoryCode,
            ].join(' ').toUpperCase(),
            style: textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
          ),
          const SizedBox(height: SoulSpace.xs),
          Text(
            vision.statement,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: SoulSpace.sm),
          FeelingLabels(
            labels: [
              for (final code in vision.feelingCodes)
                catalog.feeling(code)?.label ?? code,
            ],
          ),
        ],
      ),
    );
  }
}
