import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../soul_theme.dart';
import 'soul_button.dart';

/// Modal bottom sheet with the Soul surface, drag handle, Safe Area and
/// keyboard inset handling. Content scrolls when it does not fit.
Future<T?> showSoulBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder:
        (sheetContext) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                SoulSpace.lg,
                0,
                SoulSpace.lg,
                SoulSpace.lg,
              ),
              child: builder(sheetContext),
            ),
          ),
        ),
  );
}

/// Confirmation dialog. Resolves to `true` only when the user confirms.
Future<bool> showSoulConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(dialogContext).textTheme.headlineSmall,
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: Theme.of(dialogContext).textTheme.bodyLarge,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SoulButton(
            label: confirmLabel,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
          const SizedBox(height: SoulSpace.xs),
          SoulButton(
            label: l10n.cancel,
            variant: SoulButtonVariant.secondary,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
