import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  var _smallActionDone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = ref.watch(appStateProvider).preferredName ?? '…';
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Text(
          l10n.dayProgress(1).toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: SoulSpace.xs),
        Text(
          l10n.welcome(name),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.lg),
        const _ProgressCard(),
        const SizedBox(height: SoulSpace.lg),
        Text(
          l10n.todayRhythm,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        const _SoundCard(),
        const SizedBox(height: SoulSpace.lg),
        Text(
          l10n.oneSmallAction,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        Semantics(
          button: true,
          selected: _smallActionDone,
          label: l10n.oneSmallAction,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => setState(() => _smallActionDone = !_smallActionDone),
            child: Ink(
              padding: const EdgeInsets.all(SoulSpace.md),
              decoration: BoxDecoration(
                color: _smallActionDone ? SoulColors.lilac : SoulColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _smallActionDone
                          ? SoulColors.lilacStrong
                          : SoulColors.line,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _smallActionDone
                        ? Icons.check_circle
                        : Icons.auto_awesome_outlined,
                    color: SoulColors.lilacStrong,
                  ),
                  const SizedBox(width: SoulSpace.sm),
                  Expanded(
                    child: Text(
                      l10n.smallActionText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SoulSpace.lg),
      decoration: BoxDecoration(
        color: SoulColors.rose,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('01', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: SoulSpace.xs),
          LinearProgressIndicator(
            value: 1 / 28,
            color: SoulColors.lilacStrong,
            backgroundColor: Colors.white70,
            minHeight: 7,
            borderRadius: BorderRadius.circular(9),
          ),
        ],
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  const _SoundCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(SoulSpace.md),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: SoulColors.line),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: SoulColors.lilac,
            foregroundColor: SoulColors.plum,
            child: Icon(Icons.graphic_eq),
          ),
          const SizedBox(width: SoulSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.morningGratitude,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  l10n.neutralInstrumentalFiveMinutes,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded),
            tooltip: l10n.play,
          ),
        ],
      ),
    );
  }
}
