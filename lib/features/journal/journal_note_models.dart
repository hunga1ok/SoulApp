import '../../core/localization/soul_locale.dart';
import '../../data/local/soul_database.dart';

class JourneyDayThemes {
  static const Map<
    int,
    ({String vi, String en, String ko, String ja, String fr, String zh})
  >
  _themes = {
    1: (
      vi: 'Buổi sáng biết ơn',
      en: 'Morning Gratitude',
      ko: '감사의 아침',
      ja: '感謝の朝',
      fr: 'Gratitude du matin',
      zh: '感恩的清晨',
    ),
    2: (
      vi: 'Hòn đá nhiệm màu',
      en: 'The Magic Rock',
      ko: '마법의 돌',
      ja: '魔法の石',
      fr: 'La pierre magique',
      zh: '魔法石',
    ),
    3: (
      vi: 'Mối quan hệ nhiệm màu',
      en: 'Magical Relationships',
      ko: '마법 같은 관계',
      ja: '魔法の人間関係',
      fr: 'Relations magiques',
      zh: '奇妙的关系',
    ),
    4: (
      vi: 'Sức khỏe nhiệm màu',
      en: 'Magical Health',
      ko: '마법 같은 건강',
      ja: '魔法の健康',
      fr: 'Santé magique',
      zh: '神奇的健康',
    ),
    5: (
      vi: 'Tiền bạc nhiệm màu',
      en: 'Magic Money',
      ko: '마법의 돈',
      ja: '魔法のお金',
      fr: 'L’argent magique',
      zh: '魔法金钱',
    ),
    6: (
      vi: 'Phép màu trong công việc',
      en: 'Works Like Magic',
      ko: '일 속의 마법',
      ja: '仕事の魔法',
      fr: 'La magie au travail',
      zh: '工作中的奇迹',
    ),
    7: (
      vi: 'Lối thoát khỏi sự tiêu cực',
      en: 'The Magical Way Out of Negativity',
      ko: '부정에서 벗어나는 마법의 길',
      ja: 'ネガティブから抜け出す魔法の道',
      fr: 'Sortir de la négativité par la magie',
      zh: '走出消极的神奇之路',
    ),
    8: (
      vi: 'Gia vị nhiệm màu',
      en: 'The Magic Ingredient',
      ko: '마법의 재료',
      ja: '魔法のスパイス',
      fr: 'L’ingrédient magique',
      zh: '神奇的调味料',
    ),
    9: (
      vi: 'Nam châm tiền bạc',
      en: 'The Money Magnet',
      ko: '돈의 자석',
      ja: 'お金の磁石',
      fr: 'L’aimant à argent',
      zh: '财富磁铁',
    ),
    10: (
      vi: 'Bụi phép thuật cho mọi người',
      en: 'Magic Dust Everyone',
      ko: '모두에게 뿌리는 마법 가루',
      ja: 'みんなへの魔法の粉',
      fr: 'Poussière magique pour tous',
      zh: '洒向众人的魔法星尘',
    ),
    11: (
      vi: 'Buổi sáng nhiệm màu',
      en: 'A Magic Morning',
      ko: '마법 같은 아침',
      ja: '魔法の朝',
      fr: 'Un matin magique',
      zh: '奇妙的清晨',
    ),
    12: (
      vi: 'Những con người tạo nên khác biệt',
      en: 'Magical People Who Made a Difference',
      ko: '변화를 만든 마법 같은 사람들',
      ja: '人生を変えてくれた魔法の人々',
      fr: 'Les personnes magiques qui ont compté',
      zh: '带来改变的奇妙贵人',
    ),
    13: (
      vi: 'Biến ước mơ thành hiện thực',
      en: 'Make All Your Wishes Come True',
      ko: '모든 소원을 현실로 만들기',
      ja: 'すべての願いを叶える',
      fr: 'Réaliser tous vos souhaits',
      zh: '让所有愿望成真',
    ),
    14: (
      vi: 'Một ngày nhiệm màu',
      en: 'Have a Magical Day',
      ko: '마법 같은 하루 보내기',
      ja: '魔法のような一日を',
      fr: 'Une journée magique',
      zh: '度过神奇的一天',
    ),
    15: (
      vi: 'Hàn gắn mối quan hệ',
      en: 'Magically Heal Your Relationships',
      ko: '관계를 마법처럼 치유하기',
      ja: '人間関係を魔法で癒やす',
      fr: 'Guérir vos relations par la magie',
      zh: '神奇地疗愈关系',
    ),
    16: (
      vi: 'Điều kỳ diệu của sức khỏe',
      en: 'Magic and Miracles in Health',
      ko: '건강 속의 마법과 기적',
      ja: '健康における魔法と奇跡',
      fr: 'Magie et miracles pour la santé',
      zh: '健康的魔法与奇迹',
    ),
    17: (
      vi: 'Tấm séc nhiệm màu',
      en: 'The Magic Check',
      ko: '마법의 수표',
      ja: '魔法の小切手',
      fr: 'Le chèque magique',
      zh: '魔法支票',
    ),
    18: (
      vi: 'Danh sách việc cần làm nhiệm màu',
      en: 'The Magical To-Do List',
      ko: '마법의 할 일 목록',
      ja: '魔法のやることリスト',
      fr: 'La liste magique des tâches',
      zh: '神奇待办清单',
    ),
    19: (
      vi: 'Bước chân nhiệm màu',
      en: 'Magic Footsteps',
      ko: '마법의 발걸음',
      ja: '魔法の足音',
      fr: 'Les pas magiques',
      zh: '感恩的脚步',
    ),
    20: (
      vi: 'Phép màu của trái tim',
      en: 'Heart Magic',
      ko: '마음의 마법',
      ja: '心の魔法',
      fr: 'La magie du cœur',
      zh: '心灵的魔法',
    ),
    21: (
      vi: 'Kết quả tuyệt diệu',
      en: 'Magnificent Outcomes',
      ko: '놀라운 결과',
      ja: '素晴らしい結果',
      fr: 'Des résultats magnifiques',
      zh: '美好的结果',
    ),
    22: (
      vi: 'Ngay trước mắt bạn',
      en: 'Before Your Very Eyes',
      ko: '눈앞에서 펼쳐지는 마법',
      ja: 'あなたの目の前で',
      fr: 'Sous vos propres yeux',
      zh: '就在你眼前',
    ),
    23: (
      vi: 'Không khí nhiệm màu bạn đang thở',
      en: 'The Magical Air That You Breathe',
      ko: '숨 쉬는 마법의 공기',
      ja: 'あなたが吸う魔法の空気',
      fr: 'L’air magique que vous respirez',
      zh: '呼吸着的神奇空气',
    ),
    24: (
      vi: 'Chiếc đũa phép',
      en: 'The Magic Wand',
      ko: '마법 지팡이',
      ja: '魔法の杖',
      fr: 'La baguette magique',
      zh: '魔法棒',
    ),
    25: (
      vi: 'Gợi ý nhiệm màu',
      en: 'Cue the Magic',
      ko: '마법의 신호',
      ja: '魔法の合図',
      fr: 'Le signal magique',
      zh: '魔法的提示',
    ),
    26: (
      vi: 'Chuyển hóa sai lầm thành phước lành',
      en: 'Magically Transform Mistakes into Blessings',
      ko: '실수를 축복으로 바꾸는 마법',
      ja: '過ちを祝福に変える魔法',
      fr: 'Transformer les erreurs en bénédictions',
      zh: '将错误化为祝福',
    ),
    27: (
      vi: 'Tấm gương nhiệm màu',
      en: 'The Magic Mirror',
      ko: '마법의 거울',
      ja: '魔法の鏡',
      fr: 'Le miroir magique',
      zh: '魔法镜子',
    ),
    28: (
      vi: 'Nhớ lại phép màu',
      en: 'Remember the Magic',
      ko: '마법을 기억하기',
      ja: '魔法を思い出す',
      fr: 'Se souvenir de la magie',
      zh: '铭记奇迹',
    ),
  };

