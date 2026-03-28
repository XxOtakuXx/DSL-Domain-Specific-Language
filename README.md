# DSL Prompt Studio

A **true native desktop application** for Windows, macOS, and Linux that lets you write structured human-readable commands and instantly convert them into optimized AI prompts and structured JSON — with zero internet connection required.

Built with Flutter. No webview. No Electron. Real native performance.

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
┌─────────────────────────────────────────────────────────────┐
│  DSL Prompt Studio    [Generate] [Clear] [Compact|Expanded]  │
│                       [Load] [Save] [Export]                 │
├──────────────────────────┬──────────────────────────────────┤
│  DSL Editor              │  JSON | Compact Prompt | Expanded │
│                          │                                   │
│  1  CREATE app           │  {                                │
│  2  TYPE web             │    "create": "app",               │
│  3  FEATURES login,      │    "type": "web",                 │
│     dashboard            │    "features": [                  │
│  4  STYLE modern dark    │      "login",                     │
│  5  OUTPUT full code     │      "dashboard"                  │
│                          │    ]                              │
│  ← drag to resize →      │  }                                │
└──────────────────────────┴──────────────────────────────────┘
│  ● DSL Prompt Studio — Flutter Native Desktop   Ctrl+Enter  │
└─────────────────────────────────────────────────────────────┘
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

**All keys are flexible.** Common ones:

| Key | What it means | Example |
| --- | --- | --- |
| `CREATE` | What you're building | `CREATE app` |
| `TYPE` | The type/category | `TYPE web` |
| `FEATURES` | Comma-separated feature list | `FEATURES login, dashboard` |
| `STYLE` | Visual or design style | `STYLE modern dark` |
| `OUTPUT` | What you want back | `OUTPUT full code` |
| `STACK` | Tech stack | `STACK React, Node, PostgreSQL` |
| `AUDIENCE` | Target users | `AUDIENCE developers` |
| `TONE` | Writing tone | `TONE professional` |

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

### 5. Save and Load Files

| Button | What it does |
| --- | --- |
| **Load** | Open a `.dsl` or `.txt` file — loads it directly into the editor |
| **Save** | Save your current DSL as a `.dsl` file for later |
| **Export** | Save output as `.json` (JSON tab) or `.txt` (prompt tabs) |

This lets you build a **library of DSL templates** for different use cases.

---

## DSL Examples

### Build a Web App

```text
CREATE app
TYPE web
FEATURES auth, dashboard, payments, notifications
STYLE modern dark
STACK React, Node.js, PostgreSQL
OUTPUT full implementation
```

**Compact prompt generated:**

```text
TASK: build app
TYPE: web

FEATURES:
- auth
- dashboard
- payments
- notifs

STYLE: modern dark
STACK: React, Node.js, PostgreSQL
OUTPUT: full implementation
```

**Expanded prompt generated:**

```text
Build a modern dark web app featuring user authentication, dashboard,
payment system, and notifications. Stack: React, Node.js, PostgreSQL.
Provide full implementation.
```

---

### Write a Blog Post

```text
CREATE blog post
TOPIC Flutter desktop development
TONE professional
AUDIENCE developers
LENGTH 1000 words
OUTPUT markdown
```

---

### Define an API

```text
CREATE REST API
RESOURCE users
METHODS GET, POST, PUT, DELETE
AUTH JWT
OUTPUT OpenAPI spec
```

---

### System Architecture

```text
CREATE microservice
NAME auth-service
RESPONSIBILITIES login, token refresh, logout
DATABASE Redis, PostgreSQL
PROTOCOL gRPC
OUTPUT architecture diagram + code
```

---

## Keyword Compression Reference

The compact mode automatically compresses common terms:

| Input | Compressed to |
| --- | --- |
| `login` | `auth` |
| `authentication` | `auth` |
| `user authentication` | `auth` |
| `admin panel` | `admin` |
| `administration` | `admin` |
| `database` | `db` |
| `notifications` | `notifs` |
| `user interface` | `ui` |
| `application` | `app` |
| `configuration` | `config` |
| `deployment` | `deploy` |
| `documentation` | `docs` |
| `performance` | `perf` |
| `optimization` | `opt` |
| `responsive design` | `responsive` |

Terms not in this list are passed through unchanged.

---

## Project Structure (For Developers)

```text
lib/
├── main.dart                    Entry point — window config, ProviderScope, theme
├── theme/
│   └── app_colors.dart          VS Code-inspired color palette and text styles
├── providers/
│   └── dsl_providers.dart       Riverpod state providers
├── services/
│   ├── parser.dart              DSL text → Map<String, dynamic>
│   ├── prompt_builder.dart      Map → compact prompt / expanded prompt
│   └── file_service.dart        Load, save, export via file_picker
├── screens/
│   └── home_screen.dart         Main layout — resizable split pane, keyboard shortcuts
└── widgets/
    ├── editor.dart              Syntax-highlighted DSL editor with line numbers
    ├── output_panel.dart        Tabbed output: JSON / Compact / Expanded
    └── toolbar.dart             Generate, Clear, mode toggle, file operations
```

### State Management

This app uses [Riverpod](https://riverpod.dev/) with simple `StateProvider`s:

| Provider | Type | Purpose |
| --- | --- | --- |
| `dslInputProvider` | `StateProvider<String>` | Raw text in the editor |
| `generatedOutputProvider` | `StateProvider<GeneratedOutput?>` | Last generated result |
| `selectedTabProvider` | `StateProvider<int>` | Active output tab (0/1/2) |
| `isCompactModeProvider` | `StateProvider<bool>` | Compact vs Expanded toggle |
| `statusMessageProvider` | `StateProvider<String>` | Toolbar status feedback |

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
No. The app is fully offline. Nothing leaves your machine. No telemetry, no network calls.

**Q: Can I add my own keywords to the compression map?**
Yes — edit the `_compress` map in [lib/services/prompt_builder.dart](lib/services/prompt_builder.dart). Add any `'input': 'output'` entry.

**Q: Can I use this with any AI?**
Yes. The output is plain text. Paste the compact or expanded prompt into ChatGPT, Claude, Gemini, Copilot, or any API.

**Q: What if I use a key that isn't in the examples?**
It works fine. Unknown keys are included in the output as-is. The parser and builder handle any key generically.

**Q: Can I load existing `.txt` prompt files?**
Yes. The Load button accepts both `.dsl` and `.txt` files.

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
