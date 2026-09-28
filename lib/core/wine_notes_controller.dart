import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_controller.dart';

const _notesKey = 'wine_notes_v1';

/// Личная заметка о вине: оценка, впечатления, где купил или пробовал.
class WineNote {
  /// 1–5 звёзд; null — без оценки.
  final int? rating;
  final String text;
  final String place;
  final DateTime updatedAt;

  const WineNote({
    this.rating,
    this.text = '',
    this.place = '',
    required this.updatedAt,
  });

  bool get isEmpty =>
      rating == null && text.trim().isEmpty && place.trim().isEmpty;

  factory WineNote.fromJson(Map<String, dynamic> json) => WineNote(
    rating: (json['rating'] as num?)?.toInt(),
    text: json['text'] as String? ?? '',
    place: json['place'] as String? ?? '',
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'text': text,
    'place': place,
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Заметки по id вина. Хранятся только на телефоне.
final ValueNotifier<Map<String, WineNote>> wineNotes =
    ValueNotifier<Map<String, WineNote>>({});

/// Загружает заметки (вызывается при старте приложения).
Future<void> loadWineNotes() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_notesKey);
  if (raw == null) {
    wineNotes.value = {};
    return;
  }
  try {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    wineNotes.value = json.map(
      (id, note) =>
          MapEntry(id, WineNote.fromJson(note as Map<String, dynamic>)),
    );
  } catch (e) {
    debugPrint('Заметки повреждены, начинаем с чистого листа: $e');
    wineNotes.value = {};
  }
}

/// Сохраняет заметку; пустая заметка удаляется.
/// Раз вино попробовали — кладём его в подвал.
Future<void> saveWineNote(String wineId, WineNote note) async {
  if (note.isEmpty) return deleteWineNote(wineId);
  wineNotes.value = {...wineNotes.value, wineId: note};
  await _persist();
  await addFavorite(wineId);
}

Future<void> deleteWineNote(String wineId) async {
  if (!wineNotes.value.containsKey(wineId)) return;
  wineNotes.value = {...wineNotes.value}..remove(wineId);
  await _persist();
}

Future<void> _persist() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    _notesKey,
    jsonEncode(wineNotes.value.map((id, n) => MapEntry(id, n.toJson()))),
  );
}
