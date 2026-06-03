import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Fetches CMS content from the Vercel admin backend and caches it.
///
/// Polling: call [startPolling] once after the initial [load]. Every
/// [pollInterval] a fresh fetch is attempted; on a successful response that
/// differs from the current cache [contentVersion] is incremented so that any
/// [ValueListenableBuilder] subscribed to it rebuilds automatically.
///
/// Screens that need live CMS updates should either:
///   • wrap their build with ValueListenableBuilder on contentVersion
///   • or call `ContentService.instance.contentVersion.addListener(_onCmsUpdate)`
///     in initState and removeListener in dispose, then call setState.
class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  static const _baseUrl = 'https://tpog-ai.vercel.app/api/content';

  /// Default poll cadence. 10 s keeps demo changes visible almost instantly.
  static const Duration pollInterval = Duration(seconds: 10);

  // scope → key → value
  final Map<String, Map<String, String>> _cache = {};
  bool _loaded = false;
  Timer? _pollTimer;

  /// Notifier incremented each time a poll succeeds and the cache changes.
  /// Subscribe via [ValueListenableBuilder] or [addListener] to auto-rebuild.
  final ValueNotifier<int> contentVersion = ValueNotifier<int>(0);

  // ── public API ────────────────────────────────────────────────────────────

  /// Fetches content once. Called at startup by [main].
  Future<void> load() async {
    final changed = await _fetch();
    if (changed) _loaded = true;
  }

  /// Starts a repeating poll. Call once from [main] after [load] returns.
  /// Safe to call multiple times — subsequent calls are no-ops.
  void startPolling({Duration interval = pollInterval}) {
    if (_pollTimer != null) return;
    _pollTimer = Timer.periodic(interval, (_) => _poll());
  }

  /// Cancels the polling timer. Call in tests or when the app backgrounds.
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Returns the CMS value for [scope]/[key], or [fallback] when not loaded.
  String get(String scope, String key, {String fallback = ''}) {
    if (!_loaded) return fallback;
    return _cache[scope]?[key] ?? fallback;
  }

  bool get isLoaded => _loaded;

  // ── internals ─────────────────────────────────────────────────────────────

  /// Performs a single fetch. Returns true if the cache was updated.
  Future<bool> _fetch() async {
    try {
      final uri = Uri.parse(_baseUrl);
      final res = await http.get(uri).timeout(const Duration(seconds: 6));
      if (res.statusCode != 200) return false;

      final List<dynamic> rows = jsonDecode(res.body) as List<dynamic>;

      // Build a fresh map and compare with the existing cache to detect changes.
      final Map<String, Map<String, String>> fresh = {};
      for (final row in rows) {
        final scope = row['scope'] as String;
        final key = row['key'] as String;
        final value = row['value'] as String;
        (fresh[scope] ??= {})[key] = value;
      }

      if (_mapsEqual(_cache, fresh)) return false;

      // Update in-place so existing [get] calls during the rebuild still work.
      _cache
        ..clear()
        ..addAll(fresh);
      return true;
    } catch (_) {
      // Offline or server error — keep the last good cache, stay silent.
      return false;
    }
  }

  Future<void> _poll() async {
    final changed = await _fetch();
    if (changed) {
      contentVersion.value += 1;
    }
  }

  /// Shallow structural equality check for the two-level scope→key→value maps.
  static bool _mapsEqual(
    Map<String, Map<String, String>> a,
    Map<String, Map<String, String>> b,
  ) {
    if (a.length != b.length) return false;
    for (final scope in a.keys) {
      final aInner = a[scope]!;
      final bInner = b[scope];
      if (bInner == null) return false;
      if (aInner.length != bInner.length) return false;
      for (final key in aInner.keys) {
        if (aInner[key] != bInner[key]) return false;
      }
    }
    return true;
  }
}
