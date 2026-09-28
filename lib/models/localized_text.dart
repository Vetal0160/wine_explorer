/// Текст на нескольких языках: {'ru': ..., 'ro': ..., 'en': ...}.
typedef LocalizedText = Map<String, String>;

/// Текст на нужном языке; если перевода нет — русский или любой другой.
String localizedFor(LocalizedText text, String languageCode) =>
    text[languageCode] ??
    text['ru'] ??
    (text.isNotEmpty ? text.values.first : '');

/// Разбирает JSON-поле: объект по языкам или просто строку (считаем русской).
LocalizedText parseLocalizedText(Object? raw) {
  if (raw is Map) {
    return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
  }
  if (raw is String && raw.isNotEmpty) return {'ru': raw};
  return {};
}
