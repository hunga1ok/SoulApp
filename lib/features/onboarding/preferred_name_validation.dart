/// Maximum preferred-name length in Unicode code points.
const preferredNameMaxLength = 40;

enum PreferredNameIssue { empty, tooLong }

/// Validates the trimmed name: 1 to [preferredNameMaxLength] code points.
PreferredNameIssue? validatePreferredName(String raw) {
  final name = raw.trim();
  if (name.isEmpty) return PreferredNameIssue.empty;
  if (name.runes.length > preferredNameMaxLength) {
    return PreferredNameIssue.tooLong;
  }
  return null;
}
