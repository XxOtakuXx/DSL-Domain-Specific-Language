import 'package:flutter_riverpod/flutter_riverpod.dart';

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
