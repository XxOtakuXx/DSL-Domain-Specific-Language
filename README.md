# DSL Prompt Studio

**Write structured commands. Get optimized AI prompts instantly.**

A native desktop app for Windows, macOS, and Linux that converts simple `KEY value` commands into token-efficient AI prompts, human-readable descriptions, and structured JSON — no internet required.

Built with Flutter. No webview. No Electron. Real native performance.

[![Release](https://img.shields.io/github/v/release/XxOtakuXx/DSL-Domain-Specific-Language?label=Latest%20Release)](https://github.com/XxOtakuXx/DSL-Domain-Specific-Language/releases/tag)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)]()

> **Full version history** — see [CHANGELOG.md](CHANGELOG.md)

---

## Table of Contents

- [Why DSL Prompt Studio?](#why-dsl-prompt-studio)
- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [Features](#features)
- [Installation](#installation)
- [User Guide](#user-guide)
- [DSL Reference](#dsl-reference)
- [Examples](#examples)
- [For Developers](#for-developers)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

---

## Why DSL Prompt Studio?

When you write AI prompts manually, they tend to look like this:

> *"Please create a modern dark-themed web application that includes user authentication functionality, a dashboard interface, and a payment processing system. I would like you to provide the full implementation code."*

That's **47 tokens**. The same intent as a DSL prompt:

```
CREATE app
TYPE web
FEATURES login, dashboard, payments
STYLE modern dark
OUTPUT full code
```

Compact output: **~23 tokens** — **51% fewer tokens**, same information.

At scale across hundreds of prompts, this saves real money on API costs and improves model focus.

---

## Quick Start

1. **Download** from the [Releases page](https://github.com/XxOtakuXx/DSL-Domain-Specific-Language/releases/latest)
2. **Open** the app — no installer, no runtime needed
3. **Type** your DSL in the left panel
4. **Press** `Ctrl+Enter` (or `Cmd+Enter` on Mac)
5. **Copy** the output from any of the three tabs: JSON, Compact Prompt, or Expanded Prompt

That's it. No account, no sign-up, no internet connection required.

---

## How It Works

```
 You write this                The app generates these
┌───────────────────┐         ┌──────────────────────────────────┐
│                   │         │  JSON tab                        │
│  CREATE app       │         │  { "create": "app",              │
│  TYPE web         │────────>│    "type": "web", ... }          │
│  FEATURES login,  │         ├──────────────────────────────────┤
│    dashboard      │         │  Compact Prompt tab              │
│  STYLE modern     │         │  TASK: build app                 │
│  OUTPUT full code │         │  TYPE: web                       │
│                   │         │  FEATURES:                       │
│                   │         │  - auth                          │
│                   │         │  - dashboard                     │
│                   │         │  STYLE: modern                   │
│                   │         │  OUTPUT: full code                │
│                   │         ├──────────────────────────────────┤
│                   │         │  Expanded Prompt tab             │
│                   │         │  Build a modern web app.         │
│                   │         │  Include auth and dashboard.     │
│                   │         │  Provide full code.              │
└───────────────────┘         └──────────────────────────────────┘
```

Each line in the editor follows a simple format: `KEY value`. That's the entire syntax.

---

## Features

### Core

| Feature | Description |
|---------|-------------|
| **Three output formats** | JSON, Compact Prompt (token-efficient), and Expanded Prompt (natural language) |
| **162 built-in templates** | Ready-made DSL prompts across 19 categories — load one and generate instantly |
| **Custom templates** | Save your own DSL prompts with title, description, category, and tags |
| **Generation history** | Every prompt you generate is saved locally — browse, search, restore, or delete |
| **Plain Talk mode** | Describe what you want in plain English — the app converts it to structured output |
| **Fully offline** | DSL mode and templates work with zero internet. Only Plain Talk with an AI provider needs a connection |

### Productivity

| Feature | Shortcut | Description |
|---------|----------|-------------|
| **Generate** | `Ctrl+Enter` | Instantly convert DSL to all three output formats |
| **Command Palette** | `Ctrl+P` | Keyboard launcher for all actions — generate, switch modes, navigate tabs |
| **DSL Key Reference** | `Ctrl+Shift+R` | Searchable cheat sheet of all supported keys with one-click copy |
| **Token counter** | — | Live approximate token count in the output tab bar |
| **Font size controls** | — | Adjust output panel font size (10–20pt) |
| **Word wrap toggle** | — | Switch between soft-wrapped and scrollable output |
| **File operations** | — | Load `.dsl`/`.txt` files, save your work, export output |

> On macOS, replace `Ctrl` with `Cmd`.

### AI Providers (Optional)

Configure an AI provider in Settings to power Plain Talk mode with smarter parsing:

| Provider | Model | Cost |
|----------|-------|------|
| **Gemini** | Gemini 2.0 Flash | Free tier available |
| **OpenAI** | GPT-4o-mini | Paid |
| **Anthropic** | Claude Haiku | Paid |
| **Ollama** | Any local model | Free (runs locally) |

DSL mode never makes network calls — it always works offline regardless of provider settings.

### Template Library — 19 Categories

<details>
<summary>View all categories and template counts</summary>

| Category | Templates | Category | Templates |
|----------|:---------:|----------|:---------:|
| Software Dev | 14 | E-Commerce | 6 |
| Mobile | 4 | Artificial Intelligence | 8 |
| API Design | 5 | Cybersecurity | 6 |
| Content & Writing | 10 | Data Engineering | 5 |
| AI & Prompts | 8 | Cloud & Infrastructure | 5 |
| DevOps | 7 | Information Technology | 6 |
| Data & ML | 7 | Security Systems | 8 |
| Business | 8 | Engineering | 6 |
| Education | 5 | Reverse Engineering | 5 |
| Creative | 5 | Mathematics | 6 |
| Legal & HR | 6 | Science | 6 |
| Research | 4 | Cryptography & Blockchain | 11 |

</details>

---

## Installation

### Option 1 — Download a Release (Recommended)

Go to the [Releases page](https://github.com/XxOtakuXx/DSL-Domain-Specific-Language/releases/latest) and download the file for your platform:

| Platform | File | How to run |
|----------|------|------------|
| **Windows** | `DSL-Prompt-Studio-Windows.zip` | Extract, double-click `dsl_domain_specific_language.exe` |
| **macOS** | `DSL-Prompt-Studio-macOS.zip` | Unzip, drag `.app` to Applications, open |
| **Linux** | `DSL-Prompt-Studio-Linux.tar.gz` | `tar -xzf ...`, then `./dsl_domain_specific_language` |

Self-contained builds — no Flutter, no runtime, no installer.

> **macOS:** On first launch, right-click the app and choose **Open** to bypass the Gatekeeper warning (the app is not notarized).

### Option 2 — Build from Source

Requires [Flutter](https://docs.flutter.dev/get-started/install) (3.x or later).

```bash
git clone https://github.com/XxOtakuXx/DSL-Domain-Specific-Language.git
cd DSL-Domain-Specific-Language
flutter pub get
flutter run -d windows    # or macos / linux
```

**Release build:**

```bash
flutter build windows     # → build\windows\x64\runner\Release\
flutter build macos       # → build/macos/Build/Products/Release/
flutter build linux       # → build/linux/x64/release/bundle/
```

<details>
<summary>Platform-specific build requirements</summary>

| Platform | Requirements |
|----------|-------------|
| **Windows** | Windows 10+ (x64), Visual Studio 2022 Build Tools |
| **macOS** | macOS 10.14+, Xcode |
| **Linux** | Ubuntu 22.04+, `sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev` |

</details>

---

## User Guide

### Writing DSL

Each line in the editor is one instruction:

```
KEY value
```

- One instruction per line
- First word = key (case-insensitive), rest = value
- Commas for multiple values: `FEATURES login, dashboard, payments`
- Lines starting with `#` are comments (ignored)
- Blank lines are ignored
- **Any key works** — the parser handles everything generically

### The 5 Special Keys

These keys have fixed positions in the output. All other keys appear between TYPE and FEATURES:

| Key | What it does | Example |
|-----|-------------|---------|
| `CREATE` | Names the thing to build | `CREATE app` |
| `TYPE` | Specifies the kind | `TYPE web` |
| `FEATURES` | Lists capabilities (comma-separated → bullet list) | `FEATURES login, dashboard` |
| `STYLE` | Sets the design direction | `STYLE modern dark` |
| `OUTPUT` | Defines what to deliver | `OUTPUT full code` |

### Output Modes

- **Compact** — token-efficient, keyword-driven. Best for AI APIs where you pay per token.
- **Expanded** — natural language sentences. Best for pasting into ChatGPT, Claude, or sharing with others.

### Using Templates

1. Click the **Templates** tab
2. Browse by category (sidebar) or type in the search bar
3. Hover a template card and click **Use Template** to load it into the editor

### Saving Custom Templates

1. Write your DSL in the editor
2. Click **Save Template** in the toolbar
3. Add a title, description, category, and tags
4. Find it under **My Templates** in the Templates screen

### Generation History

Click the **History** tab to see past generations (up to 100 entries):

- **Restore** — reload the original input back into the editor
- **Delete** — remove individual entries
- **Clear All** — wipe all history
- **Search** — filter by content

### Plain Talk Mode

Switch to **Plain Talk** in the toolbar, then type naturally:

> *"Build a React e-commerce site with login, product catalog, cart, and Stripe payments"*

Press **Generate** — the app converts it to structured output just like DSL mode.

With an AI provider configured, parsing is more accurate. Without one, the built-in offline parser handles common patterns.

### Command Palette

Press `Ctrl+P` to launch the Command Palette:

| Command | Action |
|---------|--------|
| Generate | Run the generator |
| Switch to DSL / Plain Talk | Toggle input mode |
| Open Templates / History / Settings | Navigate tabs |
| Clear Editor | Wipe current input |
| Load / Save / Export | File operations |
| Save Template | Save current DSL as a template |
| Toggle Compact/Expanded | Switch output mode |
| DSL Key Reference | Open the cheat sheet |

Navigate with arrow keys, confirm with `Enter`, dismiss with `Esc`.

### Configuring an AI Provider

1. Click the **Settings** tab
2. Select a provider (Gemini, OpenAI, Anthropic, or Ollama)
3. Paste your API key and click **Save**

| Provider | Where to get a key |
|----------|--------------------|
| Gemini | [aistudio.google.com/apikey](https://aistudio.google.com/apikey) |
| OpenAI | [platform.openai.com/api-keys](https://platform.openai.com/api-keys) |
| Anthropic | [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys) |
| Ollama | No key needed — [ollama.com/download](https://ollama.com/download) |

Your key is stored locally and never leaves your machine.

---

## DSL Reference

### Output Structure

**Compact:** `TASK` → `TYPE` → extra keys (input order) → `FEATURES` list → `STYLE` → `OUTPUT`

**Expanded:** Opening sentence (`STYLE` + `TYPE` + `CREATE`) → features sentence → extra key sentences → `OUTPUT` sentence

### Extra Keys by Category

You can use **any key** — these are common ones organized for reference.

<details>
<summary><strong>Software Development</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `STACK` | Full tech stack | `React, Node.js, PostgreSQL` |
| `FRAMEWORK` | Specific framework | `Next.js` / `Django` |
| `LANGUAGE` | Programming language | `TypeScript` / `Python` |
| `DATABASE` | Data store | `PostgreSQL, Redis` |
| `AUTH` | Authentication method | `JWT` / `OAuth2` |
| `PLATFORM` | Target platform | `AWS` / `Vercel` |
| `ARCHITECTURE` | System design pattern | `microservices` / `monolith` |
| `PROTOCOL` | Communication protocol | `REST` / `gRPC` |
| `TESTING` | Test strategy | `unit, integration, e2e` |
| `CONSTRAINTS` | Hard limits | `no external libraries` |

</details>

<details>
<summary><strong>API Design</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `RESOURCE` | Primary API resource | `users` / `orders` |
| `METHODS` | HTTP verbs | `GET, POST, PUT, DELETE` |
| `VERSION` | API version | `v1` |
| `FORMAT` | Request/response format | `JSON` / `XML` |
| `PAGINATION` | Pagination style | `cursor-based` / `offset` |
| `RATE_LIMIT` | Rate limiting | `100 req/min per user` |

</details>

<details>
<summary><strong>Content & Writing</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `TOPIC` | Subject matter | `Flutter desktop development` |
| `TONE` | Voice / register | `professional` / `casual` |
| `AUDIENCE` | Target readers | `developers` / `beginners` |
| `LENGTH` | Target length | `1000 words` / `short` |
| `PERSPECTIVE` | Point of view | `first person` / `third person` |
| `SECTIONS` | Required sections | `intro, body, conclusion` |
| `KEYWORDS` | SEO or focus terms | `Flutter, Dart, desktop` |
| `EXAMPLES` | Whether to include examples | `3 code examples` |

</details>

<details>
<summary><strong>AI / Prompt Engineering</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `ROLE` | Persona the AI should adopt | `senior engineer` / `tutor` |
| `TASK` | Core instruction | `summarize` / `explain` |
| `CONTEXT` | Background the AI needs | `legacy codebase, no tests` |
| `RULES` | Hard constraints | `no jargon` / `always cite sources` |
| `PERSONA` | Character or voice | `friendly and concise` |
| `AVOID` | What to exclude | `markdown` / `assumptions` |

</details>

<details>
<summary><strong>DevOps & Infrastructure</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `TRIGGER` | CI event | `push to main` / `pull request` |
| `STEPS` | Pipeline stages | `lint, test, build, deploy` |
| `ENVIRONMENT` | Target env | `staging` / `production` |
| `RUNNER` | CI runner | `ubuntu-latest` |
| `SECRETS` | Required secrets | `API_KEY, DATABASE_URL` |
| `ROLLBACK` | Rollback strategy | `automatic on failure` |

</details>

<details>
<summary><strong>Data & ML</strong></summary>

| Key | Purpose | Example |
|-----|---------|---------|
| `MODEL` | ML model type | `classification` / `LLM fine-tune` |
| `DATA` | Dataset description | `CSV, 50k rows, labeled` |
| `METRICS` | Evaluation metrics | `accuracy, F1, AUC` |
| `TRAINING` | Training approach | `transfer learning` |
| `INFERENCE` | Inference target | `real-time API` / `batch` |

</details>

### Keyword Auto-Compression

In Compact mode, common words are automatically shortened:

| You write | Becomes |
|-----------|---------|
| `login` / `authentication` / `user auth` | `auth` |
| `signup` / `sign up` | `registration` |
| `admin panel` / `administration` | `admin` |
| `database` | `db` |
| `notification(s)` | `notif(s)` |
| `user interface` | `ui` |
| `application` | `app` |
| `repository` | `repo` |
| `configuration` | `config` |
| `environment` | `env` |
| `documentation` | `docs` |
| `performance` | `perf` |
| `optimization` | `opt` |

Custom compressions can be added in [lib/services/prompt_builder.dart](lib/services/prompt_builder.dart) — edit the `_compress` map.

---

## Examples

### Web Application

```
CREATE app
TYPE web
STACK React, Node.js, PostgreSQL
AUTH JWT
FEATURES login, dashboard, payments, notifications
STYLE modern dark
OUTPUT full implementation with file structure
```

<details>
<summary>View output</summary>

**Compact:**
```
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
```
Build a modern dark web app. Include user authentication, dashboard,
payment system, and notifications. Stack: React, Node.js, PostgreSQL.
Auth: JWT. Provide full implementation with file structure.
```

</details>

### Mobile App

```
CREATE app
TYPE mobile
PLATFORM iOS, Android
FRAMEWORK Flutter
FEATURES onboarding, home feed, profile, push notifications
STYLE clean minimal
OUTPUT full Flutter project
```

### REST API

```
CREATE REST API
RESOURCE users
METHODS GET, POST, PUT, DELETE
AUTH JWT
VERSION v1
FORMAT JSON
PAGINATION cursor-based
OUTPUT OpenAPI 3.0 spec + Express.js implementation
```

### Blog Post

```
CREATE blog post
TOPIC how to build a native desktop app with Flutter
TONE conversational but technical
AUDIENCE intermediate developers
LENGTH 1500 words
SECTIONS intro, setup, building the UI, state management, packaging, conclusion
OUTPUT markdown with code examples
```

### CI/CD Pipeline

```
CREATE GitHub Actions workflow
TRIGGER push to main, pull request
STEPS lint, unit tests, build, docker push, deploy
ENVIRONMENT staging on PR, production on main
PLATFORM AWS ECS
ROLLBACK automatic on health check failure
OUTPUT complete YAML workflow file
```

### AI System Prompt

```
CREATE system prompt
ROLE senior software architect
TASK review architecture decisions and suggest improvements
CONTEXT distributed system, 10M DAU, latency-sensitive
RULES always explain trade-offs, cite CAP theorem where relevant
AVOID recommending rewrites without justification
OUTPUT structured review with priority levels
```

### ML Pipeline

```
CREATE ML pipeline
TASK binary classification
DATA customer churn CSV, 200k rows, imbalanced 90/10
MODEL XGBoost with SMOTE oversampling
METRICS accuracy, F1, AUC-ROC
TRAINING 5-fold cross-validation
OUTPUT Python notebook with EDA, training, and evaluation
```

---

## For Developers

### Project Structure

```
lib/
├── main.dart                         App entry point
├── theme/
│   └── app_colors.dart               Color palette and text styles
├── providers/
│   └── dsl_providers.dart            Riverpod state providers (17 providers)
├── data/
│   └── template_library.dart         162 built-in templates (19 categories)
├── services/
│   ├── parser.dart                   DSL text → Map<String, dynamic>
│   ├── prompt_builder.dart           Map → compact / expanded prompt strings
│   ├── plain_talk_parser.dart        Offline rule-based Plain Talk parser
│   ├── ai_parser.dart                Dispatches to configured AI provider
│   ├── settings_service.dart         Persists provider + API key
│   ├── file_service.dart             Load / save / export via file_picker
│   ├── database_helper.dart          Shared SQLite singleton
│   ├── history_service.dart          Generation history (max 100 entries)
│   ├── custom_template_service.dart  Personal template library
│   ├── token_counter.dart            Approximate token count
│   └── ai_providers/
│       ├── ai_provider.dart          Abstract interface + shared prompt
│       ├── gemini_provider.dart      Gemini 2.0 Flash
│       ├── openai_provider.dart      GPT-4o-mini
│       ├── anthropic_provider.dart   Claude Haiku
│       └── ollama_provider.dart      Local Ollama
├── screens/
│   ├── home_screen.dart              Editor with resizable split pane
│   ├── templates_screen.dart         Template library browser
│   ├── history_screen.dart           Generation history browser
│   └── settings_screen.dart          AI provider configuration
└── widgets/
    ├── editor.dart                   Syntax-highlighted DSL editor
    ├── plain_talk_editor.dart        Natural language input field
    ├── output_panel.dart             Tabbed output with token count
    ├── toolbar.dart                  Action bar (generate, save, export)
    ├── command_palette.dart          Ctrl+P launcher + DSL reference
    └── title_bar.dart                Custom title bar with nav tabs
```

### Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.x (native desktop — Skia/Impeller, no webview) |
| Language | Dart 3.x |
| State | Riverpod 2.x (`StateProvider`) |
| Database | sqflite 2.x (SQLite) |
| HTTP | http 1.x |
| File I/O | file_picker 8.x |
| Window | window_manager 0.4.x |
| Settings | shared_preferences 2.x |
| Paths | path_provider 2.x |

### State Management

The app uses [Riverpod](https://riverpod.dev/) with `StateProvider`s:

<details>
<summary>View all providers</summary>

| Provider | Type | Purpose |
|----------|------|---------|
| `navPageProvider` | `NavPage` | Active tab (editor / templates / history / settings) |
| `dslInputProvider` | `String` | Raw DSL text in editor |
| `plainInputProvider` | `String` | Raw text in Plain Talk mode |
| `inputModeProvider` | `InputMode` | DSL vs Plain Talk |
| `selectedProviderIdProvider` | `AiProviderId` | Configured AI provider |
| `apiKeyProvider` | `String` | API key for selected provider |
| `ollamaModelProvider` | `String` | Ollama model name |
| `isAiLoadingProvider` | `bool` | True while AI call in-flight |
| `generatedOutputProvider` | `GeneratedOutput?` | Last generated result |
| `selectedTabProvider` | `int` | Active output tab (0/1/2) |
| `isCompactModeProvider` | `bool` | Compact vs Expanded |
| `statusMessageProvider` | `String` | Toolbar status feedback |
| `templateSearchProvider` | `String` | Template search query |
| `templateCategoryProvider` | `String?` | Selected category filter |
| `historyProvider` | `List<HistoryEntry>` | Loaded history entries |
| `historySearchProvider` | `String` | History search query |
| `customTemplatesProvider` | `List<CustomTemplate>` | Loaded custom templates |

</details>

### Parser & Prompt Builder

```dart
// Parse DSL text into a map
DslParser().parse(input) // → Map<String, dynamic>

// Generate prompts from the map
PromptBuilder().buildCompact(data)   // → token-efficient prompt
PromptBuilder().buildExpanded(data)  // → natural language prompt
```

The parser splits on newlines, extracts `KEY value` pairs, normalizes keys to lowercase, splits comma values into lists, and silently skips comments (`#`), blank lines, and invalid lines.

### Running Tests

```bash
flutter test       # run all tests
flutter analyze    # static analysis
```

Tests cover: key-value extraction, comma splitting, key normalization, comment/blank handling, compact compression, expanded generation, and edge cases.

---

## FAQ

<details>
<summary><strong>Does this send my data anywhere?</strong></summary>

In DSL mode: **no**. Everything is fully offline. If you configure an AI provider, Plain Talk input is sent to that provider's API when you press Generate. Your API key is stored locally and never leaves your machine.

</details>

<details>
<summary><strong>Can I use the template library offline?</strong></summary>

**Yes.** All 162 templates are compiled into the app. No network, no external files.

</details>

<details>
<summary><strong>Can I use the output with any AI?</strong></summary>

**Yes.** The output is plain text. Paste the compact or expanded prompt into ChatGPT, Claude, Gemini, Copilot, or any API.

</details>

<details>
<summary><strong>What if I use a key that isn't listed?</strong></summary>

It works. Unknown keys are included in the output as-is. The parser handles any key generically.

</details>

<details>
<summary><strong>Where is my data stored?</strong></summary>

History and custom templates are stored in a local SQLite database (`dsl_studio.db`) in your system's app support directory:
- **Windows:** `%APPDATA%\dsl_domain_specific_language`
- **macOS:** `~/Library/Application Support/dsl_domain_specific_language`

History is capped at 100 entries (oldest auto-removed).

</details>

<details>
<summary><strong>Plain Talk gave an unexpected result</strong></summary>

Without an AI provider, the offline parser uses keyword matching — it works best for common patterns. For nuanced descriptions, configure a provider in Settings. Gemini has a free tier and works well.

</details>

<details>
<summary><strong>How accurate is the token count?</strong></summary>

It's an approximation (word count x 1.0). Real token counts vary by model and tokenizer (typically 0.75-1.3 tokens per word). Use it for ballpark comparison, not billing.

</details>

<details>
<summary><strong>Can I add custom keyword compressions?</strong></summary>

Yes — edit the `_compress` map in [lib/services/prompt_builder.dart](lib/services/prompt_builder.dart).

</details>

---

## Contributing

Pull requests are welcome. For major changes, open an issue first.

```bash
git clone https://github.com/YOUR_USERNAME/DSL-Domain-Specific-Language.git
cd DSL-Domain-Specific-Language
flutter pub get
flutter run -d windows  # or macos / linux
```

Run `flutter analyze` and `flutter test` before submitting.

---

## License

MIT — use it, fork it, ship it.
