import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider.dart';

class OllamaProvider implements AiProvider {
  OllamaProvider({
    required this.model,
    this.baseUrl = 'http://localhost:11434',
  });

  final String model;
  final String baseUrl;

  @override
  String get name => 'Ollama ($model)';

  @override
  String get id => 'ollama';

  @override
  Future<Map<String, dynamic>> parse(String input) async {
    final uri = Uri.parse('$baseUrl/api/chat');
    final body = jsonEncode({
      'model': model,
      'stream': false,
      'messages': [
        {'role': 'system', 'content': kAiSystemPrompt},
        {'role': 'user', 'content': input},
      ],
    });

    final response = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Ollama ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final text =
        decoded['message']?['content'] as String?;
    if (text == null) throw Exception('Ollama: empty response');
    return jsonDecode(stripCodeFences(text)) as Map<String, dynamic>;
  }
}
