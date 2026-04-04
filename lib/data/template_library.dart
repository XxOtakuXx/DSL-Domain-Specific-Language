import 'package:flutter/material.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class TemplateItem {
  const TemplateItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.dsl,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final String dsl;
}

class TemplateCategory {
  const TemplateCategory({
    required this.name,
    required this.icon,
  });

  final String name;
  final IconData icon;
}

// ── Categories ────────────────────────────────────────────────────────────────

const List<TemplateCategory> kTemplateCategories = [
  TemplateCategory(name: 'Software Dev', icon: Icons.code),
  TemplateCategory(name: 'Mobile', icon: Icons.phone_android),
  TemplateCategory(name: 'API Design', icon: Icons.api),
  TemplateCategory(name: 'Content & Writing', icon: Icons.edit_note),
  TemplateCategory(name: 'AI & Prompts', icon: Icons.auto_awesome),
  TemplateCategory(name: 'DevOps', icon: Icons.rocket_launch),
  TemplateCategory(name: 'Data & ML', icon: Icons.bar_chart),
  TemplateCategory(name: 'Business', icon: Icons.business_center),
  TemplateCategory(name: 'Education', icon: Icons.school),
  TemplateCategory(name: 'Creative', icon: Icons.palette),
  TemplateCategory(name: 'Legal & HR', icon: Icons.gavel),
  TemplateCategory(name: 'Research', icon: Icons.science),
  TemplateCategory(name: 'E-Commerce', icon: Icons.shopping_cart),
  TemplateCategory(name: 'Artificial Intelligence', icon: Icons.psychology),
  TemplateCategory(name: 'Cybersecurity', icon: Icons.security),
  TemplateCategory(name: 'Data Engineering', icon: Icons.storage),
  TemplateCategory(name: 'Cloud & Infrastructure', icon: Icons.cloud),
  TemplateCategory(name: 'Information Technology', icon: Icons.computer),
  TemplateCategory(name: 'Security Systems', icon: Icons.shield),
  TemplateCategory(name: 'Engineering', icon: Icons.engineering),
  TemplateCategory(name: 'Reverse Engineering', icon: Icons.build_circle),
  TemplateCategory(name: 'Mathematics', icon: Icons.functions),
  TemplateCategory(name: 'Science', icon: Icons.biotech),
  TemplateCategory(name: 'Cryptography & Blockchain', icon: Icons.currency_bitcoin),
];

// ── Template library ──────────────────────────────────────────────────────────

