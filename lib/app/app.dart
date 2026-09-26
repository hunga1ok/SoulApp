import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/soul_theme.dart';
import '../l10n/app_localizations.dart';
import 'app_state.dart';
import 'router.dart';

class SoulApp extends ConsumerWidget {
  const SoulApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Soul',
      debugShowCheckedModeBanner: false,
      theme: soulTheme,
      routerConfig: router,
      locale: state.locale == null ? null : Locale(state.locale!.name),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
