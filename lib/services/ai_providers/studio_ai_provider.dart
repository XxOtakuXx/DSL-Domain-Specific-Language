import 'ai_provider.dart';

// ── Public provider ───────────────────────────────────────────────────────────

/// DSL Studio's built-in AI engine.
///
/// Pure Dart — no network, no server, no API key required.
/// Multi-pass NLP pipeline that extracts all DSL keys from natural-language
/// input. Works offline, instant response, no token limits.
class StudioAiProvider implements AiProvider {
  const StudioAiProvider();

  @override
  String get name => 'Studio AI';

  @override
  String get id => 'studio';

  @override
  Future<Map<String, dynamic>> parse(String input) async {
    // Async signature to satisfy the interface; processing is synchronous.
    return const _StudioEngine().analyze(input);
  }
}

// ── Engine ────────────────────────────────────────────────────────────────────

class _StudioEngine {
  const _StudioEngine();

  Map<String, dynamic> analyze(String input) {
    if (input.trim().isEmpty) return {};

    final ctx = _Context(input);

    // ── Pass 1: detect content domain ────────────────────────────────────────
    ctx.mode = _detectMode(ctx);

    // ── Pass 2: extract universal keys ───────────────────────────────────────
    _extractCreate(ctx);
    _extractType(ctx);

    // ── Pass 3: domain-specific extraction ───────────────────────────────────
    switch (ctx.mode) {
      case _Mode.app:
        _extractDescription(ctx);
        _extractStack(ctx);
        _extractFramework(ctx);
        _extractLanguage(ctx);
        _extractDatabase(ctx);
        _extractAuth(ctx);
        _extractPlatform(ctx);
        _extractArchitecture(ctx);
        _extractProtocol(ctx);
        _extractTesting(ctx);
        _extractFeatures(ctx);
        _extractStyle(ctx);
      case _Mode.content:
        _extractTopic(ctx);
        _extractTone(ctx);
        _extractAudience(ctx);
        _extractLength(ctx);
        _extractSections(ctx);
        _extractKeywords(ctx);
      case _Mode.aiPrompt:
        _extractRole(ctx);
        _extractTask(ctx);
        _extractContext(ctx);
        _extractRules(ctx);
        _extractPersona(ctx);
        _extractAvoid(ctx);
      case _Mode.devops:
        _extractTrigger(ctx);
        _extractSteps(ctx);
        _extractEnvironment(ctx);
        _extractRunner(ctx);
        _extractSecrets(ctx);
        _extractRollback(ctx);
      case _Mode.dataML:
        _extractModel(ctx);
        _extractData(ctx);
        _extractMetrics(ctx);
        _extractTraining(ctx);
        _extractInference(ctx);
        _extractFeatures(ctx);
    }

    // ── Pass 4: universal extras ──────────────────────────────────────────────
    _extractConstraints(ctx);
    _extractOutput(ctx);

    return ctx.result;
  }

  // ── Mode detection ────────────────────────────────────────────────────────

  _Mode _detectMode(_Context ctx) {
    final t = ctx.lower;

    // Content / writing
    if (_anyOf(t, [
      'blog post', 'blog article', 'article', 'write a post', 'email',
      'newsletter', 'press release', 'landing page copy', 'social media post',
      'tweet', 'linkedin post', 'documentation', 'readme', 'technical doc',
      'how-to guide', 'tutorial', 'essay', 'report', 'white paper',
      'whitepaper', 'case study', 'product description', 'cover letter',
      'resume', 'bio', 'marketing copy',
    ])) {
      return _Mode.content;
    }

    // AI / system prompt
    if (_anyOf(t, [
      'system prompt', 'ai agent', 'chatbot', 'ai persona', 'llm prompt',
      'gpt prompt', 'assistant persona', 'instruct model', 'prompt for',
      'act as', 'you are a', 'role of', 'behave as',
    ])) {
      return _Mode.aiPrompt;
    }

    // DevOps / infrastructure
    if (_anyOf(t, [
      'ci/cd', 'ci cd', 'pipeline', 'github action', 'gitlab ci',
      'docker', 'kubernetes', 'k8s', 'terraform', 'ansible', 'deploy',
      'deployment workflow', 'cd workflow', 'devops', 'infrastructure',
      'helm chart', 'compose file', 'build pipeline', 'release workflow',
    ])) {
      return _Mode.devops;
    }

    // Data / ML
    if (_anyOf(t, [
      'machine learning', 'ml model', 'neural network', 'deep learning',
      'classifier', 'classification', 'regression model', 'clustering',
      'train a model', 'dataset', 'data pipeline', 'feature engineering',
      'model training', 'fine-tune', 'fine tuning', 'llm fine', 'pytorch',
      'tensorflow', 'scikit', 'xgboost', 'random forest', 'embedding',
      'semantic search', 'rag pipeline', 'vector database',
    ])) {
      return _Mode.dataML;
    }

    return _Mode.app;
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  void _extractCreate(_Context ctx) {
    // Try full intent pattern first — stop at functional clause starters
    final patterns = [
      RegExp(
        r'(?:build|create|make|design|develop|write|generate|scaffold)\s+'
        r'(?:me\s+)?(?:a\s+|an\s+|the\s+)?(.+?)'
        r'(?:\s+(?:using|with|that|which|for|in|on|featuring)\b'
        r'|\s+to\s+(?!\w+\s+(?:app|tool|service|site|website))'  // "to X" only if X isn't another app noun
        r'|[.,]|$)',
        caseSensitive: false,
      ),
      RegExp(
        r"(?:i\s+(?:want|need|'d\s+like)\s+(?:to\s+(?:build|create|make)?\s+)?(?:a\s+|an\s+)?)"
        r'(.+?)'
        r'(?:\s+(?:using|with|that|which|for|to)\b|[.,]|$)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:help\s+me\s+(?:build|create|make|design|write)\s+(?:a\s+|an\s+)?)'
        r'(.+?)'
        r'(?:\s+(?:using|with|that|to)\b|[.,]|$)',
        caseSensitive: false,
      ),
    ];

    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        var create = m.group(1)?.trim() ?? '';
        // Strip leading style adjectives
        create = create
            .replaceAll(RegExp(r'^(?:modern\s+|clean\s+|minimal\s+|simple\s+|responsive\s+)+', caseSensitive: false), '')
            .trim();
        // If the captured value is too long it likely contains the description — truncate to the app-noun
        if (create.isNotEmpty) {
          final appNoun = _isolateAppNoun(create);
          if (appNoun.isNotEmpty) {
            ctx.result['create'] = appNoun;
            return;
          }
          if (create.length < 60) {
            ctx.result['create'] = create;
            return;
          }
        }
      }
    }

