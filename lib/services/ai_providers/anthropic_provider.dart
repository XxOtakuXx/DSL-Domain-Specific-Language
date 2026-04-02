import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider.dart';

class AnthropicProvider implements AiProvider {
  AnthropicProvider(this._apiKey);

  final String _apiKey;

  @override
  String get name => 'Anthropic';

  @override
  String get id => 'anthropic';

  @override
  Future<Map<String, dynamic>> parse(String input) async {
    final uri = Uri.parse('https://api.anthropic.com/v1/messages');
    final body = jsonEncode({
      'model': 'claude-haiku-4-5',
      'max_tokens': 256,
      'system': kAiSystemPrompt,
      'messages': [
        {'role': 'user', 'content': input},
      ],
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: body,
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Anthropic ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final text =
        decoded['content']?[0]?['text'] as String?;
    if (text == null) throw Exception('Anthropic: empty response');
    return jsonDecode(stripCodeFences(text)) as Map<String, dynamic>;
  }
}