const List<TemplateItem> kTemplates = [

  // ── Software Dev ──────────────────────────────────────────────────────────

  TemplateItem(
    id: 'sw_fullstack_web',
    title: 'Full-stack Web App',
    description: 'React frontend + Node.js backend with auth and database',
    category: 'Software Dev',
    tags: ['web', 'fullstack', 'react', 'nodejs', 'database', 'auth'],
    dsl: '''CREATE app
TYPE fullstack-web
STACK React, Node.js, PostgreSQL
FEATURES auth, dashboard, REST API, file uploads
STYLE modern dark
AUTH jwt
DATABASE postgres
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_rest_api',
    title: 'REST API',
    description: 'CRUD REST API with authentication and rate limiting',
    category: 'Software Dev',
    tags: ['api', 'rest', 'backend', 'crud', 'server'],
    dsl: '''CREATE api
TYPE REST
STACK Node.js, Express, MongoDB
ENDPOINTS users, products, orders
AUTH jwt, api-key
FEATURES rate-limiting, pagination, validation, error-handling
OUTPUT full code with tests''',
  ),

  TemplateItem(
    id: 'sw_graphql_api',
    title: 'GraphQL API',
    description: 'GraphQL server with resolvers, mutations, and subscriptions',
    category: 'Software Dev',
    tags: ['graphql', 'api', 'backend', 'subscriptions'],
    dsl: '''CREATE api
TYPE GraphQL
STACK Node.js, Apollo Server, PostgreSQL
SCHEMA users, posts, comments
FEATURES queries, mutations, subscriptions, auth
AUTH jwt
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_microservice',
    title: 'Microservice',
    description: 'Standalone microservice with message queue integration',
    category: 'Software Dev',
    tags: ['microservice', 'docker', 'queue', 'backend'],
    dsl: '''CREATE service
TYPE microservice
STACK Node.js, RabbitMQ, Redis
PURPOSE order-processing
FEATURES message-queue, caching, health-checks, logging
DEPLOY docker
OUTPUT full code with Dockerfile''',
  ),

  TemplateItem(
    id: 'sw_database_schema',
    title: 'Database Schema',
    description: 'Relational database schema with migrations and seed data',
    category: 'Software Dev',
    tags: ['database', 'sql', 'schema', 'migrations', 'postgres'],
    dsl: '''CREATE schema
TYPE relational
DATABASE PostgreSQL
TABLES users, products, orders, categories, reviews
FEATURES indexes, constraints, foreign-keys, soft-deletes
OUTPUT SQL migrations and seed data''',
  ),

  TemplateItem(
    id: 'sw_auth_system',
    title: 'Auth System',
    description: 'Complete authentication with OAuth, MFA, and session management',
    category: 'Software Dev',
    tags: ['auth', 'oauth', 'security', 'mfa', 'sessions'],
    dsl: '''CREATE system
TYPE authentication
STACK Node.js, Passport.js, Redis
FEATURES registration, login, oauth, mfa, password-reset, sessions
PROVIDERS google, github
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_realtime_chat',
    title: 'Real-time Chat',
    description: 'WebSocket chat app with rooms, presence, and message history',
    category: 'Software Dev',
    tags: ['chat', 'websocket', 'realtime', 'rooms'],
    dsl: '''CREATE app
TYPE real-time chat
STACK Node.js, Socket.io, React, Redis
FEATURES rooms, presence, history, typing-indicators, file-sharing
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_admin_dashboard',
    title: 'Admin Dashboard',
    description: 'Data-rich admin panel with charts, tables, and CRUD',
    category: 'Software Dev',
    tags: ['admin', 'dashboard', 'charts', 'crud', 'frontend'],
    dsl: '''CREATE app
TYPE admin-dashboard
STACK React, Recharts, Tailwind CSS
FEATURES user-management, analytics, data-tables, charts, export
ROLE admin-only
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_browser_extension',
    title: 'Browser Extension',
    description: 'Chrome/Firefox extension with popup, background, and content script',
    category: 'Software Dev',
    tags: ['extension', 'browser', 'chrome', 'firefox'],
    dsl: '''CREATE extension
TYPE browser
TARGET Chrome, Firefox
FEATURES popup, background-worker, content-script, storage
PURPOSE productivity
OUTPUT full code with manifest.json''',
  ),

  TemplateItem(
    id: 'sw_cli_tool',
    title: 'CLI Tool',
    description: 'Command-line tool with subcommands, flags, and config files',
    category: 'Software Dev',
    tags: ['cli', 'terminal', 'tool', 'commands'],
    dsl: '''CREATE tool
TYPE CLI
LANGUAGE Node.js
FEATURES subcommands, flags, config-file, interactive-prompts, color-output
COMMANDS init, build, deploy, status
OUTPUT full code with README''',
  ),

  TemplateItem(
    id: 'sw_desktop_app',
    title: 'Desktop App',
    description: 'Cross-platform desktop app with Electron and React',
    category: 'Software Dev',
    tags: ['desktop', 'electron', 'cross-platform', 'native'],
    dsl: '''CREATE app
TYPE desktop
STACK Electron, React, SQLite
PLATFORM Windows, macOS, Linux
FEATURES native-menus, file-system, notifications, auto-update
OUTPUT full code with build config''',
  ),

  TemplateItem(
    id: 'sw_data_dashboard',
    title: 'Data Dashboard',
    description: 'Real-time data visualization dashboard with live updates',
    category: 'Software Dev',
    tags: ['dashboard', 'charts', 'data', 'visualization'],
    dsl: '''CREATE app
TYPE data-dashboard
STACK React, D3.js, WebSocket
FEATURES live-charts, filters, drill-down, export, dark-mode
DATA real-time streams
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_ecommerce',
    title: 'E-commerce Platform',
    description: 'Full e-commerce solution with cart, checkout, and payments',
    category: 'Software Dev',
    tags: ['ecommerce', 'shop', 'payments', 'cart', 'stripe'],
    dsl: '''CREATE app
TYPE e-commerce
STACK Next.js, Stripe, PostgreSQL, Redis
FEATURES catalog, cart, checkout, payments, orders, admin
AUTH jwt
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'sw_saas_boilerplate',
    title: 'SaaS Boilerplate',
    description: 'Production-ready SaaS starter with billing and multi-tenancy',
    category: 'Software Dev',
    tags: ['saas', 'multi-tenant', 'billing', 'subscriptions'],
    dsl: '''CREATE app
TYPE SaaS
STACK Next.js, Prisma, Stripe, NextAuth
FEATURES multi-tenancy, billing, subscriptions, team-management, onboarding
OUTPUT full code with deployment config''',
  ),

  // ── Mobile ────────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'mob_flutter',
    title: 'Flutter App',
    description: 'Cross-platform Flutter app with state management and navigation',
    category: 'Mobile',
    tags: ['flutter', 'dart', 'mobile', 'cross-platform'],
    dsl: '''CREATE app
TYPE mobile
FRAMEWORK Flutter
STATE Riverpod
FEATURES auth, navigation, local-storage, push-notifications, dark-mode
PLATFORM Android, iOS
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'mob_react_native',
    title: 'React Native App',
    description: 'React Native app with Expo, navigation, and native modules',
    category: 'Mobile',
    tags: ['react-native', 'expo', 'mobile', 'javascript'],
    dsl: '''CREATE app
TYPE mobile
FRAMEWORK React Native
TOOLS Expo, React Navigation
FEATURES auth, tabs, push-notifications, camera, offline
PLATFORM Android, iOS
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'mob_ios',
    title: 'iOS App',
    description: 'Native SwiftUI app with Core Data and CloudKit sync',
    category: 'Mobile',
    tags: ['ios', 'swift', 'swiftui', 'native', 'apple'],
    dsl: '''CREATE app
TYPE iOS
LANGUAGE Swift
UI SwiftUI
FEATURES core-data, cloudkit, push-notifications, widgets, dark-mode
TARGET iPhone, iPad
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'mob_android',
    title: 'Android App',
    description: 'Native Android app with Jetpack Compose and Room database',
    category: 'Mobile',
    tags: ['android', 'kotlin', 'compose', 'jetpack'],
    dsl: '''CREATE app
TYPE Android
LANGUAGE Kotlin
UI Jetpack Compose
FEATURES room, viewmodel, navigation, notifications, material3
OUTPUT full code''',
  ),

  // ── API Design ────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'api_rest_crud',
    title: 'REST CRUD API',
    description: 'Standard RESTful CRUD with OpenAPI docs and validation',
    category: 'API Design',
    tags: ['rest', 'crud', 'openapi', 'validation'],
    dsl: '''CREATE api
TYPE REST CRUD
RESOURCE products
OPERATIONS create, read, update, delete, list
FEATURES pagination, filtering, sorting, validation, openapi-docs
AUTH bearer-token
OUTPUT full code and OpenAPI spec''',
  ),

  TemplateItem(
    id: 'api_graphql',
    title: 'GraphQL API',
    description: 'GraphQL schema with types, resolvers, and DataLoader',
    category: 'API Design',
    tags: ['graphql', 'schema', 'resolvers', 'dataloader'],
    dsl: '''CREATE api
TYPE GraphQL
SCHEMA users, posts, comments, tags
FEATURES queries, mutations, subscriptions, n+1-prevention, auth
OUTPUT SDL schema and resolver code''',
  ),

  TemplateItem(
    id: 'api_websocket',
    title: 'WebSocket Server',
    description: 'WebSocket server with rooms, broadcasting, and heartbeat',
    category: 'API Design',
    tags: ['websocket', 'realtime', 'socket', 'server'],
    dsl: '''CREATE server
TYPE WebSocket
STACK Node.js, ws
FEATURES rooms, broadcasting, heartbeat, reconnection, auth
EVENTS connect, message, disconnect, error
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'api_grpc',
    title: 'gRPC Service',
    description: 'gRPC service with protobuf definitions and streaming',
    category: 'API Design',
    tags: ['grpc', 'protobuf', 'streaming', 'rpc'],
    dsl: '''CREATE service
TYPE gRPC
LANGUAGE Go
FEATURES unary, server-streaming, client-streaming, bidirectional
PURPOSE user-management
OUTPUT proto file and Go implementation''',
  ),

  TemplateItem(
    id: 'api_openapi',
    title: 'OpenAPI Spec',
    description: 'Complete OpenAPI 3.0 specification with examples and schemas',
    category: 'API Design',
    tags: ['openapi', 'swagger', 'spec', 'documentation'],
    dsl: '''CREATE spec
TYPE OpenAPI 3.0
API payment-gateway
ENDPOINTS /payments, /refunds, /customers, /webhooks
FEATURES request-schemas, response-schemas, examples, security
OUTPUT YAML specification''',
  ),

  // ── Content & Writing ─────────────────────────────────────────────────────

  TemplateItem(
    id: 'cw_blog_post',
    title: 'Blog Post',
    description: 'SEO-optimized technical blog post with code examples',
    category: 'Content & Writing',
    tags: ['blog', 'writing', 'seo', 'content'],
    dsl: '''CREATE content
TYPE blog-post
TOPIC "Modern State Management in React"
AUDIENCE intermediate developers
TONE conversational, technical
LENGTH 1500 words
FEATURES intro, examples, pros-cons, conclusion, meta-description
OUTPUT full article''',
  ),

  TemplateItem(
    id: 'cw_technical_article',
    title: 'Technical Article',
    description: 'In-depth technical article with diagrams and benchmarks',
    category: 'Content & Writing',
    tags: ['technical', 'article', 'writing', 'deep-dive'],
    dsl: '''CREATE content
TYPE technical-article
TOPIC "Building Scalable Microservices"
AUDIENCE senior engineers
TONE authoritative, precise
LENGTH 3000 words
FEATURES architecture, code-examples, benchmarks, tradeoffs
OUTPUT full article''',
  ),

  TemplateItem(
    id: 'cw_newsletter',
    title: 'Newsletter',
    description: 'Weekly dev newsletter with news roundup and tips',
    category: 'Content & Writing',
    tags: ['newsletter', 'email', 'weekly', 'roundup'],
    dsl: '''CREATE content
TYPE newsletter
NICHE software development
FORMAT weekly
SECTIONS news-roundup, tutorial, tip-of-week, tool-spotlight
TONE friendly, professional
LENGTH 800 words
OUTPUT email-ready content''',
  ),

  TemplateItem(
    id: 'cw_linkedin',
    title: 'LinkedIn Post',
    description: 'Engaging LinkedIn post for thought leadership',
    category: 'Content & Writing',
    tags: ['linkedin', 'social', 'thought-leadership', 'professional'],
    dsl: '''CREATE content
TYPE LinkedIn-post
TOPIC "Lessons from shipping 10 side projects"
TONE personal, insightful
HOOK strong opening line
FEATURES story, lessons, call-to-action
LENGTH 250 words
OUTPUT ready-to-post text''',
  ),

  TemplateItem(
    id: 'cw_twitter_thread',
    title: 'Twitter/X Thread',
    description: 'Viral-style Twitter thread on a technical topic',
    category: 'Content & Writing',
    tags: ['twitter', 'thread', 'social', 'viral'],
    dsl: '''CREATE content
TYPE Twitter-thread
TOPIC "10 VS Code shortcuts that changed my life"
TONE casual, punchy
TWEETS 12
FEATURES hook-tweet, numbered-tips, closing-cta
OUTPUT numbered thread''',
  ),

  TemplateItem(
    id: 'cw_youtube_script',
    title: 'YouTube Script',
    description: 'Full YouTube video script with intro hook and timestamps',
    category: 'Content & Writing',
    tags: ['youtube', 'video', 'script', 'content'],
    dsl: '''CREATE content
TYPE YouTube-script
TOPIC "Build a SaaS in a Weekend"
DURATION 12 minutes
STYLE tutorial, energetic
FEATURES hook, chapters, transitions, outro, description
OUTPUT full script with timestamps''',
  ),

  TemplateItem(
    id: 'cw_product_description',
    title: 'Product Description',
    description: 'Compelling product page copy that converts',
    category: 'Content & Writing',
    tags: ['product', 'copy', 'marketing', 'conversion'],
    dsl: '''CREATE content
TYPE product-description
PRODUCT "AI-powered code review tool"
AUDIENCE developer teams
TONE professional, benefit-driven
FEATURES headline, benefits, social-proof, cta
OUTPUT landing page copy''',
  ),

  TemplateItem(
    id: 'cw_landing_page',
    title: 'Landing Page Copy',
    description: 'High-converting SaaS landing page copy',
    category: 'Content & Writing',
    tags: ['landing-page', 'copy', 'saas', 'conversion'],
    dsl: '''CREATE content
TYPE landing-page
PRODUCT developer-productivity-tool
SECTIONS hero, features, social-proof, pricing, faq, cta
TONE confident, clear
TARGET developers and engineering leads
OUTPUT full page copy''',
  ),

  TemplateItem(
    id: 'cw_press_release',
    title: 'Press Release',
    description: 'Official press release for a product launch',
    category: 'Content & Writing',
    tags: ['press-release', 'pr', 'launch', 'announcement'],
    dsl: '''CREATE content
TYPE press-release
EVENT product-launch
COMPANY TechStartup Inc.
PRODUCT "CodeReview AI"
FORMAT AP-style
FEATURES headline, dateline, body, quotes, boilerplate
OUTPUT ready-to-distribute release''',
  ),

  TemplateItem(
    id: 'cw_white_paper',
    title: 'White Paper',
    description: 'Authoritative white paper on a technical subject',
    category: 'Content & Writing',
    tags: ['whitepaper', 'research', 'technical', 'b2b'],
    dsl: '''CREATE content
TYPE white-paper
TOPIC "The Future of Developer Productivity"
AUDIENCE CTOs and engineering managers
LENGTH 5000 words
SECTIONS executive-summary, problem, analysis, solution, conclusion
OUTPUT full document''',
  ),

  // ── AI & Prompts ──────────────────────────────────────────────────────────

  TemplateItem(
    id: 'ai_system_prompt',
    title: 'System Prompt',
    description: 'General-purpose assistant system prompt with persona and rules',
    category: 'AI & Prompts',
    tags: ['system-prompt', 'assistant', 'persona', 'llm'],
    dsl: '''CREATE prompt
TYPE system
ROLE helpful AI assistant
PERSONA professional, concise, accurate
RULES no-hallucination, cite-sources, ask-clarifying-questions
TONE balanced, friendly
OUTPUT ready-to-use system prompt''',
  ),

  TemplateItem(
    id: 'ai_code_review_bot',
    title: 'Code Review Bot',
    description: 'AI code reviewer with style, security, and performance checks',
    category: 'AI & Prompts',
    tags: ['code-review', 'ai', 'bot', 'security', 'quality'],
    dsl: '''CREATE prompt
TYPE code-review-bot
CHECKS style, security, performance, best-practices, tests
LANGUAGE-SPECIFIC yes
OUTPUT format: severity, location, suggestion
TONE constructive, specific
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_research_assistant',
    title: 'Research Assistant',
    description: 'AI research helper that synthesizes sources and cites evidence',
    category: 'AI & Prompts',
    tags: ['research', 'assistant', 'synthesis', 'citations'],
    dsl: '''CREATE prompt
TYPE research-assistant
CAPABILITIES search, summarize, compare, cite, outline
DOMAIN general academic
OUTPUT formats: summary, outline, citation
RULES always-cite, note-uncertainty, structured-output
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_data_analyst',
    title: 'Data Analyst',
    description: 'AI data analyst that interprets data and generates insights',
    category: 'AI & Prompts',
    tags: ['data', 'analysis', 'insights', 'statistics'],
    dsl: '''CREATE prompt
TYPE data-analyst
SKILLS statistics, visualization-recommendations, trend-detection
INPUT CSV, JSON, plain-text data
OUTPUT insights, charts-description, recommendations
FORMAT structured markdown
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_tutor',
    title: 'Tutor',
    description: 'Adaptive AI tutor that adjusts to student knowledge level',
    category: 'AI & Prompts',
    tags: ['tutor', 'education', 'adaptive', 'learning'],
    dsl: '''CREATE prompt
TYPE AI-tutor
SUBJECT programming
STYLE socratic, adaptive
FEATURES assess-level, explain-concepts, practice-problems, feedback
TONE encouraging, patient
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_customer_support',
    title: 'Customer Support Bot',
    description: 'AI support agent with escalation and knowledge base lookup',
    category: 'AI & Prompts',
    tags: ['support', 'customer-service', 'bot', 'helpdesk'],
    dsl: '''CREATE prompt
TYPE customer-support-bot
COMPANY SaaS product
TONE empathetic, professional
FEATURES faq-lookup, escalation-path, ticket-creation, status-check
RULES never-promise-refunds, escalate-billing-issues
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_sales_coach',
    title: 'Sales Coach',
    description: 'AI sales coach for objection handling and pitch practice',
    category: 'AI & Prompts',
    tags: ['sales', 'coaching', 'objections', 'pitch'],
    dsl: '''CREATE prompt
TYPE sales-coach
METHODOLOGY SPIN selling, challenger sale
FEATURES roleplay, objection-handling, pitch-feedback, scripts
TONE motivating, direct
OUTPUT system prompt''',
  ),

  TemplateItem(
    id: 'ai_creative_writer',
    title: 'Creative Writing Partner',
    description: 'AI creative collaborator for fiction, worldbuilding, and editing',
    category: 'AI & Prompts',
    tags: ['creative', 'writing', 'fiction', 'collaboration'],
    dsl: '''CREATE prompt
TYPE creative-writing-partner
GENRES fantasy, sci-fi, literary fiction
FEATURES brainstorm, draft, edit, feedback, worldbuilding
TONE collaborative, imaginative
OUTPUT system prompt''',
  ),

  // ── DevOps ────────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'devops_github_actions',
    title: 'GitHub Actions CI/CD',
    description: 'CI/CD pipeline with test, build, and deploy stages',
    category: 'DevOps',
    tags: ['github-actions', 'cicd', 'pipeline', 'automation'],
    dsl: '''CREATE pipeline
TYPE GitHub Actions
TRIGGERS push, pull-request, release
STAGES lint, test, build, deploy
TARGET staging, production
FEATURES caching, matrix-testing, secrets, notifications
OUTPUT .github/workflows YAML''',
  ),

  TemplateItem(
    id: 'devops_docker',
    title: 'Docker Setup',
    description: 'Multi-stage Dockerfile with docker-compose for dev and prod',
    category: 'DevOps',
    tags: ['docker', 'containerization', 'compose', 'devops'],
    dsl: '''CREATE config
TYPE Docker
APP Node.js web app
STAGES development, production
FEATURES multi-stage-build, health-check, non-root-user, compose
SERVICES app, database, redis, nginx
OUTPUT Dockerfile and docker-compose.yml''',
  ),

  TemplateItem(
    id: 'devops_kubernetes',
    title: 'Kubernetes Manifests',
    description: 'K8s deployment with services, ingress, and autoscaling',
    category: 'DevOps',
    tags: ['kubernetes', 'k8s', 'deployment', 'containers'],
    dsl: '''CREATE config
TYPE Kubernetes
APP web-service
RESOURCES Deployment, Service, Ingress, HPA, ConfigMap, Secret
REPLICAS 3
FEATURES autoscaling, rolling-updates, health-probes, resource-limits
OUTPUT YAML manifests''',
  ),

  TemplateItem(
    id: 'devops_terraform',
    title: 'Terraform IaC',
    description: 'Terraform configuration for AWS cloud infrastructure',
    category: 'DevOps',
    tags: ['terraform', 'iac', 'aws', 'infrastructure'],
    dsl: '''CREATE infrastructure
TYPE Terraform
PROVIDER AWS
RESOURCES VPC, EC2, RDS, S3, CloudFront, Route53
FEATURES modules, remote-state, workspaces, outputs
ENV dev, staging, production
OUTPUT .tf files''',
  ),

  TemplateItem(
    id: 'devops_monitoring',
    title: 'Monitoring & Alerting',
    description: 'Prometheus and Grafana monitoring stack with alerting rules',
    category: 'DevOps',
    tags: ['monitoring', 'prometheus', 'grafana', 'alerting'],
    dsl: '''CREATE config
TYPE monitoring-stack
TOOLS Prometheus, Grafana, AlertManager
METRICS latency, error-rate, throughput, saturation
ALERTS p99-latency, error-spike, disk-full
DASHBOARDS application, infrastructure
OUTPUT config files''',
  ),

  TemplateItem(
    id: 'devops_security_audit',
    title: 'Security Audit',
    description: 'Automated security scanning pipeline for vulnerabilities',
    category: 'DevOps',
    tags: ['security', 'audit', 'scanning', 'vulnerabilities'],
    dsl: '''CREATE pipeline
TYPE security-audit
TOOLS Snyk, OWASP ZAP, Trivy, SonarQube
CHECKS dependency-vulnerabilities, container-scanning, SAST, DAST
TRIGGER on-merge, weekly-schedule
OUTPUT CI pipeline config and report template''',
  ),

  TemplateItem(
    id: 'devops_db_migration',
    title: 'Database Migration',
    description: 'Safe zero-downtime database migration strategy and scripts',
    category: 'DevOps',
    tags: ['database', 'migration', 'zero-downtime', 'devops'],
    dsl: '''CREATE strategy
TYPE database-migration
DATABASE PostgreSQL
APPROACH expand-contract
FEATURES rollback-plan, data-validation, zero-downtime, audit-log
TOOLS Flyway
OUTPUT migration scripts and runbook''',
  ),

  // ── Data & ML ─────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'ml_pipeline',
    title: 'ML Pipeline',
    description: 'End-to-end machine learning pipeline with training and serving',
    category: 'Data & ML',
    tags: ['machine-learning', 'pipeline', 'training', 'serving'],
    dsl: '''CREATE pipeline
TYPE machine-learning
STACK Python, scikit-learn, MLflow
STAGES data-ingestion, preprocessing, training, evaluation, serving
FEATURES experiment-tracking, versioning, monitoring, retraining
OUTPUT full pipeline code''',
  ),

  TemplateItem(
    id: 'ml_eda',
    title: 'EDA Notebook',
    description: 'Exploratory Data Analysis notebook with visualizations',
    category: 'Data & ML',
    tags: ['eda', 'notebook', 'jupyter', 'visualization', 'analysis'],
    dsl: '''CREATE notebook
TYPE exploratory-data-analysis
STACK Python, pandas, matplotlib, seaborn
SECTIONS data-loading, cleaning, stats, distributions, correlations, insights
DATASET tabular CSV
OUTPUT Jupyter notebook''',
  ),

  TemplateItem(
    id: 'ml_nlp',
    title: 'NLP Model',
    description: 'Text classification model with preprocessing and evaluation',
    category: 'Data & ML',
    tags: ['nlp', 'text', 'classification', 'transformers'],
    dsl: '''CREATE model
TYPE NLP text-classification
STACK Python, Transformers, PyTorch
TASK sentiment-analysis
FEATURES tokenization, fine-tuning, evaluation, inference-API
MODEL bert-base-uncased
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'ml_computer_vision',
    title: 'Computer Vision',
    description: 'Image classification CNN with data augmentation and transfer learning',
    category: 'Data & ML',
    tags: ['computer-vision', 'cnn', 'image', 'classification'],
    dsl: '''CREATE model
TYPE computer-vision
TASK image-classification
STACK Python, PyTorch, torchvision
FEATURES transfer-learning, augmentation, evaluation, deployment
BACKBONE ResNet50
OUTPUT full training code''',
  ),

  TemplateItem(
    id: 'ml_recommendation',
    title: 'Recommendation System',
    description: 'Collaborative filtering recommendation engine',
    category: 'Data & ML',
    tags: ['recommendation', 'collaborative-filtering', 'ml'],
    dsl: '''CREATE system
TYPE recommendation-engine
APPROACH collaborative-filtering, content-based
STACK Python, Surprise, FastAPI
FEATURES user-item-matrix, similarity, cold-start-handling, API
OUTPUT full code''',
  ),

  TemplateItem(
    id: 'ml_ab_test',
    title: 'A/B Test Analysis',
    description: 'Statistical A/B test analysis with significance testing',
    category: 'Data & ML',
    tags: ['ab-test', 'statistics', 'analysis', 'significance'],
    dsl: '''CREATE analysis
TYPE A/B-test
STACK Python, scipy, pandas
METRICS conversion-rate, revenue-per-user
TESTS t-test, chi-squared, bayesian
FEATURES sample-size-calc, significance, confidence-intervals, report
OUTPUT Jupyter notebook''',
  ),

  TemplateItem(
    id: 'ml_data_cleaning',
    title: 'Data Cleaning Script',
    description: 'Robust data pipeline for cleaning and validating datasets',
    category: 'Data & ML',
    tags: ['data-cleaning', 'etl', 'validation', 'pipeline'],
    dsl: '''CREATE script
TYPE data-cleaning
STACK Python, pandas, Great Expectations
STEPS missing-values, duplicates, outliers, type-casting, validation
INPUT raw CSV files
OUTPUT clean parquet + validation report
OUTPUT full code''',
  ),

  // ── Business ──────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'biz_business_plan',
    title: 'Business Plan',
    description: 'Comprehensive business plan for a tech startup',
    category: 'Business',
    tags: ['business-plan', 'startup', 'strategy', 'financials'],
    dsl: '''CREATE document
TYPE business-plan
COMPANY AI-powered SaaS startup
SECTIONS executive-summary, market-analysis, product, go-to-market, financials, team
LENGTH comprehensive
OUTPUT full business plan''',
  ),

  TemplateItem(
    id: 'biz_pitch_deck',
    title: 'Pitch Deck',
    description: 'Investor pitch deck outline with narrative and key slides',
    category: 'Business',
    tags: ['pitch-deck', 'investor', 'startup', 'fundraising'],
    dsl: '''CREATE presentation
TYPE pitch-deck
SLIDES problem, solution, market-size, product, traction, business-model, team, ask
AUDIENCE seed investors
STYLE clean, data-driven
OUTPUT slide outline with speaker notes''',
  ),

  TemplateItem(
    id: 'biz_competitive_analysis',
    title: 'Competitive Analysis',
    description: 'Framework for analyzing competitors across key dimensions',
    category: 'Business',
    tags: ['competitive', 'analysis', 'strategy', 'market'],
    dsl: '''CREATE analysis
TYPE competitive
DIMENSIONS features, pricing, positioning, strengths, weaknesses
COMPETITORS 5
FORMAT comparison-matrix
PRODUCT developer-tools SaaS
OUTPUT structured analysis''',
  ),

  TemplateItem(
    id: 'biz_gtm',
    title: 'Go-to-Market Strategy',
    description: 'GTM plan with channels, ICP, and launch milestones',
    category: 'Business',
    tags: ['gtm', 'marketing', 'launch', 'strategy'],
    dsl: '''CREATE strategy
TYPE go-to-market
PRODUCT B2B SaaS developer tool
ICP early-stage startups
CHANNELS content-marketing, product-led-growth, partnerships
MILESTONES beta, launch, scale
OUTPUT GTM plan document''',
  ),

  TemplateItem(
    id: 'biz_okr',
    title: 'OKR Framework',
    description: 'Quarterly OKRs for an engineering team',
    category: 'Business',
    tags: ['okr', 'goals', 'engineering', 'planning'],
    dsl: '''CREATE framework
TYPE OKR
TEAM engineering
QUARTER Q2 2025
OBJECTIVES 3
KEY-RESULTS 3 per objective
FOCUS velocity, quality, reliability
OUTPUT formatted OKR document''',
  ),

  TemplateItem(
    id: 'biz_product_roadmap',
    title: 'Product Roadmap',
    description: 'Quarterly product roadmap with themes and initiatives',
    category: 'Business',
    tags: ['roadmap', 'product', 'planning', 'strategy'],
    dsl: '''CREATE document
TYPE product-roadmap
HORIZONS Q1, Q2, Q3, Q4
THEMES performance, user-experience, integrations, enterprise
FORMAT now-next-later
OUTPUT roadmap document''',
  ),

  TemplateItem(
    id: 'biz_swot',
    title: 'SWOT Analysis',
    description: 'Structured SWOT analysis for strategic decision-making',
    category: 'Business',
    tags: ['swot', 'analysis', 'strategy', 'planning'],
    dsl: '''CREATE analysis
TYPE SWOT
CONTEXT early-stage B2B SaaS
SECTIONS strengths, weaknesses, opportunities, threats
DEPTH detailed with action-items
OUTPUT structured analysis''',
  ),

  TemplateItem(
    id: 'biz_project_brief',
    title: 'Project Brief',
    description: 'Clear project brief with scope, goals, and success metrics',
    category: 'Business',
    tags: ['project', 'brief', 'scope', 'planning'],
    dsl: '''CREATE document
TYPE project-brief
PROJECT new feature rollout
SECTIONS background, goals, scope, out-of-scope, success-metrics, timeline, stakeholders
OUTPUT ready-to-share brief''',
  ),

  // ── Education ─────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'edu_course_outline',
    title: 'Course Outline',
    description: 'Structured course curriculum with modules and learning objectives',
    category: 'Education',
    tags: ['course', 'curriculum', 'learning', 'modules'],
    dsl: '''CREATE curriculum
TYPE course-outline
SUBJECT "Full-Stack Web Development"
DURATION 12 weeks
MODULES 12
FEATURES learning-objectives, prerequisites, assessments, resources
OUTPUT full course outline''',
  ),

  TemplateItem(
    id: 'edu_study_guide',
    title: 'Study Guide',
    description: 'Comprehensive study guide with key concepts and review questions',
    category: 'Education',
    tags: ['study', 'guide', 'review', 'concepts'],
    dsl: '''CREATE document
TYPE study-guide
SUBJECT "System Design Interview Prep"
SECTIONS key-concepts, examples, common-questions, cheatsheet
AUDIENCE software engineers
OUTPUT study guide document''',
  ),

  TemplateItem(
    id: 'edu_lesson_plan',
    title: 'Lesson Plan',
    description: 'Detailed lesson plan with activities and assessment',
    category: 'Education',
    tags: ['lesson', 'plan', 'teaching', 'activities'],
    dsl: '''CREATE plan
TYPE lesson
SUBJECT "Introduction to Algorithms"
DURATION 90 minutes
SECTIONS warm-up, instruction, activity, discussion, assessment
LEVEL undergraduate
OUTPUT full lesson plan''',
  ),

  TemplateItem(
    id: 'edu_quiz_generator',
    title: 'Quiz Generator',
    description: 'Multiple-choice and short-answer quiz on a technical topic',
    category: 'Education',
    tags: ['quiz', 'assessment', 'questions', 'test'],
    dsl: '''CREATE assessment
TYPE quiz
TOPIC "JavaScript Fundamentals"
QUESTIONS 20
TYPES multiple-choice, true-false, short-answer
DIFFICULTY beginner to intermediate
OUTPUT quiz with answer key''',
  ),

  TemplateItem(
    id: 'edu_explainer',
    title: 'Explainer Article',
    description: 'Clear explainer on a complex technical concept',
    category: 'Education',
    tags: ['explainer', 'tutorial', 'technical', 'learning'],
    dsl: '''CREATE content
TYPE explainer-article
TOPIC "How Distributed Systems Work"
AUDIENCE beginners
STYLE analogies, progressive-complexity
FEATURES visuals-described, examples, summary, further-reading
OUTPUT full article''',
  ),

  // ── Creative ──────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'cr_short_story',
    title: 'Short Story',
    description: 'Original short story with character arc and plot structure',
    category: 'Creative',
    tags: ['fiction', 'story', 'narrative', 'creative-writing'],
    dsl: '''CREATE story
TYPE short-fiction
GENRE science fiction
THEME "consequences of AI"
POV first-person
LENGTH 2000 words
STRUCTURE setup, conflict, climax, resolution
OUTPUT full story''',
  ),

  TemplateItem(
    id: 'cr_worldbuilding',
    title: 'World Building',
    description: 'Detailed fictional world with lore, geography, and factions',
    category: 'Creative',
    tags: ['worldbuilding', 'fantasy', 'lore', 'fiction'],
    dsl: '''CREATE world
TYPE fictional
GENRE epic fantasy
ELEMENTS geography, history, magic-system, factions, cultures
DETAIL level-of-detail: comprehensive
OUTPUT world bible document''',
  ),

  TemplateItem(
    id: 'cr_character',
    title: 'Character Creation',
    description: 'Deep character profile with backstory, motivations, and arc',
    category: 'Creative',
    tags: ['character', 'profile', 'fiction', 'backstory'],
    dsl: '''CREATE character
TYPE protagonist
GENRE contemporary thriller
SECTIONS backstory, personality, motivations, flaws, relationships, arc
DEPTH psychological depth
OUTPUT full character profile''',
  ),

  TemplateItem(
    id: 'cr_screenplay',
    title: 'Screenplay',
    description: 'Properly formatted screenplay scene or short film',
    category: 'Creative',
    tags: ['screenplay', 'script', 'film', 'dialogue'],
    dsl: '''CREATE script
TYPE screenplay
FORMAT industry-standard
GENRE drama
SCENES 5
LENGTH 10 pages
FEATURES action-lines, dialogue, scene-headings
OUTPUT formatted screenplay''',
  ),

  TemplateItem(
    id: 'cr_game_design',
    title: 'Game Design Document',
    description: 'GDD covering mechanics, systems, and player experience',
    category: 'Creative',
    tags: ['game', 'design', 'gdd', 'mechanics'],
    dsl: '''CREATE document
TYPE game-design
GENRE roguelike
SECTIONS concept, core-loop, mechanics, systems, art-direction, monetization
PLATFORM PC
OUTPUT full GDD''',
  ),

  // ── Legal & HR ────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'legal_privacy_policy',
    title: 'Privacy Policy',
    description: 'GDPR and CCPA compliant privacy policy for a SaaS app',
    category: 'Legal & HR',
    tags: ['privacy', 'gdpr', 'ccpa', 'legal', 'compliance'],
    dsl: '''CREATE document
TYPE privacy-policy
COMPLIANCE GDPR, CCPA
COMPANY SaaS startup
SECTIONS data-collected, usage, sharing, retention, rights, contact
TONE plain-language
OUTPUT full privacy policy''',
  ),

  TemplateItem(
    id: 'legal_tos',
    title: 'Terms of Service',
    description: 'Standard terms of service for a web application',
    category: 'Legal & HR',
    tags: ['terms', 'tos', 'legal', 'service-agreement'],
    dsl: '''CREATE document
TYPE terms-of-service
PRODUCT B2B SaaS platform
SECTIONS acceptance, service-description, user-obligations, payment, liability, termination
TONE formal but readable
OUTPUT full ToS document''',
  ),

  TemplateItem(
    id: 'hr_job_description',
    title: 'Job Description',
    description: 'Inclusive, compelling job description for a senior engineer',
    category: 'Legal & HR',
    tags: ['job', 'hiring', 'hr', 'recruiting'],
    dsl: '''CREATE document
TYPE job-description
ROLE "Senior Full-Stack Engineer"
COMPANY remote-first startup
SECTIONS summary, responsibilities, requirements, nice-to-have, benefits
TONE inclusive, authentic
OUTPUT ready-to-post JD''',
  ),

  TemplateItem(
    id: 'hr_performance_review',
    title: 'Performance Review',
    description: 'Structured performance review template for engineering managers',
    category: 'Legal & HR',
    tags: ['performance', 'review', 'hr', 'manager'],
    dsl: '''CREATE template
TYPE performance-review
ROLE software engineer
SECTIONS achievements, growth-areas, goals, rating, development-plan
FREQUENCY annual
OUTPUT fillable review template''',
  ),

  TemplateItem(
    id: 'hr_interview_questions',
    title: 'Interview Questions',
    description: 'Structured interview question bank for technical hiring',
    category: 'Legal & HR',
    tags: ['interview', 'hiring', 'questions', 'technical'],
    dsl: '''CREATE document
TYPE interview-questions
ROLE "Staff Engineer"
CATEGORIES technical, behavioral, system-design, culture-fit
QUESTIONS 30
FEATURES scoring-rubric, follow-ups, red-flags
OUTPUT complete interview guide''',
  ),

  TemplateItem(
    id: 'hr_meeting_agenda',
    title: 'Meeting Agenda',
    description: 'Focused meeting agenda with time boxes and pre-reads',
    category: 'Legal & HR',
    tags: ['meeting', 'agenda', 'productivity', 'planning'],
    dsl: '''CREATE document
TYPE meeting-agenda
MEETING quarterly-planning
DURATION 90 minutes
SECTIONS pre-reads, goals, agenda-items, decisions-needed, action-items
FORMAT time-boxed
OUTPUT ready-to-send agenda''',
  ),

  // ── Research ──────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'res_literature_review',
    title: 'Literature Review',
    description: 'Systematic literature review structure for academic research',
    category: 'Research',
    tags: ['literature-review', 'academic', 'research', 'synthesis'],
    dsl: '''CREATE document
TYPE literature-review
FIELD computer science
TOPIC "Large Language Models in Code Generation"
SECTIONS introduction, methodology, themes, gaps, conclusion
SOURCES 20+ papers
OUTPUT structured review outline''',
  ),

  TemplateItem(
    id: 'res_research_proposal',
    title: 'Research Proposal',
    description: 'Formal research proposal with methodology and timeline',
    category: 'Research',
    tags: ['research', 'proposal', 'academic', 'methodology'],
    dsl: '''CREATE document
TYPE research-proposal
FIELD human-computer interaction
TOPIC "AI-assisted developer experience"
SECTIONS background, research-questions, methodology, timeline, budget, references
OUTPUT full proposal''',
  ),

  TemplateItem(
    id: 'res_survey_design',
    title: 'Survey Design',
    description: 'Research survey with validated question types and scales',
    category: 'Research',
    tags: ['survey', 'questionnaire', 'research', 'data-collection'],
    dsl: '''CREATE instrument
TYPE survey
PURPOSE developer-experience research
QUESTIONS 25
TYPES likert-scale, multiple-choice, open-ended
SECTIONS demographics, tool-usage, satisfaction, challenges
OUTPUT survey instrument''',
  ),

  TemplateItem(
    id: 'res_statistical_analysis',
    title: 'Statistical Analysis',
    description: 'Statistical analysis plan with hypothesis tests and power analysis',
    category: 'Research',
    tags: ['statistics', 'analysis', 'hypothesis', 'research'],
    dsl: '''CREATE plan
TYPE statistical-analysis
STACK Python, scipy, statsmodels
HYPOTHESES 3
TESTS t-test, ANOVA, regression
FEATURES power-analysis, effect-size, visualizations
OUTPUT analysis code and report template''',
  ),

  // ── E-Commerce ────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'ec_woocommerce_plugin',
    title: 'WooCommerce Plugin',
    description: 'Custom WooCommerce plugin with hooks, settings page, and REST endpoint',
    category: 'E-Commerce',
    tags: ['woocommerce', 'wordpress', 'plugin', 'php', 'ecommerce'],
    dsl: '''CREATE plugin
TYPE woocommerce
STACK PHP 8.1, WordPress 6.x, WooCommerce 8.x
FEATURES custom-product-field, checkout-hook, order-meta, settings-page, REST-endpoint
HOOKS woocommerce_checkout_process, woocommerce_order_status_changed, woocommerce_product_options_general_product_data
SETTINGS api-key, enable-toggle, select-dropdown
AUTH wordpress-nonce
OUTPUT full plugin with readme.txt and uninstall.php''',
  ),

  TemplateItem(
    id: 'ec_shopify_app',
    title: 'Shopify App',
    description: 'Shopify embedded app with Admin API integration and OAuth flow',
    category: 'E-Commerce',
    tags: ['shopify', 'app', 'nodejs', 'oauth', 'admin-api', 'ecommerce'],
    dsl: '''CREATE app
TYPE shopify-embedded
STACK Node.js, Shopify CLI 3.x, Polaris, Remix
FEATURES oauth-flow, session-storage, admin-api, webhooks, app-proxy
SCOPES read_products, write_orders, read_customers
WEBHOOKS orders/create, products/update, app/uninstalled
DATABASE SQLite
OUTPUT full app with shopify.app.toml and deploy config''',
  ),

  TemplateItem(
    id: 'ec_magento_module',
    title: 'Magento 2 Module',
    description: 'Magento 2 module with custom attribute, observer, and admin grid',
    category: 'E-Commerce',
    tags: ['magento', 'magento2', 'module', 'php', 'ecommerce'],
    dsl: '''CREATE module
TYPE magento2
STACK PHP 8.2, Magento 2.4.x
FEATURES custom-attribute, observer, admin-grid, REST-api, cron-job, email-template
OBSERVERS sales_order_place_after, catalog_product_save_after
ADMIN grid with filters and mass-actions
DI preferences, plugins, virtual-types
OUTPUT module with registration.php, composer.json, and install schema''',
  ),

  TemplateItem(
    id: 'ec_prestashop_module',
    title: 'PrestaShop Module',
    description: 'PrestaShop module with front controller, hooks, and back-office config',
    category: 'E-Commerce',
    tags: ['prestashop', 'module', 'php', 'ecommerce'],
    dsl: '''CREATE module
TYPE prestashop
STACK PHP 8.1, PrestaShop 8.x
FEATURES front-controller, hooks, back-office-config, override, display-block
HOOKS displayHeader, actionOrderStatusUpdate, displayProductAdditionalInfo
CONFIG form with text, select, and checkbox fields
OUTPUT module with index.php, logo.png placeholder, and install SQL''',
  ),

  TemplateItem(
    id: 'ec_bigcommerce_app',
    title: 'BigCommerce App',
    description: 'BigCommerce single-click app with Management API and webhooks',
    category: 'E-Commerce',
    tags: ['bigcommerce', 'app', 'nodejs', 'api', 'ecommerce'],
    dsl: '''CREATE app
TYPE bigcommerce-single-click
STACK Node.js, Express, BigCommerce Management API v2/v3
FEATURES oauth-install-flow, webhooks, storefront-script, metafields, widget-template
SCOPES store_v2_orders, store_v2_products, store_content
WEBHOOKS store/order/created, store/product/updated
OUTPUT full app with bigcommerce.yaml and deploy instructions''',
  ),

  TemplateItem(
    id: 'ec_generic_cart_plugin',
    title: 'Generic Cart & Checkout Plugin',
    description: 'Platform-agnostic e-commerce plugin spec for custom cart logic and payment gateway',
    category: 'E-Commerce',
    tags: ['cart', 'checkout', 'payment', 'gateway', 'plugin', 'ecommerce'],
    dsl: '''CREATE plugin
TYPE ecommerce-cart
PLATFORM specify-target-platform
STACK specify-language-and-framework
FEATURES add-to-cart, cart-totals, discount-codes, tax-calculation, payment-gateway, order-confirmation
PAYMENT stripe, paypal, manual
HOOKS before-checkout, after-order-placed, on-payment-failure
OUTPUT plugin scaffold with configuration, hooks, and payment adapter pattern''',
  ),

  // ── Artificial Intelligence ───────────────────────────────────────────────

  TemplateItem(
    id: 'ai_build_llm_chatbot',
    title: 'LLM Chatbot App',
    description: 'Build a production chatbot powered by an LLM with memory and streaming',
    category: 'Artificial Intelligence',
    tags: ['llm', 'chatbot', 'openai', 'langchain', 'streaming', 'memory'],
    dsl: '''CREATE app
TYPE llm-chatbot
STACK Python 3.11, LangChain, OpenAI GPT-4o, FastAPI
FEATURES streaming-responses, conversation-memory, system-prompt, multi-turn, token-limit-guard
MEMORY type: sliding-window, max-tokens: 8000
DEPLOYMENT docker, uvicorn
OUTPUT full app with chat endpoint, memory manager, and Dockerfile''',
  ),

  TemplateItem(
    id: 'ai_rag_pipeline',
    title: 'RAG Pipeline',
    description: 'Retrieval-Augmented Generation pipeline with vector store and document ingestion',
    category: 'Artificial Intelligence',
    tags: ['rag', 'vector-store', 'embeddings', 'retrieval', 'llm', 'langchain'],
    dsl: '''CREATE pipeline
TYPE RAG
STACK Python 3.11, LangChain, OpenAI, ChromaDB
FEATURES document-ingestion, chunking, embedding, vector-search, answer-generation, source-citation
CHUNKING strategy: recursive, chunk-size: 512, overlap: 64
EMBEDDING model: text-embedding-3-small
RETRIEVER top-k: 5, similarity-threshold: 0.75
OUTPUT full pipeline with ingest script, retriever, and query API''',
  ),

  TemplateItem(
    id: 'ai_fine_tuning',
    title: 'LLM Fine-Tuning',
    description: 'Fine-tune an open-source LLM on a custom dataset using LoRA/QLoRA',
    category: 'Artificial Intelligence',
    tags: ['fine-tuning', 'lora', 'qlora', 'transformers', 'huggingface', 'llm'],
    dsl: '''CREATE training-job
TYPE llm-fine-tuning
STACK Python 3.11, HuggingFace Transformers, PEFT, bitsandbytes, Accelerate
BASE-MODEL mistralai/Mistral-7B-Instruct-v0.2
METHOD QLoRA
DATASET format: instruction-response JSONL
HYPERPARAMS epochs: 3, lr: 2e-4, batch-size: 4, gradient-accumulation: 8
HARDWARE single-GPU A100 or consumer RTX 3090
OUTPUT training script, dataset formatter, and model export to GGUF''',
  ),

  TemplateItem(
    id: 'ai_agent_framework',
    title: 'AI Agent with Tools',
    description: 'Autonomous AI agent with tool use, planning loop, and memory',
    category: 'Artificial Intelligence',
    tags: ['agent', 'tool-use', 'planning', 'autonomous', 'langchain', 'llm'],
    dsl: '''CREATE agent
TYPE autonomous-tool-use
STACK Python 3.11, LangChain Agents, OpenAI GPT-4o, Tavily Search
TOOLS web-search, code-interpreter, file-read, calculator, API-caller
PLANNING ReAct loop
MEMORY short-term: buffer, long-term: vector-store
SAFETY max-iterations: 10, human-in-the-loop: optional
OUTPUT agent with tool registry, planning loop, and CLI runner''',
  ),

  TemplateItem(
    id: 'ai_image_classifier',
    title: 'Image Classifier',
    description: 'Train a CNN image classifier with transfer learning and export for deployment',
    category: 'Artificial Intelligence',
    tags: ['cnn', 'image-classification', 'pytorch', 'transfer-learning', 'computer-vision'],
    dsl: '''CREATE model
TYPE image-classifier
STACK Python 3.11, PyTorch, torchvision, ResNet50
METHOD transfer-learning
DATASET custom, format: ImageFolder, split: 80/10/10
FEATURES data-augmentation, early-stopping, confusion-matrix, grad-cam
HYPERPARAMS epochs: 20, lr: 1e-4, batch-size: 32, freeze-backbone: first-5-epochs
EXPORT ONNX, TorchScript
OUTPUT training script, evaluation report, and inference server''',
  ),

  TemplateItem(
    id: 'ai_nlp_text_classifier',
    title: 'NLP Text Classifier',
    description: 'Fine-tune BERT for text classification (sentiment, intent, topic)',
    category: 'Artificial Intelligence',
    tags: ['nlp', 'bert', 'text-classification', 'sentiment', 'huggingface', 'transformers'],
    dsl: '''CREATE model
TYPE text-classifier
STACK Python 3.11, HuggingFace Transformers, PyTorch
BASE-MODEL bert-base-uncased
TASK sentiment-analysis
CLASSES positive, negative, neutral
DATASET CSV with text and label columns
FEATURES tokenization, class-weights, evaluation-metrics, confusion-matrix
HYPERPARAMS epochs: 4, lr: 2e-5, max-length: 256, batch-size: 16
OUTPUT fine-tuned model, inference API, and evaluation notebook''',
  ),

  TemplateItem(
    id: 'ai_ml_pipeline',
    title: 'ML Training Pipeline',
    description: 'End-to-end ML pipeline with feature engineering, training, and model registry',
    category: 'Artificial Intelligence',
    tags: ['mlops', 'pipeline', 'sklearn', 'mlflow', 'feature-engineering', 'training'],
    dsl: '''CREATE pipeline
TYPE ml-training
STACK Python 3.11, scikit-learn, MLflow, pandas, optuna
STAGES data-ingestion, feature-engineering, model-training, hyperparameter-tuning, evaluation, registration
MODELS random-forest, xgboost, logistic-regression
TUNING optuna, n-trials: 100
TRACKING MLflow experiments and artifacts
FEATURES cross-validation, feature-importance, SHAP-explainability
OUTPUT pipeline with config YAML, MLflow setup, and deployment-ready model''',
  ),

  TemplateItem(
    id: 'ai_learn_from_scratch',
    title: 'Learn AI / ML from Scratch',
    description: 'Structured AI learning curriculum with projects, resources, and milestones',
    category: 'Artificial Intelligence',
    tags: ['learning', 'curriculum', 'beginner', 'roadmap', 'ml', 'ai'],
    dsl: '''CREATE curriculum
TYPE ai-ml-learning-path
LEVEL beginner
GOAL build and deploy ML models
DURATION 12 weeks
TOPICS Python basics, linear-algebra, statistics, supervised-learning, neural-networks, deep-learning, NLP, computer-vision, MLOps
PROJECTS iris-classifier, sentiment-analyzer, image-classifier, fine-tuned-LLM, RAG-chatbot
RESOURCES fast.ai, Andrej Karpathy tutorials, HuggingFace course, Stanford CS231n
OUTPUT week-by-week study plan with project checkpoints and resource links''',
  ),

  // ── Cybersecurity ─────────────────────────────────────────────────────────

  TemplateItem(
    id: 'sec_pentest_report',
    title: 'Penetration Test Report',
    description: 'Structured pentest report with findings, CVSS scores, and remediation steps',
    category: 'Cybersecurity',
    tags: ['pentest', 'report', 'vulnerability', 'cvss', 'remediation'],
    dsl: '''CREATE report
TYPE penetration-test
SCOPE web-application
METHODOLOGY OWASP Testing Guide, PTES
SECTIONS executive-summary, scope, methodology, findings, risk-matrix, remediation
FINDINGS format: title, severity, CVSS-score, description, proof-of-concept, remediation
SEVERITY critical, high, medium, low, informational
OUTPUT professional pentest report template in markdown''',
  ),

  TemplateItem(
    id: 'sec_threat_model',
    title: 'Threat Model',
    description: 'STRIDE threat model for a system with data flow diagrams and mitigations',
    category: 'Cybersecurity',
    tags: ['threat-modeling', 'stride', 'security', 'dfd', 'architecture'],
    dsl: '''CREATE document
TYPE threat-model
FRAMEWORK STRIDE
SYSTEM web-application with API and database
COMPONENTS frontend, API-gateway, backend-service, database, auth-service, CDN
THREATS spoofing, tampering, repudiation, information-disclosure, denial-of-service, elevation-of-privilege
MITIGATIONS per-threat with priority and owner
OUTPUT threat model with data flow diagram, threat table, and mitigation plan''',
  ),

  TemplateItem(
    id: 'sec_siem_detection',
    title: 'SIEM Detection Rule',
    description: 'Write SIEM detection rules for common attack patterns with alert logic',
    category: 'Cybersecurity',
    tags: ['siem', 'detection', 'splunk', 'elastic', 'alert', 'threat-hunting'],
    dsl: '''CREATE rule
TYPE siem-detection
PLATFORM Splunk / Elastic SIEM
ATTACK-PATTERNS brute-force, lateral-movement, privilege-escalation, data-exfiltration, C2-beacon
MITRE-ATT&CK yes
FIELDS source-ip, dest-ip, user, event-id, timestamp, action
THRESHOLDS configurable per rule
OUTPUT detection rules with SPL/KQL, MITRE mapping, and triage runbook''',
  ),

  TemplateItem(
    id: 'sec_secure_code_review',
    title: 'Secure Code Review',
    description: 'Security-focused code review checklist covering OWASP Top 10 and common CVEs',
    category: 'Cybersecurity',
    tags: ['code-review', 'owasp', 'security', 'sast', 'vulnerabilities'],
    dsl: '''CREATE checklist
TYPE secure-code-review
LANGUAGE Python / JavaScript / Go
STANDARDS OWASP Top 10, CWE Top 25
CHECKS injection, broken-auth, XSS, IDOR, security-misconfiguration, XXE, deserialization, logging, crypto
TOOLS semgrep, bandit, eslint-security
SEVERITY critical, high, medium, low
OUTPUT review checklist with code examples, bad-vs-good patterns, and fix snippets''',
  ),

  TemplateItem(
    id: 'sec_incident_response',
    title: 'Incident Response Playbook',
    description: 'IR playbook for a specific threat scenario with triage, containment, and recovery steps',
    category: 'Cybersecurity',
    tags: ['incident-response', 'playbook', 'forensics', 'containment', 'soc'],
    dsl: '''CREATE playbook
TYPE incident-response
SCENARIO ransomware-attack
PHASES detection, triage, containment, eradication, recovery, post-incident
ROLES SOC-analyst, IR-lead, system-owner, legal, communications
TOOLS EDR, SIEM, forensic-image, network-capture
ESCALATION matrix with SLA timelines
OUTPUT step-by-step IR playbook with checklists, decision trees, and communication templates''',
  ),

  TemplateItem(
    id: 'sec_ctf_challenge',
    title: 'CTF Challenge Solver',
    description: 'Structured approach to solving CTF challenges across common categories',
    category: 'Cybersecurity',
    tags: ['ctf', 'capture-the-flag', 'hacking', 'learning', 'challenges'],
    dsl: '''CREATE guide
TYPE CTF-challenge-solver
CATEGORIES web, crypto, reverse-engineering, pwn, forensics, OSINT, steganography
APPROACH reconnaissance, enumeration, exploitation, post-exploitation
TOOLS burpsuite, ghidra, gdb, pwntools, binwalk, cyberchef, nmap
SKILL-LEVEL beginner-to-intermediate
OUTPUT methodology guide with tool commands, common patterns, and flag extraction techniques''',
  ),

  // ── Data Engineering ──────────────────────────────────────────────────────

  TemplateItem(
    id: 'de_etl_pipeline',
    title: 'ETL Pipeline',
    description: 'Extract, Transform, Load pipeline with scheduling, logging, and error handling',
    category: 'Data Engineering',
    tags: ['etl', 'pipeline', 'airflow', 'python', 'data', 'scheduling'],
    dsl: '''CREATE pipeline
TYPE ETL
STACK Python 3.11, Apache Airflow, pandas, SQLAlchemy
SOURCE PostgreSQL / REST API / S3
TARGET data-warehouse (Snowflake / BigQuery)
FEATURES incremental-load, schema-validation, error-retry, dead-letter-queue, data-lineage
SCHEDULING daily at 02:00 UTC
MONITORING Airflow alerts, Slack notifications
OUTPUT DAG definition, transformers, schema contracts, and monitoring setup''',
  ),

  TemplateItem(
    id: 'de_streaming_pipeline',
    title: 'Real-Time Streaming Pipeline',
    description: 'Event-driven streaming pipeline with Kafka and Flink or Spark Streaming',
    category: 'Data Engineering',
    tags: ['streaming', 'kafka', 'flink', 'spark', 'real-time', 'events'],
    dsl: '''CREATE pipeline
TYPE streaming
STACK Python / Java, Apache Kafka, Apache Flink, Redis
SOURCE Kafka topic (click events, transactions, IoT)
FEATURES windowing, deduplication, late-arrival-handling, stateful-aggregation, watermarks
SINK data-warehouse, Elasticsearch, Redis cache
THROUGHPUT 100k events/sec
MONITORING Kafka lag, Flink job metrics, Grafana
OUTPUT stream processor, Kafka producer/consumer, and deployment config''',
  ),

  TemplateItem(
    id: 'de_data_warehouse',
    title: 'Data Warehouse Design',
    description: 'Star schema data warehouse with dbt models, dimensions, and fact tables',
    category: 'Data Engineering',
    tags: ['data-warehouse', 'dbt', 'snowflake', 'bigquery', 'star-schema', 'analytics'],
    dsl: '''CREATE warehouse
TYPE star-schema
STACK dbt, Snowflake / BigQuery, Fivetran
FACTS orders, sessions, transactions
DIMENSIONS customers, products, dates, channels, geography
FEATURES slowly-changing-dimensions, surrogate-keys, incremental-models, data-tests
DOCUMENTATION dbt docs with column descriptions
OUTPUT dbt project with models, sources, macros, and CI test suite''',
  ),

  TemplateItem(
    id: 'de_data_quality',
    title: 'Data Quality Framework',
    description: 'Automated data quality checks with alerting and a data observability dashboard',
    category: 'Data Engineering',
    tags: ['data-quality', 'great-expectations', 'observability', 'validation', 'monitoring'],
    dsl: '''CREATE framework
TYPE data-quality
STACK Python, Great Expectations, dbt tests, Monte Carlo / Soda
CHECKS schema-drift, null-rate, row-count, distribution-shift, referential-integrity, freshness
DATA-SOURCES PostgreSQL, Snowflake, S3 parquet
ALERTING PagerDuty, Slack, email
DASHBOARD quality-score per dataset, trend over time
OUTPUT expectation suites, validation pipeline, alert config, and observability dashboard''',
  ),

  TemplateItem(
    id: 'de_lakehouse',
    title: 'Data Lakehouse',
    description: 'Modern lakehouse architecture with Delta Lake, catalog, and query engine',
    category: 'Data Engineering',
    tags: ['lakehouse', 'delta-lake', 'spark', 'unity-catalog', 'iceberg', 'databricks'],
    dsl: '''CREATE architecture
TYPE lakehouse
STACK Apache Spark, Delta Lake / Apache Iceberg, Databricks / AWS Glue, Unity Catalog
ZONES bronze (raw), silver (cleaned), gold (aggregated)
FEATURES ACID-transactions, time-travel, schema-evolution, partition-pruning, Z-ordering
COMPUTE Databricks clusters / EMR Serverless
GOVERNANCE column-level-lineage, PII-tagging, access-control
OUTPUT lakehouse design with medallion architecture, table definitions, and Spark jobs''',
  ),

  // ── Cloud & Infrastructure ────────────────────────────────────────────────

  TemplateItem(
    id: 'cloud_aws_infra',
    title: 'AWS Infrastructure (Terraform)',
    description: 'Production AWS infrastructure with VPC, ECS, RDS, and ALB via Terraform',
    category: 'Cloud & Infrastructure',
    tags: ['aws', 'terraform', 'vpc', 'ecs', 'rds', 'iac'],
    dsl: '''CREATE infrastructure
TYPE aws-production
TOOL Terraform
COMPONENTS VPC, public/private subnets, NAT gateway, ALB, ECS Fargate, RDS PostgreSQL, ElastiCache, S3, CloudFront, WAF
FEATURES multi-AZ, auto-scaling, secrets-manager, CloudWatch alarms, cost-tags
NETWORKING CIDR 10.0.0.0/16, 3 AZs
SECURITY security-groups, IAM roles, KMS encryption, VPC flow logs
OUTPUT Terraform modules with variables, outputs, and remote state config''',
  ),

  TemplateItem(
    id: 'cloud_kubernetes_cluster',
    title: 'Kubernetes Cluster Setup',
    description: 'Production Kubernetes cluster with namespaces, RBAC, ingress, and monitoring',
    category: 'Cloud & Infrastructure',
    tags: ['kubernetes', 'k8s', 'helm', 'ingress', 'rbac', 'monitoring'],
    dsl: '''CREATE cluster
TYPE kubernetes-production
PLATFORM EKS / GKE / AKS
TOOL Helm, kubectl, Terraform
COMPONENTS namespaces, RBAC, ingress-nginx, cert-manager, cluster-autoscaler, HPA, PodDisruptionBudgets
MONITORING Prometheus, Grafana, Alertmanager, Loki
SECURITY network-policies, pod-security-standards, OPA Gatekeeper, secrets-store-csi
OUTPUT cluster manifests, Helm values, monitoring stack, and runbook''',
  ),

  TemplateItem(
    id: 'cloud_network_design',
    title: 'Network Architecture Design',
    description: 'Enterprise network design with segmentation, firewall rules, and VPN',
    category: 'Cloud & Infrastructure',
    tags: ['network', 'architecture', 'firewall', 'vpn', 'vlan', 'zero-trust'],
    dsl: '''CREATE architecture
TYPE enterprise-network
TOPOLOGY hub-and-spoke
SEGMENTS DMZ, corporate-LAN, server-VLAN, guest-VLAN, OT-network
COMPONENTS core-switch, edge-firewall, IDS/IPS, load-balancer, VPN-gateway, DNS, DHCP
SECURITY zero-trust, micro-segmentation, east-west-inspection, MFA-VPN
REDUNDANCY active-passive failover, dual ISP, BGP
OUTPUT network diagram, IP addressing plan, firewall ruleset, and configuration templates''',
  ),

  TemplateItem(
    id: 'cloud_serverless_app',
    title: 'Serverless Application',
    description: 'Event-driven serverless app with Lambda, API Gateway, DynamoDB, and SQS',
    category: 'Cloud & Infrastructure',
    tags: ['serverless', 'lambda', 'aws', 'api-gateway', 'dynamodb', 'sqs'],
    dsl: '''CREATE app
TYPE serverless
STACK AWS Lambda, API Gateway, DynamoDB, SQS, S3, EventBridge
RUNTIME Python 3.12 / Node.js 20
TOOL AWS SAM / Serverless Framework
FEATURES REST-api, async-processing, event-driven, dead-letter-queue, X-Ray-tracing
TRIGGERS HTTP, S3 events, SQS, EventBridge schedule
SECURITY IAM least-privilege, API key, Lambda authorizer
OUTPUT SAM template, Lambda functions, local dev setup, and CI/CD pipeline''',
  ),

  TemplateItem(
    id: 'cloud_cicd_pipeline',
    title: 'CI/CD Pipeline',
    description: 'Full CI/CD pipeline with build, test, security scan, and multi-environment deploy',
    category: 'Cloud & Infrastructure',
    tags: ['cicd', 'github-actions', 'pipeline', 'deploy', 'docker', 'devops'],
    dsl: '''CREATE pipeline
TYPE CI/CD
PLATFORM GitHub Actions / GitLab CI
STAGES lint, unit-test, build, security-scan, integration-test, deploy-staging, smoke-test, deploy-production
TOOLS Docker, Trivy (image scan), SAST, Terraform plan
ENVIRONMENTS dev, staging, production
DEPLOY strategy: blue-green / canary
NOTIFICATIONS Slack on failure, PagerDuty on prod incident
OUTPUT workflow YAML, Dockerfiles, environment configs, and rollback procedure''',
  ),

  // ── Information Technology ────────────────────────────────────────────────

  TemplateItem(
    id: 'it_helpdesk_sop',
    title: 'Helpdesk SOP',
    description: 'Standard operating procedure for a common IT helpdesk issue with triage steps',
    category: 'Information Technology',
    tags: ['helpdesk', 'sop', 'it-support', 'triage', 'documentation'],
    dsl: '''CREATE document
TYPE SOP
ISSUE password-reset / VPN-connectivity / hardware-failure
AUDIENCE tier-1 helpdesk technician
SECTIONS overview, prerequisites, step-by-step-procedure, escalation-criteria, rollback
TOOLS Active Directory, ticketing-system, remote-desktop
ESTIMATED-TIME 10 minutes
OUTPUT SOP with numbered steps, screenshots placeholders, and escalation matrix''',
  ),

  TemplateItem(
    id: 'it_asset_management',
    title: 'IT Asset Management System',
    description: 'Asset tracking system for hardware, software licenses, and lifecycle management',
    category: 'Information Technology',
    tags: ['asset-management', 'itam', 'inventory', 'lifecycle', 'cmdb'],
    dsl: '''CREATE system
TYPE IT-asset-management
STACK Python / Node.js, PostgreSQL, REST API
ASSETS hardware (laptops, servers, phones), software-licenses, network-devices
FEATURES asset-registry, assignment-tracking, lifecycle-alerts, license-compliance, depreciation, audit-log
INTEGRATIONS Active Directory, ticketing-system, procurement
REPORTS expiring-licenses, end-of-life-hardware, cost-by-department
OUTPUT full system with API, admin dashboard, and import/export templates''',
  ),

  TemplateItem(
    id: 'it_disaster_recovery',
    title: 'Disaster Recovery Plan',
    description: 'DR plan with RTO/RPO targets, runbooks, and failover procedures',
    category: 'Information Technology',
    tags: ['disaster-recovery', 'drp', 'rto', 'rpo', 'business-continuity', 'backup'],
    dsl: '''CREATE plan
TYPE disaster-recovery
SCOPE entire-IT-infrastructure
RTO 4 hours
RPO 1 hour
COMPONENTS backup-strategy, failover-sites, communication-plan, vendor-contacts, recovery-runbooks
BACKUP schedule: hourly snapshots, daily full, offsite-replication
TESTING quarterly DR drill
PRIORITIES tier-1: payment-system, tier-2: email, tier-3: internal-tools
OUTPUT DR plan with runbooks, contact list, recovery checklists, and test report template''',
  ),

  TemplateItem(
    id: 'it_active_directory',
    title: 'Active Directory Setup',
    description: 'AD domain design with OUs, GPOs, security groups, and hardening',
    category: 'Information Technology',
    tags: ['active-directory', 'windows-server', 'gpo', 'ldap', 'identity', 'sysadmin'],
    dsl: '''CREATE infrastructure
TYPE active-directory
DOMAIN company.local
FOREST-LEVEL Windows Server 2022
STRUCTURE OUs: Departments, Servers, Workstations, Service-Accounts
GPOs password-policy, screen-lock, software-restriction, audit-policy, LAPS
SECURITY tiered-admin-model, PAW, just-in-time-access, AD-recycle-bin
FEATURES DHCP, DNS, PKI, ADFS
OUTPUT AD design document, GPO settings, PowerShell setup scripts, and hardening checklist''',
  ),

  TemplateItem(
    id: 'it_monitoring_setup',
    title: 'IT Monitoring & Alerting',
    description: 'Infrastructure monitoring stack with dashboards, alerts, and on-call runbooks',
    category: 'Information Technology',
    tags: ['monitoring', 'alerting', 'prometheus', 'grafana', 'nagios', 'observability'],
    dsl: '''CREATE system
TYPE monitoring
STACK Prometheus, Grafana, Alertmanager, Loki, node-exporter
TARGETS servers, network-devices, databases, applications, URLs
METRICS CPU, memory, disk, network-latency, service-uptime, error-rate
ALERTS critical: pagerduty, warning: slack, info: email
DASHBOARDS infrastructure-overview, application-health, capacity-planning
ON-CALL rotation with escalation policy
OUTPUT monitoring config, Grafana dashboards, alert rules, and on-call runbook''',
  ),

  TemplateItem(
    id: 'it_network_audit',
    title: 'Network Audit & Inventory',
    description: 'Network discovery, device inventory, and configuration audit report',
    category: 'Information Technology',
    tags: ['network-audit', 'inventory', 'nmap', 'snmp', 'compliance', 'sysadmin'],
    dsl: '''CREATE report
TYPE network-audit
SCOPE LAN, WAN, wireless, cloud-connectivity
TOOLS nmap, SNMP, Netmiko, Nessus
DISCOVERY IP-range scan, device fingerprinting, port enumeration
INVENTORY routers, switches, firewalls, APs, servers, endpoints
CHECKS firmware-versions, open-ports, default-credentials, unused-ports, VLAN-config
OUTPUT audit report with device inventory CSV, risk findings, and remediation plan''',
  ),

  // ── Security Systems ──────────────────────────────────────────────────────

  TemplateItem(
    id: 'ss_access_control_system',
    title: 'Access Control System',
    description: 'Design a physical access control system with card readers, zones, and audit logs',
    category: 'Security Systems',
    tags: ['access-control', 'physical-security', 'rfid', 'acl', 'audit-log'],
    dsl: '''CREATE system
TYPE physical-access-control
HARDWARE RFID card readers, electric strikes, door controllers, biometric scanners
ZONES lobby, office-floor, server-room, executive-suite, restricted-lab
FEATURES role-based-access, time-schedules, anti-passback, alarm-triggers, audit-log, remote-unlock
INTEGRATIONS HR-system (auto-provision on hire/offboard), SIEM, video-surveillance
ALERTS tailgating, forced-door, access-denied-threshold, after-hours-entry
OUTPUT system design, zone map, access matrix, hardware BOM, and integration spec''',
  ),

  TemplateItem(
    id: 'ss_cctv_surveillance',
    title: 'CCTV / Surveillance System',
    description: 'IP camera network design with NVR, storage, and AI motion analytics',
    category: 'Security Systems',
    tags: ['cctv', 'surveillance', 'ip-camera', 'nvr', 'video-analytics'],
    dsl: '''CREATE system
TYPE video-surveillance
CAMERAS IP PTZ, fixed dome, fisheye, license-plate-recognition, thermal
COVERAGE entrances, parking, perimeter, server-room, reception, stairwells
NVR centralized recording, 30-day retention, RAID-6 storage
FEATURES motion-detection, AI-analytics, facial-recognition, license-plate-capture, remote-viewing, alerts
NETWORKING dedicated VLAN, PoE switches, fiber backbone
STORAGE calculation: camera-count x bitrate x retention-days
OUTPUT camera placement plan, NVR config, network diagram, storage sizing, and monitoring dashboard''',
  ),

  TemplateItem(
    id: 'ss_intrusion_detection',
    title: 'Intrusion Detection System',
    description: 'Physical IDS with sensors, alarm panels, zones, and central monitoring',
    category: 'Security Systems',
    tags: ['intrusion-detection', 'alarm', 'sensors', 'physical-security', 'monitoring'],
    dsl: '''CREATE system
TYPE intrusion-detection
SENSORS PIR motion, door/window contact, glass-break, vibration, beam-sensor
ZONES perimeter, interior, silent-alarm, 24-hour, entry-exit
PANEL dual-path communication (IP + cellular backup)
FEATURES arm/disarm schedules, remote-arm, bypass-logging, tamper-detection, duress-code
MONITORING central-station UL-listed, police-dispatch, mobile-app notifications
POWER primary AC with 24-hour battery backup
OUTPUT zone layout, sensor placement, panel config, monitoring procedures, and user training guide''',
  ),

  TemplateItem(
    id: 'ss_security_operations_center',
    title: 'Security Operations Center (SOC)',
    description: 'SOC design with physical layout, tools, workflows, and analyst runbooks',
    category: 'Security Systems',
    tags: ['soc', 'security-operations', 'monitoring', 'incident-response', 'design'],
    dsl: '''CREATE facility
TYPE security-operations-center
TIER 24/7 enterprise SOC
LAYOUT video-wall, analyst workstations, supervisor station, incident-room, server-rack
TOOLS SIEM, SOAR, threat-intelligence-platform, ticketing, communication
WORKFLOWS alert-triage, incident-escalation, threat-hunting, shift-handover
INTEGRATIONS physical-security (CCTV, access-control), IT-infrastructure, business-systems
STAFFING tier-1 analysts, tier-2 investigators, tier-3 threat-hunters, SOC-manager
OUTPUT SOC design document, floor plan, tool stack, runbooks, and staffing model''',
  ),

  TemplateItem(
    id: 'ss_zero_trust_architecture',
    title: 'Zero Trust Architecture',
    description: 'Zero trust security model design with identity, device, and network controls',
    category: 'Security Systems',
    tags: ['zero-trust', 'identity', 'microsegmentation', 'ztna', 'architecture'],
    dsl: '''CREATE architecture
TYPE zero-trust
PRINCIPLES verify-explicitly, least-privilege, assume-breach
PILLARS identity, devices, network, applications, data, infrastructure
COMPONENTS identity-provider (Okta/Entra ID), MFA, device-compliance, ZTNA, microsegmentation, CASB, DLP
POLICIES conditional-access, just-in-time-access, session-recording, continuous-verification
INTEGRATIONS SIEM, EDR, PAM, vulnerability-management
MATURITY-STAGES initial, advanced, optimal
OUTPUT architecture design, policy templates, implementation roadmap, and maturity assessment''',
  ),

  TemplateItem(
    id: 'ss_security_audit',
    title: 'Physical Security Audit',
    description: 'Physical security assessment covering perimeter, access, surveillance, and policies',
    category: 'Security Systems',
    tags: ['physical-security', 'audit', 'assessment', 'compliance', 'risk'],
    dsl: '''CREATE assessment
TYPE physical-security-audit
SCOPE building-perimeter, access-control, surveillance, data-centers, visitor-management
STANDARDS ISO 27001 Annex A, NIST SP 800-116, SOC 2
CHECKS perimeter-fencing, lighting, guard-patrols, badge-systems, tailgating-controls, visitor-logs, clean-desk
FINDINGS format: control, observation, risk-level, recommendation
RISK-LEVELS critical, high, medium, low
OUTPUT audit report with findings, risk matrix, photo evidence placeholders, and remediation roadmap''',
  ),

  TemplateItem(
    id: 'ss_guard_patrol_system',
    title: 'Guard Tour & Patrol System',
    description: 'Guard patrol management with checkpoints, schedules, incident reporting, and analytics',
    category: 'Security Systems',
    tags: ['guard-tour', 'patrol', 'checkpoint', 'incident-report', 'security-management'],
    dsl: '''CREATE system
TYPE guard-patrol-management
FEATURES NFC/QR checkpoints, patrol-scheduling, real-time-tracking, incident-reporting, missed-checkpoint-alert
CHECKPOINTS entrances, parking-lot, server-room, loading-dock, rooftop, emergency-exits
REPORTS patrol-compliance, incident-log, guard-performance, shift-summary
INTEGRATIONS access-control, CCTV, dispatch-center, HR-system
MOBILE guard-app with offline-mode and GPS tracking
DASHBOARD supervisor-view with live map and alert feed
OUTPUT system design, checkpoint placement plan, patrol schedules, mobile app spec, and report templates''',
  ),

  TemplateItem(
    id: 'ss_learn_security_systems',
    title: 'Learn Security Systems',
    description: 'Structured learning path for physical and electronic security systems professional',
    category: 'Security Systems',
    tags: ['learning', 'curriculum', 'physical-security', 'cctv', 'access-control', 'career'],
    dsl: '''CREATE curriculum
TYPE security-systems-learning-path
LEVEL beginner-to-professional
GOAL design, install, and manage integrated security systems
DURATION 16 weeks
TOPICS physical-security-fundamentals, access-control, CCTV, intrusion-detection, fire-alarm, intercoms, IP-networking, low-voltage-wiring, codes-and-standards, system-integration, cybersecurity-for-physical-systems
CERTIFICATIONS PSP (Physical Security Professional), Lenel, Genetec, Axis, CompTIA Security+
HANDS-ON labs for wiring, programming panels, configuring NVRs, and integrating systems
OUTPUT week-by-week study plan, lab exercises, certification roadmap, and career path guide''',
  ),

  // ── Engineering ───────────────────────────────────────────────────────────

  TemplateItem(
    id: 'eng_software_architecture',
    title: 'Software Architecture Design',
    description: 'Design a scalable software architecture with components, patterns, and trade-off analysis',
    category: 'Engineering',
    tags: ['architecture', 'design', 'microservices', 'patterns', 'scalability'],
    dsl: '''CREATE document
TYPE software-architecture
SYSTEM distributed web platform
PATTERNS microservices, event-driven, CQRS, saga, circuit-breaker
COMPONENTS API-gateway, auth-service, domain-services, message-broker, cache, CDN, database-per-service
QUALITIES scalability, fault-tolerance, observability, security, maintainability
DIAGRAMS C4-model: context, container, component
TRADE-OFFS consistency-vs-availability, coupling-vs-autonomy, complexity-vs-flexibility
OUTPUT architecture document with diagrams, ADRs, and technology selection rationale''',
  ),

  TemplateItem(
    id: 'eng_embedded_firmware',
    title: 'Embedded Systems Firmware',
    description: 'Firmware design for a microcontroller with RTOS, peripherals, and OTA updates',
    category: 'Engineering',
    tags: ['embedded', 'firmware', 'rtos', 'microcontroller', 'iot', 'c'],
    dsl: '''CREATE firmware
TYPE embedded-system
MCU STM32 / ESP32 / Raspberry Pi Pico
RTOS FreeRTOS / Zephyr
LANGUAGE C / C++
PERIPHERALS UART, SPI, I2C, GPIO, ADC, PWM, CAN-bus
FEATURES task-scheduling, watchdog, power-management, OTA-updates, bootloader, fault-handling
PROTOCOLS MQTT, Modbus, BLE
OUTPUT firmware architecture, HAL abstraction layer, task design, and build system (CMake)''',
  ),

  TemplateItem(
    id: 'eng_mechanical_design',
    title: 'Mechanical System Design',
    description: 'Mechanical engineering design spec with requirements, materials, and analysis',
    category: 'Engineering',
    tags: ['mechanical', 'design', 'cad', 'fea', 'materials', 'manufacturing'],
    dsl: '''CREATE specification
TYPE mechanical-design
SYSTEM structural bracket / actuator assembly / heat exchanger
REQUIREMENTS load-bearing: 500N, operating-temp: -20°C to 120°C, IP67
MATERIAL aluminum-6061 / stainless-steel-316 / carbon-fiber
ANALYSIS FEA stress analysis, fatigue life, thermal analysis
MANUFACTURING CNC machining, sheet metal, 3D printing (prototype)
TOLERANCES GD&T per ASME Y14.5
STANDARDS ISO 9001, ASTM material specs
OUTPUT design spec, material selection rationale, FEA summary, and manufacturing drawing notes''',
  ),

  TemplateItem(
    id: 'eng_electrical_circuit',
    title: 'Electrical Circuit Design',
    description: 'Electronic circuit design with schematic, BOM, PCB layout guidelines, and testing plan',
    category: 'Engineering',
    tags: ['electrical', 'circuit', 'pcb', 'schematic', 'electronics', 'hardware'],
    dsl: '''CREATE design
TYPE electronic-circuit
FUNCTION power-supply / motor-driver / sensor-interface / RF-transceiver
VOLTAGE 3.3V / 5V / 12V / 24V
CURRENT max 2A
COMPONENTS MCU, voltage-regulator, MOSFETs, op-amps, filters, protection-circuits
TOOLS KiCad / Altium Designer
PCB 4-layer, controlled impedance, EMC guidelines
TESTING bench-verification, thermal-imaging, EMC pre-compliance
OUTPUT schematic description, BOM, PCB layout rules, test procedure, and compliance checklist''',
  ),

  TemplateItem(
    id: 'eng_systems_engineering',
    title: 'Systems Engineering Plan',
    description: 'MBSE-style systems engineering plan with requirements, architecture, and V&V',
    category: 'Engineering',
    tags: ['systems-engineering', 'mbse', 'requirements', 'verification', 'validation'],
    dsl: '''CREATE plan
TYPE systems-engineering
METHODOLOGY MBSE, V-model
PHASES concept, requirements, architecture, design, integration, verification, validation, operations
REQUIREMENTS stakeholder, system, subsystem — with traceability matrix
ARCHITECTURE functional, physical, logical views
TOOLS SysML / Cameo, JIRA for requirements
VERIFICATION test-plan with pass/fail criteria per requirement
RISK risk-register with likelihood, impact, and mitigation
OUTPUT SEMP document, SysML diagrams, requirements traceability matrix, and V&V plan''',
  ),

  TemplateItem(
    id: 'eng_learn_engineering',
    title: 'Learn Engineering Fundamentals',
    description: 'Structured engineering learning path from fundamentals to specialization',
    category: 'Engineering',
    tags: ['learning', 'curriculum', 'engineering', 'fundamentals', 'career', 'roadmap'],
    dsl: '''CREATE curriculum
TYPE engineering-learning-path
DISCIPLINE software / electrical / mechanical / systems
LEVEL undergraduate-to-professional
DURATION 24 weeks
TOPICS calculus, linear-algebra, physics, thermodynamics, circuit-theory, programming, materials-science, control-systems, signal-processing, project-management
PROJECTS bridge-design, PCB-design, control-system-simulation, capstone-project
TOOLS MATLAB, Python, KiCad, SolidWorks, SPICE
OUTPUT week-by-week curriculum, project briefs, resource list, and capstone guide''',
  ),

  // ── Reverse Engineering ───────────────────────────────────────────────────

  TemplateItem(
    id: 're_binary_analysis',
    title: 'Binary Analysis',
    description: 'Static and dynamic analysis of a binary executable to understand behavior and find vulnerabilities',
    category: 'Reverse Engineering',
    tags: ['binary-analysis', 'static-analysis', 'dynamic-analysis', 'ghidra', 'ida', 'malware'],
    dsl: '''CREATE analysis
TYPE binary-reverse-engineering
TARGET unknown executable / malware sample / firmware image
APPROACH static-first, then dynamic
STATIC-TOOLS Ghidra, IDA Pro, Binary Ninja, strings, file, objdump, Detect-It-Easy
DYNAMIC-TOOLS x64dbg, gdb, Frida, API Monitor, Wireshark, Process Monitor
STEPS file-identification, entropy-check, import-table, string-extraction, disassembly, control-flow-graph, deobfuscation, behavior-analysis
ARTIFACTS IOCs, YARA rules, function-rename map, call-graph
OUTPUT analysis report with findings, IOCs, MITRE ATT&CK mapping, and annotated disassembly notes''',
  ),

  TemplateItem(
    id: 're_protocol_reverse',
    title: 'Network Protocol Reverse Engineering',
    description: 'Reverse engineer an undocumented network protocol from packet captures',
    category: 'Reverse Engineering',
    tags: ['protocol-analysis', 'wireshark', 'network', 'reverse-engineering', 'fuzzing'],
    dsl: '''CREATE analysis
TYPE protocol-reverse-engineering
TARGET proprietary binary protocol / undocumented API
CAPTURE-TOOLS Wireshark, tcpdump, mitmproxy, Frida
STEPS traffic-capture, session-identification, message-framing, field-mapping, checksum-analysis, state-machine-reconstruction
TECHNIQUES differential-analysis, known-plaintext, fuzzing, replay-attacks
OUTPUT protocol specification document, field definitions, state diagram, Scapy dissector, and fuzzer template''',
  ),

  TemplateItem(
    id: 're_firmware_extraction',
    title: 'Firmware Extraction & Analysis',
    description: 'Extract and analyze embedded device firmware for security research',
    category: 'Reverse Engineering',
    tags: ['firmware', 'iot', 'binwalk', 'embedded', 'hardware-hacking', 'security'],
    dsl: '''CREATE analysis
TYPE firmware-reverse-engineering
TARGET IoT device / router / industrial-controller
EXTRACTION-METHODS UART-console, JTAG/SWD, flash-chip-dump, OTA-update-intercept, vendor-portal
TOOLS binwalk, dd, flashrom, OpenOCD, UART-adapter, logic-analyzer
ANALYSIS filesystem-extraction, hardcoded-credentials, debug-interfaces, update-mechanism, crypto-keys, vulnerable-libraries
EMULATION QEMU full-system, Firmwalker, FAT
OUTPUT extraction procedure, filesystem tree, vulnerability findings, and re-flashing guide''',
  ),

  TemplateItem(
    id: 're_mobile_app',
    title: 'Mobile App Reverse Engineering',
    description: 'Decompile and analyze an Android or iOS app for security assessment',
    category: 'Reverse Engineering',
    tags: ['mobile', 'android', 'ios', 'apk', 'frida', 'jadx', 'security'],
    dsl: '''CREATE analysis
TYPE mobile-reverse-engineering
PLATFORM Android APK / iOS IPA
TOOLS jadx, apktool, MobSF, Frida, objection, r2frida, class-dump
STEPS unpack, decompile, manifest-analysis, hardcoded-secrets, network-traffic-interception, SSL-pinning-bypass, root-detection-bypass, dynamic-instrumentation
CHECKS insecure-storage, weak-crypto, exported-components, deep-links, third-party-SDKs
OUTPUT security report with findings, PoC scripts, and remediation recommendations''',
  ),

  TemplateItem(
    id: 're_learn_reverse_engineering',
    title: 'Learn Reverse Engineering',
    description: 'Structured learning path for binary reverse engineering from zero to advanced',
    category: 'Reverse Engineering',
    tags: ['learning', 'curriculum', 'reverse-engineering', 'assembly', 'ghidra', 'malware'],
    dsl: '''CREATE curriculum
TYPE reverse-engineering-learning-path
LEVEL beginner-to-advanced
DURATION 20 weeks
TOPICS x86/x64 assembly, calling-conventions, PE/ELF-format, static-analysis, dynamic-analysis, anti-reversing-techniques, malware-families, exploit-development, kernel-internals
TOOLS Ghidra, x64dbg, IDA Free, pwndbg, Python scripting
PRACTICE crackmes.one, malware-traffic-analysis, pwn.college, reverse.engineering CTF challenges
OUTPUT week-by-week study plan, hands-on challenge list, tool cheat sheet, and career roadmap''',
  ),

  // ── Mathematics ───────────────────────────────────────────────────────────

  TemplateItem(
    id: 'math_proof_assistant',
    title: 'Mathematical Proof Assistant',
    description: 'Guide to constructing formal proofs with proof strategies and worked examples',
    category: 'Mathematics',
    tags: ['proof', 'formal-math', 'logic', 'theorem', 'discrete-math'],
    dsl: '''CREATE guide
TYPE mathematical-proof
TOPIC group-theory / real-analysis / number-theory / combinatorics
PROOF-METHODS direct, contradiction, induction, contrapositive, construction, pigeonhole
STRUCTURE statement, definitions, lemmas, main-proof, corollaries
NOTATION LaTeX-ready
LEVEL undergraduate
OUTPUT proof template with strategy selection guide, worked examples, and common pitfalls''',
  ),

  TemplateItem(
    id: 'math_linear_algebra',
    title: 'Linear Algebra Problem Solver',
    description: 'Structured approach to linear algebra problems with step-by-step solutions',
    category: 'Mathematics',
    tags: ['linear-algebra', 'matrices', 'eigenvalues', 'vectors', 'transformations'],
    dsl: '''CREATE solver
TYPE linear-algebra
TOPICS matrices, determinants, vector-spaces, linear-transformations, eigenvalues, SVD, PCA, least-squares
PROBLEM-TYPES computation, proof, application
NOTATION matrix-form, index-form, geometric-interpretation
TOOLS NumPy, MATLAB, Wolfram Alpha
APPLICATIONS machine-learning, graphics, quantum-computing, signals
OUTPUT step-by-step solution template, geometric intuition, code verification, and application context''',
  ),

  TemplateItem(
    id: 'math_calculus',
    title: 'Calculus & Analysis',
    description: 'Calculus problem framework covering limits, derivatives, integrals, and series',
    category: 'Mathematics',
    tags: ['calculus', 'analysis', 'derivatives', 'integrals', 'series', 'differential-equations'],
    dsl: '''CREATE framework
TYPE calculus
TOPICS limits, continuity, differentiation, integration, multivariable-calculus, vector-calculus, differential-equations, series-and-sequences
TECHNIQUES substitution, integration-by-parts, partial-fractions, Laplace-transform, Fourier-series
VISUALIZATION function-plotting, slope-fields, surface-plots
TOOLS Python sympy, Wolfram Alpha, Desmos, MATLAB
APPLICATIONS physics, engineering, machine-learning, economics
OUTPUT solution walkthrough, symbolic computation code, visualization script, and common mistakes guide''',
  ),

  TemplateItem(
    id: 'math_applied_optimization',
    title: 'Applied Optimization',
    description: 'Formulate and solve optimization problems: linear, nonlinear, and combinatorial',
    category: 'Mathematics',
    tags: ['optimization', 'linear-programming', 'convex', 'operations-research', 'algorithms'],
    dsl: '''CREATE solution
TYPE optimization
PROBLEM-TYPE linear-programming / integer-programming / convex / nonlinear / combinatorial
FORMULATION objective-function, constraints, decision-variables, bounds
SOLVERS PuLP, scipy.optimize, CVXPY, Gurobi, OR-Tools
METHODS simplex, interior-point, branch-and-bound, gradient-descent, genetic-algorithm
APPLICATIONS scheduling, resource-allocation, route-optimization, portfolio, ML-hyperparameters
OUTPUT problem formulation, solver code, sensitivity analysis, and result interpretation''',
  ),

  TemplateItem(
    id: 'math_statistics_probability',
    title: 'Statistics & Probability',
    description: 'Statistical analysis and probability framework with distributions, tests, and inference',
    category: 'Mathematics',
    tags: ['statistics', 'probability', 'distributions', 'inference', 'bayesian', 'hypothesis-testing'],
    dsl: '''CREATE analysis
TYPE statistics-and-probability
TOPICS descriptive-statistics, probability-distributions, hypothesis-testing, confidence-intervals, regression, ANOVA, Bayesian-inference, Monte-Carlo
DISTRIBUTIONS normal, binomial, Poisson, exponential, chi-squared, t-distribution
TESTS t-test, ANOVA, chi-squared, Mann-Whitney, Kolmogorov-Smirnov
TOOLS Python scipy/statsmodels, R, Jupyter
VISUALIZATION histograms, QQ-plots, boxplots, probability-plots
OUTPUT analysis template, test selection flowchart, code examples, and result interpretation guide''',
  ),

  TemplateItem(
    id: 'math_learn_mathematics',
    title: 'Learn Mathematics (Roadmap)',
    description: 'Complete mathematics learning path from foundations through advanced topics',
    category: 'Mathematics',
    tags: ['learning', 'curriculum', 'mathematics', 'roadmap', 'self-study'],
    dsl: '''CREATE curriculum
TYPE mathematics-learning-path
LEVEL high-school-to-graduate
DURATION 52 weeks
TRACKS pure-math, applied-math, statistics, discrete-math
TOPICS pre-calculus, calculus, linear-algebra, differential-equations, real-analysis, abstract-algebra, probability, statistics, numerical-methods, topology
RESOURCES MIT OpenCourseWare, 3Blue1Brown, Paul's Math Notes, Art of Problem Solving
MILESTONES weekly problem sets, monthly proof challenges, semester capstone problems
OUTPUT year-long study plan, topic prerequisites map, resource links, and self-assessment checkpoints''',
  ),

  // ── Science ───────────────────────────────────────────────────────────────

  TemplateItem(
    id: 'sci_experiment_design',
    title: 'Scientific Experiment Design',
    description: 'Design a controlled experiment with hypothesis, methodology, and statistical power',
    category: 'Science',
    tags: ['experiment', 'scientific-method', 'hypothesis', 'methodology', 'research-design'],
    dsl: '''CREATE experiment
TYPE controlled-scientific-experiment
FIELD biology / chemistry / physics / psychology
HYPOTHESIS null and alternative hypothesis
VARIABLES independent, dependent, controlled, confounding
DESIGN randomized-controlled, double-blind, factorial, crossover
SAMPLE-SIZE power-analysis: alpha 0.05, power 0.80, effect-size 0.5
STATISTICS planned analysis: t-test / ANOVA / regression
ETHICS IRB/IACUC consideration, data-privacy
OUTPUT experiment protocol, data collection sheet, statistical analysis plan, and write-up template''',
  ),

  TemplateItem(
    id: 'sci_physics_simulation',
    title: 'Physics Simulation',
    description: 'Numerical simulation of a physical system with equations of motion and visualization',
    category: 'Science',
    tags: ['physics', 'simulation', 'numerical-methods', 'ode', 'python', 'visualization'],
    dsl: '''CREATE simulation
TYPE physics
SYSTEM n-body gravitational / fluid-dynamics / electromagnetic / quantum-particle
EQUATIONS Newtons-laws / Navier-Stokes / Maxwell / Schrödinger
NUMERICAL-METHOD Runge-Kutta 4, Euler, Verlet, finite-difference
STACK Python, NumPy, SciPy, Matplotlib, Pygame / VPython
PARAMETERS configurable: mass, initial-conditions, time-step, boundary-conditions
VISUALIZATION real-time animation, phase-space plots, energy conservation check
OUTPUT simulation code, parameter config, animation renderer, and validation against analytical solution''',
  ),

  TemplateItem(
    id: 'sci_chemistry_lab',
    title: 'Chemistry Lab Protocol',
    description: 'Detailed laboratory protocol with safety, procedures, calculations, and analysis',
    category: 'Science',
    tags: ['chemistry', 'lab', 'protocol', 'safety', 'synthesis', 'analysis'],
    dsl: '''CREATE protocol
TYPE chemistry-lab
EXPERIMENT organic-synthesis / titration / spectroscopy / electrochemistry
MATERIALS reagents with CAS numbers, quantities, hazard-classifications
SAFETY GHS hazard symbols, PPE requirements, waste-disposal, emergency-procedures
PROCEDURE step-by-step with times, temperatures, and critical-checkpoints
CALCULATIONS stoichiometry, yield, molarity, error-analysis
ANALYSIS characterization methods: NMR, IR, HPLC, melting-point
OUTPUT lab protocol, safety checklist, calculation worksheet, and results template''',
  ),

  TemplateItem(
    id: 'sci_applied_physics',
    title: 'Applied Physics Problem',
    description: 'Framework for solving applied physics problems across mechanics, thermodynamics, and E&M',
    category: 'Science',
    tags: ['applied-physics', 'mechanics', 'thermodynamics', 'electromagnetism', 'problem-solving'],
    dsl: '''CREATE solution
TYPE applied-physics
DOMAIN classical-mechanics / thermodynamics / electromagnetism / optics / fluid-mechanics
APPROACH draw-FBD, identify-laws, set-up-equations, solve-symbolically, substitute-numbers, sanity-check
LAWS Newtons-laws, conservation-of-energy, Gauss-law, Faraday, first/second-law-of-thermodynamics
TOOLS Python sympy, MATLAB, Wolfram Alpha, Desmos
UNITS SI with dimensional-analysis check
OUTPUT problem setup, free-body diagram description, symbolic solution, numerical answer, and physical interpretation''',
  ),

  TemplateItem(
    id: 'sci_biology_research',
    title: 'Biology Research Framework',
    description: 'Structured framework for molecular biology, genetics, or ecology research projects',
    category: 'Science',
    tags: ['biology', 'molecular-biology', 'genetics', 'research', 'bioinformatics'],
    dsl: '''CREATE framework
TYPE biology-research
FIELD molecular-biology / genetics / ecology / neuroscience / bioinformatics
QUESTION research question with PICO framework
METHODS PCR, gel-electrophoresis, CRISPR, RNA-seq, BLAST, phylogenetic-analysis
TOOLS BioPython, R Bioconductor, NCBI databases, ImageJ
CONTROLS positive, negative, technical-replicates: 3, biological-replicates: 3
ANALYSIS statistical-tests, pathway-enrichment, sequence-alignment
OUTPUT research plan, methods section, analysis pipeline, and figure generation scripts''',
  ),

  TemplateItem(
    id: 'sci_learn_science',
    title: 'Learn Science (Roadmap)',
    description: 'Comprehensive science learning path spanning physics, chemistry, biology, and applied sciences',
    category: 'Science',
    tags: ['learning', 'curriculum', 'science', 'roadmap', 'self-study', 'stem'],
    dsl: '''CREATE curriculum
TYPE science-learning-path
LEVEL high-school-to-undergraduate
DURATION 52 weeks
TRACKS physics, chemistry, biology, earth-science, applied-science
TOPICS scientific-method, mechanics, thermodynamics, electromagnetism, atomic-theory, organic-chemistry, cell-biology, genetics, ecology, materials-science
LABS virtual-labs via PhET, home-experiments, data-analysis projects
RESOURCES Khan Academy, MIT OpenCourseWare, Crash Course, OpenStax textbooks
OUTPUT year-long study plan, topic map, lab project list, and assessment checkpoints''',
  ),

  // ── Cryptography & Blockchain ─────────────────────────────────────────────

  TemplateItem(
    id: 'crypto_fundamentals',
    title: 'Cryptography Fundamentals',
    description: 'Deep dive into symmetric, asymmetric, and hash-based cryptography with implementations',
    category: 'Cryptography & Blockchain',
    tags: ['cryptography', 'aes', 'rsa', 'elliptic-curve', 'hash', 'learning'],
    dsl: '''CREATE guide
TYPE cryptography-fundamentals
TOPICS symmetric-encryption (AES-256-GCM), asymmetric-encryption (RSA, ECC), hash-functions (SHA-256, SHA-3), digital-signatures (ECDSA, EdDSA), key-exchange (ECDH, DH), MAC (HMAC), KDF (PBKDF2, Argon2, bcrypt)
ATTACKS chosen-plaintext, timing-attacks, padding-oracle, birthday-attack, rainbow-tables
IMPLEMENTATION Python cryptography library, OpenSSL, libsodium
BEST-PRACTICES key-management, IV-reuse-prevention, authenticated-encryption, constant-time-comparison
OUTPUT concept explanations, Python code examples, attack demos, and implementation checklist''',
  ),

  TemplateItem(
    id: 'crypto_tls_pki',
    title: 'TLS & PKI Implementation',
    description: 'Build and configure a PKI with CA, certificates, TLS hardening, and certificate lifecycle',
    category: 'Cryptography & Blockchain',
    tags: ['tls', 'pki', 'certificates', 'ca', 'x509', 'ssl'],
    dsl: '''CREATE infrastructure
TYPE PKI-and-TLS
COMPONENTS root-CA, intermediate-CA, leaf-certificates, CRL, OCSP, CT-logs
CERTIFICATE-TYPES server-TLS, client-mTLS, code-signing, S/MIME
TLS-VERSION 1.3 preferred, 1.2 fallback
CIPHER-SUITES TLS_AES_256_GCM_SHA384, TLS_CHACHA20_POLY1305_SHA256
TOOLS OpenSSL, cfssl, EJBCA, Let's Encrypt / ACME, cert-manager
LIFECYCLE auto-renewal, revocation, monitoring expiry
OUTPUT CA setup scripts, certificate templates, TLS config for nginx/Apache, and rotation runbook''',
  ),

  TemplateItem(
    id: 'crypto_zero_knowledge',
    title: 'Zero-Knowledge Proof System',
    description: 'Design and implement a ZKP system using zk-SNARKs or zk-STARKs',
    category: 'Cryptography & Blockchain',
    tags: ['zkp', 'zero-knowledge', 'zk-snarks', 'zk-starks', 'circom', 'privacy'],
    dsl: '''CREATE system
TYPE zero-knowledge-proof
SCHEME zk-SNARKs (Groth16 / PLONK) / zk-STARKs
USE-CASE private-transaction, age-proof, range-proof, set-membership, authentication
TOOLS Circom, snarkjs, Noir, Halo2, StarkNet
CIRCUIT arithmetic-circuit with constraints
TRUSTED-SETUP powers-of-tau ceremony (for SNARKs)
VERIFICATION on-chain (Solidity verifier) / off-chain
OUTPUT circuit definition, proof generation script, Solidity verifier contract, and gas cost analysis''',
  ),

  TemplateItem(
    id: 'crypto_smart_contract',
    title: 'Smart Contract (Solidity)',
    description: 'Production-ready Solidity smart contract with security patterns, tests, and audit checklist',
    category: 'Cryptography & Blockchain',
    tags: ['smart-contract', 'solidity', 'ethereum', 'evm', 'defi', 'security'],
    dsl: '''CREATE contract
TYPE solidity-smart-contract
NETWORK Ethereum / Polygon / Arbitrum / Base
STANDARD ERC-20 / ERC-721 / ERC-1155 / custom
FEATURES access-control, pausable, upgradeable (UUPS), reentrancy-guard, multi-sig
STACK Solidity 0.8.x, Hardhat / Foundry, OpenZeppelin
TESTING unit-tests, fuzz-tests, fork-tests
SECURITY checks: reentrancy, integer-overflow, access-control, oracle-manipulation, front-running
GAS gas-optimization: packing, unchecked, custom-errors
OUTPUT contract code, test suite, deployment script, and security audit checklist''',
  ),

  TemplateItem(
    id: 'crypto_defi_protocol',
    title: 'DeFi Protocol',
    description: 'Design a DeFi protocol — DEX, lending, yield farming, or stablecoin',
    category: 'Cryptography & Blockchain',
    tags: ['defi', 'dex', 'lending', 'yield', 'amm', 'liquidity', 'solidity'],
    dsl: '''CREATE protocol
TYPE DeFi
MECHANISM AMM-DEX / lending-borrowing / yield-aggregator / stablecoin
STACK Solidity 0.8.x, Foundry, Uniswap v3 SDK, Chainlink oracles, OpenZeppelin
FEATURES liquidity-pools, fee-model, price-oracle, flash-loans, governance-token, timelock
TOKENOMICS supply, distribution, vesting, staking-rewards
SECURITY price-oracle-manipulation-protection, economic-attack-simulation, formal-verification
AUDITS Slither, Echidna fuzzer, manual-review checklist
OUTPUT protocol architecture, contract suite, tokenomics model, and security report''',
  ),

  TemplateItem(
    id: 'crypto_nft_collection',
    title: 'NFT Collection',
    description: 'Launch an NFT collection with ERC-721, metadata, reveal mechanism, and marketplace listing',
    category: 'Cryptography & Blockchain',
    tags: ['nft', 'erc-721', 'metadata', 'ipfs', 'opensea', 'mint'],
    dsl: '''CREATE collection
TYPE NFT
STANDARD ERC-721A (gas-optimized)
NETWORK Ethereum mainnet / Polygon / Base
FEATURES whitelist-mint (merkle-tree), public-mint, reveal-mechanism, royalties (EIP-2981), soulbound-option
METADATA IPFS via Pinata / NFT.Storage, JSON schema
MINT-PRICE configurable, ETH / ERC-20
ROYALTIES 5% secondary sales
MARKETPLACE OpenSea, Blur compatible
OUTPUT ERC-721A contract, merkle-tree generator, metadata uploader, mint frontend, and deployment guide''',
  ),

  TemplateItem(
    id: 'crypto_blockchain_node',
    title: 'Custom Blockchain / L2',
    description: 'Design a custom blockchain or Layer 2 network with consensus, VM, and node architecture',
    category: 'Cryptography & Blockchain',
    tags: ['blockchain', 'layer2', 'consensus', 'evm', 'rollup', 'node'],
    dsl: '''CREATE blockchain
TYPE custom-L1 / optimistic-rollup / zk-rollup
CONSENSUS PoS / PoA / PBFT / Tendermint
VM EVM-compatible / custom-WASM
COMPONENTS p2p-network, mempool, block-producer, state-machine, RPC-node, bridge
STACK Go / Rust, libp2p, LevelDB / RocksDB
FEATURES finality, gas-model, native-token, bridge-to-Ethereum, block-explorer
OUTPUT architecture design, consensus spec, node setup guide, bridge contract, and testnet deployment''',
  ),

  TemplateItem(
    id: 'crypto_crypto_trading_bot',
    title: 'Crypto Trading Bot',
    description: 'Algorithmic crypto trading bot with strategy, backtesting, and exchange integration',
    category: 'Cryptography & Blockchain',
    tags: ['trading-bot', 'crypto', 'algorithmic-trading', 'backtesting', 'defi', 'ccxt'],
    dsl: '''CREATE bot
TYPE crypto-trading
STACK Python 3.11, ccxt, pandas, TA-Lib, backtrader / vectorbt
EXCHANGES Binance, Coinbase, Kraken, dYdX (DEX)
STRATEGY trend-following / mean-reversion / arbitrage / market-making
INDICATORS RSI, MACD, Bollinger-bands, EMA, volume-profile
RISK-MANAGEMENT stop-loss, take-profit, position-sizing, max-drawdown-limit
BACKTESTING historical OHLCV data, walk-forward validation, Sharpe ratio
OUTPUT strategy code, backtesting report, live-trading runner, and risk dashboard''',
  ),

  TemplateItem(
    id: 'crypto_wallet',
    title: 'Crypto Wallet (HD Wallet)',
    description: 'Build a hierarchical deterministic wallet with key derivation, signing, and multi-chain support',
    category: 'Cryptography & Blockchain',
    tags: ['wallet', 'hd-wallet', 'bip39', 'bip44', 'key-management', 'multi-chain'],
    dsl: '''CREATE wallet
TYPE HD-wallet
STANDARDS BIP-39 mnemonic, BIP-32 key-derivation, BIP-44 path, BIP-84 native-segwit
CHAINS Ethereum, Bitcoin, Solana, Polygon
FEATURES mnemonic-generation, key-derivation, address-generation, transaction-signing, hardware-wallet-support (Ledger/Trezor)
SECURITY encrypted-keystore, memory-safe key-handling, air-gap-signing
STACK TypeScript, ethers.js v6, bitcoinjs-lib, @solana/web3.js
OUTPUT wallet library, CLI tool, encrypted storage module, and hardware wallet adapter''',
  ),

  TemplateItem(
    id: 'crypto_learn_cryptography',
    title: 'Learn Cryptography',
    description: 'Structured learning path from classical ciphers to modern applied cryptography',
    category: 'Cryptography & Blockchain',
    tags: ['learning', 'cryptography', 'curriculum', 'roadmap', 'math', 'security'],
    dsl: '''CREATE curriculum
TYPE cryptography-learning-path
LEVEL beginner-to-advanced
DURATION 20 weeks
TOPICS classical-ciphers, information-theory, symmetric-cryptography, asymmetric-cryptography, hash-functions, digital-signatures, zero-knowledge-proofs, post-quantum-cryptography, protocols (TLS, SSH, Signal)
MATH number-theory, modular-arithmetic, elliptic-curves, finite-fields, lattices
RESOURCES Christof Paar lectures, Boneh-Shoup textbook, cryptopals.com challenges, CryptoHack
HANDS-ON implement AES, RSA, ECDH from scratch, solve cryptopals sets
OUTPUT week-by-week plan, math prerequisites, implementation exercises, and challenge progression''',
  ),

  TemplateItem(
    id: 'crypto_learn_blockchain',
    title: 'Learn Blockchain Development',
    description: 'Complete blockchain development curriculum from Solidity basics to full DApp deployment',
    category: 'Cryptography & Blockchain',
    tags: ['learning', 'blockchain', 'solidity', 'web3', 'dapp', 'curriculum'],
    dsl: '''CREATE curriculum
TYPE blockchain-dev-learning-path
LEVEL beginner-to-professional
DURATION 24 weeks
TOPICS blockchain-fundamentals, Solidity-basics, smart-contract-patterns, DeFi-protocols, NFTs, security-and-auditing, Layer2, cross-chain-bridges, ZK-proofs, full-stack-DApp
TOOLS Hardhat, Foundry, ethers.js, wagmi, RainbowKit, The Graph, IPFS, OpenZeppelin
PROJECTS ERC-20-token, NFT-collection, DEX, lending-protocol, full-DApp-with-frontend
RESOURCES Cyfrin Updraft, Patrick Collins, Ethereum docs, Secureum
OUTPUT week-by-week roadmap, project specs, audit checklist, and job-ready portfolio guide''',
  ),
];
