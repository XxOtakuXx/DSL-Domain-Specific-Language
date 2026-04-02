# Natural Language "Plain Talk" Mode — Multi-Provider AI

## Overview

Add a **Plain Talk** input mode alongside the existing DSL editor. Users type a plain English sentence; the app uses whichever AI provider the user has configured, or falls back to a built-in offline rule-based parser if none is set up.

---

## New Dependencies → `pubspec.yaml`

| Package | Reason |
|---|---|
| `http: ^1.2.0` | All API HTTP calls |
| `shared_preferences: ^2.3.0` | Persist provider choice + API keys between sessions |

---

## Supported AI Providers

| Provider | Model | Key Required | Notes |
|---|---|---|---|
| **Gemini** | `gemini-2.0-flash` | Yes (free tier available) | Google AI Studio |
| **OpenAI** | `gpt-4o-mini` | Yes (paid) | OpenAI platform |
| **Anthropic** | `claude-haiku-3-5` | Yes (paid) | Anthropic console |
| **Ollama** | user-selected model | No (runs locally) | 100% offline/free |
| **None** | — | — | Falls back to built-in rule-based parser |

---

## Architecture — AI Provider Abstraction

#### [NEW] `lib/services/ai_providers/ai_provider.dart`
Abstract interface every provider implements:
```dart
abstract class AiProvider {
  String get name;
  String get id;
  Future<Map<String, dynamic>> parse(String input);
}
```

#### [NEW] `lib/services/ai_providers/gemini_provider.dart`
Calls `generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent`

#### [NEW] `lib/services/ai_providers/openai_provider.dart`
Calls `api.openai.com/v1/chat/completions` with model `gpt-4o-mini`

#### [NEW] `lib/services/ai_providers/anthropic_provider.dart`
Calls `api.anthropic.com/v1/messages` with model `claude-haiku-3-5`

#### [NEW] `lib/services/ai_providers/ollama_provider.dart`
Calls `http://localhost:11434/api/chat` — no key needed, user picks model name (e.g. `llama3`, `mistral`)

All providers use the same system prompt to extract structured JSON, and return `Map<String, dynamic>` identical to `DslParser` output.

**System prompt (shared across all providers):**
```
You are a structured data extractor. Given a plain English description of a software project, extract and return ONLY a valid JSON object with these keys:
- "create": short noun phrase of what to build
- "type": one of [web, mobile, api, desktop, cli, other]
- "features": array of key features
- "style": visual/technical style if mentioned (or omit)
No explanation. No markdown. JSON only.
```

---

## Proposed Changes

### Component 1 — Providers

#### [MODIFY] `lib/providers/dsl_providers.dart`
- Add `enum InputMode { dsl, plainTalk }`
- Add `inputModeProvider`
- Add `plainInputProvider`
- Add `enum AiProviderId { none, gemini, openai, anthropic, ollama }`
- Add `selectedProviderIdProvider = StateProvider<AiProviderId>((ref) => AiProviderId.none)`
- Add `apiKeyProvider = StateProvider<String>((ref) => '')` (key for the selected provider)
- Add `ollamaModelProvider = StateProvider<String>((ref) => 'llama3')` (Ollama model name)
- Add `isAiLoadingProvider = StateProvider<bool>((ref) => false)`

---

### Component 2 — Settings Service

#### [NEW] `lib/services/settings_service.dart`
Persists to `SharedPreferences`:
- `loadSettings()` → `SettingsData { providerId, apiKey, ollamaModel }`
- `saveSettings(SettingsData)`
- `clearApiKey()`

---

### Component 3 — Rule-Based Fallback Parser

#### [NEW] `lib/services/plain_talk_parser.dart`
Pure-Dart, zero-dependency, instant:
- **Intent** → `create`: build/create/make/design/develop/write
- **Type**: website/site → `web`; mobile/iOS/Android → `mobile`; API/backend/server → `api`; CLI/script/tool → `cli`; dashboard → `web`
- **Feature keyword map**: selling/shop/store → `e-commerce`; login/auth → `auth`; admin → `admin panel`; payment/checkout → `payments`; search → `search`; chat/message → `messaging`; notification → `notifications`; map/location → `maps`; analytics → `analytics`
- **Style**: modern/minimal/dark/responsive/clean captured verbatim

