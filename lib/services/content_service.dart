import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fetches CMS content from the Vercel admin backend and caches it for the
/// lifetime of the app. Screens call [get] with a scope + key; if the backend
/// is unreachable the fallback string is returned so the app stays usable.
class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  static const _baseUrl = 'https://tpog-ai.vercel.app/api/content';

  // scope → key → value
  final Map<String, Map<String, String>> _cache = {};
  bool _loaded = false;

  /// Call once at app startup. Silently swallows errors so the app still
  /// launches when offline.
  Future<void> load() async {
    try {
      final uri = Uri.parse(_baseUrl);
      final res = await http.get(uri).timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return;
      final List<dynamic> rows = jsonDecode(res.body) as List<dynamic>;
      for (final row in rows) {
        final scope = row['scope'] as String;
        final key = row['key'] as String;
        final value = row['value'] as String;
        (_cache[scope] ??= {})[key] = value;
      }
      _loaded = true;
    } catch (_) {
      // offline or server error — screens will use their fallback strings
    }
  }

  /// Returns the CMS value for [scope]/[key], or [fallback] when not loaded.
  String get(String scope, String key, {String fallback = ''}) {
    if (!_loaded) return fallback;
    return _cache[scope]?[key] ?? fallback;
  }

  bool get isLoaded => _loaded;
}
