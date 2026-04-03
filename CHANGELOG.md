# Changelog

All notable changes to DSL Prompt Studio are documented here.
Versions follow [Semantic Versioning](https://semver.org/).

---

## [v1.3.0] — 2026-04-04

### ✨ New Features

- **Generation History** — every prompt you generate is automatically saved to a local SQLite database. Browse, search, restore to editor, or delete entries from the new History tab. Capped at 100 entries (oldest auto-removed).
- **Custom Templates** — save any DSL from the editor as a personal template with a title, description, category, and tags. Stored locally, visible in the Templates screen under "My Templates".
- **Command Palette** (`Ctrl+P` / `Cmd+P`) — keyboard-first launcher for all major actions: generate, switch modes, open tabs, clear editor, save template, export, toggle output mode, and open the DSL reference.
- **DSL Key Reference** (`Ctrl+Shift+R` / `Cmd+Shift+R`) — in-app searchable cheat sheet of all supported keys across 7 categories, with one-click clipboard copy per row.
- **Token counter** — live approximate token estimate shown in the output panel tab bar for the active tab. Updates on tab switch.
- **Font size controls** — increase or decrease the output panel font size (range 10–20pt) without leaving the app.
- **Word wrap toggle** — switch the output panel between soft-wrapped and horizontally-scrollable (no-wrap) views.
- **Save Template button** in the toolbar — saves the current DSL directly from the editor (DSL mode only).

### 🔧 Improvements

- Output panel tab bar now shows token count with animated transitions between tabs.
- `Ctrl+P` / `Cmd+P` and `Ctrl+Shift+R` / `Cmd+Shift+R` keyboard shortcuts added globally.
- Templates screen "My Templates" sidebar section appears automatically when custom templates exist.
- Custom template cards show a `MINE` badge and hover-reveal delete button.
- History entries display relative timestamps ("just now", "5m ago", "3h ago", "2d ago").

### 🐛 Bug Fixes

- **Security:** Gemini API key moved from URL query parameter to `x-goog-api-key` header — prevents key leaking to logs and proxies.
- **Security:** Replaced `exit(0)` with `windowManager.close()` for graceful shutdown — prevents SQLite corruption on mid-write exit.
- **Bug:** History restore now correctly routes Plain Talk entries to the Plain Talk editor instead of the DSL editor.
- **Bug:** Fixed `List.cast<String>()` crash in prompt builder — now safely maps elements via `.toString()`.
- **Bug:** Fixed toggle button border radius using hardcoded label check — now uses positional `isLeft` parameter.
- **Bug:** Fixed status message race condition — rapid messages no longer clear each other prematurely.
- **Bug:** Fixed `FocusNode` leak in Command Palette — keyboard listener node now properly disposed.
- **Stability:** Unified database access through shared `DatabaseHelper` singleton — eliminates race condition from two services opening the same SQLite file independently.
- **Cleanup:** Removed 438 lines of dead code (`settings_panel.dart` — never imported).

---

## [v1.2.0] — 2026-04-03

### ✨ New Features

- **Template Library** — 83 professionally crafted DSL prompt templates across 12 categories: Software Dev, Mobile, API Design, Content & Writing, AI & Prompts, DevOps, Data & ML, Business, Education, Creative, Legal & HR, and Research.
- **Templates tab** — new top-level navigation tab for instant access to the full template library.
- **Real-time search** — filters templates by title, description, and tags as you type.
- **Category sidebar** — one-click filter to narrow templates to a specific category.
- **Plain Talk mode** — describe what you want in plain English; the app converts it to structured DSL output automatically.
- **AI provider integration** — connect Gemini, OpenAI (GPT-4o-mini), Anthropic (Claude Haiku), or a local Ollama instance to power Plain Talk parsing. Falls back to an offline rule-based parser when no provider is configured.
- **Settings tab** — configure your AI provider and API key; setting persists between sessions.

---

## [v1.0.2] — 2026-03-29

### 🐛 Bug Fixes

- Fixed keys with comma-separated values (e.g. `STACK React, Node.js`) being silently dropped from compact prompt output.

---

## [v1.0.1] — 2026-03-29

### 🐛 Bug Fixes

- Fixed the editor losing keyboard focus after the first Generate — `Ctrl+Enter` now works reliably on every subsequent press.

---

## [v1.0.0] — 2026-03-29

### 🎉 Initial Release

- Windows, macOS, and Linux native desktop builds.
- DSL editor with syntax highlighting and line numbers.
- JSON, Compact Prompt, and Expanded Prompt output tabs.
- Resizable split pane, drag-to-resize divider.
- Load / Save / Export file operations.
- Compact keyword compression map.
- `Ctrl+Enter` generate shortcut.
