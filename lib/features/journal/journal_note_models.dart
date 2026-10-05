import '../../core/localization/soul_locale.dart';
import '../../data/local/soul_database.dart';

class JourneyDayThemes {
  static const Map<int, (String vi, String en)> _themes = {
    1: ('Buổi sáng biết ơn', 'Morning Gratitude'),
    2: ('Hòn đá nhiệm màu', 'The Magic Rock'),
    3: ('Mối quan hệ nhiệm màu', 'Magical Relationships'),
    4: ('Sức khỏe nhiệm màu', 'Magical Health'),
    5: ('Tiền bạc nhiệm màu', 'Magic Money'),
    6: ('Phép màu trong công việc', 'Works Like Magic'),
    7: ('Lối thoát khỏi sự tiêu cực', 'The Magical Way Out of Negativity'),
    8: ('Gia vị nhiệm màu', 'The Magic Ingredient'),
    9: ('Nam châm tiền bạc', 'The Money Magnet'),
    10: ('Bụi phép thuật cho mọi người', 'Magic Dust Everyone'),
    11: ('Buổi sáng nhiệm màu', 'A Magic Morning'),
    12: (
      'Những con người tạo nên khác biệt',
      'Magical People Who Made a Difference',
    ),
    13: ('Biến ước mơ thành hiện thực', 'Make All Your Wishes Come True'),
    14: ('Một ngày nhiệm màu', 'Have a Magical Day'),
    15: ('Hàn gắn mối quan hệ', 'Magically Heal Your Relationships'),
    16: ('Điều kỳ diệu của sức khỏe', 'Magic and Miracles in Health'),
    17: ('Tấm séc nhiệm màu', 'The Magic Check'),
    18: ('Danh sách việc cần làm nhiệm màu', 'The Magical To-Do List'),
    19: ('Bước chân nhiệm màu', 'Magic Footsteps'),
    20: ('Phép màu của trái tim', 'Heart Magic'),
    21: ('Kết quả tuyệt diệu', 'Magnificent Outcomes'),
    22: ('Ngay trước mắt bạn', 'Before Your Very Eyes'),
    23: (
      'Không khí nhiệm màu bạn đang thở',
      'The Magical Air That You Breathe',
    ),
    24: ('Chiếc đũa phép', 'The Magic Wand'),
    25: ('Gợi ý nhiệm màu', 'Cue the Magic'),
    26: (
      'Chuyển hóa sai lầm thành phước lành',
      'Magically Transform Mistakes into Blessings',
    ),
    27: ('Tấm gương nhiệm màu', 'The Magic Mirror'),
    28: ('Nhớ lại phép màu', 'Remember the Magic'),
  };

  static String getTitle(int day, SoulLocale locale) {
    final entry = _themes[day];
    if (entry != null) {
      return locale == SoulLocale.vi ? entry.$1 : entry.$2;
    }
    return locale == SoulLocale.vi
        ? 'Ngày $day: Thực hành biết ơn'
        : 'Day $day: Gratitude Practice';
  }
}

