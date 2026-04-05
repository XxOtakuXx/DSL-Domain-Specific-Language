import '../providers/dsl_providers.dart';
import 'ai_providers/gemini_provider.dart';
import 'ai_providers/openai_provider.dart';
import 'ai_providers/anthropic_provider.dart';
import 'ai_providers/ollama_provider.dart';
import 'ai_providers/studio_ai_provider.dart';
import 'plain_talk_parser.dart';

class AiParser {
  /// Routes to the correct provider and returns `(result, usedAi)`.
  /// Falls back to [PlainTalkParser] on any error or timeout.
  static Future<(Map<String, dynamic>, bool, String?)> parse({
    required String input,
    required AiProviderId providerId,
    required String apiKey,
    required String ollamaModel,
  }) async {
    try {
      final Map<String, dynamic> result;
      switch (providerId) {
        case AiProviderId.studio:
          result = await const StudioAiProvider().parse(input);
        case AiProviderId.gemini:
          result = await GeminiProvider(apiKey).parse(input);
        case AiProviderId.openai:
          result = await OpenAiProvider(apiKey).parse(input);
        case AiProviderId.anthropic:
          result = await AnthropicProvider(apiKey).parse(input);
        case AiProviderId.ollama:
          result = await OllamaProvider(model: ollamaModel).parse(input);
        case AiProviderId.none:
          return (PlainTalkParser().parse(input), false, null);
      }
      return (result, true, null);
    } catch (e) {
      return (PlainTalkParser().parse(input), false, e.toString());
    }
  }
}
