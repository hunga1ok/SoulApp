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

/// Artistic theme metadata for Vision categories.
class CategoryArtTheme {
  const CategoryArtTheme({
    required this.gradientColors,
    required this.accentColor,
    required this.icon,
    required this.frequencyTagVi,
    required this.frequencyTagEn,
    required this.bgIcon,
  });

  final List<Color> gradientColors;
  final Color accentColor;
  final String icon;
  final String frequencyTagVi;
  final String frequencyTagEn;
  final IconData bgIcon;

  String frequencyTag(bool isVi) => isVi ? frequencyTagVi : frequencyTagEn;

  static CategoryArtTheme forCategory(String categoryCode) {
    switch (categoryCode.toUpperCase()) {
      case 'LOVE':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFFFCBD2),
            Color(0xFFFFB3BC),
            Color(0xFFFFE3E6),
          ],
          accentColor: Color(0xFFB0425C),
          icon: '❤️',
          frequencyTagVi: '639 Hz • Tần số tình yêu',
          frequencyTagEn: '639 Hz • Love & Harmony',
          bgIcon: Icons.favorite_rounded,
        );
      case 'CAREER':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFB8D5E5),
            Color(0xFF8EB9D2),
            Color(0xFFE8F1F5),
          ],
          accentColor: Color(0xFF285472),
          icon: '💼',
          frequencyTagVi: '528 Hz • Khai mở tiềm năng',
          frequencyTagEn: '528 Hz • Transformation',
          bgIcon: Icons.lightbulb_outline_rounded,
        );
      case 'MONEY':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFFBE4C8),
            Color(0xFFF5CF9C),
            Color(0xFFFFF7ED),
          ],
          accentColor: Color(0xFF9E6517),
          icon: '💰',
          frequencyTagVi: '888 Hz • Dòng chảy đủ đầy',
          frequencyTagEn: '888 Hz • Abundance Flow',
          bgIcon: Icons.all_inclusive_rounded,
        );
      case 'HEALTH':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFC7E8D6),
            Color(0xFFA5D8BC),
            Color(0xFFEFF9F3),
          ],
          accentColor: Color(0xFF25663E),
          icon: '🌿',
          frequencyTagVi: '528 Hz • Tái tạo sinh lực',
          frequencyTagEn: '528 Hz • Vitality & Health',
          bgIcon: Icons.spa_rounded,
        );
      case 'HOME':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFEADBCE),
            Color(0xFFD8BFAB),
            Color(0xFFF9F5F0),
          ],
          accentColor: Color(0xFF704A33),
          icon: '🏡',
          frequencyTagVi: '432 Hz • Bình yên tổ ấm',
          frequencyTagEn: '432 Hz • Rooted Calm',
          bgIcon: Icons.cottage_rounded,
        );
      case 'TRAVEL':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFBCE7EE),
            Color(0xFF8CD4E2),
            Color(0xFFEEFBFC),
          ],
          accentColor: Color(0xFF1D6F7F),
          icon: '✈️',
          frequencyTagVi: '741 Hz • Tự do khám phá',
          frequencyTagEn: '741 Hz • Freedom & Wonder',
          bgIcon: Icons.flight_takeoff_rounded,
        );
      case 'FAMILY':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFFFD4D4),
            Color(0xFFFFB8B8),
            Color(0xFFFFF0F0),
          ],
          accentColor: Color(0xFF9E3E3E),
          icon: '👨‍👩‍👧',
          frequencyTagVi: '528 Hz • Kết nối yêu thương',
          frequencyTagEn: '528 Hz • Heart Space',
          bgIcon: Icons.family_restroom_rounded,
        );
      case 'GROWTH':
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFE2D6F5),
            Color(0xFFCAB4EC),
            Color(0xFFF7F2FD),
          ],
          accentColor: Color(0xFF673F94),
          icon: '✨',
          frequencyTagVi: '963 Hz • Thức tỉnh trực giác',
          frequencyTagEn: '963 Hz • Higher Intuition',
          bgIcon: Icons.auto_awesome_rounded,
        );
      case 'PEACE':
      default:
        return const CategoryArtTheme(
          gradientColors: [
            Color(0xFFD1E4E6),
            Color(0xFFB5D3D6),
            Color(0xFFF2F7F7),
          ],
          accentColor: Color(0xFF386065),
          icon: '🕊️',
          frequencyTagVi: '432 Hz • Tĩnh lặng tâm hồn',
          frequencyTagEn: '432 Hz • Deep Inner Peace',
          bgIcon: Icons.self_improvement_rounded,
        );
    }
  }
}

/// Artistic visual banner displayed on vision cards and detail headers
/// when no custom photo is uploaded.
class CategoryArtBanner extends StatelessWidget {
  const CategoryArtBanner({
    super.key,
    required this.categoryCode,
    this.categoryName,
    this.height = 140,
    this.showTag = true,
  });

  final String categoryCode;
  final String? categoryName;
  final double height;
  final bool showTag;

  @override
  Widget build(BuildContext context) {
    final theme = CategoryArtTheme.forCategory(categoryCode);
    final isVi = Localizations.localeOf(context).languageCode == 'vi';

    return ClipRRect(
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -20,
              child: Opacity(
                opacity: 0.18,
                child: Icon(
                  theme.bgIcon,
                  size: height * 1.15,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: SoulSpace.md,
              top: SoulSpace.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.sm,
                  vertical: SoulSpace.xxs + 1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(SoulRadius.row),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(theme.icon, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: SoulSpace.xs),
                    Text(
                      categoryName ?? categoryCode,
                      style: TextStyle(
                        color: theme.accentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showTag)
              Positioned(
                left: SoulSpace.md,
                bottom: SoulSpace.sm,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SoulSpace.xs + 2,
                    vertical: SoulSpace.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(SoulRadius.row),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.graphic_eq_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: SoulSpace.xxs + 1),
                      Text(
                        theme.frequencyTag(isVi),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
