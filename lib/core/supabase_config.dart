/// Ключи Supabase передаются при запуске, а не хранятся в коде:
///   flutter run --dart-define-from-file=supabase.json
/// Файл supabase.json в .gitignore; шаблон — supabase.example.json.
const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabaseKey = String.fromEnvironment('SUPABASE_KEY');

/// Если ключей нет — приложение работает на тестовых данных.
bool get isSupabaseConfigured =>
    supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
