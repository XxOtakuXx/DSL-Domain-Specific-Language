import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider.dart';

class OpenAiProvider implements AiProvider {
  OpenAiProvider(this._apiKey);

  final String _apiKey;

  @override
  String get name => 'OpenAI';

  @override
  String get id => 'openai';

  @override
  Future<Map<String, dynamic>> parse(String input) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final body = jsonEncode({
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': kAiSystemPrompt},
        {'role': 'user', 'content': input},
      ],
      'temperature': 0.2,
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: body,
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      final snippet = response.body.length > 200
          ? '${response.body.substring(0, 200)}…'
          : response.body;
      throw Exception('OpenAI ${response.statusCode}: $snippet');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final text =
        decoded['choices']?[0]?['message']?['content'] as String?;
    if (text == null) throw Exception('OpenAI: empty response');
    return jsonDecode(stripCodeFences(text)) as Map<String, dynamic>;
  }
}
