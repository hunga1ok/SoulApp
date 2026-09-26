import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';

/// Returns the first supported language in the device's preference order,
/// or `null` when none is supported. The result is only a visual suggestion
/// on the language gate; it is never persisted without the user's tap.
SoulLocale? suggestLocale(Iterable<Locale> deviceLocales) {
  for (final locale in deviceLocales) {
    switch (locale.languageCode) {
      case 'vi':
        return SoulLocale.vi;
      case 'en':
        return SoulLocale.en;
    }
  }
  return null;
}

final suggestedLocaleProvider = Provider<SoulLocale?>((ref) {
  return suggestLocale(WidgetsBinding.instance.platformDispatcher.locales);
});
