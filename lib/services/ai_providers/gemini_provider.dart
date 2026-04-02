import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_provider.dart';

class GeminiProvider implements AiProvider {
  GeminiProvider(this._apiKey);

  final String _apiKey;

  @override
  String get name => 'Gemini';

  @override
  String get id => 'gemini';

  @override
  Future<Map<String, dynamic>> parse(String input) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey',
    );
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': '$kAiSystemPrompt\n\nUser input: $input'},
          ],
        },
      ],
    });

    final response = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gemini ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final text = decoded['candidates']?[0]?['content']?['parts']?[0]
        ?['text'] as String?;
    if (text == null) throw Exception('Gemini: empty response');
    return jsonDecode(stripCodeFences(text)) as Map<String, dynamic>;
  }
}