/// Combines gratitude item and reason into one complete, fluent sentence.
/// E.g. "Tôi biết ơn [điều biết ơn] vì [lý do]."
/// E.g. "I am grateful for [item] because [reason]."
String formatGratitudeSentence({
  required String gratitude,
  String? reason,
  required SoulLocale locale,
}) {
  final cleanGratitude = gratitude.trim();
  final cleanReason = reason?.trim() ?? '';

  if (locale == SoulLocale.vi) {
    final lower = cleanGratitude.toLowerCase();
    String base;
    if (lower.startsWith('tôi biết ơn vì ')) {
      base = 'Tôi biết ơn ${cleanGratitude.substring(15).trim()}';
    } else if (lower.startsWith('tôi biết ơn') || lower.startsWith('biết ơn')) {
      base = cleanGratitude;
    } else {
      base = 'Tôi biết ơn $cleanGratitude';
    }

    if (cleanReason.isEmpty) {
      return base.endsWith('.') ? base : '$base.';
    }

    final lowerReason = cleanReason.toLowerCase();
    String becausePart;
    if (lowerReason.startsWith('vì sao') ||
        lowerReason.startsWith('bởi vì') ||
        lowerReason.startsWith('vì')) {
      becausePart = cleanReason;
    } else {
      becausePart = 'vì $cleanReason';
    }

    final full = '$base $becausePart';
    return full.endsWith('.') ? full : '$full.';
  } else {
    final lower = cleanGratitude.toLowerCase();
    String base;
    if (lower.startsWith('i am grateful') || lower.startsWith('grateful for')) {
      base = cleanGratitude;
    } else {
      base = 'I am grateful for $cleanGratitude';
    }

    if (cleanReason.isEmpty) {
      return base.endsWith('.') ? base : '$base.';
    }

    final lowerReason = cleanReason.toLowerCase();
    String becausePart;
    if (lowerReason.startsWith('because')) {
      becausePart = cleanReason;
    } else {
      becausePart = 'because $cleanReason';
    }

    final full = '$base $becausePart';
    return full.endsWith('.') ? full : '$full.';
  }
}

class JournalNote {
  const JournalNote({
    required this.id,
    required this.title,
    this.journeyDay,
    required this.createdAt,
    required this.sentences,
    required this.rawEntries,
  });

  final String id;
  final String title;
  final int? journeyDay;
  final DateTime createdAt;
  final List<String> sentences;
  final List<GratitudeEntryRow> rawEntries;
}

/// Groups flat GratitudeEntryRow items into cohesive JournalNote representations.
List<JournalNote> groupGratitudeEntries(
  List<GratitudeEntryRow> entries,
  SoulLocale locale,
) {
  if (entries.isEmpty) return const [];

  final Map<String, List<GratitudeEntryRow>> groups = {};

  for (final entry in entries) {
    String key;
    if (entry.journeyDay != null) {
      final dateKey =
          '${entry.createdAt.year}_${entry.createdAt.month}_${entry.createdAt.day}';
      key = 'journey_${entry.journeyDay}_$dateKey';
    } else {
      // Standalone note: group entries created within the same minute
      final minuteKey =
          '${entry.createdAt.year}_${entry.createdAt.month}_${entry.createdAt.day}_${entry.createdAt.hour}_${entry.createdAt.minute}';
      key = 'note_${entry.id}_$minuteKey';
    }
    groups.putIfAbsent(key, () => []).add(entry);
  }

  final notes = <JournalNote>[];

  for (final MapEntry(value: groupEntries) in groups.entries) {
    if (groupEntries.isEmpty) continue;
    final first = groupEntries.first;

    String title;
    if (first.journeyDay != null) {
      title = JourneyDayThemes.getTitle(first.journeyDay!, locale);
    } else {
      // Check if bracketed theme was prefixed: e.g. "[Gia đình] ..."
      final rawText = first.gratitudeText;
      if (rawText.startsWith('[') && rawText.contains(']')) {
        final closing = rawText.indexOf(']');
        title = rawText.substring(1, closing).trim();
      } else {
        title =
            locale == SoulLocale.vi ? 'Khoảnh khắc biết ơn' : 'Grateful Moment';
      }
    }

    final sentences = <String>[];
    for (final entry in groupEntries) {
      String cleanText = entry.gratitudeText;
      if (first.journeyDay == null &&
          cleanText.startsWith('[') &&
          cleanText.contains(']')) {
        final closing = cleanText.indexOf(']');
        cleanText = cleanText.substring(closing + 1).trim();
      }
      sentences.add(
        formatGratitudeSentence(
          gratitude: cleanText,
          reason: entry.reasonText,
          locale: locale,
        ),
      );
    }

    notes.add(
      JournalNote(
        id: first.id,
        title: title,
        journeyDay: first.journeyDay,
        createdAt: first.createdAt,
        sentences: sentences,
        rawEntries: groupEntries,
      ),
    );
  }

  notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return notes;
}
