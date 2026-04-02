/// Pure-Dart rule-based fallback parser for Plain Talk mode.
/// Zero dependencies — works fully offline.
class PlainTalkParser {
  Map<String, dynamic> parse(String input) {
    final result = <String, dynamic>{};
    final lower = input.toLowerCase();

    // ── Intent / create ───────────────────────────────────────────────────────
    final intentRegex = RegExp(
      r'(?:build|create|make|design|write|develop)\s+(?:a\s+|an\s+|me\s+a\s+|me\s+an\s+)?(.+?)(?:\s+with|\s+that|\s+using|\s+featuring|\.|$)',
      caseSensitive: false,
    );
    final intentMatch = intentRegex.firstMatch(input);
    result['create'] = intentMatch?.group(1)?.trim() ?? 'application';

    // ── Type ──────────────────────────────────────────────────────────────────
    const typeMap = {
      'website': 'web',
      'site': 'web',
      'web app': 'web',
      'web application': 'web',
      'dashboard': 'web',
      'mobile app': 'mobile',
      'mobile application': 'mobile',
      'android': 'mobile',
      'ios': 'mobile',
      'api': 'api',
      'backend': 'api',
      'rest api': 'api',
      'desktop app': 'desktop',
      'desktop application': 'desktop',
      'cli': 'cli',
      'command line': 'cli',
      'script': 'cli',
      'tool': 'cli',
    };
    for (final entry in typeMap.entries) {
      if (lower.contains(entry.key)) {
        result['type'] = entry.value;
        break;
      }
    }

    // ── Features ──────────────────────────────────────────────────────────────
    const featureMap = {
      'selling': 'e-commerce',
      'products': 'e-commerce',
      'shop': 'e-commerce',
      'store': 'e-commerce',
      'cart': 'e-commerce',
      'login': 'auth',
      'auth': 'auth',
      'signin': 'auth',
      'sign in': 'auth',
      'register': 'auth',
      'signup': 'auth',
      'admin': 'admin panel',
      'search': 'search',
      'payment': 'payments',
      'checkout': 'payments',
      'stripe': 'payments',
      'chat': 'messaging',
      'message': 'messaging',
      'notification': 'notifications',
      'profile': 'user profiles',
      'account': 'user profiles',
      'map': 'maps',
      'location': 'maps',
      'analytics': 'analytics',
      'stats': 'analytics',
      'dashboard': 'dashboard',
      'upload': 'file upload',
      'file': 'file upload',
    };
    final foundFeatures = <String>{};
    for (final entry in featureMap.entries) {
      if (lower.contains(entry.key)) {
        foundFeatures.add(entry.value);
      }
    }
    if (foundFeatures.isNotEmpty) {
      result['features'] = foundFeatures.toList();
    }

    // ── Style ─────────────────────────────────────────────────────────────────
    const styleKeywords = [
      'modern', 'minimal', 'minimalist', 'clean', 'dark', 'light',
      'responsive', 'flat', 'material', 'retro', 'corporate', 'elegant',
    ];
    final foundStyles = styleKeywords.where((s) => lower.contains(s)).toList();
    if (foundStyles.isNotEmpty) {
      result['style'] = foundStyles.join(' ');
    }

    return result;
  }
}
