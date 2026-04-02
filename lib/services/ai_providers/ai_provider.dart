/// Shared system prompt used by every AI provider.
const String kAiSystemPrompt =
    'You are a structured data extractor. Given a plain English description '
    'of a software project, extract and return ONLY a valid JSON object with '
    'these keys:\n'
    '- "create": short noun phrase of what to build\n'
    '- "type": one of [web, mobile, api, desktop, cli, other]\n'
    '- "features": array of key features\n'
    '- "style": visual/technical style if mentioned (or omit)\n'
    'No explanation. No markdown. JSON only.';

/// Abstract interface every AI provider must implement.
abstract class AiProvider {
  String get name;
  String get id;

  /// Returns parsed structured data, or throws on failure.
  Future<Map<String, dynamic>> parse(String input);
}

/// Strips markdown code fences (```json ... ``` or ``` ... ```) from AI output.
String stripCodeFences(String text) {
  final trimmed = text.trim();
  final fencePattern = RegExp(r'^```(?:json)?\s*([\s\S]*?)\s*```$');
  final match = fencePattern.firstMatch(trimmed);
  return match != null ? match.group(1)! : trimmed;
}
