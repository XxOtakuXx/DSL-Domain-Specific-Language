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
];