  static String getTitle(int day, SoulLocale locale) {
    final entry = _themes[day];
    if (entry != null) {
      return switch (locale) {
        SoulLocale.vi => entry.vi,
        SoulLocale.en => entry.en,
        SoulLocale.ko => entry.ko,
        SoulLocale.ja => entry.ja,
        SoulLocale.fr => entry.fr,
        SoulLocale.zh => entry.zh,
      };
    }
    return switch (locale) {
      SoulLocale.vi => 'Ngày $day: Thực hành biết ơn',
      SoulLocale.en => 'Day $day: Gratitude Practice',
      SoulLocale.ko => '$day일차: 감사 실천',
      SoulLocale.ja => '$day日目：感謝の実践',
      SoulLocale.fr => 'Jour $day : Pratique de la gratitude',
      SoulLocale.zh => '第 $day 天：感恩练习',
    };
  }
}

/// Encodes optional photo and voice recording paths into `reasonText`.
String? encodeJournalAttachments({String? imagePath, String? audioPath}) {
  final parts = <String>[
    if (imagePath != null && imagePath.trim().isNotEmpty)
      'image:${imagePath.trim()}',
    if (audioPath != null && audioPath.trim().isNotEmpty)
      'audio:${audioPath.trim()}',
  ];
  return parts.isEmpty ? null : parts.join('|');
}

