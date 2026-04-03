# DSL Prompt Studio

A **true native desktop application** for Windows, macOS, and Linux that lets you write structured human-readable commands and instantly convert them into optimized AI prompts and structured JSON — with zero internet connection required.

Built with Flutter. No webview. No Electron. Real native performance.

---

## Changelog

### v1.3.0

- New: **Generation History** — every prompt you generate is automatically saved; browse, search, restore, or delete entries from the new History tab
- New: **Custom Templates** — save your own DSL prompts to a personal template library with title, description, category, and tags; browse them alongside built-in templates
- New: **Command Palette** (`Ctrl+P` / `Cmd+P`) — keyboard-first launcher for all actions: generate, switch modes, open templates, clear editor, and more
- New: **DSL Key Reference** (`Ctrl+Shift+R` / `Cmd+Shift+R`) — in-app cheat sheet with 7 categories of keys and per-row clipboard copy
- New: **Token counter** — live token estimate displayed in the output panel tab bar for the currently active output tab
- New: **Font size controls** — increase or decrease the output panel font size (range: 10–20pt)
- New: **Word wrap toggle** — switch the output panel between soft-wrapped and horizontally-scrollable views
- New: **Save Template button** in the toolbar — save the current DSL directly from the editor with a title, description, category, and tags

### v1.2.0

- New: **Template Library** — 83 professionally crafted DSL templates across 12 categories (Software Dev, Mobile, API Design, Content & Writing, AI & Prompts, DevOps, Data & ML, Business, Education, Creative, Legal & HR, Research)
- New: **Templates tab** in the title bar — browse, search, filter by category, and load any template into the editor in one click
- New: real-time search filters templates by title, description, and tags

### v1.1.0

- New: **Plain Talk mode** — describe what you want in plain English instead of DSL; the app converts it into structured output
- New: **AI provider integration** — connect Gemini, OpenAI, Anthropic, or local Ollama for smarter Plain Talk parsing
- New: **Settings tab** — configure and persist your AI provider and API key
- New: offline rule-based fallback parser when no AI provider is configured

### v1.0.2

- Fixed: keys with comma-separated values (e.g. `STACK React, Node.js`) were silently dropped from compact output

### v1.0.1

- Fixed: typing in the editor and pressing Ctrl+Enter stopped working after the first Generate

### v1.0.0

- Initial release — Windows, macOS, Linux native desktop builds

---

## Who Is This For?

| You are... | This helps you... |
| --- | --- |
| **An AI power user** | Stop rewriting the same bloated prompts. Write DSL once, generate compact or verbose prompts on demand. |
| **A developer / engineer** | Templating complex AI instructions? Define them as structured DSL, export clean JSON, pipe into any API. |
| **A prompt engineer** | Compare token-efficient compact prompts vs. full expanded versions side-by-side. |
| **A technical writer** | Turn structured outlines into readable natural language descriptions in one click. |
| **A total beginner** | No coding required. Write plain English-ish commands, get usable AI prompts out. |

---

## What Is a DSL?

DSL stands for **Domain Specific Language** — a mini-language designed for one specific purpose.

This app's DSL is dead simple. Each line is a command:

```text
KEY value
```

That's it. One key, one value, per line.

**Example:**

```text
CREATE app
TYPE web
FEATURES login, dashboard, payments
STYLE modern dark
OUTPUT full code
```

You write that in the left panel. Press **Generate** (or `Ctrl+Enter`). The right panel instantly shows you:

- **JSON** — structured machine-readable data
- **Compact Prompt** — token-efficient AI prompt (~50% fewer tokens)
- **Expanded Prompt** — human-readable natural language version

---

## What Problem Does It Solve?

When you write AI prompts manually, you tend to write things like:

> *"Please create a modern dark-themed web application that includes user authentication functionality, a dashboard interface, and a payment processing system. I would like you to provide the full implementation code for this application."*

That's **47 tokens**. The same intent as a compact DSL prompt:

```text
TASK: build app
TYPE: web

FEATURES:
- auth
- dashboard
- payments

STYLE: modern dark
OUTPUT: full code
```

That's **~23 tokens** — **51% fewer tokens**, same information. At scale across hundreds of prompts, this saves real money on API costs and improves model focus.

---

## Screenshots / Layout

