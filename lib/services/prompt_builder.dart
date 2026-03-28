/// Builds compact or expanded AI prompts from a parsed DSL map.
class PromptBuilder {
  // ── Keyword compression map ───────────────────────────────────────────────

  static const Map<String, String> _compress = {
    'login': 'auth',
    'authentication': 'auth',
    'user authentication': 'auth',
    'user auth': 'auth',
    'user login': 'auth',
    'sign in': 'auth',
    'signin': 'auth',
    'signup': 'registration',
    'sign up': 'registration',
    'admin panel': 'admin',
    'administration': 'admin',
    'administrator': 'admin',
    'database': 'db',
    'notification': 'notif',
    'notifications': 'notifs',
    'user interface': 'ui',
    'application': 'app',
    'repository': 'repo',
    'configuration': 'config',
    'environment': 'env',
    'deployment': 'deploy',
    'documentation': 'docs',
    'performance': 'perf',
    'optimization': 'opt',
    'optimized': 'opt',
    'responsive design': 'responsive',
  };

  String _applyCompression(String value) {
    final lower = value.trim().toLowerCase();
    return _compress[lower] ?? value.trim();
  }

  List<String> _compressList(List<String> items) =>
      items.map(_applyCompression).toList();

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _str(dynamic v) => v is String ? v : '';
  List<String> _list(dynamic v) {
    if (v is List) return v.cast<String>();
    if (v is String) return [v];
    return [];
  }

  // ── Compact mode ─────────────────────────────────────────────────────────

  /// High signal, low-token structured prompt.
  String buildCompact(Map<String, dynamic> data) {
    if (data.isEmpty) return '';

    final buf = StringBuffer();

    // Known key order for compact output
    final known = ['create', 'type', 'features', 'style', 'output'];
    final remaining =
        data.keys.where((k) => !known.contains(k)).toList();

    // TASK line
    if (data.containsKey('create')) {
      buf.writeln('TASK: build ${_applyCompression(_str(data['create']))}');
    }

    // TYPE line
    if (data.containsKey('type')) {
      buf.writeln('TYPE: ${_str(data['type'])}');
    }

    // Any extra non-feature keys before FEATURES
    for (final k in remaining) {
      final v = data[k];
      if (v is String) {
        buf.writeln('${k.toUpperCase()}: ${_applyCompression(v)}');
      }
    }

    // FEATURES block
    if (data.containsKey('features')) {
      buf.writeln();
      buf.writeln('FEATURES:');
      for (final item in _compressList(_list(data['features']))) {
        buf.writeln('- $item');
      }
    }

    // STYLE line
    if (data.containsKey('style')) {
      buf.writeln();
      buf.writeln('STYLE: ${_str(data['style'])}');
    }

    // OUTPUT line
    if (data.containsKey('output')) {
      buf.writeln('OUTPUT: ${_str(data['output'])}');
    }

    return buf.toString().trimRight();
  }

  // ── Expanded mode ─────────────────────────────────────────────────────────

  /// Human-readable natural-language prompt.
  String buildExpanded(Map<String, dynamic> data) {
    if (data.isEmpty) return '';

    final parts = <String>[];

    final create = _str(data['create']);
    final type = _str(data['type']);
    final style = _str(data['style']);
    final output = _str(data['output']);
    final features = _list(data['features']);

    // Opening sentence
    final opening = StringBuffer('Build');
    if (style.isNotEmpty) {
      opening.write(' a $style');
    } else {
      opening.write(' a');
    }
    if (type.isNotEmpty) opening.write(' $type');
    if (create.isNotEmpty) {
      opening.write(' ${create.toLowerCase()}');
    } else {
      opening.write(' application');
    }
    opening.write('.');
    parts.add(opening.toString());

    // Features sentence
    if (features.isNotEmpty) {
      final humanFeatures = features.map(_humanize).toList();
      if (humanFeatures.length == 1) {
        parts.add('Include ${humanFeatures.first}.');
      } else {
        final last = humanFeatures.removeLast();
        parts.add('Include ${humanFeatures.join(', ')}, and $last.');
      }
    }

    // Extra keys
    final known = {'create', 'type', 'features', 'style', 'output'};
    for (final k in data.keys.where((k) => !known.contains(k))) {
      final v = data[k];
      if (v is String && v.isNotEmpty) {
        parts.add('${_titleCase(k)}: $v.');
      } else if (v is List && v.isNotEmpty) {
        parts.add('${_titleCase(k)}: ${(v as List<String>).join(', ')}.');
      }
    }

    // Output instruction
    if (output.isNotEmpty) {
      parts.add('Provide ${output.toLowerCase()}.');
    }

    return parts.join(' ');
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  String _humanize(String s) {
    const map = {
      'auth': 'user authentication',
      'login': 'user authentication',
      'admin': 'admin panel',
      'db': 'database integration',
      'notif': 'notifications',
      'notifs': 'notifications',
    };
    return map[s.toLowerCase()] ?? s.toLowerCase();
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
