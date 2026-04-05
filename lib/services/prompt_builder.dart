/// Builds compact or expanded AI prompts from a parsed DSL map.
class PromptBuilder {
  // ── Compression map ───────────────────────────────────────────────────────

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
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return [v];
    return [];
  }

  // ── Compact mode ──────────────────────────────────────────────────────────

  /// Structured, high-signal prompt — ordered for maximum AI comprehension.
  String buildCompact(Map<String, dynamic> data) {
    if (data.isEmpty) return '';

    final buf = StringBuffer();

    // ── Identity block ────────────────────────────────────────────────────
    final create = _str(data['create']);
    if (create.isNotEmpty) {
      buf.writeln('TASK: build ${_applyCompression(create)}');
    }

    final type = _str(data['type']);
    if (type.isNotEmpty) buf.writeln('TYPE: $type');

    // Description comes immediately after TASK/TYPE so the AI knows the purpose
    final description = _str(data['description']);
    if (description.isNotEmpty) buf.writeln('PURPOSE: $description');

    // ── Tech stack block ──────────────────────────────────────────────────
    final techKeys = ['stack', 'framework', 'language', 'database', 'auth',
                      'protocol', 'architecture', 'platform', 'testing'];
    bool hasTech = false;
    for (final k in techKeys) {
      final v = data[k];
      if (v == null) continue;
      final s = v is List
          ? _list(v).map(_applyCompression).join(', ')
          : _applyCompression(_str(v));
      if (s.isNotEmpty) {
        buf.writeln('${k.toUpperCase()}: $s');
        hasTech = true;
      }
    }
    if (hasTech) buf.writeln();

    // ── Features block ────────────────────────────────────────────────────
    final features = _list(data['features']);
    if (features.isNotEmpty) {
      buf.writeln('FEATURES:');
      for (final item in _compressList(features)) {
        buf.writeln('- $item');
      }
      buf.writeln();
    }

    // ── Requirements block — inferred from description + features ─────────
    final reqs = _inferRequirements(data);
    if (reqs.isNotEmpty) {
      buf.writeln('REQUIREMENTS:');
      for (final r in reqs) {
        buf.writeln('- $r');
      }
      buf.writeln();
    }

    // ── Style / constraints / output ──────────────────────────────────────
    final styleRaw = data['style'];
    final style = styleRaw is List ? _list(styleRaw).join(', ') : _str(styleRaw);
    if (style.isNotEmpty) buf.writeln('STYLE: $style');

    final constraints = _str(data['constraints']);
    if (constraints.isNotEmpty) buf.writeln('CONSTRAINTS: $constraints');

    // Content-mode specific keys
    for (final k in ['topic', 'tone', 'audience', 'length', 'sections',
                     'keywords', 'role', 'task', 'context', 'rules',
                     'persona', 'avoid', 'trigger', 'steps', 'environment',
                     'runner', 'secrets', 'rollback', 'model', 'data',
                     'metrics', 'training', 'inference']) {
      final v = data[k];
      if (v == null) continue;
      final s = v is List ? _list(v).join(', ') : _str(v);
      if (s.isNotEmpty) buf.writeln('${k.toUpperCase()}: $s');
    }

    final output = _str(data['output']);
    if (output.isNotEmpty) buf.writeln('\nOUTPUT: $output');

    return buf.toString().trimRight();
  }

  // ── Expanded mode ─────────────────────────────────────────────────────────

  /// Human-readable, narrative prompt with full context for the AI.
  String buildExpanded(Map<String, dynamic> data) {
    if (data.isEmpty) return '';

    final parts = <String>[];

    final create     = _str(data['create']);
    final type       = _str(data['type']);
    final styleRawE  = data['style'];
    final style      = styleRawE is List ? _list(styleRawE).join(', ') : _str(styleRawE);
    final output     = _str(data['output']);
    final desc       = _str(data['description']);
    final features   = _list(data['features']);
    final stack      = _str(data['stack']);
    final framework  = _str(data['framework']);
    final language   = _str(data['language']);
    final database   = _str(data['database']);
    final auth       = _str(data['auth']);
    final platform   = _str(data['platform']);
    final arch       = _str(data['architecture']);
    final protocol   = _str(data['protocol']);
    final testing    = _str(data['testing']);
    final constraints = _str(data['constraints']);

    // ── Opening sentence ──────────────────────────────────────────────────
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

    // ── Purpose ───────────────────────────────────────────────────────────
    if (desc.isNotEmpty) {
      parts.add('The app should $desc.');
    }

    // ── Tech stack ────────────────────────────────────────────────────────
    final techParts = <String>[];
    if (framework.isNotEmpty) {
      techParts.add(framework);
    } else if (stack.isNotEmpty) {
      techParts.add(stack);
    }
    if (language.isNotEmpty) techParts.add(language);
    if (database.isNotEmpty) techParts.add('$database for the database');
    if (auth.isNotEmpty) techParts.add('$auth for authentication');
    if (protocol.isNotEmpty) techParts.add(protocol);
    if (platform.isNotEmpty) techParts.add('deployed on $platform');

    if (techParts.isNotEmpty) {
      parts.add('Use ${techParts.join(', ')}.');
    }

    // ── Architecture ──────────────────────────────────────────────────────
    if (arch.isNotEmpty) {
      parts.add('Follow a $arch architecture.');
    }

    // ── Features ──────────────────────────────────────────────────────────
    if (features.isNotEmpty) {
      final humanFeatures = features.map(_humanize).toList();
      if (humanFeatures.length == 1) {
        parts.add('Include ${humanFeatures.first}.');
      } else {
        final last = humanFeatures.removeLast();
        parts.add('Include ${humanFeatures.join(', ')}, and $last.');
      }
    }

    // ── Inferred requirements ─────────────────────────────────────────────
    final reqs = _inferRequirements(data);
    if (reqs.isNotEmpty) {
      parts.add('Technical requirements: ${reqs.join('; ')}.');
    }

    // ── Testing ───────────────────────────────────────────────────────────
    if (testing.isNotEmpty) {
      parts.add('Include $testing tests.');
    }

    // ── Content mode extra keys ───────────────────────────────────────────
    final contentKeys = {
      'topic': 'Topic', 'tone': 'Tone', 'audience': 'Audience',
      'length': 'Length', 'sections': 'Sections', 'keywords': 'Keywords',
      'role': 'Role', 'task': 'Task', 'context': 'Context',
      'rules': 'Rules', 'persona': 'Persona', 'avoid': 'Avoid',
      'trigger': 'Trigger', 'steps': 'Steps', 'environment': 'Environment',
      'runner': 'Runner', 'secrets': 'Secrets', 'rollback': 'Rollback',
      'model': 'Model', 'data': 'Data', 'metrics': 'Metrics',
      'training': 'Training', 'inference': 'Inference',
    };
    final skipInExpanded = {'create','type','description','style','output',
      'stack','framework','language','database','auth','platform',
      'architecture','protocol','testing','features','constraints'};

    for (final entry in contentKeys.entries) {
      if (skipInExpanded.contains(entry.key)) continue;
      final v = data[entry.key];
      if (v == null) continue;
      final s = v is List ? _list(v).join(', ') : _str(v);
      if (s.isNotEmpty) parts.add('${entry.value}: $s.');
    }

    // ── Constraints ───────────────────────────────────────────────────────
    if (constraints.isNotEmpty) {
      parts.add('Constraints: $constraints.');
    }

    // ── Output instruction ────────────────────────────────────────────────
    if (output.isNotEmpty) {
      parts.add('Provide $output.');
    }

    return parts.join(' ');
  }

  // ── Requirements inference ─────────────────────────────────────────────────

  /// Infers implicit technical requirements from the description + features.
  /// These are things the AI needs to know to build it correctly but that
  /// the user didn't spell out explicitly.
  List<String> _inferRequirements(Map<String, dynamic> data) {
    final reqs = <String>[];
    final desc = _str(data['description']).toLowerCase();
    final type = _str(data['type']).toLowerCase();
    final feats = _list(data['features']).map((f) => f.toLowerCase()).toList();
    final lang  = _str(data['language']).toLowerCase();
    final fw    = _str(data['framework']).toLowerCase();
    final stack = _str(data['stack']).toLowerCase();

    bool hasFeature(String needle) =>
        feats.any((f) => f.contains(needle)) || desc.contains(needle);

    // ── File / download domain
    if (hasFeature('torrent') || desc.contains('torrent')) {
      reqs.add('parse .torrent files and magnet URIs');
      reqs.add('HTTP client for download stream handling');
      reqs.add('background download service');
      reqs.add('storage read/write permissions');
      if (desc.contains('direct') || hasFeature('direct download')) {
        reqs.add('resolve magnet/torrent to direct HTTP URLs via debrid or tracker');
      }
    }
    if (hasFeature('video downloader') || hasFeature('youtube')) {
      reqs.add('yt-dlp or equivalent video extraction library');
      reqs.add('format/quality selection UI');
      reqs.add('background download with progress tracking');
    }
    if (hasFeature('file format conversion') || hasFeature('pdf conversion')) {
      reqs.add('file format conversion library (e.g. LibreOffice, pandoc, FFmpeg)');
      reqs.add('input/output format selection');
      reqs.add('async processing for large files');
    }
    if (hasFeature('image processing')) {
      reqs.add('image processing library (e.g. sharp, Pillow, ImageMagick)');
      reqs.add('batch processing support');
    }
    if (hasFeature('download queue')) {
      reqs.add('persistent download queue with resume support');
      reqs.add('transfer speed display');
    }

    // ── Authentication / user management
    if (hasFeature('authentication') || hasFeature('auth')) {
      reqs.add('secure password hashing (bcrypt/argon2)');
      reqs.add('session/token management with refresh');
      if (hasFeature('two-factor') || desc.contains('2fa')) {
        reqs.add('TOTP/HOTP for 2FA (e.g. speakeasy, otplib)');
      }
    }
    if (hasFeature('role-based access') || hasFeature('rbac')) {
      reqs.add('middleware-level permission enforcement');
    }

    // ── Payments
    if (hasFeature('payments') || desc.contains('payment') || desc.contains('billing')) {
      reqs.add('Stripe SDK (or chosen payment gateway) with webhook verification');
      reqs.add('PCI-compliant card handling — never store raw card data');
    }
    if (hasFeature('subscription') || desc.contains('subscription')) {
      reqs.add('subscription lifecycle: trial, active, past_due, cancelled');
    }

    // ── Real-time
    if (hasFeature('real-time') || hasFeature('chat') || hasFeature('websocket')) {
      reqs.add('WebSocket or SSE for real-time data push');
      reqs.add('connection reconnection and heartbeat logic');
    }

    // ── Notifications
    if (hasFeature('push notification')) {
      if (type == 'mobile') {
        reqs.add('FCM (Android) / APNs (iOS) push notification setup');
      } else {
        reqs.add('Web Push API with service worker');
      }
    }

    // ── Maps / location
    if (hasFeature('maps') || desc.contains('location') || desc.contains('geolocation')) {
      reqs.add('GPS/location permission handling');
      reqs.add('map tile provider (Google Maps / Mapbox / OpenStreetMap)');
    }

    // ── Search
    if (hasFeature('search') || hasFeature('full-text')) {
      reqs.add('full-text search index (Elasticsearch, Meilisearch, or DB FTS)');
    }

    // ── File storage / uploads
    if (hasFeature('file uploads') || hasFeature('cloud file storage')) {
      reqs.add('multipart upload with size/type validation');
      reqs.add('object storage (S3/GCS/Cloudflare R2) or local storage with CDN');
    }

    // ── Offline / sync
    if (hasFeature('offline support') || hasFeature('cross-device sync')) {
      reqs.add('local-first storage with sync-on-reconnect');
      reqs.add('conflict resolution strategy for concurrent edits');
    }

    // ── Mobile-specific
    if (type == 'mobile') {
      if (!reqs.any((r) => r.contains('permission'))) {
        // Only add if specific permissions were needed above
      }
      if (hasFeature('biometric') || desc.contains('biometric') || desc.contains('fingerprint')) {
        reqs.add('biometric authentication (Face ID / fingerprint)');
      }
      if (desc.contains('android') && desc.contains('ios') ||
          (fw.contains('flutter') || fw.contains('react native') || stack.contains('flutter'))) {
        reqs.add('cross-platform build (Android + iOS)');
      } else if (desc.contains('android') || lang.contains('kotlin') || lang.contains('java')) {
        reqs.add('Android (Kotlin + Jetpack Compose recommended)');
      } else if (desc.contains('ios') || lang.contains('swift')) {
        reqs.add('iOS (Swift + SwiftUI recommended)');
      }
    }

    // ── API / backend
    if (type == 'api') {
      reqs.add('input validation on all endpoints');
      reqs.add('structured error responses (RFC 7807 or similar)');
      if (!hasFeature('rate limiting')) reqs.add('rate limiting per IP/user');
    }

    // ── E-commerce
    if (hasFeature('shopping cart') || hasFeature('checkout') || hasFeature('product catalog')) {
      reqs.add('cart state persistence (guest + logged-in merge)');
      reqs.add('inventory stock check at checkout');
      reqs.add('order state machine: pending → paid → fulfilled → shipped');
    }

    // ── Analytics / reporting
    if (hasFeature('analytics') || hasFeature('data visualization')) {
      reqs.add('time-series data aggregation queries');
      reqs.add('exportable reports (CSV / PDF)');
    }

    // ── Security (universal)
    if (!reqs.any((r) => r.contains('HTTPS') || r.contains('SSL'))) {
      if (type == 'api' || type == 'web') {
        reqs.add('HTTPS enforced; CORS configured for allowed origins only');
      }
    }

    // ── Caching
    if (hasFeature('caching') || hasFeature('performance')) {
      reqs.add('Redis or in-memory cache with TTL strategy');
    }

    // ── Background jobs
    if (hasFeature('background jobs') || desc.contains('scheduled') || desc.contains('cron')) {
      reqs.add('job queue (BullMQ / Sidekiq / Celery) with retry and dead-letter handling');
    }

    return reqs;
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

}