/// Parses `reasonText` into `(imagePath, audioPath, plainReason)`.
({String? imagePath, String? audioPath, String? plainReason})
parseJournalAttachments(String? reasonText) {
  if (reasonText == null || reasonText.trim().isEmpty) {
    return (imagePath: null, audioPath: null, plainReason: null);
  }
  final raw = reasonText.trim();
  if (!raw.startsWith('image:') && !raw.startsWith('audio:')) {
    return (imagePath: null, audioPath: null, plainReason: raw);
  }
  String? imagePath;
  String? audioPath;
  for (final token in raw.split('|')) {
    final part = token.trim();
    if (part.startsWith('image:')) {
      final val = part.substring('image:'.length).trim();
      if (val.isNotEmpty) imagePath = val;
    } else if (part.startsWith('audio:')) {
      final val = part.substring('audio:'.length).trim();
      if (val.isNotEmpty) audioPath = val;
    }
  }
  return (imagePath: imagePath, audioPath: audioPath, plainReason: null);
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
    this.imagePath,
    this.audioPath,
  });

  final String id;
  final String title;
  final int? journeyDay;
  final DateTime createdAt;
  final List<String> sentences;
  final List<GratitudeEntryRow> rawEntries;
  final String? imagePath;
  final String? audioPath;
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
        title = switch (locale) {
          SoulLocale.vi => 'Khoảnh khắc biết ơn',
          SoulLocale.en => 'Grateful Moment',
          SoulLocale.ko => '감사의 순간',
          SoulLocale.ja => '感謝の瞬間',
          SoulLocale.fr => 'Moment de gratitude',
          SoulLocale.zh => '感恩时刻',
        };
      }
    }

    String? foundImagePath;
    String? foundAudioPath;
    final sentences = <String>[];
    for (final entry in groupEntries) {
      String cleanText = entry.gratitudeText;
      if (first.journeyDay == null &&
          cleanText.startsWith('[') &&
          cleanText.contains(']')) {
        final closing = cleanText.indexOf(']');
        cleanText = cleanText.substring(closing + 1).trim();
      }

      final parsed = parseJournalAttachments(entry.reasonText);
      foundImagePath ??= parsed.imagePath;
      foundAudioPath ??= parsed.audioPath;
      final reason = parsed.plainReason;

      // If the text looks like multi-line journal freeform paragraphs, add each line/paragraph
      if (cleanText.contains('\n')) {
        final lines = cleanText
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty);
        for (final line in lines) {
          sentences.add(line);
        }
      } else {
        if (reason != null && reason.isNotEmpty) {
          sentences.add('$cleanText ($reason)');
        } else {
          sentences.add(cleanText);
        }
      }
    }

    notes.add(
      JournalNote(
        id: first.id,
        title: title,
        journeyDay: first.journeyDay,
        createdAt: first.createdAt,
        sentences: sentences,
        rawEntries: groupEntries,
        imagePath: foundImagePath,
        audioPath: foundAudioPath,
      ),
    );
  }

  notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return notes;
}
