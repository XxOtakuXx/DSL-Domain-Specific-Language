import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Navigation ───────────────────────────────────────────────────────────────

enum NavPage { editor, templates, settings }

final navPageProvider = StateProvider<NavPage>((ref) => NavPage.editor);

// ── Input mode ────────────────────────────────────────────────────────────────

enum InputMode { dsl, plainTalk }

/// The current editor mode (strict DSL vs Plain Talk natural language).
final inputModeProvider = StateProvider<InputMode>((ref) => InputMode.dsl);

/// Raw plain-text input for Plain Talk mode.
final plainInputProvider = StateProvider<String>((ref) => '');

// ── AI provider selection ─────────────────────────────────────────────────────

enum AiProviderId { none, gemini, openai, anthropic, ollama }

/// Which AI provider is currently selected.
final selectedProviderIdProvider =
    StateProvider<AiProviderId>((ref) => AiProviderId.none);

/// API key for the selected provider (Gemini / OpenAI / Anthropic).
final apiKeyProvider = StateProvider<String>((ref) => '');

/// Ollama model name (e.g. "llama3", "mistral").
final ollamaModelProvider = StateProvider<String>((ref) => 'llama3');

/// True while the AI API call is in-flight.
final isAiLoadingProvider = StateProvider<bool>((ref) => false);

const String kDemoInput = '''CREATE app
TYPE web
FEATURES login, dashboard, payments
STYLE modern dark
OUTPUT full code''';

// ── Data model ────────────────────────────────────────────────────────────────

class GeneratedOutput {
  const GeneratedOutput({
    required this.json,
    required this.compactPrompt,
    required this.expandedPrompt,
  });

  final Map<String, dynamic> json;
  final String compactPrompt;
  final String expandedPrompt;

  static const GeneratedOutput empty = GeneratedOutput(
    json: {},
    compactPrompt: '',
    expandedPrompt: '',
  );
}

// ── Providers ─────────────────────────────────────────────────────────────────

/// Raw DSL text in the editor.
final dslInputProvider = StateProvider<String>((ref) => kDemoInput);

/// Last successfully generated output (null = never generated).
final generatedOutputProvider = StateProvider<GeneratedOutput?>((ref) => null);

/// Active output tab: 0 = JSON, 1 = Compact Prompt, 2 = Expanded Prompt.
final selectedTabProvider = StateProvider<int>((ref) => 0);

/// Default prompt mode shown in the toolbar toggle.
final isCompactModeProvider = StateProvider<bool>((ref) => true);

/// Transient status message shown in the toolbar (e.g. "Copied!").
final statusMessageProvider = StateProvider<String>((ref) => '');

// ── Templates ─────────────────────────────────────────────────────────────────

/// Search query on the Templates screen.
final templateSearchProvider = StateProvider<String>((ref) => '');

/// Selected category filter on the Templates screen (null = All Templates).
final templateCategoryProvider = StateProvider<String?>((ref) => null);