```text
┌────────────────────────────────────────────────────────────────────┐
│ ⬛ DSL Prompt Studio │ Editor │ Templates │ History │ Settings │ — □ ✕ │
├────────────────────────────────────────────────────────────────────┤
│  [DSL | Plain Talk]  [Generate] [Clear] [Compact|Expanded]         │
│  [Load] [Save] [Save Template] [Export]                            │
├───────────────────────────┬────────────────────────────────────────┤
│  DSL Editor               │  JSON | Compact Prompt | Expanded      │
│                           │  ── 142 tokens  A- A+ ⇌ Copy ──        │
│  1  CREATE app            │                                        │
│  2  TYPE web              │  {                                     │
│  3  FEATURES login,       │    "create": "app",                    │
│     dashboard             │    "type": "web",                      │
│  4  STYLE modern dark     │    "features": [                       │
│  5  OUTPUT full code      │      "login",                          │
│                           │      "dashboard"                       │
│  ← drag to resize →       │    ]                                   │
│                           │  }                                     │
├───────────────────────────┴────────────────────────────────────────┤
│  ● DSL Prompt Studio — Flutter Native Desktop       Ctrl+Enter     │
└────────────────────────────────────────────────────────────────────┘
```

**Templates tab:**

```text
┌──────────────────────────────────────────────────────────────┐
│  CATEGORIES          │  🔍 Search templates…                 │
│  ─────────────────   │  ────────────────────────────────────  │
│  All Templates  83   │  83 templates                         │
│  Software Dev   14   │                                       │
│  Mobile          4   │  ┌──────────────┐ ┌──────────────┐   │
│  API Design      5   │  │ Full-stack   │ │ REST API     │   │
│  Content & Writ 10   │  │ Web App      │ │              │   │
│  AI & Prompts    8   │  │ CREATE app   │ │ CREATE api   │   │
│  DevOps          7   │  │ TYPE full... │ │ TYPE REST    │   │
│  Data & ML       7   │  │              │ │              │   │
│  Business        8   │  └──────────────┘ └──────────────┘   │
│  Education       5   │                                       │
│  Creative        5   │  (hover a card → "Use Template" btn)  │
│  Legal & HR      6   │                                       │
│  Research        4   │                                       │
│  ─────────────────   │                                       │
│  My Templates    2   │  (MINE badge on custom cards)         │
└──────────────────────┴──────────────────────────────────────┘
```

**History tab:**

```text
┌──────────────────────────────────────────────────────────────┐
│  History  •  12 entries    🔍 Search history…   [Clear All]  │
├──────────────────────────────────────────────────────────────┤
│  ┌────────────────────────────────────────────────────────┐  │
│  │ DSL  Full-stack Web App                       2h ago   │  │
│  │      TASK: build app TYPE: web STACK: React…           │  │
│  │                                   [↺ Restore] [🗑 Del] │  │
│  └────────────────────────────────────────────────────────┘  │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ PT   Build a React e-commerce site with login…  5h ago │  │
│  │      TASK: build app TYPE: web STACK: React…           │  │
│  └────────────────────────────────────────────────────────┘  │
│  …                                                           │
└──────────────────────────────────────────────────────────────┘
```

---

## Installation

### Option 1 — Download a Release (No Flutter required)

