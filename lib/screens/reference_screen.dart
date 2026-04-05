import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class _KeyEntry {
  const _KeyEntry({
    required this.key,
    required this.purpose,
    required this.explanation,
    required this.example,
    this.compactOutput = '',
    this.expandedOutput = '',
    this.notes = '',
  });

  final String key;
  final String purpose;
  final String explanation;
  final String example;
  final String compactOutput;
  final String expandedOutput;
  final String notes;
}

class _Category {
  const _Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.keys,
  });

  final String name;
  final IconData icon;
  final Color color;
  final List<_KeyEntry> keys;
}

// ── Key data ──────────────────────────────────────────────────────────────────

const List<_Category> _categories = [
  _Category(
    name: 'Special Keys',
    icon: Icons.star_outline,
    color: Color(0xFF0078D4),
    keys: [
      _KeyEntry(
        key: 'CREATE',
        purpose: 'Defines what you are building',
        explanation:
            'The primary subject of your prompt — the thing you want built, written, or generated. '
            'This is always the first meaningful key the output builder processes. '
            'In compact mode it renders as "TASK: build <value>". '
            'In expanded mode it becomes the grammatical subject of the opening sentence.',
        example: 'CREATE app',
        compactOutput: 'TASK: build app',
        expandedOutput: 'Build a ... app.',
        notes:
            'Can be anything: app, API, blog post, script, pipeline, schema, system prompt, etc.',
      ),
      _KeyEntry(
        key: 'TYPE',
        purpose: 'Specifies the kind or category of the thing being built',
        explanation:
            'Narrows down what CREATE refers to. Follows immediately after TASK in compact output. '
            'In expanded mode it is appended to the opening sentence alongside STYLE and CREATE. '
            'Keep this short — one or two words is best.',
        example: 'TYPE web',
        compactOutput: 'TYPE: web',
        expandedOutput: '...a web app.',
        notes: 'Common values: web, mobile, CLI, REST API, GraphQL, microservice, blog post.',
      ),
      _KeyEntry(
        key: 'FEATURES',
        purpose: 'Lists the capabilities or requirements',
        explanation:
            'Comma-separated values that describe what the thing should include or support. '
            'Each value becomes its own bullet point in compact mode. '
            'In expanded mode they become a natural-language list: "Include X, Y, and Z." '
            'Values are also passed through the keyword compressor — for example "login" becomes "auth".',
        example: 'FEATURES login, dashboard, payments',
        compactOutput: 'FEATURES:\n- auth\n- dashboard\n- payments',
        expandedOutput: 'Include user authentication, dashboard, and payment system.',
        notes:
            'Use commas to separate items. Put the most important features first — they appear first in the output.',
      ),
      _KeyEntry(
        key: 'STYLE',
        purpose: 'Sets the design direction, tone, or visual character',
        explanation:
            'Describes how the thing should look, feel, or be written. '
            'In compact mode it appears as "STYLE: <value>" after the features block. '
            'In expanded mode it is prepended to the opening sentence as an adjective — so "STYLE modern dark" '
            'makes the output read "Build a modern dark web app."',
        example: 'STYLE modern dark',
        compactOutput: 'STYLE: modern dark',
        expandedOutput: 'Build a modern dark ...',
        notes:
            'For content: use values like "conversational", "technical", "formal". For apps: "minimal", "bold", "corporate".',
      ),
      _KeyEntry(
        key: 'OUTPUT',
        purpose: 'Defines exactly what to deliver',
        explanation:
            'Tells the AI what form the response should take. Always appears last in both compact and expanded output. '
            'In expanded mode it becomes "Provide <value>." as the final sentence. '
            'Be as specific as possible — vague outputs produce vague results.',
        example: 'OUTPUT full code with comments',
        compactOutput: 'OUTPUT: full code with comments',
        expandedOutput: 'Provide full code with comments.',
        notes:
            'Good values: "full code", "SQL migration", "OpenAPI spec", "markdown", "Python notebook", "YAML workflow file".',
      ),
    ],
  ),
  _Category(
    name: 'Software Dev',
    icon: Icons.code,
    color: Color(0xFF4EC9B0),
    keys: [
      _KeyEntry(
        key: 'STACK',
        purpose: 'Full technology stack',
        explanation:
            'Lists every technology in play — frontend, backend, and database together. '
            'Use this when you want the AI to generate code or instructions that span multiple layers. '
            'Comma-separate technologies in order from frontend to backend.',
        example: 'STACK React, Node.js, PostgreSQL',
        compactOutput: 'STACK: React, Node.js, PostgreSQL',
        expandedOutput: 'Stack: React, Node.js, PostgreSQL.',
      ),
      _KeyEntry(
        key: 'FRAMEWORK',
        purpose: 'Specific framework within the stack',
        explanation:
            'More precise than STACK — use this when the framework matters more than the underlying language. '
            'Useful when the AI needs to generate framework-specific code, config, or patterns '
            'like Next.js routing, Django models, or Spring Boot annotations.',
        example: 'FRAMEWORK Next.js',
        compactOutput: 'FRAMEWORK: Next.js',
        expandedOutput: 'Framework: Next.js.',
        notes: 'Common values: Next.js, Django, FastAPI, Spring Boot, Rails, Laravel, Flutter, SwiftUI.',
      ),
      _KeyEntry(
        key: 'LANGUAGE',
        purpose: 'Primary programming language',
        explanation:
            'Pins the output to a specific language. Use this when your stack crosses multiple languages '
            'and you want to be explicit about which one the AI should write in. '
            'Also useful for tasks like code review, refactoring, or explanation.',
        example: 'LANGUAGE TypeScript',
        compactOutput: 'LANGUAGE: TypeScript',
        expandedOutput: 'Language: TypeScript.',
        notes: 'Common values: TypeScript, Python, Go, Rust, Swift, Kotlin, Java, C#, Dart.',
      ),
      _KeyEntry(
        key: 'DATABASE',
        purpose: 'Data storage solution(s)',
        explanation:
            'Specifies the database or storage system to use. Can include multiple systems separated by commas. '
            'This tells the AI which SQL dialect, ORM conventions, or query patterns to follow '
            'when generating schemas, migrations, or queries.',
        example: 'DATABASE PostgreSQL, Redis',
        compactOutput: 'DATABASE: PostgreSQL, Redis',
        expandedOutput: 'Database: PostgreSQL, Redis.',
        notes: 'Common values: PostgreSQL, MySQL, SQLite, MongoDB, Redis, DynamoDB, Firestore, Supabase.',
      ),
      _KeyEntry(
        key: 'AUTH',
        purpose: 'Authentication method or strategy',
        explanation:
            'Tells the AI how users or services will authenticate. This shapes generated middleware, '
            'route guards, token handling, and session management code. '
            'Be specific — "JWT" and "OAuth2" produce very different implementations.',
        example: 'AUTH JWT',
        compactOutput: 'AUTH: JWT',
        expandedOutput: 'Auth: JWT.',
        notes: 'Common values: JWT, OAuth2, session cookies, API keys, mTLS, Basic Auth, Passkeys.',
      ),
      _KeyEntry(
        key: 'PLATFORM',
        purpose: 'Target deployment or runtime platform',
        explanation:
            'Specifies where the code will run or be deployed. '
            'Affects generated infrastructure code, environment config, Dockerfiles, and deployment scripts. '
            'For cloud targets, include the specific service if known.',
        example: 'PLATFORM AWS ECS',
        compactOutput: 'PLATFORM: AWS ECS',
        expandedOutput: 'Platform: AWS ECS.',
        notes: 'Common values: AWS, GCP, Azure, Vercel, Netlify, Railway, self-hosted, Docker, Kubernetes.',
      ),
      _KeyEntry(
        key: 'ARCHITECTURE',
        purpose: 'System design pattern',
        explanation:
            'Describes the high-level structure of the system. Drives decisions about service boundaries, '
            'data flow, and communication patterns in generated code and documentation. '
            'Choose the pattern that matches your actual or intended design.',
        example: 'ARCHITECTURE microservices',
        compactOutput: 'ARCHITECTURE: microservices',
        expandedOutput: 'Architecture: microservices.',
        notes: 'Common values: microservices, monolith, serverless, event-driven, CQRS, layered, hexagonal.',
      ),
      _KeyEntry(
        key: 'PROTOCOL',
        purpose: 'Communication protocol between components',
        explanation:
            'Specifies how services or clients talk to each other. '
            'Useful when generating API specs, client SDKs, or server stubs — '
            'each protocol has distinct conventions for serialization, streaming, and error handling.',
        example: 'PROTOCOL gRPC',
        compactOutput: 'PROTOCOL: gRPC',
        expandedOutput: 'Protocol: gRPC.',
        notes: 'Common values: REST, gRPC, GraphQL, WebSocket, MQTT, AMQP, tRPC.',
      ),
      _KeyEntry(
        key: 'TESTING',
        purpose: 'Test strategy and coverage approach',
        explanation:
            'Tells the AI what kinds of tests to generate and at what level. '
            'Multiple values (comma-separated) mean the AI should produce tests at each level. '
            'This shapes test file structure, test runner config, and mock/stub usage.',
        example: 'TESTING unit, integration, e2e',
        compactOutput: 'TESTING: unit, integration, e2e',
        expandedOutput: 'Testing: unit, integration, e2e.',
        notes: 'Common values: unit, integration, e2e, snapshot, contract, load, property-based.',
      ),
      _KeyEntry(
        key: 'CONSTRAINTS',
        purpose: 'Hard requirements or non-negotiable limits',
        explanation:
            'Lists things the solution must or must not do. These are guardrails, not suggestions — '
            'use this for genuine hard limits like "no external dependencies", "must work offline", '
            'or "read-only database access". The AI treats these as inviolable.',
        example: 'CONSTRAINTS no external libraries, must run offline',
        compactOutput: 'CONSTRAINTS: no external libraries, must run offline',
        expandedOutput: 'Constraints: no external libraries, must run offline.',
      ),
    ],
  ),
  _Category(
    name: 'API Design',
    icon: Icons.api,
    color: Color(0xFF569CD6),
    keys: [
      _KeyEntry(
        key: 'RESOURCE',
        purpose: 'Primary API resource being designed',
        explanation:
            'Names the domain entity your API revolves around. '
            'Drives the generated URL paths, controller/handler names, model names, and CRUD logic. '
            'Can list multiple resources if the API covers several.',
        example: 'RESOURCE users',
        compactOutput: 'RESOURCE: users',
        expandedOutput: 'Resource: users.',
        notes: 'Common values: users, orders, products, posts, comments, sessions, invoices.',
      ),
      _KeyEntry(
        key: 'METHODS',
        purpose: 'HTTP methods the endpoint supports',
        explanation:
            'Lists the HTTP verbs your API accepts. This directly shapes the generated route definitions, '
            'handler signatures, and OpenAPI spec entries. '
            'Only include the methods you actually need — fewer is clearer.',
        example: 'METHODS GET, POST, PUT, DELETE',
        compactOutput: 'METHODS: GET, POST, PUT, DELETE',
        expandedOutput: 'Methods: GET, POST, PUT, DELETE.',
        notes: 'Standard values: GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS.',
      ),
      _KeyEntry(
        key: 'VERSION',
        purpose: 'API version identifier',
        explanation:
            'Pins the output to a specific API version. '
            'Affects URL path prefixes (/v1/...), OpenAPI info blocks, and any versioning middleware. '
            'Include this whenever you want the generated code to reflect versioning conventions.',
        example: 'VERSION v1',
        compactOutput: 'VERSION: v1',
        expandedOutput: 'Version: v1.',
      ),
      _KeyEntry(
        key: 'FORMAT',
        purpose: 'Request and response data format',
        explanation:
            'Specifies how data is serialized in transit. '
            'Affects Content-Type headers, serializer/deserializer choice, and generated schema types. '
            'For REST APIs, JSON is the default — specify XML or others explicitly.',
        example: 'FORMAT JSON',
        compactOutput: 'FORMAT: JSON',
        expandedOutput: 'Format: JSON.',
        notes: 'Common values: JSON, XML, MessagePack, Protobuf, form-data, multipart.',
      ),
      _KeyEntry(
        key: 'PAGINATION',
        purpose: 'How large result sets are paginated',
        explanation:
            'Tells the AI which pagination strategy to implement. '
            'Cursor-based is preferred for real-time feeds (no skipped items on insert). '
            'Offset-based is simpler but can produce inconsistent results on fast-changing datasets.',
        example: 'PAGINATION cursor-based',
        compactOutput: 'PAGINATION: cursor-based',
        expandedOutput: 'Pagination: cursor-based.',
        notes: 'Common values: cursor-based, offset, page-based, keyset, seek.',
      ),
      _KeyEntry(
        key: 'RATE_LIMIT',
        purpose: 'Rate limiting policy for the API',
        explanation:
            'Defines how many requests a client can make in a given time window. '
            'Affects generated middleware, response headers (X-RateLimit-*), and error responses (429). '
            'Be specific about the scope — per user, per IP, or per API key.',
        example: 'RATE_LIMIT 100 req/min per user',
        compactOutput: 'RATE_LIMIT: 100 req/min per user',
        expandedOutput: 'Rate limit: 100 requests per minute per user.',
      ),
    ],
  ),
  _Category(
    name: 'Content & Writing',
    icon: Icons.article_outlined,
    color: Color(0xFFCE9178),
    keys: [
      _KeyEntry(
        key: 'TOPIC',
        purpose: 'The subject matter of the content',
        explanation:
            'Tells the AI what the content is about. Be specific — "Flutter" is too broad; '
            '"how to build a native desktop app with Flutter 3" is better. '
            'The more precise the topic, the more focused the generated content.',
        example: 'TOPIC how to build a native desktop app with Flutter',
        compactOutput: 'TOPIC: how to build a native desktop app with Flutter',
        expandedOutput: 'Topic: how to build a native desktop app with Flutter.',
      ),
      _KeyEntry(
        key: 'TONE',
        purpose: 'The voice and register of the writing',
        explanation:
            'Controls how the content sounds to the reader. '
            'Multiple tones can be combined with commas. '
            'The AI will balance all listed tones — "technical but approachable" gives different results '
            'than either "technical" or "approachable" alone.',
        example: 'TONE conversational, technical',
        compactOutput: 'TONE: conversational, technical',
        expandedOutput: 'Tone: conversational, technical.',
        notes:
            'Common values: professional, casual, conversational, technical, persuasive, formal, empathetic, direct.',
      ),
      _KeyEntry(
        key: 'AUDIENCE',
        purpose: 'Who the content is written for',
        explanation:
            'Defines the reader or viewer. Drives vocabulary choices, assumed prior knowledge, '
            'depth of explanation, and example complexity. '
            '"Beginner developers" and "senior engineers" require completely different outputs.',
        example: 'AUDIENCE intermediate developers',
        compactOutput: 'AUDIENCE: intermediate developers',
        expandedOutput: 'Audience: intermediate developers.',
        notes: 'Be specific: "C-suite executives", "junior React developers", "non-technical stakeholders".',
      ),
      _KeyEntry(
        key: 'LENGTH',
        purpose: 'Target length or size of the output',
        explanation:
            'Sets an expectation for how long the content should be. '
            'Use word counts for articles, page counts for reports, or descriptive terms for brevity. '
            'The AI will calibrate depth and detail accordingly.',
        example: 'LENGTH 1500 words',
        compactOutput: 'LENGTH: 1500 words',
        expandedOutput: 'Length: 1500 words.',
        notes: 'Common values: "short", "detailed", "500 words", "2 pages", "one paragraph", "comprehensive".',
      ),
      _KeyEntry(
        key: 'PERSPECTIVE',
        purpose: 'Point of view for the writing',
        explanation:
            'Controls whether the AI writes as "I", "we", or about "they/the user". '
            'First person works for personal essays and tutorials. '
            'Third person is standard for documentation and formal reports.',
        example: 'PERSPECTIVE first person',
        compactOutput: 'PERSPECTIVE: first person',
        expandedOutput: 'Perspective: first person.',
        notes: 'Values: first person, second person, third person.',
      ),
      _KeyEntry(
        key: 'SECTIONS',
        purpose: 'Required structural sections of the document',
        explanation:
            'Lists the sections the content must include, in order. '
            'Forces the AI to produce a structured document rather than free-form prose. '
            'Useful for articles, reports, proposals, and any content with a defined shape.',
        example: 'SECTIONS intro, problem, solution, examples, conclusion',
        compactOutput: 'SECTIONS: intro, problem, solution, examples, conclusion',
        expandedOutput: 'Sections: intro, problem, solution, examples, conclusion.',
      ),
      _KeyEntry(
        key: 'KEYWORDS',
        purpose: 'SEO keywords or focus terms to include',
        explanation:
            'Tells the AI which words and phrases must appear in the content. '
            'For SEO content, this guides keyword placement and density. '
            'For technical content, it ensures specific technologies or concepts are covered.',
        example: 'KEYWORDS Flutter, Dart, desktop, native',
        compactOutput: 'KEYWORDS: Flutter, Dart, desktop, native',
        expandedOutput: 'Keywords: Flutter, Dart, desktop, native.',
      ),
      _KeyEntry(
        key: 'EXAMPLES',
        purpose: 'Whether and how to include examples',
        explanation:
            'Controls example quantity and type. '
            'Code examples, real-world cases, and analogies are all valid values. '
            'Specify a number if you want a precise count; use descriptive terms for flexibility.',
        example: 'EXAMPLES 3 code examples, real-world cases',
        compactOutput: 'EXAMPLES: 3 code examples, real-world cases',
        expandedOutput: 'Examples: 3 code examples, real-world cases.',
      ),
    ],
  ),
  _Category(
    name: 'AI & Prompts',
    icon: Icons.psychology_outlined,
    color: Color(0xFFB5CEA8),
    keys: [
      _KeyEntry(
        key: 'ROLE',
        purpose: 'Persona the AI should adopt',
        explanation:
            'Sets the role or identity the AI inhabits when responding. '
            'This is one of the most powerful keys — the AI will apply domain expertise, '
            'communication style, and judgment appropriate to the specified role. '
            '"Senior software architect" produces very different responses than "documentation writer".',
        example: 'ROLE senior software architect',
        compactOutput: 'ROLE: senior software architect',
        expandedOutput: 'Role: senior software architect.',
        notes: 'Be specific: "principal engineer at a fintech startup" beats "developer".',
      ),
      _KeyEntry(
        key: 'TASK',
        purpose: 'The core action or instruction',
        explanation:
            'Defines the primary action the AI should perform. '
            'When used alongside ROLE, CONTEXT, and RULES, this becomes the heart of a system prompt. '
            'Use strong verbs: "analyze", "review", "generate", "explain", "refactor", "summarize".',
        example: 'TASK review architecture decisions and suggest improvements',
        compactOutput: 'TASK: review architecture decisions and suggest improvements',
        expandedOutput: 'Task: review architecture decisions and suggest improvements.',
        notes:
            'Note: TASK is also used internally by the parser as the compact output for CREATE. '
            'When using TASK explicitly, it appears between TYPE and FEATURES.',
      ),
      _KeyEntry(
        key: 'CONTEXT',
        purpose: 'Background information the AI needs',
        explanation:
            'Provides situational context that shapes the response. '
            'Without context, the AI makes assumptions — often wrong ones. '
            'Good context removes ambiguity: "legacy codebase, no tests, 10-year-old Rails app" '
            'will produce much more practical advice than just "Rails app".',
        example: 'CONTEXT legacy codebase, no tests, production traffic',
        compactOutput: 'CONTEXT: legacy codebase, no tests, production traffic',
        expandedOutput: 'Context: legacy codebase, no tests, production traffic.',
      ),
      _KeyEntry(
        key: 'RULES',
        purpose: 'Hard constraints on the response',
        explanation:
            'Lists non-negotiable rules the AI must follow. '
            'Different from CONSTRAINTS (which is about the solution) — RULES are about how the AI behaves. '
            '"Always explain trade-offs" and "never recommend third-party services" are typical rules.',
        example: 'RULES always explain trade-offs, cite sources, no vague advice',
        compactOutput: 'RULES: always explain trade-offs, cite sources, no vague advice',
        expandedOutput: 'Rules: always explain trade-offs, cite sources, no vague advice.',
      ),
      _KeyEntry(
        key: 'PERSONA',
        purpose: 'The character or communication style',
        explanation:
            'Controls how the AI communicates — its personality and delivery style. '
            'Whereas ROLE defines expertise, PERSONA defines manner. '
            'A "patient tutor" responds differently than a "blunt principal engineer" '
            'even with the same technical knowledge.',
        example: 'PERSONA concise, direct, no filler',
        compactOutput: 'PERSONA: concise, direct, no filler',
        expandedOutput: 'Persona: concise, direct, no filler.',
      ),
      _KeyEntry(
        key: 'AVOID',
        purpose: 'What to exclude from the response',
        explanation:
            'Explicitly tells the AI what not to include or do. '
            'Useful for preventing common AI tendencies like unnecessary preamble, '
            'markdown formatting in plain-text contexts, or making assumptions without stating them.',
        example: 'AVOID markdown, bullet points, assumptions',
        compactOutput: 'AVOID: markdown, bullet points, assumptions',
        expandedOutput: 'Avoid: markdown, bullet points, assumptions.',
        notes:
            'Common values: "markdown", "lengthy explanations", "assumptions", "jargon", "recommending rewrites".',
      ),
    ],
  ),
  _Category(
    name: 'DevOps & Infra',
    icon: Icons.settings_ethernet,
    color: Color(0xFFCCA700),
    keys: [
      _KeyEntry(
        key: 'TRIGGER',
        purpose: 'The event that starts the pipeline',
        explanation:
            'Defines when the CI/CD workflow or automation fires. '
            'Maps directly to CI platform event types (GitHub Actions "on:", GitLab "rules:", etc.). '
            'Multiple triggers can be listed with commas.',
        example: 'TRIGGER push to main, pull request',
        compactOutput: 'TRIGGER: push to main, pull request',
        expandedOutput: 'Trigger: push to main, pull request.',
        notes: 'Common values: push to main, pull request, schedule, release, tag push, manual.',
      ),
      _KeyEntry(
        key: 'STEPS',
        purpose: 'Pipeline stages or job steps in order',
        explanation:
            'Lists the stages that run in sequence. '
            'The AI generates a job or stage for each step in the order listed. '
            'Order matters — "build" must come before "deploy".',
        example: 'STEPS lint, test, build, docker push, deploy',
        compactOutput: 'STEPS: lint, test, build, docker push, deploy',
        expandedOutput: 'Steps: lint, test, build, docker push, deploy.',
      ),
      _KeyEntry(
        key: 'ENVIRONMENT',
        purpose: 'Target deployment environment',
        explanation:
            'Specifies where the code is deployed. '
            'Can be a single environment or a mapping (e.g. "staging on PR, production on main"). '
            'Drives environment-specific config injection, approval gates, and deployment targets.',
        example: 'ENVIRONMENT staging on PR, production on main',
        compactOutput: 'ENVIRONMENT: staging on PR, production on main',
        expandedOutput: 'Environment: staging on PR, production on main.',
        notes: 'Common values: development, staging, production, preview, canary.',
      ),
      _KeyEntry(
        key: 'RUNNER',
        purpose: 'The CI runner or machine type to use',
        explanation:
            'Specifies the OS and hardware the pipeline runs on. '
            'Critical for platform-specific builds (iOS on macos-14, Windows apps on windows-latest). '
            'Self-hosted runners need their label instead of a public image name.',
        example: 'RUNNER ubuntu-latest',
        compactOutput: 'RUNNER: ubuntu-latest',
        expandedOutput: 'Runner: ubuntu-latest.',
        notes: 'Common values: ubuntu-latest, macos-14, windows-latest, self-hosted.',
      ),
      _KeyEntry(
        key: 'SECRETS',
        purpose: 'Environment secrets needed by the pipeline',
        explanation:
            'Lists the secret names the workflow needs injected as environment variables. '
            'The AI generates the appropriate `env:` blocks referencing `\${{ secrets.NAME }}`. '
            'Only list secret names — never include actual values.',
        example: 'SECRETS DATABASE_URL, AWS_ACCESS_KEY_ID, DOCKER_TOKEN',
        compactOutput: 'SECRETS: DATABASE_URL, AWS_ACCESS_KEY_ID, DOCKER_TOKEN',
        expandedOutput: 'Secrets: DATABASE_URL, AWS_ACCESS_KEY_ID, DOCKER_TOKEN.',
      ),
      _KeyEntry(
        key: 'ROLLBACK',
        purpose: 'Rollback strategy on deployment failure',
        explanation:
            'Tells the AI what happens when a deployment goes wrong. '
            'Drives generated failure handlers, health check steps, and rollback job definitions. '
            '"Automatic on health check failure" is the most common production-safe strategy.',
        example: 'ROLLBACK automatic on health check failure',
        compactOutput: 'ROLLBACK: automatic on health check failure',
        expandedOutput: 'Rollback: automatic on health check failure.',
        notes: 'Common values: automatic on failure, manual approval, blue/green swap, previous image tag.',
      ),
    ],
  ),
  _Category(
    name: 'Data & ML',
    icon: Icons.bar_chart,
    color: Color(0xFF9CDCFE),
    keys: [
      _KeyEntry(
        key: 'MODEL',
        purpose: 'ML model type or task category',
        explanation:
            'Specifies the machine learning task or model architecture to use. '
            'Shapes the training loop, evaluation strategy, and generated notebook or code structure. '
            'Be specific about the algorithm if you have a preference.',
        example: 'MODEL XGBoost with SMOTE oversampling',
        compactOutput: 'MODEL: XGBoost with SMOTE oversampling',
        expandedOutput: 'Model: XGBoost with SMOTE oversampling.',
        notes:
            'Common values: binary classification, regression, clustering, LLM fine-tune, CNN, transformer.',
      ),
      _KeyEntry(
        key: 'DATA',
        purpose: 'Description of the input dataset',
        explanation:
            'Describes the data the model trains or runs on — format, size, and any notable characteristics. '
            'The AI uses this to generate appropriate data loading, cleaning, and preprocessing steps. '
            'Always mention class imbalance, missing values, or other data quality issues.',
        example: 'DATA customer churn CSV, 200k rows, imbalanced 90/10',
        compactOutput: 'DATA: customer churn CSV, 200k rows, imbalanced 90/10',
        expandedOutput: 'Data: customer churn CSV, 200k rows, imbalanced 90/10.',
      ),
      _KeyEntry(
        key: 'METRICS',
        purpose: 'Evaluation metrics for model performance',
        explanation:
            'Lists the metrics used to evaluate model quality. '
            'Multiple metrics can be listed — the AI generates evaluation code for each. '
            'Choose metrics that match the task: accuracy for balanced classes, '
            'F1/AUC for imbalanced ones.',
        example: 'METRICS accuracy, F1, AUC-ROC',
        compactOutput: 'METRICS: accuracy, F1, AUC-ROC',
        expandedOutput: 'Metrics: accuracy, F1, AUC-ROC.',
        notes: 'Common values: accuracy, precision, recall, F1, AUC-ROC, RMSE, MAE, BLEU, perplexity.',
      ),
      _KeyEntry(
        key: 'TRAINING',
        purpose: 'Training strategy or methodology',
        explanation:
            'Describes how the model is trained. Drives generated training loops, '
            'cross-validation code, hyperparameter search, and data split logic. '
            'Be specific about the validation strategy for reproducible results.',
        example: 'TRAINING 5-fold cross-validation, early stopping',
        compactOutput: 'TRAINING: 5-fold cross-validation, early stopping',
        expandedOutput: 'Training: 5-fold cross-validation, early stopping.',
        notes:
            'Common values: train/val/test split, k-fold cross-validation, transfer learning, from scratch, fine-tuning.',
      ),
      _KeyEntry(
        key: 'INFERENCE',
        purpose: 'How the trained model is served or used',
        explanation:
            'Specifies the inference environment — where and how predictions are generated. '
            'Affects generated serving code, API wrappers, batch job scripts, or edge deployment config. '
            'Real-time APIs require very different code than batch jobs.',
        example: 'INFERENCE real-time REST API',
        compactOutput: 'INFERENCE: real-time REST API',
        expandedOutput: 'Inference: real-time REST API.',
        notes: 'Common values: real-time API, batch job, edge device, streaming, serverless function.',
      ),
    ],
  ),
  _Category(
    name: 'Custom Keys',
    icon: Icons.add_box_outlined,
    color: Color(0xFF858585),
    keys: [
      _KeyEntry(
        key: 'ANY KEY',
        purpose: 'You can use any key name you invent',
        explanation:
            'The parser handles every key generically — you are not limited to the keys listed here. '
            'Any word you put as the first token on a line becomes a key, and everything after the '
            'first space becomes its value. Custom keys appear between TYPE and FEATURES in compact '
            'output as "KEY: value", and as "Key: value." sentences in expanded output.',
        example: 'NAME payment-service',
        compactOutput: 'NAME: payment-service',
        expandedOutput: 'Name: payment-service.',
        notes:
            'Custom key ideas: NAME, GOAL, OWNER, DEADLINE, PRIORITY, SCOPE, DEPENDENCIES, REFERENCES, NOTES.',
      ),
      _KeyEntry(
        key: 'NAME',
        purpose: 'The name of a service, component, or artifact',
        explanation:
            'Useful when generating microservices, libraries, packages, or components that need a specific identifier. '
            'The AI uses this name in generated code — as the package name, service identifier, '
            'class name, or directory name depending on context.',
        example: 'NAME payment-service',
        compactOutput: 'NAME: payment-service',
        expandedOutput: 'Name: payment-service.',
      ),
      _KeyEntry(
        key: 'GOAL',
        purpose: 'The primary objective or success criterion',
        explanation:
            'Describes what a successful outcome looks like. '
            'Especially useful for system prompts, planning documents, and analysis tasks '
            'where the AI needs to know what "done" means. '
            'Distinct from TASK — GOAL defines success, TASK defines action.',
        example: 'GOAL reduce API latency to under 100ms at p99',
        compactOutput: 'GOAL: reduce API latency to under 100ms at p99',
        expandedOutput: 'Goal: reduce API latency to under 100ms at p99.',
      ),
      _KeyEntry(
        key: 'RESPONSIBILITIES',
        purpose: 'What this component is responsible for',
        explanation:
            'Lists the bounded context of a service or module. '
            'Useful when generating microservices — tells the AI what this service owns '
            'and by implication what belongs elsewhere. '
            'Drives generated handler names, public API surface, and documentation.',
        example: 'RESPONSIBILITIES charge, refund, webhook handling, idempotency',
        compactOutput: 'RESPONSIBILITIES: charge, refund, webhook handling, idempotency',
        expandedOutput: 'Responsibilities: charge, refund, webhook handling, idempotency.',
      ),
      _KeyEntry(
        key: 'RELATIONS',
        purpose: 'Relationships between entities in a schema',
        explanation:
            'Describes how database tables or domain models relate to each other. '
            'Common in database schema generation — the AI uses these to generate '
            'foreign keys, join tables, and ORM association methods.',
        example: 'RELATIONS user has_many posts, post has_many comments',
        compactOutput: 'RELATIONS: user has_many posts, post has_many comments',
        expandedOutput: 'Relations: user has_many posts, post has_many comments.',
      ),
      _KeyEntry(
        key: 'INDEXES',
        purpose: 'Database columns that need indexes',
        explanation:
            'Specifies which columns should be indexed for query performance. '
            'The AI generates the appropriate CREATE INDEX statements or migration code. '
            'Use dot notation to specify table.column.',
        example: 'INDEXES users.email, posts.created_at, posts.user_id',
        compactOutput: 'INDEXES: users.email, posts.created_at, posts.user_id',
        expandedOutput: 'Indexes: users.email, posts.created_at, posts.user_id.',
      ),
      _KeyEntry(
        key: 'TABLES',
        purpose: 'Database tables to include in a schema',
        explanation:
            'Lists the tables that make up a database schema. '
            'The AI generates a CREATE TABLE statement for each one, inferring sensible columns '
            'unless you use RELATIONS and CONSTRAINTS to be more specific.',
        example: 'TABLES users, sessions, posts, comments, tags',
        compactOutput: 'TABLES: users, sessions, posts, comments, tags',
        expandedOutput: 'Tables: users, sessions, posts, comments, tags.',
      ),
      _KeyEntry(
        key: 'FOCUS',
        purpose: 'Specific areas to emphasize in a review or analysis',
        explanation:
            'Tells the AI where to concentrate its attention. '
            'Useful for code reviews, architecture reviews, and audits '
            'where you want depth on specific dimensions rather than a broad shallow scan.',
        example: 'FOCUS security, performance, readability',
        compactOutput: 'FOCUS: security, performance, readability',
        expandedOutput: 'Focus: security, performance, readability.',
      ),
      _KeyEntry(
        key: 'PATTERNS',
        purpose: 'Design patterns or principles to follow or enforce',
        explanation:
            'Lists coding patterns or software principles the output must follow. '
            'For code generation this shapes class design and method structure. '
            'For code review it becomes the criteria the AI evaluates against.',
        example: 'PATTERNS SOLID, DRY, no magic numbers',
        compactOutput: 'PATTERNS: SOLID, DRY, no magic numbers',
        expandedOutput: 'Patterns: SOLID, DRY, no magic numbers.',
      ),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_KeyEntry> get _visibleKeys {
    if (_query.isNotEmpty) {
      // Search across all categories
      return _categories
          .expand((c) => c.keys)
          .where((k) =>
              k.key.toLowerCase().contains(_query) ||
              k.purpose.toLowerCase().contains(_query) ||
              k.explanation.toLowerCase().contains(_query) ||
              k.example.toLowerCase().contains(_query))
          .toList();
    }
    return _categories[_selectedCategory].keys;
  }

  bool get _isSearching => _query.isNotEmpty;

  int _totalKeys() => _categories.fold(0, (sum, c) => sum + c.keys.length);

  @override
  Widget build(BuildContext context) {
    final keys = _visibleKeys;

    return Row(
      children: [
        // ── Sidebar ────────────────────────────────────────────────
        Container(
          width: 210,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DSL KEY REFERENCE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_totalKeys()} keys across ${_categories.length} categories',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textDisabled),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              // Category list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    final active = !_isSearching && i == _selectedCategory;
                    return _SidebarItem(
                      label: cat.name,
                      icon: cat.icon,
                      color: cat.color,
                      count: cat.keys.length,
                      active: active,
                      onTap: () => setState(() {
                        _selectedCategory = i;
                        _searchCtrl.clear();
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ── Main content ───────────────────────────────────────────
        Expanded(
          child: Column(
            children: [
              // Search bar
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: _isSearching
                              ? 'Searching all ${_totalKeys()} keys…'
                              : 'Search keys, descriptions, or examples…',
                          hintStyle: const TextStyle(
                              fontSize: 13, color: AppColors.textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_isSearching) ...[
                      Text(
                        '${keys.length} result${keys.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _searchCtrl.clear(),
                        child: const Icon(Icons.close,
                            size: 14, color: AppColors.textSecondary),
                      ),
                    ] else ...[
                      // Category heading
                      Text(
                        _categories[_selectedCategory].name,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${_categories[_selectedCategory].keys.length}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Key cards
              Expanded(
                child: keys.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 32, color: AppColors.textDisabled),
                            SizedBox(height: 8),
                            Text(
                              'No keys match your search',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : Scrollbar(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: keys.length,
                          itemBuilder: (_, i) {
                            final cat = _isSearching
                                ? _categoryForKey(keys[i])
                                : _categories[_selectedCategory];
                            return _KeyCard(
                              entry: keys[i],
                              accentColor: cat?.color ?? AppColors.accent,
                              showCategory: _isSearching,
                              categoryName: cat?.name ?? '',
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _Category? _categoryForKey(_KeyEntry entry) {
    for (final cat in _categories) {
      if (cat.keys.any((k) => k.key == entry.key)) return cat;
    }
    return null;
  }
}

// ── Sidebar item ──────────────────────────────────────────────────────────────

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.surfaceHover
                : _hovered
                    ? AppColors.surfaceElevated
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.active ? widget.color : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 13,
                color: widget.active ? widget.color : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: widget.active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.active
                      ? AppColors.surfaceElevated
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.active
                        ? AppColors.textSecondary
                        : AppColors.textDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Key card ──────────────────────────────────────────────────────────────────

class _KeyCard extends StatefulWidget {
  const _KeyCard({
    required this.entry,
    required this.accentColor,
    required this.showCategory,
    required this.categoryName,
  });

  final _KeyEntry entry;
  final Color accentColor;
  final bool showCategory;
  final String categoryName;

  @override
  State<_KeyCard> createState() => _KeyCardState();
}

class _KeyCardState extends State<_KeyCard> {
  bool _copiedExample = false;
  bool _expanded = false;

  void _copyExample() {
    Clipboard.setData(ClipboardData(text: widget.entry.example));
    setState(() => _copiedExample = true);
    Future.delayed(
        const Duration(seconds: 2), () => setState(() => _copiedExample = false));
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final hasOutputPreviews =
        e.compactOutput.isNotEmpty || e.expandedOutput.isNotEmpty;
    final hasNotes = e.notes.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Key badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    e.key,
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: widget.accentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      e.purpose,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                if (widget.showCategory)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      widget.categoryName,
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary),
                    ),
                  ),
              ],
            ),
          ),

          // ── Explanation ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              e.explanation,
              style: const TextStyle(
                fontSize: 12,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          // ── Example row ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                const Text(
                  'EXAMPLE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDisabled,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      e.example,
                      style: const TextStyle(
                        fontFamily: 'Consolas',
                        fontSize: 12,
                        color: AppColors.syntaxKey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _CopyButton(
                  copied: _copiedExample,
                  onTap: _copyExample,
                ),
              ],
            ),
          ),

          // ── Toggle for output previews + notes ──────────────────
          if (hasOutputPreviews || hasNotes)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 14,
                        color: AppColors.textDisabled,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _expanded ? 'Hide output previews' : 'Show output previews',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_expanded && (hasOutputPreviews || hasNotes))
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.compactOutput.isNotEmpty)
                    _OutputPreviewRow(
                      label: 'COMPACT',
                      value: e.compactOutput,
                      color: AppColors.syntaxComma,
                    ),
                  if (e.expandedOutput.isNotEmpty)
                    _OutputPreviewRow(
                      label: 'EXPANDED',
                      value: e.expandedOutput,
                      color: AppColors.syntaxValue,
                    ),
                  if (hasNotes) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 72,
                          child: Text(
                            'NOTES',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDisabled,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.notes,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

// ── Output preview row ────────────────────────────────────────────────────────

class _OutputPreviewRow extends StatelessWidget {
  const _OutputPreviewRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textDisabled,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Consolas',
                fontSize: 11,
                height: 1.5,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Copy button ───────────────────────────────────────────────────────────────

class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.copied, required this.onTap});

  final bool copied;
  final VoidCallback onTap;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceHover : AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.copied ? Icons.check : Icons.copy_outlined,
                size: 13,
                color:
                    widget.copied ? AppColors.success : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                widget.copied ? 'Copied' : 'Copy',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.copied
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
