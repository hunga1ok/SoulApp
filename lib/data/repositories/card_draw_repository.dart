import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/app_state.dart';

class CardDrawEntry {
  const CardDrawEntry({
    required this.id,
    required this.deckId,
    required this.cardId,
    required this.drawnAt,
    this.isFavorite = false,
  });

  final String id;
  final String deckId;
  final String cardId;
  final DateTime drawnAt;
  final bool isFavorite;

  CardDrawEntry copyWith({
    String? id,
    String? deckId,
    String? cardId,
    DateTime? drawnAt,
    bool? isFavorite,
  }) {
    return CardDrawEntry(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      cardId: cardId ?? this.cardId,
      drawnAt: drawnAt ?? this.drawnAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'deckId': deckId,
    'cardId': cardId,
    'drawnAt': drawnAt.toIso8601String(),
    'isFavorite': isFavorite,
  };

  factory CardDrawEntry.fromJson(Map<String, dynamic> json) => CardDrawEntry(
    id: json['id'] as String,
    deckId: json['deckId'] as String,
    cardId: json['cardId'] as String,
    drawnAt: DateTime.parse(json['drawnAt'] as String),
    isFavorite: (json['isFavorite'] as bool?) ?? false,
  );
}

class CardDrawState {
  const CardDrawState({
    required this.entries,
    required this.todayEntries,
    required this.remainingDraws,
  });

  final List<CardDrawEntry> entries;
  final List<CardDrawEntry> todayEntries;
  final int remainingDraws;

  bool get canDraw => remainingDraws > 0;
  static const int maxDailyDraws = 2;
}

class CardDrawNotifier extends StateNotifier<CardDrawState> {
  CardDrawNotifier(this._preferences)
    : super(
        const CardDrawState(
          entries: [],
          todayEntries: [],
          remainingDraws: CardDrawState.maxDailyDraws,
        ),
      ) {
    _load();
  }

  static const _storageKey = 'soul_card_draw_history';
  final SharedPreferences _preferences;

  void _load() {
    final raw = _preferences.getStringList(_storageKey) ?? [];
    final entries = <CardDrawEntry>[];
    for (final item in raw) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        entries.add(CardDrawEntry.fromJson(decoded));
      } catch (_) {}
    }

    entries.sort((a, b) => b.drawnAt.compareTo(a.drawnAt));
    final now = DateTime.now();
    final today =
        entries.where((e) {
          return e.drawnAt.year == now.year &&
              e.drawnAt.month == now.month &&
              e.drawnAt.day == now.day;
        }).toList();

    final remaining = (CardDrawState.maxDailyDraws - today.length).clamp(
      0,
      CardDrawState.maxDailyDraws,
    );

    state = CardDrawState(
      entries: List.unmodifiable(entries),
      todayEntries: List.unmodifiable(today),
      remainingDraws: remaining,
    );
  }

  Future<void> _persist() async {
    final raw = state.entries.map((e) => jsonEncode(e.toJson())).toList();
    await _preferences.setStringList(_storageKey, raw);
  }

  Future<CardDrawEntry?> recordDraw({
    required String deckId,
    required String cardId,
  }) async {
    if (!state.canDraw) return null;

    final entry = CardDrawEntry(
      id:
          'draw_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      deckId: deckId,
      cardId: cardId,
      drawnAt: DateTime.now(),
    );

    final updatedAll = [entry, ...state.entries];
    final updatedToday = [entry, ...state.todayEntries];
    final remaining = (CardDrawState.maxDailyDraws - updatedToday.length).clamp(
      0,
      CardDrawState.maxDailyDraws,
    );

    state = CardDrawState(
      entries: List.unmodifiable(updatedAll),
      todayEntries: List.unmodifiable(updatedToday),
      remainingDraws: remaining,
    );

    await _persist();
    return entry;
  }

  Future<void> toggleFavorite(String entryId) async {
    final updated =
        state.entries.map((e) {
          if (e.id == entryId) {
            return e.copyWith(isFavorite: !e.isFavorite);
          }
          return e;
        }).toList();

    final now = DateTime.now();
    final today =
        updated.where((e) {
          return e.drawnAt.year == now.year &&
              e.drawnAt.month == now.month &&
              e.drawnAt.day == now.day;
        }).toList();

    state = CardDrawState(
      entries: List.unmodifiable(updated),
      todayEntries: List.unmodifiable(today),
      remainingDraws: state.remainingDraws,
    );

    await _persist();
  }
}

final cardDrawProvider = StateNotifierProvider<CardDrawNotifier, CardDrawState>(
  (ref) {
    final prefs = ref.watch(preferencesProvider);
    return CardDrawNotifier(prefs);
  },
);
