import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_state.dart';

class GratitudeNote {
  const GratitudeNote({
    required this.id,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String body;
  final DateTime createdAt;

  Map<String, String> toJson() => {
    'id': id,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
  };

  factory GratitudeNote.fromJson(Map<String, dynamic> json) => GratitudeNote(
    id: json['id'] as String,
    body: json['body'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

final gratitudeNotesProvider =
    AsyncNotifierProvider<GratitudeNotesController, List<GratitudeNote>>(
      GratitudeNotesController.new,
    );

class GratitudeNotesController extends AsyncNotifier<List<GratitudeNote>> {
  static const _key = 'gratitude_notes_v1';

  @override
  Future<List<GratitudeNote>> build() async {
    final raw = ref.read(preferencesProvider).getString(_key);
    if (raw == null) return const [];
    final notes =
        (jsonDecode(raw) as List)
            .cast<Map<String, dynamic>>()
            .map(GratitudeNote.fromJson)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> add(String body) async {
    final text = body.trim();
    if (text.isEmpty) return;
    final notes = [...(state.valueOrNull ?? await future)];
    notes.insert(
      0,
      GratitudeNote(
        id: const Uuid().v4(),
        body: text,
        createdAt: DateTime.now(),
      ),
    );
    state = AsyncData(notes);
    await ref
        .read(preferencesProvider)
        .setString(_key, jsonEncode([for (final note in notes) note.toJson()]));
  }
}