    // Fallback: use first noun phrase
    ctx.result['create'] = _inferCreate(ctx);
  }

  /// Strips the functional description tail from a captured create string.
  /// e.g. "android app to torrent to direct download generator" → "android app"
  /// e.g. "web app that converts pdf to word" → "web app"
  String _isolateAppNoun(String raw) {
    // Split on "to", "that", "which", "for", "with", "-"
    final stopPattern = RegExp(
      r'\s+(?:to|that|which|for|with|where|allowing|enabling)\s+',
      caseSensitive: false,
    );
    final parts = raw.split(stopPattern);
    if (parts.length > 1) {
      final head = parts.first.trim();
      // Validate the head looks like an app noun (≤ 4 words)
      if (head.split(' ').length <= 4 && head.isNotEmpty) {
        return head;
      }
    }
    return raw.length < 40 ? raw : '';
  }

  String _inferCreate(_Context ctx) {
    final t = ctx.lower;
    if (_anyOf(t, ['api', 'rest api', 'graphql api', 'backend api'])) return 'API';
    if (_anyOf(t, ['dashboard', 'admin panel', 'admin dashboard'])) return 'dashboard';
    if (_anyOf(t, ['mobile app', 'ios app', 'android app', 'flutter app'])) return 'mobile app';
    if (_anyOf(t, ['desktop app', 'desktop application'])) return 'desktop app';
    if (_anyOf(t, ['cli', 'command line tool', 'command-line tool'])) return 'CLI tool';
    if (_anyOf(t, ['website', 'web site', 'landing page'])) return 'website';
    if (_anyOf(t, ['microservice', 'micro service'])) return 'microservice';
    if (_anyOf(t, ['chatbot', 'chat bot', 'bot'])) return 'chatbot';
    if (_anyOf(t, ['blog', 'article', 'post'])) return 'blog post';
    if (_anyOf(t, ['email', 'newsletter'])) return 'email';
    if (_anyOf(t, ['script', 'automation'])) return 'script';
    return 'application';
  }

  // ── DESCRIPTION ───────────────────────────────────────────────────────────

  /// Captures the functional purpose of the app — what it actually does.
  /// e.g. "android app to torrent to direct download generator"
  ///       → description = "converts torrent links to direct download links"
  void _extractDescription(_Context ctx) {
    final t = ctx.lower;

    // 1. Explicit "that/which/to" functional clause
    final functionalPattern = RegExp(
      r'(?:app|tool|website|site|service|system|platform|bot|script|extension|plugin)\s+'
      r'(?:to|that|which|for)\s+(.+?)(?:[.,]|$)',
      caseSensitive: false,
    );
    final fm = functionalPattern.firstMatch(ctx.raw);
    if (fm != null) {
      final desc = fm.group(1)?.trim() ?? '';
      if (desc.isNotEmpty && desc.length < 120) {
        ctx.result['description'] = desc;
        return;
      }
    }

    // 2. "for X purpose" pattern
    final forPattern = RegExp(
      r'(?:build|create|make|develop)\s+(?:a\s+|an\s+)?(?:[\w\s]+?)\s+for\s+(.+?)(?:[.,]|$)',
      caseSensitive: false,
    );
    final form = forPattern.firstMatch(ctx.raw);
    if (form != null) {
      final desc = form.group(1)?.trim() ?? '';
      if (desc.isNotEmpty && desc.length < 120 && !_looksLikeAppNoun(desc)) {
        ctx.result['description'] = desc;
        return;
      }
    }

    // 3. Domain keyword inference — compose a description from known concepts
    final inferred = _inferDescription(t);
    if (inferred.isNotEmpty) {
      ctx.result['description'] = inferred;
    }
  }

  bool _looksLikeAppNoun(String s) {
    return RegExp(r'\b(?:app|website|tool|service|system|platform|dashboard)\b', caseSensitive: false).hasMatch(s);
  }

  String _inferDescription(String t) {
    // File / download tools
    if (_anyOf(t, ['torrent', '.torrent', 'magnet link'])) {
      if (_anyOf(t, ['direct download', 'direct link', 'http download', 'debrid'])) {
        return 'converts torrent/magnet links to direct HTTP download links';
      }
      return 'torrent management and download tool';
    }
    if (_anyOf(t, ['youtube downloader', 'yt downloader', 'video downloader'])) {
      return 'downloads videos from YouTube and other platforms';
    }
    if (_anyOf(t, ['pdf to', 'convert pdf'])) {
      return 'converts PDF files to other formats';
    }
    if (_anyOf(t, ['image compress', 'image resize', 'image convert', 'image optimizer'])) {
      return 'compresses, resizes, and converts images';
    }
    if (_anyOf(t, ['url shortener', 'link shortener', 'short url'])) {
      return 'shortens long URLs and tracks click analytics';
    }
    if (_anyOf(t, ['qr code', 'qr generator'])) {
      return 'generates and scans QR codes';
    }
    if (_anyOf(t, ['barcode', 'barcode scanner'])) {
      return 'generates and scans barcodes';
    }
    if (_anyOf(t, ['file converter', 'format converter', 'convert files'])) {
      return 'converts files between formats';
    }
    if (_anyOf(t, ['file manager', 'file explorer', 'file browser'])) {
      return 'browse, organize, and manage files';
    }
    if (_anyOf(t, ['cloud storage', 'file storage', 'file hosting'])) {
      return 'upload, store, and share files in the cloud';
    }

    // Productivity tools
    if (_anyOf(t, ['todo', 'to-do', 'task manager', 'task list', 'task tracker'])) {
      return 'manage tasks and track productivity';
    }
    if (_anyOf(t, ['note', 'note-taking', 'notes app', 'notebook'])) {
      return 'create, organize, and sync notes';
    }
    if (_anyOf(t, ['calendar', 'event', 'scheduling', 'scheduler', 'booking'])) {
      return 'schedule events, manage calendar, and handle bookings';
    }
    if (_anyOf(t, ['habit tracker', 'habit', 'daily tracker'])) {
      return 'track daily habits and streaks';
    }
    if (_anyOf(t, ['expense tracker', 'budget', 'finance tracker', 'money tracker'])) {
      return 'track expenses and manage personal budget';
    }
    if (_anyOf(t, ['invoice', 'billing', 'invoicing'])) {
      return 'create and manage invoices and billing';
    }
    if (_anyOf(t, ['password manager', 'credential manager'])) {
      return 'securely store and manage passwords';
    }
    if (_anyOf(t, ['time tracker', 'time tracking', 'pomodoro', 'work timer'])) {
      return 'track time spent on tasks and projects';
    }

    // Social / communication
    if (_anyOf(t, ['social media', 'social network', 'social platform'])) {
      return 'connect users through posts, follows, and interactions';
    }
    if (_anyOf(t, ['forum', 'community board', 'discussion board'])) {
      return 'community discussion forum with threads and replies';
    }
    if (_anyOf(t, ['job board', 'job listing', 'job portal', 'job finder'])) {
      return 'list and search job opportunities';
    }
    if (_anyOf(t, ['recipe', 'cooking app', 'food app', 'meal planner'])) {
      return 'discover, save, and plan recipes and meals';
    }
    if (_anyOf(t, ['fitness', 'workout', 'gym tracker', 'exercise'])) {
      return 'track workouts and monitor fitness progress';
    }
    if (_anyOf(t, ['travel', 'trip planner', 'itinerary'])) {
      return 'plan trips and manage travel itineraries';
    }
    if (_anyOf(t, ['news', 'news reader', 'news aggregator', 'rss'])) {
      return 'aggregate and display news from multiple sources';
    }
    if (_anyOf(t, ['weather', 'weather app', 'forecast'])) {
      return 'display weather forecasts and conditions';
    }
    if (_anyOf(t, ['crypto', 'cryptocurrency', 'crypto tracker', 'bitcoin'])) {
      return 'track cryptocurrency prices and portfolio';
    }
    if (_anyOf(t, ['stock', 'stock tracker', 'portfolio tracker', 'trading'])) {
      return 'track stocks, portfolio performance, and market data';
    }
    if (_anyOf(t, ['music player', 'audio player', 'playlist'])) {
      return 'play music, manage playlists, and browse library';
    }
    if (_anyOf(t, ['podcast', 'podcast player', 'podcast app'])) {
      return 'discover, subscribe, and listen to podcasts';
    }

    // Dev tools
    if (_anyOf(t, ['code editor', 'ide', 'code playground'])) {
      return 'write, run, and share code in the browser';
    }
    if (_anyOf(t, ['api tester', 'api client', 'http client', 'postman clone'])) {
      return 'test and debug HTTP API requests';
    }
    if (_anyOf(t, ['regex tester', 'regex playground'])) {
      return 'test and visualize regular expressions';
    }
    if (_anyOf(t, ['color picker', 'color palette', 'palette generator'])) {
      return 'pick colors and generate palettes';
    }
    if (_anyOf(t, ['diagram', 'flowchart', 'uml', 'wireframe'])) {
      return 'create diagrams, flowcharts, and wireframes';
    }

    // E-learning
    if (_anyOf(t, ['quiz', 'flashcard', 'flash card', 'study app', 'learning app'])) {
      return 'study with interactive quizzes and flashcards';
    }
    if (_anyOf(t, ['lms', 'course platform', 'online course', 'e-learning'])) {
      return 'deliver and manage online courses';
    }

    return '';
  }

  // ── TYPE ─────────────────────────────────────────────────────────────────

  void _extractType(_Context ctx) {
    final t = ctx.lower;

    const typeMap = {
      // Web
      'web app': 'web', 'web application': 'web', 'webapp': 'web',
      'website': 'web', 'web site': 'web', 'single-page': 'web',
      'spa': 'web', 'full-stack': 'web', 'full stack': 'web',
      'next.js app': 'web', 'react app': 'web', 'vue app': 'web',
      'landing page': 'web', 'dashboard': 'web', 'admin panel': 'web',
      // Mobile
      'mobile app': 'mobile', 'mobile application': 'mobile',
      'ios app': 'mobile', 'android app': 'mobile',
      'flutter app': 'mobile', 'react native': 'mobile',
      'cross-platform app': 'mobile', 'cross platform app': 'mobile',
      // API
      'rest api': 'api', 'restful api': 'api', 'graphql api': 'api',
      'graphql': 'api', 'grpc service': 'api', 'backend api': 'api',
      'api server': 'api', 'api service': 'api', 'web api': 'api',
      'microservice': 'api', 'micro service': 'api',
      // CLI
      'cli': 'cli', 'command line': 'cli', 'command-line': 'cli',
      'terminal app': 'cli', 'shell script': 'cli', 'script': 'cli',
      'automation script': 'cli', 'cli tool': 'cli',
      // Desktop
      'desktop app': 'desktop', 'desktop application': 'desktop',
      'electron app': 'desktop', 'tauri app': 'desktop',
      'flutter desktop': 'desktop', 'native app': 'desktop',
      // Library / package
      'library': 'library', 'package': 'library', 'npm package': 'library',
      'sdk': 'library', 'framework': 'library',
      // Content
      'blog post': 'blog post', 'article': 'article', 'email': 'email',
      'newsletter': 'newsletter', 'report': 'report',
    };

    for (final entry in typeMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['type'] = entry.value;
        return;
      }
    }

    // Fallback inference from mode
    switch (ctx.mode) {
      case _Mode.content: break; // type already from map or leave empty
      case _Mode.aiPrompt: ctx.result['type'] = 'system prompt';
      case _Mode.devops: ctx.result['type'] = 'CI/CD workflow';
      case _Mode.dataML: ctx.result['type'] = 'ML pipeline';
      case _Mode.app:
        if (_anyOf(t, ['backend', 'server', 'service'])) ctx.result['type'] = 'api';
    }
  }

  // ── STACK / FRAMEWORK / LANGUAGE ─────────────────────────────────────────

  // All known tech, organized so we can detect stack members
  static const _frontendTech = [
    'react', 'vue', 'vue.js', 'angular', 'svelte', 'next.js', 'nextjs',
    'nuxt', 'nuxt.js', 'remix', 'gatsby', 'astro', 'solid', 'solidjs',
    'htmx', 'alpine.js', 'alpinejs', 'ember', 'backbone',
  ];

  static const _backendTech = [
    'node.js', 'nodejs', 'express', 'fastify', 'nestjs', 'nest.js',
    'django', 'fastapi', 'flask', 'rails', 'ruby on rails', 'laravel',
    'spring boot', 'springboot', 'spring', 'asp.net', 'dotnet', '.net',
    'go', 'golang', 'fiber', 'gin', 'echo', 'rust', 'actix',
    'elixir', 'phoenix', 'haskell', 'scala', 'play framework',
  ];

  static const _mobileTech = [
    'flutter', 'react native', 'swift', 'swiftui', 'kotlin', 'jetpack compose',
    'xamarin', 'ionic', 'capacitor', 'expo',
  ];

  static const _databases = {
    'postgresql': 'PostgreSQL', 'postgres': 'PostgreSQL', 'psql': 'PostgreSQL',
    'mysql': 'MySQL', 'mariadb': 'MariaDB', 'sqlite': 'SQLite',
    'mongodb': 'MongoDB', 'mongo': 'MongoDB', 'mongoose': 'MongoDB',
    'redis': 'Redis', 'dynamodb': 'DynamoDB', 'firestore': 'Firestore',
    'firebase': 'Firebase', 'supabase': 'Supabase', 'planetscale': 'PlanetScale',
    'cockroachdb': 'CockroachDB', 'cassandra': 'Cassandra', 'elasticsearch': 'Elasticsearch',
    'neo4j': 'Neo4j', 'influxdb': 'InfluxDB', 'clickhouse': 'ClickHouse',
    'neon': 'Neon', 'turso': 'Turso',
  };

  static const _authMethods = {
    'jwt': 'JWT', 'json web token': 'JWT',
    'oauth': 'OAuth2', 'oauth2': 'OAuth2', 'oauth 2': 'OAuth2',
    'google auth': 'Google OAuth', 'github auth': 'GitHub OAuth',
    'session': 'session cookies', 'cookie': 'session cookies',
    'api key': 'API keys', 'api keys': 'API keys',
    'basic auth': 'Basic Auth', 'bearer token': 'Bearer token',
    'clerk': 'Clerk', 'auth0': 'Auth0', 'supabase auth': 'Supabase Auth',
    'firebase auth': 'Firebase Auth', 'nextauth': 'NextAuth',
    'passport': 'Passport.js', 'magic link': 'magic links',
    'passkey': 'Passkeys', 'webauthn': 'WebAuthn',
    'mtls': 'mTLS', 'mutual tls': 'mTLS',
  };

  static const _platforms = {
    'aws': 'AWS', 'amazon web services': 'AWS',
    'ec2': 'AWS EC2', 'ecs': 'AWS ECS', 'lambda': 'AWS Lambda',
    's3': 'AWS S3', 'rds': 'AWS RDS', 'eks': 'AWS EKS',
    'gcp': 'GCP', 'google cloud': 'GCP', 'google cloud platform': 'GCP',
    'cloud run': 'GCP Cloud Run', 'gke': 'GCP GKE',
    'azure': 'Azure', 'microsoft azure': 'Azure',
    'vercel': 'Vercel', 'netlify': 'Netlify', 'railway': 'Railway',
    'render': 'Render', 'fly.io': 'Fly.io', 'heroku': 'Heroku',
    'digitalocean': 'DigitalOcean', 'linode': 'Linode', 'vultr': 'Vultr',
    'kubernetes': 'Kubernetes', 'k8s': 'Kubernetes',
    'docker': 'Docker', 'docker swarm': 'Docker Swarm',
    'cloudflare': 'Cloudflare', 'cloudflare workers': 'Cloudflare Workers',
    'self-hosted': 'self-hosted', 'on-premise': 'on-premise',
  };

  static const _architectures = {
    'microservices': 'microservices', 'microservice': 'microservices',
    'monolith': 'monolith', 'monolithic': 'monolith',
    'serverless': 'serverless',
    'event-driven': 'event-driven', 'event driven': 'event-driven',
    'cqrs': 'CQRS', 'event sourcing': 'event sourcing',
    'hexagonal': 'hexagonal', 'clean architecture': 'clean architecture',
    'ddd': 'DDD', 'domain-driven': 'DDD',
    'layered': 'layered', 'mvc': 'MVC', 'mvvm': 'MVVM',
    'jamstack': 'JAMstack', 'jam stack': 'JAMstack',
    'api gateway': 'API gateway', 'service mesh': 'service mesh',
    'bff': 'BFF', 'backend for frontend': 'BFF',
  };

  void _extractStack(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    // Frontend
    for (final tech in _frontendTech) {
      if (t.contains(tech)) {
        found.add(_canonicalizeTech(tech));
      }
    }
    // Backend
    for (final tech in _backendTech) {
      if (t.contains(tech)) {
        found.add(_canonicalizeTech(tech));
      }
    }
    // Mobile
    for (final tech in _mobileTech) {
      if (t.contains(tech)) {
        found.add(_canonicalizeTech(tech));
      }
    }
    // Databases in stack list
    for (final entry in _databases.entries) {
      if (t.contains(entry.key)) found.add(entry.value);
    }

    // Remove empty, deduplicate preserving order
    final unique = found.where((s) => s.isNotEmpty).toSet().toList();
    if (unique.isNotEmpty) {
      ctx.result['stack'] = unique.join(', ');
    }
  }

  void _extractFramework(_Context ctx) {
    final t = ctx.lower;

    const frameworkMap = {
      'next.js': 'Next.js', 'nextjs': 'Next.js',
      'nuxt': 'Nuxt', 'nuxt.js': 'Nuxt',
      'remix': 'Remix', 'gatsby': 'Gatsby', 'astro': 'Astro',
      'django': 'Django', 'fastapi': 'FastAPI', 'flask': 'Flask',
      'express': 'Express.js', 'fastify': 'Fastify',
      'nestjs': 'NestJS', 'nest.js': 'NestJS',
      'rails': 'Ruby on Rails', 'ruby on rails': 'Ruby on Rails',
      'laravel': 'Laravel', 'spring boot': 'Spring Boot',
      'asp.net': 'ASP.NET', 'dotnet core': '.NET Core',
      'gin': 'Gin', 'fiber': 'Fiber', 'echo': 'Echo',
      'actix': 'Actix', 'axum': 'Axum',
      'phoenix': 'Phoenix', 'svelte': 'SvelteKit',
      'sveltekit': 'SvelteKit', 'solid': 'SolidJS',
      'vue': 'Vue.js', 'angular': 'Angular',
      'react native': 'React Native', 'expo': 'Expo',
      'flutter': 'Flutter', 'swiftui': 'SwiftUI',
      'jetpack compose': 'Jetpack Compose',
      'tauri': 'Tauri', 'electron': 'Electron',
    };

    for (final entry in frameworkMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['framework'] = entry.value;
        return;
      }
    }
  }

  void _extractLanguage(_Context ctx) {
    final t = ctx.lower;

    const langMap = {
      'typescript': 'TypeScript', 'javascript': 'JavaScript',
      ' ts ': 'TypeScript', ' js ': 'JavaScript',
      'python': 'Python', 'golang': 'Go', ' go ': 'Go',
      'rust': 'Rust', 'java': 'Java', 'kotlin': 'Kotlin',
      'swift': 'Swift', 'dart': 'Dart', 'c#': 'C#', 'csharp': 'C#',
      'ruby': 'Ruby', 'php': 'PHP', 'elixir': 'Elixir',
      'scala': 'Scala', 'haskell': 'Haskell', 'clojure': 'Clojure',
      'c++': 'C++', ' c ': 'C', 'zig': 'Zig', 'nim': 'Nim',
      'r language': 'R', 'julia': 'Julia',
    };

    for (final entry in langMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['language'] = entry.value;
        return;
      }
    }

    // Infer from framework
    final create = ctx.result['create']?.toString().toLowerCase() ?? '';
    final framework = ctx.result['framework']?.toString().toLowerCase() ?? '';
    final combined = '$create $framework';
    if (_anyOf(combined, ['react', 'vue', 'angular', 'next.js', 'svelte', 'node', 'express'])) {
      ctx.result['language'] ??= _anyOf(t, ['typescript', ' ts ']) ? 'TypeScript' : 'JavaScript';
    } else if (_anyOf(combined, ['django', 'fastapi', 'flask'])) {
      ctx.result['language'] ??= 'Python';
    } else if (_anyOf(combined, ['rails', 'sinatra'])) {
      ctx.result['language'] ??= 'Ruby';
    } else if (_anyOf(combined, ['spring boot', 'spring'])) {
      ctx.result['language'] ??= 'Java';
    }
  }

  void _extractDatabase(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    for (final entry in _databases.entries) {
      if (t.contains(entry.key)) found.add(entry.value);
    }

    final unique = found.toSet().toList();
    if (unique.isNotEmpty) {
      ctx.result['database'] = unique.join(', ');
    }
  }

  void _extractAuth(_Context ctx) {
    final t = ctx.lower;
    for (final entry in _authMethods.entries) {
      if (t.contains(entry.key)) {
        ctx.result['auth'] = entry.value;
        return;
      }
    }

    // Infer auth from context clues
    if (_anyOf(t, ['login', 'sign in', 'sign up', 'register', 'user account', 'authentication', 'authorization'])) {
      // Only infer if a framework suggests a default
      final fw = ctx.result['framework']?.toString().toLowerCase() ?? '';
      if (_anyOf(fw, ['next.js', 'remix'])) {
        ctx.result['auth'] ??= 'NextAuth';
      } else if (fw.contains('supabase') || ctx.lower.contains('supabase')) {
        ctx.result['auth'] ??= 'Supabase Auth';
      } else if (ctx.lower.contains('firebase')) {
        ctx.result['auth'] ??= 'Firebase Auth';
      }
    }
  }

  void _extractPlatform(_Context ctx) {
    final t = ctx.lower;
    for (final entry in _platforms.entries) {
      if (t.contains(entry.key)) {
        ctx.result['platform'] = entry.value;
        return;
      }
    }
  }

  void _extractArchitecture(_Context ctx) {
    final t = ctx.lower;
    for (final entry in _architectures.entries) {
      if (t.contains(entry.key)) {
        ctx.result['architecture'] = entry.value;
        return;
      }
    }
  }

  void _extractProtocol(_Context ctx) {
    final t = ctx.lower;
    const protocolMap = {
      'graphql': 'GraphQL', 'grpc': 'gRPC', 'websocket': 'WebSocket',
      'web socket': 'WebSocket', 'mqtt': 'MQTT', 'amqp': 'AMQP',
      'trpc': 'tRPC', 'rest': 'REST', 'restful': 'REST',
      'server-sent events': 'SSE', 'sse': 'SSE',
    };
    for (final entry in protocolMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['protocol'] = entry.value;
        return;
      }
    }
  }

  void _extractTesting(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['unit test', 'unit tests', 'jest', 'vitest', 'mocha', 'jasmine', 'pytest', 'rspec'])) found.add('unit');
    if (_anyOf(t, ['integration test', 'integration tests', 'supertest', 'testcontainer'])) found.add('integration');
    if (_anyOf(t, ['e2e', 'end-to-end', 'end to end', 'playwright', 'cypress', 'selenium'])) found.add('e2e');
    if (_anyOf(t, ['snapshot test', 'storybook'])) found.add('snapshot');
    if (_anyOf(t, ['load test', 'performance test', 'k6', 'jmeter', 'locust'])) found.add('load');
    if (_anyOf(t, ['contract test', 'pact'])) found.add('contract');

    if (found.isNotEmpty) {
      ctx.result['testing'] = found.join(', ');
    }
  }

  // ── FEATURES ─────────────────────────────────────────────────────────────

  void _extractFeatures(_Context ctx) {
    final t = ctx.lower;
    final found = <String>{};

    // ── Authentication & user management
    if (_anyOf(t, ['login', 'sign in', 'signin', 'authentication', 'auth', 'jwt', 'oauth'])) found.add('authentication');
    if (_anyOf(t, ['register', 'signup', 'sign up', 'create account', 'registration'])) found.add('user registration');
    if (_anyOf(t, ['profile', 'user profile', 'account settings', 'avatar'])) found.add('user profiles');
    if (_anyOf(t, ['role', 'permission', 'rbac', 'access control', 'admin access'])) found.add('role-based access control');
    if (_anyOf(t, ['2fa', 'two-factor', 'mfa', 'multi-factor'])) found.add('two-factor authentication');
    if (_anyOf(t, ['password reset', 'forgot password', 'reset password'])) found.add('password reset');

    // ── E-commerce
    if (_anyOf(t, ['cart', 'shopping cart', 'add to cart', 'basket'])) found.add('shopping cart');
    if (_anyOf(t, ['checkout', 'check out', 'purchase flow'])) found.add('checkout');
    if (_anyOf(t, ['product', 'products', 'product listing', 'catalog', 'catalogue'])) found.add('product catalog');
    if (_anyOf(t, ['payment', 'stripe', 'paypal', 'credit card', 'billing', 'subscription'])) found.add('payments');
    if (_anyOf(t, ['order', 'orders', 'order history', 'order tracking'])) found.add('order management');
    if (_anyOf(t, ['inventory', 'stock', 'warehouse'])) found.add('inventory management');
    if (_anyOf(t, ['wishlist', 'wish list', 'save for later'])) found.add('wishlist');
    if (_anyOf(t, ['review', 'rating', 'reviews', 'ratings'])) found.add('reviews & ratings');
    if (_anyOf(t, ['coupon', 'discount', 'promo code', 'voucher'])) found.add('discount codes');
    if (_anyOf(t, ['shipping', 'delivery', 'fulfillment'])) found.add('shipping & delivery');

    // ── Content & navigation
    if (_anyOf(t, ['dashboard', 'overview page', 'analytics page'])) found.add('dashboard');
    if (_anyOf(t, ['admin', 'admin panel', 'admin dashboard', 'cms', 'content management'])) found.add('admin panel');
    if (_anyOf(t, ['search', 'search bar', 'filter', 'full-text search', 'elasticsearch'])) found.add('search & filtering');
    if (_anyOf(t, ['pagination', 'paginate', 'infinite scroll'])) found.add('pagination');
    if (_anyOf(t, ['sort', 'sorting', 'sortable'])) found.add('sorting');
    if (_anyOf(t, ['breadcrumb', 'navigation', 'nav bar', 'navbar', 'sidebar'])) found.add('navigation');

    // ── Communication
    if (_anyOf(t, ['notification', 'push notification', 'alert', 'in-app notification'])) found.add('notifications');
    if (_anyOf(t, ['email', 'send email', 'email notification', 'transactional email'])) found.add('email notifications');
    if (_anyOf(t, ['sms', 'text message'])) found.add('SMS notifications');
    if (_anyOf(t, ['chat', 'messaging', 'real-time chat', 'live chat'])) found.add('real-time chat');
    if (_anyOf(t, ['comment', 'comments', 'discussion', 'forum'])) found.add('comments');
    if (_anyOf(t, ['contact form', 'feedback form', 'support form'])) found.add('contact form');

    // ── Media & files
    if (_anyOf(t, ['upload', 'file upload', 'image upload', 'attachment', 'drag and drop'])) found.add('file uploads');
    if (_anyOf(t, ['image', 'photo', 'gallery', 'media library'])) found.add('media management');
    if (_anyOf(t, ['video', 'stream', 'streaming', 'player'])) found.add('video streaming');
    if (_anyOf(t, ['export', 'csv export', 'pdf export', 'download report'])) found.add('export');

    // ── Data & analytics
    if (_anyOf(t, ['analytics', 'stats', 'statistics', 'metrics', 'reports', 'reporting'])) found.add('analytics');
    if (_anyOf(t, ['chart', 'graph', 'visualization', 'recharts', 'd3', 'chart.js'])) found.add('data visualization');
    if (_anyOf(t, ['audit log', 'activity log', 'history', 'audit trail'])) found.add('audit logging');
    if (_anyOf(t, ['real-time', 'live data', 'live updates', 'websocket'])) found.add('real-time updates');

    // ── Maps & location
    if (_anyOf(t, ['map', 'google map', 'mapbox', 'location', 'geolocation', 'gps'])) found.add('maps & location');

    // ── Social
    if (_anyOf(t, ['like', 'upvote', 'reaction', 'emoji reaction'])) found.add('reactions & likes');
    if (_anyOf(t, ['follow', 'follower', 'subscribe', 'social feed', 'feed'])) found.add('social feed');
    if (_anyOf(t, ['share', 'social share', 'sharing'])) found.add('social sharing');

    // ── Settings & preferences
    if (_anyOf(t, ['settings', 'preference', 'configuration page', 'user setting'])) found.add('settings & preferences');
    if (_anyOf(t, ['dark mode', 'theme', 'light mode', 'theme switcher'])) found.add('dark mode');
    if (_anyOf(t, ['language', 'i18n', 'internationalization', 'localization', 'l10n', 'multi-language'])) found.add('internationalization');

    // ── APIs & integrations
    if (_anyOf(t, ['webhook', 'webhooks', 'event hook'])) found.add('webhooks');
    if (_anyOf(t, ['api integration', 'third-party api', 'external api', 'integration'])) found.add('API integrations');
    if (_anyOf(t, ['cron', 'scheduled task', 'background job', 'queue', 'worker'])) found.add('background jobs');
    if (_anyOf(t, ['rate limit', 'rate limiting', 'throttl'])) found.add('rate limiting');
    if (_anyOf(t, ['cache', 'caching', 'redis cache'])) found.add('caching');

    // ── Security
    if (_anyOf(t, ['encrypt', 'encryption', 'e2e encryption', 'end-to-end encryption'])) found.add('end-to-end encryption');
    if (_anyOf(t, ['audit', 'security audit', 'vulnerability'])) found.add('security audit');

    // ── ML / AI features
    if (_anyOf(t, ['recommendation', 'recommend', 'suggested'])) found.add('recommendations');
    if (_anyOf(t, ['ai', 'ai-powered', 'gpt', 'openai', 'llm'])) found.add('AI-powered features');

    // ── File / download tools
    if (_anyOf(t, ['torrent', 'magnet link', '.torrent'])) found.add('torrent parsing');
    if (_anyOf(t, ['direct download', 'direct link', 'http download'])) found.add('direct download links');
    if (_anyOf(t, ['debrid', 'real-debrid', 'premiumize', 'alldebrid'])) found.add('debrid service integration');
    if (_anyOf(t, ['youtube downloader', 'yt-dlp', 'video download', 'yt downloader'])) found.add('video downloader');
    if (_anyOf(t, ['file converter', 'format converter', 'convert files', 'convert video', 'convert audio'])) found.add('file format conversion');
    if (_anyOf(t, ['pdf convert', 'pdf to', 'to pdf'])) found.add('PDF conversion');
    if (_anyOf(t, ['image compress', 'image resize', 'image convert', 'image optimizer'])) found.add('image processing');
    if (_anyOf(t, ['url shortener', 'short url', 'link shortener'])) found.add('URL shortening');
    if (_anyOf(t, ['qr code', 'qr generator', 'qr scanner'])) found.add('QR code generation & scanning');
    if (_anyOf(t, ['barcode', 'barcode scanner'])) found.add('barcode scanning');
    if (_anyOf(t, ['file manager', 'file browser', 'file explorer'])) found.add('file management');
    if (_anyOf(t, ['cloud storage', 'file hosting', 'file upload'])) found.add('cloud file storage');
    if (_anyOf(t, ['download manager', 'download queue', 'batch download'])) found.add('download queue manager');
    if (_anyOf(t, ['vpn', 'proxy', 'tunnel'])) found.add('VPN / proxy support');
    if (_anyOf(t, ['progress bar', 'download progress', 'transfer speed'])) found.add('download progress tracking');

    // ── Productivity
    if (_anyOf(t, ['todo', 'to-do', 'task list', 'task manager'])) found.add('task management');
    if (_anyOf(t, ['note', 'notes', 'note-taking'])) found.add('note-taking');
    if (_anyOf(t, ['calendar', 'events', 'scheduling'])) found.add('calendar & scheduling');
    if (_anyOf(t, ['habit tracker', 'habit', 'streak'])) found.add('habit tracking');
    if (_anyOf(t, ['expense', 'budget', 'spending tracker'])) found.add('expense tracking');
    if (_anyOf(t, ['invoice', 'billing'])) found.add('invoice generation');
    if (_anyOf(t, ['password manager', 'vault', 'secure credentials'])) found.add('password vault');
    if (_anyOf(t, ['time tracker', 'pomodoro', 'work timer'])) found.add('time tracking');
    if (_anyOf(t, ['offline mode', 'offline support', 'works offline'])) found.add('offline support');
    if (_anyOf(t, ['sync', 'cloud sync', 'cross-device sync'])) found.add('cross-device sync');

    // ── Dev tools
    if (_anyOf(t, ['api tester', 'http client', 'request builder'])) found.add('API request testing');
    if (_anyOf(t, ['code editor', 'syntax highlight', 'code highlight'])) found.add('code editor');
    if (_anyOf(t, ['regex', 'regular expression tester'])) found.add('regex tester');
    if (_anyOf(t, ['color picker', 'palette generator'])) found.add('color picker');
    if (_anyOf(t, ['diagram', 'flowchart', 'uml'])) found.add('diagram builder');

    // ── Media & entertainment
    if (_anyOf(t, ['music player', 'audio player', 'playlist'])) found.add('music player');
    if (_anyOf(t, ['podcast', 'podcast player'])) found.add('podcast player');
    if (_anyOf(t, ['video player', 'media player', 'streaming player'])) found.add('video player');
    if (_anyOf(t, ['subtitle', 'captions', 'srt'])) found.add('subtitle support');

    if (found.isNotEmpty) {
      ctx.result['features'] = found.toList();
    }
  }

  // ── STYLE ─────────────────────────────────────────────────────────────────

  void _extractStyle(_Context ctx) {
    final t = ctx.lower;
    final parts = <String>[];

    const designStyle = [
      'modern', 'clean', 'minimal', 'minimalist', 'flat', 'material',
      'neumorphic', 'glassmorphism', 'brutalist', 'retro', 'elegant',
      'corporate', 'playful', 'bold', 'simple', 'professional',
    ];
    const colorMode = ['dark', 'light', 'dark mode', 'light mode'];
    const perf = ['fast', 'lightweight', 'performance-first', 'high-performance'];
    const responsive = ['responsive', 'mobile-first', 'adaptive'];

    for (final s in designStyle) {
      if (t.contains(s)) {
        parts.add(s);
        break;
      }
    }
    for (final s in colorMode) {
      if (t.contains(s)) {
        parts.add(s.replaceAll(' mode', ''));
        break;
      }
    }
    for (final s in perf) {
      if (t.contains(s)) {
        parts.add('performance-first');
        break;
      }
    }
    for (final s in responsive) {
      if (t.contains(s)) {
        parts.add(s);
        break;
      }
    }

    if (parts.isNotEmpty) {
      ctx.result['style'] = parts.join(', ');
    }
  }

  // ── CONTENT MODE ──────────────────────────────────────────────────────────

  void _extractTopic(_Context ctx) {
    // Everything after "about" or after "on" or the subject clause
    final patterns = [
      RegExp(r'\babout\s+(.+?)(?:[.,]|$)', caseSensitive: false),
      RegExp(r'\bon\s+(?:the\s+topic\s+of\s+)?(.+?)(?:[.,]|$)', caseSensitive: false),
      RegExp(r'\btopic[:\s]+(.+?)(?:[.,]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final topic = m.group(1)?.trim() ?? '';
        if (topic.isNotEmpty) {
          ctx.result['topic'] = topic;
          return;
        }
      }
    }

    // Fallback: use the create value as topic
    final create = ctx.result['create']?.toString() ?? '';
    if (create.isNotEmpty && create != 'application') {
      ctx.result['topic'] = create;
    }
  }

  void _extractTone(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    const tones = [
      'professional', 'casual', 'formal', 'informal', 'conversational',
      'technical', 'friendly', 'authoritative', 'persuasive', 'empathetic',
      'direct', 'concise', 'detailed', 'humorous', 'serious', 'inspiring',
      'educational', 'neutral',
    ];

    for (final tone in tones) {
      if (t.contains(tone)) found.add(tone);
    }

    if (found.isNotEmpty) {
      ctx.result['tone'] = found.take(3).join(', ');
    }
  }

  void _extractAudience(_Context ctx) {
    final t = ctx.lower;

    const audienceMap = {
      'beginner': 'beginners', 'beginners': 'beginners', 'new developer': 'beginner developers',
      'junior developer': 'junior developers', 'senior developer': 'senior developers',
      'developer': 'developers', 'engineers': 'engineers', 'technical': 'technical audience',
      'non-technical': 'non-technical stakeholders', 'executive': 'executives', 'ceo': 'executives',
      'business': 'business stakeholders', 'customer': 'customers', 'end user': 'end users',
      'student': 'students', 'researcher': 'researchers', 'marketer': 'marketers',
      'designer': 'designers', 'product manager': 'product managers',
    };

    for (final entry in audienceMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['audience'] = entry.value;
        return;
      }
    }

    // Pattern match "for X audience" or "targeted at X"
    final patterns = [
      RegExp(r'\bfor\s+([\w\s]+?)\s+(?:audience|readers|users)\b', caseSensitive: false),
      RegExp(r'\btargeted?\s+(?:at|to)\s+([\w\s]+?)(?:[.,]|$)', caseSensitive: false),
      RegExp(r'\baudience[:\s]+([\w\s]+?)(?:[.,]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final audience = m.group(1)?.trim() ?? '';
        if (audience.isNotEmpty && audience.length < 40) {
          ctx.result['audience'] = audience;
          return;
        }
      }
    }
  }

  void _extractLength(_Context ctx) {
    final wordPattern = RegExp(r'(\d[\d,]*)\s*(?:word|words)\b', caseSensitive: false);
    final m = wordPattern.firstMatch(ctx.raw);
    if (m != null) {
      ctx.result['length'] = '${m.group(1)} words';
      return;
    }

    const lengthMap = {
      'short': 'short', 'brief': 'brief', 'concise': 'concise',
      'detailed': 'detailed', 'comprehensive': 'comprehensive', 'long-form': 'long-form',
      'in-depth': 'in-depth', 'quick': 'quick summary', 'summary': 'summary',
      'one page': '1 page', 'two page': '2 pages', 'three page': '3 pages',
    };

    for (final entry in lengthMap.entries) {
      if (ctx.lower.contains(entry.key)) {
        ctx.result['length'] = entry.value;
        return;
      }
    }
  }

  void _extractSections(_Context ctx) {
    final patterns = [
      RegExp(r'\bsections?[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\b(?:include|containing|with)\s+(?:sections?|parts?)[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final raw = m.group(1)?.trim() ?? '';
        if (raw.isNotEmpty) {
          ctx.result['sections'] = raw;
          return;
        }
      }
    }

    // Infer common section patterns
    final t = ctx.lower;
    if (_anyOf(t, ['blog', 'article'])) {
      if (ctx.result['sections'] == null) {
        ctx.result['sections'] = 'introduction, body, conclusion';
      }
    } else if (_anyOf(t, ['email'])) {
      if (ctx.result['sections'] == null) {
        ctx.result['sections'] = 'subject line, opening, body, CTA';
      }
    }
  }

  void _extractKeywords(_Context ctx) {
    final patterns = [
      RegExp(r'\bkeywords?[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bfocus(?:ing)?\s+on\s+(.+?)(?:[.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final raw = m.group(1)?.trim() ?? '';
        if (raw.isNotEmpty && raw.length < 80) {
          ctx.result['keywords'] = raw;
          return;
        }
      }
    }
  }

  // ── AI PROMPT MODE ────────────────────────────────────────────────────────

  void _extractRole(_Context ctx) {
    final patterns = [
      RegExp(r'\bact\s+as\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\byou\s+are\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\brole\s+of\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bbehave\s+as\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bpersona\s+of\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bwho\s+(?:is|acts?\s+as)\s+(?:a\s+|an\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final role = m.group(1)?.trim() ?? '';
        if (role.isNotEmpty && role.length < 60) {
          ctx.result['role'] = role;
          return;
        }
      }
    }

    const roleKeywords = {
      'software engineer': 'senior software engineer',
      'software developer': 'senior software developer',
      'architect': 'software architect',
      'data scientist': 'data scientist',
      'devops': 'DevOps engineer',
      'security engineer': 'security engineer',
      'technical writer': 'technical writer',
      'product manager': 'product manager',
      'teacher': 'patient teacher',
      'tutor': 'expert tutor',
      'coach': 'expert coach',
      'assistant': 'helpful assistant',
    };
    for (final entry in roleKeywords.entries) {
      if (ctx.lower.contains(entry.key)) {
        ctx.result['role'] = entry.value;
        return;
      }
    }
  }

  void _extractTask(_Context ctx) {
    final patterns = [
      RegExp(r'\btask[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\byour\s+(?:job|task|goal)\s+is\s+to\s+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bresponsible\s+for\s+(.+?)(?:[.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final task = m.group(1)?.trim() ?? '';
        if (task.isNotEmpty && task.length < 100) {
          ctx.result['task'] = task;
          return;
        }
      }
    }

    // Infer from create
    final create = ctx.result['create']?.toString() ?? '';
    if (create.isNotEmpty && ctx.mode == _Mode.aiPrompt) {
      ctx.result['task'] ??= create;
    }
  }

  void _extractContext(_Context ctx) {
    final patterns = [
      RegExp(r'\bcontext[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bgiven\s+that\s+(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bin\s+the\s+context\s+of\s+(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bworking\s+(?:with|on)\s+(.+?)(?:[,.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final context = m.group(1)?.trim() ?? '';
        if (context.isNotEmpty && context.length < 120) {
          ctx.result['context'] = context;
          return;
        }
      }
    }
  }

  void _extractRules(_Context ctx) {
    final patterns = [
      RegExp(r'\brules?[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\balways\s+(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bmust\s+(?:always\s+)?(.+?)(?:[,.]|$)', caseSensitive: false),
    ];
    final found = <String>[];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final rule = m.group(1)?.trim() ?? '';
        if (rule.isNotEmpty && rule.length < 80) {
          found.add(rule);
        }
      }
    }
    if (found.isNotEmpty) {
      ctx.result['rules'] = found.join(', ');
    }
  }

  void _extractPersona(_Context ctx) {
    final t = ctx.lower;
    final parts = <String>[];

    const traits = [
      'friendly', 'helpful', 'patient', 'concise', 'direct', 'detailed',
      'encouraging', 'strict', 'formal', 'casual', 'empathetic', 'precise',
    ];

    for (final trait in traits) {
      if (t.contains(trait)) parts.add(trait);
    }

    if (parts.isNotEmpty) {
      ctx.result['persona'] = parts.join(', ');
    }
  }

  void _extractAvoid(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    final patterns = [
      RegExp(r"(?:avoid|don't|do not|never)\s+(?:use\s+|include\s+|add\s+)?(.+?)(?:[,.]|$)", caseSensitive: false),
      RegExp(r'\bwithout\s+(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'\bexclude\s+(.+?)(?:[,.]|$)', caseSensitive: false),
    ];

    for (final p in patterns) {
      for (final m in p.allMatches(ctx.raw)) {
        final val = m.group(1)?.trim() ?? '';
        if (val.isNotEmpty && val.length < 60) found.add(val);
      }
    }

    // Common avoids from keywords
    if (t.contains('no markdown')) found.add('markdown');
    if (t.contains('no bullet')) found.add('bullet points');
    if (t.contains('no jargon')) found.add('jargon');
    if (t.contains('no emoji')) found.add('emojis');

    if (found.isNotEmpty) {
      ctx.result['avoid'] = found.take(4).join(', ');
    }
  }

  // ── DEVOPS MODE ───────────────────────────────────────────────────────────

  void _extractTrigger(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['push to main', 'push to master', 'on push', 'merge to main'])) found.add('push to main');
    if (_anyOf(t, ['pull request', 'pr', 'on pr'])) found.add('pull request');
    if (_anyOf(t, ['schedule', 'cron', 'nightly', 'daily', 'weekly'])) found.add('schedule');
    if (_anyOf(t, ['release', 'tag push', 'on tag', 'new release'])) found.add('tag push');
    if (_anyOf(t, ['manual', 'workflow dispatch', 'manually'])) found.add('manual trigger');

    if (found.isNotEmpty) {
      ctx.result['trigger'] = found.join(', ');
    }
  }

  void _extractSteps(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['lint', 'eslint', 'prettier', 'format check'])) found.add('lint');
    if (_anyOf(t, ['test', 'tests', 'unit test', 'run tests'])) found.add('test');
    if (_anyOf(t, ['build', 'compile', 'bundle'])) found.add('build');
    if (_anyOf(t, ['docker', 'container', 'image build', 'docker build'])) found.add('docker build');
    if (_anyOf(t, ['push image', 'docker push', 'ecr', 'registry'])) found.add('push image');
    if (_anyOf(t, ['deploy', 'deployment', 'release'])) found.add('deploy');
    if (_anyOf(t, ['security scan', 'snyk', 'trivy', 'vulnerability scan'])) found.add('security scan');

    if (found.isNotEmpty) {
      ctx.result['steps'] = found.join(', ');
    }
  }

  void _extractEnvironment(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['staging', 'stage env', 'staging environment'])) found.add('staging');
    if (_anyOf(t, ['production', 'prod', 'live'])) found.add('production');
    if (_anyOf(t, ['preview', 'feature env', 'pr environment'])) found.add('preview');
    if (_anyOf(t, ['development', 'dev env', 'local'])) found.add('development');

    if (found.isNotEmpty) {
      ctx.result['environment'] = found.join(', ');
    }
  }

  void _extractRunner(_Context ctx) {
    final t = ctx.lower;
    if (t.contains('macos') || t.contains('mac-os') || t.contains('ios build')) {
      ctx.result['runner'] = 'macos-14';
    } else if (t.contains('windows')) {
      ctx.result['runner'] = 'windows-latest';
    } else if (t.contains('self-hosted') || t.contains('self hosted')) {
      ctx.result['runner'] = 'self-hosted';
    } else {
      ctx.result['runner'] = 'ubuntu-latest';
    }
  }

  void _extractSecrets(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['database url', 'db url', 'database connection'])) found.add('DATABASE_URL');
    if (_anyOf(t, ['api key', 'api_key'])) found.add('API_KEY');
    if (_anyOf(t, ['aws access', 'aws_access'])) found.add('AWS_ACCESS_KEY_ID');
    if (_anyOf(t, ['docker token', 'docker hub', 'registry token'])) found.add('DOCKER_TOKEN');
    if (_anyOf(t, ['jwt secret', 'jwt_secret'])) found.add('JWT_SECRET');
    if (_anyOf(t, ['stripe', 'stripe key'])) found.add('STRIPE_SECRET_KEY');

    if (found.isNotEmpty) {
      ctx.result['secrets'] = found.join(', ');
    }
  }

  void _extractRollback(_Context ctx) {
    final t = ctx.lower;
    if (_anyOf(t, ['automatic rollback', 'auto rollback', 'rollback on fail'])) {
      ctx.result['rollback'] = 'automatic on failure';
    } else if (_anyOf(t, ['blue.green', 'blue-green', 'canary'])) {
      ctx.result['rollback'] = 'blue-green swap';
    } else if (_anyOf(t, ['manual rollback', 'rollback manual'])) {
      ctx.result['rollback'] = 'manual approval';
    }
  }

  // ── DATA / ML MODE ────────────────────────────────────────────────────────

  void _extractModel(_Context ctx) {
    final t = ctx.lower;
    const modelMap = {
      'binary classification': 'binary classification',
      'multiclass classification': 'multiclass classification',
      'classification': 'classification',
      'regression': 'regression',
      'clustering': 'clustering',
      'xgboost': 'XGBoost', 'lightgbm': 'LightGBM', 'catboost': 'CatBoost',
      'random forest': 'Random Forest', 'decision tree': 'Decision Tree',
      'neural network': 'neural network', 'cnn': 'CNN', 'rnn': 'RNN',
      'lstm': 'LSTM', 'transformer': 'Transformer',
      'fine-tune': 'LLM fine-tuning', 'fine tune': 'LLM fine-tuning',
      'rag': 'RAG pipeline', 'retrieval augmented': 'RAG pipeline',
    };

    for (final entry in modelMap.entries) {
      if (t.contains(entry.key)) {
        ctx.result['model'] = entry.value;
        return;
      }
    }
  }

  void _extractData(_Context ctx) {
    final patterns = [
      RegExp(r'\bdata(?:set)?\s*[:\-–]?\s*(.+?)(?:[,.]|$)', caseSensitive: false),
      RegExp(r'(\d[\d,]*)\s*(?:row|rows|sample|record|entry|entries)\b', caseSensitive: false),
    ];

    final sizeMatch = RegExp(r'(\d[\d,k]*)\s*(?:row|rows|record|sample)', caseSensitive: false).firstMatch(ctx.raw);
    final formatMatch = RegExp(r'\b(csv|json|parquet|excel|xlsx|sql|tsv)\b', caseSensitive: false).firstMatch(ctx.raw);

    final parts = <String>[];
    if (formatMatch != null) parts.add(formatMatch.group(1)!.toUpperCase());
    if (sizeMatch != null) parts.add('${sizeMatch.group(1)} rows');

    // Imbalance detection
    final imbalanceMatch = RegExp(r'(\d+)[/:](\d+)\s*(?:class\s+)?(?:imbalance|ratio|split)', caseSensitive: false).firstMatch(ctx.raw);
    if (imbalanceMatch != null) parts.add('imbalanced ${imbalanceMatch.group(1)}/${imbalanceMatch.group(2)}');

    if (parts.isNotEmpty) {
      ctx.result['data'] = parts.join(', ');
    } else {
      for (final p in patterns) {
        final m = p.firstMatch(ctx.raw);
        if (m != null && m.group(1) != null) {
          final raw = m.group(1)!.trim();
          if (raw.isNotEmpty && raw.length < 80) {
            ctx.result['data'] = raw;
            return;
          }
        }
      }
    }
  }

  void _extractMetrics(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    const metricsMap = {
      'accuracy': 'accuracy', 'precision': 'precision', 'recall': 'recall',
      'f1': 'F1', 'f1 score': 'F1', 'auc': 'AUC', 'auc-roc': 'AUC-ROC',
      'roc': 'AUC-ROC', 'rmse': 'RMSE', 'mae': 'MAE', 'mse': 'MSE',
      'r2': 'R²', 'r squared': 'R²', 'bleu': 'BLEU',
      'perplexity': 'perplexity', 'map': 'mAP',
    };

    for (final entry in metricsMap.entries) {
      if (t.contains(entry.key)) found.add(entry.value);
    }

    if (found.isNotEmpty) {
      ctx.result['metrics'] = found.join(', ');
    }
  }

  void _extractTraining(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['cross-validation', 'cross validation', 'k-fold', 'k fold'])) found.add('cross-validation');
    if (_anyOf(t, ['transfer learning'])) found.add('transfer learning');
    if (_anyOf(t, ['fine-tun', 'fine tun'])) found.add('fine-tuning');
    if (_anyOf(t, ['from scratch'])) found.add('from scratch');
    if (_anyOf(t, ['early stopping'])) found.add('early stopping');
    if (_anyOf(t, ['hyperparameter', 'grid search', 'random search', 'optuna', 'ray tune'])) found.add('hyperparameter tuning');
    if (_anyOf(t, ['smote', 'oversampl', 'undersampl'])) found.add('class balancing');

    if (found.isNotEmpty) {
      ctx.result['training'] = found.join(', ');
    }
  }

  void _extractInference(_Context ctx) {
    final t = ctx.lower;
    if (_anyOf(t, ['real-time', 'realtime', 'real time', 'low latency', 'online inference'])) {
      ctx.result['inference'] = 'real-time API';
    } else if (_anyOf(t, ['batch', 'batch processing', 'batch prediction'])) {
      ctx.result['inference'] = 'batch processing';
    } else if (_anyOf(t, ['edge', 'on-device', 'mobile inference'])) {
      ctx.result['inference'] = 'edge / on-device';
    } else if (_anyOf(t, ['serverless', 'lambda', 'cloud function'])) {
      ctx.result['inference'] = 'serverless function';
    }
  }

  // ── UNIVERSAL: CONSTRAINTS ────────────────────────────────────────────────

  void _extractConstraints(_Context ctx) {
    final t = ctx.lower;
    final found = <String>[];

    if (_anyOf(t, ['no external lib', 'no third-party', 'no dependencies', 'zero dependencies'])) {
      found.add('no external libraries');
    }
    if (_anyOf(t, ['offline', 'works offline', 'offline-first', 'no internet'])) {
      found.add('must work offline');
    }
    if (_anyOf(t, ['read-only', 'read only', 'no writes'])) {
      found.add('read-only access');
    }
    if (_anyOf(t, ['backwards compatible', 'backward compatible', 'no breaking changes'])) {
      found.add('no breaking changes');
    }
    if (_anyOf(t, ['open source', 'open-source', 'mit license', 'apache license'])) {
      found.add('open-source only dependencies');
    }

    if (found.isNotEmpty) {
      ctx.result['constraints'] = found.join(', ');
    }
  }

  // ── OUTPUT ────────────────────────────────────────────────────────────────

  void _extractOutput(_Context ctx) {
    // Explicit output mention
    final patterns = [
      RegExp(r'\boutput[:\s]+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bprovide\s+(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bgenerate\s+(?:a\s+|an\s+)?(.+?)(?:[.]|$)', caseSensitive: false),
      RegExp(r'\bdeliver\s+(.+?)(?:[.]|$)', caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(ctx.raw);
      if (m != null) {
        final out = m.group(1)?.trim() ?? '';
        if (out.isNotEmpty && out.length < 80 && !_looksLikeIntent(out)) {
          ctx.result['output'] = out;
          return;
        }
      }
    }

    // Infer from mode / type
    ctx.result['output'] = _inferOutput(ctx);
  }

  bool _looksLikeIntent(String s) {
    return RegExp(r'^(?:me\s+|a\s+|an\s+)?(?:build|create|make|design|develop)\b', caseSensitive: false).hasMatch(s);
  }

  String _inferOutput(_Context ctx) {
    final t = ctx.lower;
    switch (ctx.mode) {
      case _Mode.content:
        if (_anyOf(t, ['blog', 'article'])) return 'full markdown article';
        if (_anyOf(t, ['email', 'newsletter'])) return 'complete email copy';
        if (_anyOf(t, ['report'])) return 'formatted report';
        return 'written content';
      case _Mode.aiPrompt:
        return 'complete system prompt';
      case _Mode.devops:
        if (_anyOf(t, ['github action'])) return 'complete GitHub Actions YAML';
        if (_anyOf(t, ['gitlab'])) return 'complete GitLab CI YAML';
        if (_anyOf(t, ['docker'])) return 'Dockerfile + compose file';
        return 'complete CI/CD configuration';
      case _Mode.dataML:
        if (_anyOf(t, ['notebook', 'jupyter'])) return 'Jupyter notebook';
        if (_anyOf(t, ['pipeline'])) return 'complete ML pipeline';
        return 'Python script with training and evaluation';
      case _Mode.app:
        final type = ctx.result['type']?.toString() ?? '';
        final desc = ctx.result['description']?.toString() ?? '';
        final platform = type == 'mobile' ? 'mobile app' :
                         type == 'desktop' ? 'desktop app' :
                         type == 'cli' ? 'CLI tool' :
                         type == 'api' ? 'API service' :
                         type == 'web' ? 'web app' : 'app';

        if (_anyOf(t, ['openapi', 'swagger'])) return 'OpenAPI spec + implementation';

        if (desc.isNotEmpty) {
          return 'complete $platform — full source code, project structure, setup instructions, '
              'and implementation for: $desc';
        }

        // Type-specific defaults with richer description
        if (type == 'api') {
          return 'full API implementation with endpoints, models, validation, and README';
        }
        if (type == 'mobile') {
          final fw = ctx.result['framework']?.toString() ?? '';
          return 'complete ${fw.isNotEmpty ? fw : "mobile"} app — screens, navigation, state management, and build setup';
        }
        if (type == 'cli') return 'complete CLI implementation with argument parsing and help docs';
        if (type == 'desktop') return 'complete desktop app with UI, state management, and installer setup';
        if (type == 'web') return 'complete web app — pages, components, routing, and deployment config';
        return 'full implementation with file structure, source code, and setup instructions';
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _anyOf(String text, List<String> needles) =>
      needles.any((n) => text.contains(n));

  String _canonicalizeTech(String tech) {
    const canon = {
      'node.js': 'Node.js', 'nodejs': 'Node.js',
      'react': 'React', 'vue.js': 'Vue.js', 'vue': 'Vue.js',
      'angular': 'Angular', 'svelte': 'Svelte',
      'next.js': 'Next.js', 'nextjs': 'Next.js',
      'nuxt.js': 'Nuxt', 'nuxt': 'Nuxt',
      'express': 'Express.js', 'fastify': 'Fastify',
      'nestjs': 'NestJS', 'nest.js': 'NestJS',
      'django': 'Django', 'flask': 'Flask', 'fastapi': 'FastAPI',
      'spring boot': 'Spring Boot', 'springboot': 'Spring Boot',
      'rails': 'Rails', 'laravel': 'Laravel',
      'golang': 'Go', 'go': 'Go', 'rust': 'Rust',
      'flutter': 'Flutter', 'react native': 'React Native',
      'swift': 'Swift', 'swiftui': 'SwiftUI',
      'kotlin': 'Kotlin', 'jetpack compose': 'Jetpack Compose',
    };
    return canon[tech.toLowerCase()] ?? tech;
  }
}

// ── Context object ────────────────────────────────────────────────────────────

class _Context {
  _Context(this.raw) : lower = raw.toLowerCase();

  final String raw;
  final String lower;
  _Mode mode = _Mode.app;
  final Map<String, dynamic> result = {};
}

enum _Mode { app, content, aiPrompt, devops, dataML }