Go to the [Releases page](https://github.com/XxOtakuXx/DSL-Domain-Specific-Language/releases/latest) and download the file for your platform:

| Platform | File | How to run |
| --- | --- | --- |
| **Windows** | `DSL-Prompt-Studio-Windows.zip` | Extract the zip, double-click `dsl_domain_specific_language.exe` |
| **macOS** | `DSL-Prompt-Studio-macOS.zip` | Unzip, drag the `.app` to Applications, double-click to open |
| **Linux** | `DSL-Prompt-Studio-Linux.tar.gz` | `tar -xzf DSL-Prompt-Studio-Linux.tar.gz`, then `./dsl_domain_specific_language` |

These are self-contained builds. No Flutter, no runtime, no installer wizard.

> **macOS note:** On first launch, right-click the app and choose **Open** to bypass the Gatekeeper warning (app is not notarized).

---

### Option 2 — Build from Source

You need **Flutter** installed. This is a one-time setup.

#### Install Flutter

**Windows:**

1. Go to [flutter.dev/docs/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
2. Download the Flutter SDK zip
3. Extract it to `C:\flutter`
4. Add `C:\flutter\bin` to your system PATH
   - Search "environment variables" in Start Menu
   - Under System Variables → `Path` → Edit → New → paste `C:\flutter\bin`
5. Open a new terminal and run `flutter doctor`, then follow any instructions it shows

**macOS:**

```bash
# Install via Homebrew (recommended)
brew install --cask flutter
```

**Linux:**

```bash
# Ubuntu/Debian
sudo snap install flutter --classic
```

After Flutter is installed, enable desktop support:

```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

#### Clone and Run

```bash
# 1. Clone the repository
git clone https://github.com/XxOtakuXx/DSL-Domain-Specific-Language.git
cd DSL-Domain-Specific-Language

# 2. Install dependencies
flutter pub get

# 3. Run in development mode
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

#### Build a Release Binary

```bash
# Windows — produces .exe + DLLs in build\windows\x64\runner\Release\
flutter build windows

# macOS — produces .app bundle in build/macos/Build/Products/Release/
flutter build macos

# Linux — produces binary in build/linux/x64/release/bundle/
flutter build linux
```

The release build is self-contained and can be distributed to any machine without Flutter installed.

---

## How to Use

### 1. Write Your DSL

Click in the left editor panel and type your instructions. Each line follows the format:

```text
KEY value
```

**Rules:**

- One instruction per line
- The first word on each line is the **key** (case-insensitive)
- Everything after the first space is the **value**
- Use commas to specify multiple values: `FEATURES login, dashboard, payments`
- Lines starting with `#` are comments and are ignored
- Blank lines are ignored
- Invalid lines are silently skipped — nothing will crash

**All keys are flexible.** There are 5 special keys with fixed positions in the output, plus any extra key you invent:

| Key | Special? | Role | Example |
| --- | --- | --- | --- |
| `CREATE` | Yes | Becomes `TASK: build …` in compact; subject of the opening sentence in expanded | `CREATE app` |
| `TYPE` | Yes | `TYPE: …` line right after TASK | `TYPE web` |
| `FEATURES` | Yes | Renders as a bullet list in compact; `Include X, Y, and Z.` in expanded | `FEATURES login, dashboard` |
| `STYLE` | Yes | `STYLE: …` after the features block; prepended to opening sentence in expanded | `STYLE modern dark` |
| `OUTPUT` | Yes | Always last line; `Provide …` in expanded | `OUTPUT full code` |
| Any other key | No | Appears between TYPE and FEATURES in compact order; as `Key: value.` sentence in expanded | `STACK React, Node` |

See the **Key Reference Cheat Sheet** below for a full catalog of useful keys by category.

You can use **any key you want** — the parser handles everything generically.

---

### 2. Choose a Mode

The toolbar has a **Compact / Expanded** toggle:

- **Compact** — strips filler words, uses short keywords, maximizes information per token. Best for feeding into AI APIs where you're paying per token or want laser-focused output.
- **Expanded** — converts your DSL into clean natural language sentences. Best for pasting into ChatGPT/Claude directly, sharing with teammates, or documentation.

---

### 3. Generate

Press the **Generate** button in the toolbar, or use the keyboard shortcut:

- **Windows / Linux:** `Ctrl + Enter`
- **macOS:** `Cmd + Enter`

The right panel updates instantly with all three output formats.

---

### 4. Use the Output

**JSON tab** — copy the structured data and use it in code, APIs, or pipelines.

**Compact Prompt tab** — paste into any AI tool for token-efficient, focused output.

**Expanded Prompt tab** — paste into AI chat interfaces for human-readable prompts.

The **Copy** button (top-right of the output panel) copies the current tab's content to your clipboard in one click.

---

### 5. Use the Template Library

Click the **Templates** tab in the title bar to browse 83 ready-made DSL prompts:

- **Filter by category** — click any category in the left sidebar
- **Search** — type in the search bar to filter by title, description, or tags
- **Load a template** — hover a card and click **Use Template** to load it into the editor and jump straight to the Editor tab
- **My Templates** section appears in the sidebar once you have saved any custom templates

Templates cover: Software Dev, Mobile, API Design, Content & Writing, AI & Prompts, DevOps, Data & ML, Business, Education, Creative, Legal & HR, and Research.

---

### 6. Save Custom Templates

In the Editor (DSL mode), click **Save Template** in the toolbar to save the current DSL to your personal library:

- Enter a **title** (required)
- Optionally add a **description**, **category**, and **comma-separated tags**
- Your template is saved locally to `dsl_studio.db` and appears in the Templates screen under **My Templates**
- Custom templates can be deleted by hovering the card and clicking the delete icon

---

### 7. Browse Generation History

Click the **History** tab to see every prompt you have generated in this session and across past sessions (up to 100 entries):

- Entries are sorted newest-first with relative timestamps ("just now", "5m ago", "3d ago")
- **DSL** or **PT** badge shows which mode produced the entry
- **Restore** (↺ icon on hover) — loads the original input back into the editor and returns to the Editor tab
- **Delete** (trash icon on hover) — removes that entry
- **Clear All** — deletes all history after a confirmation dialog
- **Search** — filters by title, DSL input, or compact prompt content

---

### 8. Command Palette

Press `Ctrl+P` (Windows/Linux) or `Cmd+P` (macOS) to open the Command Palette — a keyboard-first launcher for all major actions:

| Command | What it does |
| --- | --- |
| Generate | Run the generator (same as Ctrl+Enter) |
| Switch to DSL / Plain Talk | Toggle input mode |
| Open Templates | Navigate to the Templates tab |
| Open History | Navigate to the History tab |
| Open Settings | Navigate to the Settings tab |
| Clear Editor | Wipe the current input |
| Load File | Open a DSL/txt file |
| Save File | Save to disk |
| Save Template | Save current DSL as a custom template |
| Export Output | Export JSON/prompt to file |
| Toggle Compact/Expanded | Switch output mode |
| DSL Key Reference | Open the in-app cheat sheet |

Navigate with ↑ / ↓ arrows, confirm with **Enter**, dismiss with **Esc**.

---

### 9. DSL Key Reference

Press `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (macOS) to open the DSL Key Reference panel — a searchable, categorized cheat sheet of all supported keys with one-click copy per row.

---

### 10. Save and Load Files

| Button | What it does |
| --- | --- |
| **Load** | Open a `.dsl` or `.txt` file — loads it directly into the editor |
| **Save** | Save your current DSL as a `.dsl` file for later |
| **Export** | Save output as `.json` (JSON tab) or `.txt` (prompt tabs) |

---

### 11. Plain Talk Mode

Click **Plain Talk** in the toolbar mode toggle to switch from DSL to natural language input.

Type a plain English description:

> *"Build a React e-commerce site with login, product catalog, shopping cart, and Stripe payments"*

Press **Generate** — the app converts it to structured output exactly like DSL mode.

**With an AI provider configured** (see Settings), the parsing is smarter and handles more complex descriptions.

**Without an AI provider**, the built-in offline rule-based parser handles common intents instantly.

---

### 12. Configure an AI Provider (Optional)

Click the **Settings** tab to set up an AI provider for Plain Talk mode:

| Provider | Cost | Notes |
| --- | --- | --- |
| **Gemini** | Free tier available | [aistudio.google.com/apikey](https://aistudio.google.com/apikey) |
| **OpenAI** | Paid (gpt-4o-mini) | [platform.openai.com/api-keys](https://platform.openai.com/api-keys) |
| **Anthropic** | Paid (claude-haiku) | [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys) |
| **Ollama** | Free, runs locally | [ollama.com/download](https://ollama.com/download) |

Select your provider, paste your API key, and click **Save**. The setting persists between sessions. DSL mode is unaffected — it never makes network calls.

---

## Key Reference Cheat Sheet

### How the Output Is Built

The compact and expanded builders treat keys differently depending on whether they are "special" or "extra":

**Compact output order:** `TASK` → `TYPE` → extra keys (input order) → `FEATURES` list → `STYLE` → `OUTPUT`

**Expanded output order:** opening sentence (`STYLE` + `TYPE` + `CREATE`) → features sentence → extra key sentences → `OUTPUT` sentence

---

### Special Keys

These 5 keys have fixed positions and dedicated formatting:

| Key | Compact output | Expanded output |
| --- | --- | --- |
| `CREATE` | `TASK: build <value>` — always first | Subject of the opening sentence |
| `TYPE` | `TYPE: <value>` — second line | Appended to the opening sentence |
| `FEATURES` | `FEATURES:` bullet list — after extra keys | `Include X, Y, and Z.` sentence |
| `STYLE` | `STYLE: <value>` — after features | Adjective in the opening sentence |
| `OUTPUT` | `OUTPUT: <value>` — always last | `Provide <value>.` last sentence |

Comma-separated values in FEATURES become individual bullets. Any other special key with a comma becomes a joined string (e.g. `STYLE modern, minimal` → `STYLE: modern, minimal`).

---

### Extra Keys by Category

Any key not in the special 5 is an **extra key**. It appears as `KEY: value` between TYPE and FEATURES in compact, and as `Key: value.` in expanded. Use any name you want.

#### Software Development

| Key | Purpose | Example value |
| --- | --- | --- |
| `STACK` | Full tech stack | `React, Node.js, PostgreSQL` |
| `FRAMEWORK` | Specific framework | `Next.js` / `Django` / `Spring Boot` |
| `LANGUAGE` | Programming language | `TypeScript` / `Python` / `Rust` |
| `DATABASE` | Data store | `PostgreSQL, Redis` |
| `AUTH` | Authentication method | `JWT` / `OAuth2` / `session cookies` |
| `PLATFORM` | Target platform | `AWS` / `Vercel` / `self-hosted` |
| `ARCHITECTURE` | System design pattern | `microservices` / `monolith` / `serverless` |
| `PROTOCOL` | Communication protocol | `REST` / `gRPC` / `WebSocket` |
| `TESTING` | Test strategy | `unit, integration, e2e` |
| `CONSTRAINTS` | Hard limits | `no external libraries` / `must run offline` |

#### API Design

| Key | Purpose | Example value |
| --- | --- | --- |
| `RESOURCE` | Primary API resource | `users` / `orders` / `products` |
| `METHODS` | HTTP verbs | `GET, POST, PUT, DELETE` |
| `VERSION` | API version | `v1` |
| `FORMAT` | Request/response format | `JSON` / `XML` |
| `PAGINATION` | Pagination style | `cursor-based` / `offset` |
| `RATE_LIMIT` | Rate limiting | `100 req/min per user` |

#### Content & Writing

| Key | Purpose | Example value |
| --- | --- | --- |
| `TOPIC` | Subject matter | `Flutter desktop development` |
| `TONE` | Voice / register | `professional` / `casual` / `technical` / `persuasive` |
| `AUDIENCE` | Target readers | `developers` / `executives` / `beginners` |
| `LENGTH` | Target length | `1000 words` / `short` / `detailed` |
| `PERSPECTIVE` | Point of view | `first person` / `third person` |
| `SECTIONS` | Required sections | `intro, body, conclusion, CTA` |
| `KEYWORDS` | SEO or focus terms | `Flutter, Dart, desktop` |
| `EXAMPLES` | Whether to include examples | `3 code examples` / `real-world cases` |

#### AI / Prompt Engineering

| Key | Purpose | Example value |
| --- | --- | --- |
| `ROLE` | Persona the AI should adopt | `senior engineer` / `technical writer` / `tutor` |
| `TASK` | Core instruction | `summarize` / `explain` / `generate` / `analyze` |
| `CONTEXT` | Background the AI needs | `legacy codebase, no tests` |
| `RULES` | Hard constraints | `no jargon` / `always cite sources` |
| `PERSONA` | Character or voice | `friendly and concise` |
| `AVOID` | What to exclude | `markdown` / `bullet points` / `assumptions` |

#### DevOps & Infrastructure

| Key | Purpose | Example value |
| --- | --- | --- |
| `TRIGGER` | CI event | `push to main` / `pull request` / `schedule` |
| `STEPS` | Pipeline stages | `lint, test, build, deploy` |
| `ENVIRONMENT` | Target env | `staging` / `production` |
| `RUNNER` | CI runner | `ubuntu-latest` / `macos-14` |
| `SECRETS` | Required secrets | `API_KEY, DATABASE_URL` |
| `ROLLBACK` | Rollback strategy | `automatic on failure` |

#### Data & ML

| Key | Purpose | Example value |
| --- | --- | --- |
| `MODEL` | ML model type | `classification` / `regression` / `LLM fine-tune` |
| `DATA` | Dataset description | `CSV, 50k rows, labeled` |
| `METRICS` | Evaluation metrics | `accuracy, F1, AUC` |
| `TRAINING` | Training approach | `transfer learning` / `from scratch` |
| `INFERENCE` | Inference target | `real-time API` / `batch` |

---

### Keyword Auto-Compression

In **Compact mode**, these input values are automatically shortened to save tokens:

| You write | Compact outputs |
| --- | --- |
| `login` / `authentication` / `user auth` | `auth` |
| `sign in` / `signin` | `auth` |
| `signup` / `sign up` | `registration` |
| `admin panel` / `administration` | `admin` |
| `database` | `db` |
| `notification` / `notifications` | `notif` / `notifs` |
| `user interface` | `ui` |
| `application` | `app` |
| `repository` | `repo` |
| `configuration` | `config` |
| `environment` | `env` |
| `deployment` | `deploy` |
| `documentation` | `docs` |
| `performance` | `perf` |
| `optimization` / `optimized` | `opt` |
| `responsive design` | `responsive` |

Anything not in this list passes through unchanged. To add your own, edit `_compress` in [lib/services/prompt_builder.dart](lib/services/prompt_builder.dart).

---

## Examples by Use Case

### Web Application

```text
CREATE app
TYPE web
STACK React, Node.js, PostgreSQL
AUTH JWT
FEATURES login, dashboard, payments, notifications
STYLE modern dark
OUTPUT full implementation with file structure
```

**Compact:**

```text
TASK: build app
TYPE: web
STACK: React, Node.js, PostgreSQL
AUTH: JWT

FEATURES:
- auth
- dashboard
- payments
- notifs

STYLE: modern dark
OUTPUT: full implementation with file structure
```

**Expanded:**

```text
Build a modern dark web app. Include user authentication, dashboard,
payment system, and notifications. Stack: React, Node.js, PostgreSQL.
Auth: JWT. Provide full implementation with file structure.
```

---

### Mobile App

```text
CREATE app
TYPE mobile
PLATFORM iOS, Android
FRAMEWORK Flutter
FEATURES onboarding, home feed, profile, push notifications
STYLE clean minimal
OUTPUT full Flutter project
```

---

### REST API

```text
CREATE REST API
RESOURCE users
METHODS GET, POST, PUT, DELETE
AUTH JWT
VERSION v1
FORMAT JSON
PAGINATION cursor-based
OUTPUT OpenAPI 3.0 spec + Express.js implementation
```

---

### GraphQL API

```text
CREATE GraphQL API
RESOURCE products, orders, users
AUTH OAuth2
DATABASE MongoDB
FEATURES mutations, subscriptions, pagination
OUTPUT schema + resolvers
```

---

### Blog Post / Article

```text
CREATE blog post
TOPIC how to build a native desktop app with Flutter
TONE conversational but technical
AUDIENCE intermediate developers
LENGTH 1500 words
SECTIONS intro, setup, building the UI, state management, packaging, conclusion
KEYWORDS Flutter, desktop, Dart, native
OUTPUT markdown with code examples
```

**Compact:**

```text
TASK: build blog post
TOPIC: how to build a native desktop app with Flutter
TONE: conversational but technical
AUDIENCE: intermediate developers
LENGTH: 1500 words
SECTIONS: intro, setup, building the UI, state management, packaging, conclusion
KEYWORDS: Flutter, desktop, Dart, native
OUTPUT: markdown with code examples
```

**Expanded:**

```text
Build a blog post. Topic: how to build a native desktop app with Flutter.
Tone: conversational but technical. Audience: intermediate developers.
Length: 1500 words. Sections: intro, setup, building the UI, state management,
packaging, conclusion. Keywords: Flutter, desktop, Dart, native.
Provide markdown with code examples.
```

---

### Marketing Email

```text
CREATE email
TYPE promotional
TONE friendly, persuasive
AUDIENCE existing customers
GOAL re-engage lapsed users
PRODUCT DSL Prompt Studio v1.0
OFFER 30-day free trial of Pro tier
SECTIONS subject line, opening hook, value prop, CTA, footer
OUTPUT plain text + HTML version
```

---

### Code Review Prompt

```text
CREATE code review
LANGUAGE TypeScript
FOCUS security, performance, readability
PATTERNS SOLID, DRY, no magic numbers
AVOID nitpicks on formatting
CONTEXT new contributor, first PR
OUTPUT inline comments + summary
```

---

### CI/CD Pipeline

```text
CREATE GitHub Actions workflow
TRIGGER push to main, pull request
STEPS lint, unit tests, build, docker push, deploy
ENVIRONMENT staging on PR, production on main
PLATFORM AWS ECS
SECRETS DATABASE_URL, AWS_ACCESS_KEY_ID
ROLLBACK automatic on health check failure
OUTPUT complete YAML workflow file
```

---

### Database Schema

```text
CREATE database schema
DATABASE PostgreSQL
TABLES users, sessions, posts, comments, tags
RELATIONS user has_many posts, post has_many comments, post has_many tags
INDEXES users.email, posts.created_at, posts.user_id
CONSTRAINTS email unique, soft deletes on posts
OUTPUT SQL migration files
```

---

### AI System Prompt

```text
CREATE system prompt
ROLE senior software architect
TASK review architecture decisions and suggest improvements
CONTEXT distributed system, 10M daily active users, latency-sensitive
RULES always explain trade-offs, cite CAP theorem where relevant, no vague advice
AVOID recommending rewrites without justification
OUTPUT structured review with priority levels
```

---

### Data Science / ML

```text
CREATE ML pipeline
TASK binary classification
DATA customer churn CSV, 200k rows, imbalanced 90/10
MODEL XGBoost with SMOTE oversampling
METRICS accuracy, F1, AUC-ROC
TRAINING 5-fold cross-validation
FEATURES age, tenure, usage, support_tickets
OUTPUT Python notebook with EDA, training, and evaluation
```

---

### Microservice

```text
CREATE microservice
NAME payment-service
RESPONSIBILITIES charge, refund, webhook handling, idempotency
PROTOCOL gRPC internal, REST external
DATABASE PostgreSQL for ledger, Redis for idempotency keys
AUTH service-to-service mTLS
OUTPUT Go service with proto definitions and Docker setup
```

---

## Project Structure (For Developers)

```text
lib/
├── main.dart                         Entry point — window config, ProviderScope, theme
├── theme/
│   └── app_colors.dart               VS Code-inspired color palette and text styles
├── providers/
│   └── dsl_providers.dart            Riverpod state providers (14 providers)
├── data/
│   └── template_library.dart         83 built-in DSL templates (pure Dart, no I/O)
├── services/
│   ├── parser.dart                   DSL text → Map<String, dynamic>
│   ├── prompt_builder.dart           Map → compact prompt / expanded prompt
│   ├── plain_talk_parser.dart        Offline rule-based Plain Talk → Map
│   ├── ai_parser.dart                Dispatches to the configured AI provider
│   ├── settings_service.dart         Persists provider selection + API key
│   ├── file_service.dart             Load, save, export via file_picker
│   ├── history_service.dart          SQLite-backed generation history (max 100)
│   ├── custom_template_service.dart  SQLite-backed personal template library
│   ├── token_counter.dart            Approximate token count for output display
│   └── ai_providers/
│       ├── ai_provider.dart          Abstract interface
│       ├── gemini_provider.dart      Gemini 2.0 Flash
│       ├── openai_provider.dart      GPT-4o-mini
│       ├── anthropic_provider.dart   Claude Haiku
│       └── ollama_provider.dart      Local Ollama
├── screens/
│   ├── home_screen.dart              Editor — resizable split pane, keyboard shortcuts
│   ├── templates_screen.dart         Built-in + custom template library
│   ├── history_screen.dart           Generation history browser
│   └── settings_screen.dart          AI provider configuration
└── widgets/
    ├── editor.dart                   Syntax-highlighted DSL editor with line numbers
    ├── plain_talk_editor.dart        Plain Talk text field with live detection strip
    ├── output_panel.dart             Tabbed output with token count, font size, word wrap
    ├── toolbar.dart                  Generate, Clear, Save Template, mode toggle, file ops
    ├── command_palette.dart          Ctrl+P command launcher + DSL reference panel
    ├── settings_panel.dart           Provider selector UI component
    └── title_bar.dart                Custom title bar with nav tabs + window controls
```

### State Management

This app uses [Riverpod](https://riverpod.dev/) with simple `StateProvider`s:

| Provider | Type | Purpose |
| --- | --- | --- |
| `navPageProvider` | `StateProvider<NavPage>` | Active tab: editor / templates / history / settings |
| `dslInputProvider` | `StateProvider<String>` | Raw DSL text in the editor |
| `plainInputProvider` | `StateProvider<String>` | Raw text in Plain Talk mode |
| `inputModeProvider` | `StateProvider<InputMode>` | DSL vs Plain Talk |
| `selectedProviderIdProvider` | `StateProvider<AiProviderId>` | Configured AI provider |
| `apiKeyProvider` | `StateProvider<String>` | API key for the selected provider |
| `ollamaModelProvider` | `StateProvider<String>` | Ollama model name |
| `isAiLoadingProvider` | `StateProvider<bool>` | True while an AI call is in-flight |
| `generatedOutputProvider` | `StateProvider<GeneratedOutput?>` | Last generated result |
| `selectedTabProvider` | `StateProvider<int>` | Active output tab (0/1/2) |
| `isCompactModeProvider` | `StateProvider<bool>` | Compact vs Expanded toggle |
| `statusMessageProvider` | `StateProvider<String>` | Toolbar status feedback |
| `templateSearchProvider` | `StateProvider<String>` | Search query on Templates screen |
| `templateCategoryProvider` | `StateProvider<String?>` | Selected category filter |
| `historyProvider` | `StateProvider<List<HistoryEntry>>` | Loaded history entries |
| `historySearchProvider` | `StateProvider<String>` | Search query on History screen |
| `customTemplatesProvider` | `StateProvider<List<CustomTemplate>>` | Loaded custom templates |

### Parser Logic

[lib/services/parser.dart](lib/services/parser.dart)

```dart
DslParser().parse(input) // → Map<String, dynamic>
```

- Splits on newlines
- Extracts `KEY` and `value` by first space
- Normalizes keys to lowercase
- Comma values → `List<String>`
- Comments (`#`) and blank lines → skipped
- Invalid lines → silently ignored

### Prompt Builder Logic

[lib/services/prompt_builder.dart](lib/services/prompt_builder.dart)

```dart
PromptBuilder().buildCompact(data)   // → token-efficient prompt string
PromptBuilder().buildExpanded(data)  // → natural language prompt string
```

Compact output follows a fixed structure: `TASK → TYPE → extra keys → FEATURES list → STYLE → OUTPUT`.
Expanded output assembles human sentences from the same data.

### Running Tests

```bash
flutter test
```

Tests cover the parser and prompt builder:

- Key-value extraction
- Comma array splitting
- Key normalization
- Comment and blank line skipping
- Compact keyword compression
- Expanded sentence generation
- Empty input edge cases

---

## Tech Stack

| Component | Technology |
| --- | --- |
| UI Framework | Flutter 3.x (native desktop) |
| Language | Dart 3.x |
| State Management | Riverpod 2.x |
| File I/O | file_picker 8.x |
| Window Management | window_manager 0.4.x |
| HTTP (AI providers) | http 1.x |
| Settings persistence | shared_preferences 2.x |
| Local database | sqflite 2.x (SQLite — history + custom templates) |
| App data path | path_provider 2.x |
| Rendering | Flutter engine (Skia / Impeller) — no webview |

---

## Platform Notes

### Windows

- Minimum: Windows 10 (x64)
- Builds to a standalone folder with `.exe` + required DLLs
- Visual Studio 2022 Build Tools required to build from source

### macOS

- Minimum: macOS 10.14 Mojave
- Builds to a `.app` bundle (arm64, runs on Intel via Rosetta 2)
- Xcode required to build from source
- Sandbox entitlements configured for file access

### Linux

- Tested on Ubuntu 22.04+
- Requires `gtk3` and `clang` to build from source:

```bash
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
```

---

## Frequently Asked Questions

**Q: Does this send my data anywhere?**
In DSL mode and Plain Talk with no provider configured: no. Everything is fully offline. If you configure an AI provider in Settings, your Plain Talk input is sent to that provider's API when you press Generate. Your API key is stored locally in the system's shared preferences — it never leaves your machine otherwise.

**Q: Can I use the template library offline?**
Yes. All 83 templates are compiled into the app as Dart data. No network, no files, no I/O — they load instantly.

**Q: Can I add my own keywords to the compression map?**
Yes — edit the `_compress` map in [lib/services/prompt_builder.dart](lib/services/prompt_builder.dart). Add any `'input': 'output'` entry.

**Q: Can I use this with any AI?**
Yes. The output is plain text. Paste the compact or expanded prompt into ChatGPT, Claude, Gemini, Copilot, or any API. Or configure a provider in Settings to power Plain Talk mode directly.

**Q: What if I use a key that isn't in the examples?**
It works fine. Unknown keys are included in the output as-is. The parser and builder handle any key generically.

**Q: Can I load existing `.txt` prompt files?**
Yes. The Load button accepts both `.dsl` and `.txt` files.

**Q: Plain Talk mode gave me a different result than I expected.**
Without an AI provider, the offline parser uses keyword matching — it works best for common patterns (web app, mobile app, API, etc.). For more nuanced descriptions, configure a provider in Settings. Gemini has a free tier and works well.

**Q: Where is my history and custom templates stored?**
In a SQLite database (`dsl_studio.db`) inside your system's app support directory — `%APPDATA%\dsl_domain_specific_language` on Windows, `~/Library/Application Support/dsl_domain_specific_language` on macOS. History is capped at 100 entries (oldest are automatically removed).

**Q: Can I use the Command Palette with the keyboard only?**
Yes. `Ctrl+P` opens it, ↑ / ↓ navigate the list, `Enter` executes the selected command, `Esc` dismisses it. No mouse required.

**Q: How is the token count calculated?**
It's an approximation: word count × 1.0. Real token counts vary by model and tokenizer (typically 0.75–1.3 tokens per word). The count is for ballpark comparison — not billing-accurate.

**Q: The window is too small / large. Can I resize it?**
Yes — drag any window edge. The minimum size is 800×560. Your OS remembers the window position.

---

## Contributing

Pull requests are welcome. For major changes, open an issue first.

```bash
# Fork the repo, then:
git clone https://github.com/YOUR_USERNAME/DSL-Domain-Specific-Language.git
cd DSL-Domain-Specific-Language
flutter pub get
flutter run -d windows  # or macos / linux
```

Please run `flutter analyze` and `flutter test` before submitting a PR.

---

## License

MIT — use it, fork it, ship it.
