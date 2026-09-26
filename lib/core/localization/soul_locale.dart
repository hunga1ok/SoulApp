/// Supported app and content locales.
enum SoulLocale {
  vi,
  en;

  /// Parses the backend/profile code; returns `null` for anything else.
  static SoulLocale? tryParse(String? code) {
    for (final locale in values) {
      if (locale.name == code) return locale;
    }
    return null;
  }
}
