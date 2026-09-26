import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/design_system.dart';
import '../../data/local/image_store.dart';
import '../../l10n/app_localizations.dart';

final _storedImageProvider = FutureProvider.autoDispose.family<File, String>((
  ref,
  relativePath,
) {
  return ref.watch(imageStoreProvider).resolve(relativePath);
});

/// A Vision photo: either a stored image ([relativePath]) or a freshly
/// picked file ([filePath]). Missing or broken files show a placeholder.
class VisionPhoto extends ConsumerWidget {
  const VisionPhoto({
    super.key,
    this.relativePath,
    this.filePath,
    this.height = 180,
  });

  final String? relativePath;
  final String? filePath;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final File? file =
        filePath != null
            ? File(filePath!)
            : relativePath == null
            ? null
            : ref.watch(_storedImageProvider(relativePath!)).valueOrNull;
    final placeholder = Container(
      height: height,
      color: SoulColors.lilac,
      alignment: Alignment.center,
      child: Semantics(
        label: l10n.photoUnavailable,
        child: const Icon(Icons.image_outlined, color: SoulColors.plum),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child:
          file == null
              ? placeholder
              : Image.file(
                file,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
                semanticLabel: l10n.visionPhoto,
                errorBuilder: (context, error, stackTrace) => placeholder,
              ),
    );
  }
}

/// Read-only feeling labels.
class FeelingLabels extends StatelessWidget {
  const FeelingLabels({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: SoulSpace.xs,
      runSpacing: SoulSpace.xs,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SoulSpace.sm,
              vertical: SoulSpace.xxs,
            ),
            decoration: BoxDecoration(
              color: SoulColors.selectedFill,
              borderRadius: BorderRadius.circular(SoulRadius.row),
            ),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SoulColors.selectedInk),
            ),
          ),
      ],
    );
  }
}
