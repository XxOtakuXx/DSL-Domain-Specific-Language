import 'package:shared_preferences/shared_preferences.dart';
import '../providers/dsl_providers.dart';

class SettingsData {
  const SettingsData({
    required this.providerId,
    required this.apiKey,
    required this.ollamaModel,
  });

  final AiProviderId providerId;
  final String apiKey;
  final String ollamaModel;

  static const SettingsData defaults = SettingsData(
    providerId: AiProviderId.none,
    apiKey: '',
    ollamaModel: 'llama3',
  );
}

class SettingsService {
  static const _keyProviderId = 'ai_provider_id';
  static const _keyApiKey = 'ai_api_key';
  static const _keyOllamaModel = 'ollama_model';

  Future<SettingsData> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final idStr = prefs.getString(_keyProviderId) ?? 'none';
    final providerId = AiProviderId.values.firstWhere(
      (e) => e.name == idStr,
      orElse: () => AiProviderId.none,
    );
    return SettingsData(
      providerId: providerId,
      apiKey: prefs.getString(_keyApiKey) ?? '',
      ollamaModel: prefs.getString(_keyOllamaModel) ?? 'llama3',
    );
  }

  Future<void> saveSettings(SettingsData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProviderId, data.providerId.name);
    await prefs.setString(_keyApiKey, data.apiKey);
    await prefs.setString(_keyOllamaModel, data.ollamaModel);
  }

  Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyApiKey);
  }
}
