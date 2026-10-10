/// Supported app and content locales.
enum SoulLocale {
  vi,
  en,
  ko,
  ja,
  fr,
  zh;

  /// Native language name (endonym) shown in language selectors.
  String get endonym => switch (this) {
    SoulLocale.vi => 'Tiếng Việt',
    SoulLocale.en => 'English',
    SoulLocale.ko => '한국어',
    SoulLocale.ja => '日本語',
    SoulLocale.fr => 'Français',
    SoulLocale.zh => '中文',
  };

  /// Localized "Continue" label for the language-neutral gate screen.
  String get continueLabel => switch (this) {
    SoulLocale.vi => 'Tiếp tục',
    SoulLocale.en => 'Continue',
    SoulLocale.ko => '계속하기',
    SoulLocale.ja => '続ける',
    SoulLocale.fr => 'Continuer',
    SoulLocale.zh => '继续',
  };

  /// Parses a stored locale code; returns `null` for anything else.
  static SoulLocale? tryParse(String? code) {
    for (final locale in values) {
      if (locale.name == code) return locale;
    }
    return null;
  }
}
