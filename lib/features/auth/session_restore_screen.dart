import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/design_system.dart';
import '../../core/errors/error_messages.dart';
import '../../l10n/app_localizations.dart';
import 'session_controller.dart';

/// Shown while a stored session is restored on start, or with a retry when
/// the restore failed for a transient reason (network, server unavailable).
class SessionRestoreScreen extends ConsumerWidget {
  const SessionRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    return Scaffold(
      body: SafeArea(
        child:
            session.hasError && !session.isLoading
                ? SoulErrorState(
                  message: errorMessage(
                    AppLocalizations.of(context)!,
                    session.error,
                  ),
                  onRetry:
                      () =>
                          ref
                              .read(sessionControllerProvider.notifier)
                              .retryRestore(),
                )
                : const SoulLoadingState(),
      ),
    );
  }
}