---

### Component 4 — AI Parser Dispatcher

#### [NEW] `lib/services/ai_parser.dart`
Routes to the correct provider based on `AiProviderId`:
```dart
class AiParser {
  static Future<Map<String, dynamic>> parse({
    required String input,
    required AiProviderId providerId,
    required String apiKey,
    required String ollamaModel,
  }) async { ... }
}
```
On error or timeout → returns `null`, caller falls back to `PlainTalkParser`

---

### Component 5 — Plain Talk Editor Widget

#### [NEW] `lib/widgets/plain_talk_editor.dart`
- Large, friendly `TextField` (sans-serif, relaxed padding)
- Hint: `"Describe what you want to build in plain English..."`
- **Live detection strip** at the bottom (rule-based preview, instant):
  `type: web  •  features: 3 detected  •  style: modern`
- Header badge: `✦ AI: Gemini` / `✦ AI: Ollama` / `⊘ Offline` based on configured provider

---

### Component 6 — Settings Panel

#### [NEW] `lib/widgets/settings_panel.dart`
A modal/drawer with:

**Provider selector** — segmented control or dropdown:
```
○ None (offline)   ○ Gemini   ○ OpenAI   ○ Anthropic   ○ Ollama
```

**Dynamic fields** based on selection:
- Gemini / OpenAI / Anthropic → API Key field (obscured, show/hide toggle) + link to get key
- Ollama → Base URL field (default: `http://localhost:11434`) + Model name field (e.g. `llama3`)
- None → message: "Using built-in rule-based parser"

**Status row**: `● AI Active — Gemini` or `○ Offline mode`

Provider get-key links:
| Provider | Link |
|---|---|
| Gemini | `https://aistudio.google.com/apikey` |
| OpenAI | `https://platform.openai.com/api-keys` |
| Anthropic | `https://console.anthropic.com/settings/keys` |
| Ollama | `https://ollama.com/download` |

---

### Component 7 — Toolbar Updates

#### [MODIFY] `lib/widgets/toolbar.dart`
- Add **Input Mode toggle**: `DSL` ↔ `Plain Talk` (after app name, before Generate)
- Add **Settings ⚙ button** (far right) → opens `SettingsPanel`
- While AI is loading: Generate button shows spinner + `"Thinking…"`
- Status bar: `Plain Talk → Prompt  •  AI: Gemini` or `AI: Offline`

---

### Component 8 — Home Screen

#### [MODIFY] `lib/screens/home_screen.dart`
- On startup: load settings → set providers
- Watch `inputModeProvider` → swap left panel
- `_generate()`:
  - DSL mode → `DslParser` (unchanged)
  - Plain Talk + provider configured → `AiParser.parse()` (async) → on error fall back to `PlainTalkParser`
  - Plain Talk + no provider → `PlainTalkParser` (sync, instant)

---

## Data Flow

```
User types plain English
        │
  inputMode == plainTalk?
        │
  Provider configured?
   ├─ YES → AiParser ──→ Gemini / OpenAI / Anthropic / Ollama
   │              └── error/timeout ──┐
   │                                  ▼
   └─ NO ──────────────→ PlainTalkParser (offline)
                                  │
                                  ▼
                       Map<String, dynamic>
                                  │
                                  ▼
                    PromptBuilder (unchanged)
                                  │
                         compact / expanded prompt
```

---

## Verification Plan

### Build
```
flutter pub add http shared_preferences
flutter build windows --debug
```

### Manual Tests
1. No provider → Plain Talk uses rule-based parser → instant result
2. Gemini key → calls Gemini, richer output
3. OpenAI key → calls OpenAI
4. Anthropic key → calls Claude
5. Ollama (running locally) → calls localhost, no key needed
6. Network off with any key → graceful fallback + status message
7. DSL mode → completely unchanged behavior
8. Settings persist after app restart
