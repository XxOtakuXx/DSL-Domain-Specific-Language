import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';

// ── Provider metadata ─────────────────────────────────────────────────────────

const _providerMeta = {
  AiProviderId.none: (
    label: 'None (offline)',
    keyHint: '',
    keyLabel: '',
    link: '',
    linkLabel: '',
  ),
  AiProviderId.gemini: (
    label: 'Gemini',
    keyHint: 'AIza...',
    keyLabel: 'Gemini API Key',
    link: 'aistudio.google.com/apikey',
    linkLabel: 'Get a free Gemini API key',
  ),
  AiProviderId.openai: (
    label: 'OpenAI',
    keyHint: 'sk-...',
    keyLabel: 'OpenAI API Key',
    link: 'platform.openai.com/api-keys',
    linkLabel: 'Get an OpenAI API key',
  ),
  AiProviderId.anthropic: (
    label: 'Anthropic',
    keyHint: 'sk-ant-...',
    keyLabel: 'Anthropic API Key',
    link: 'console.anthropic.com/settings/keys',
    linkLabel: 'Get an Anthropic API key',
  ),
  AiProviderId.ollama: (
    label: 'Ollama',
    keyHint: '',
    keyLabel: '',
    link: 'ollama.com/download',
    linkLabel: 'Download Ollama (free, runs locally)',
  ),
};

// ── Settings Panel ────────────────────────────────────────────────────────────

class SettingsPanel extends ConsumerStatefulWidget {
  const SettingsPanel({super.key});

  @override
  ConsumerState<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends ConsumerState<SettingsPanel> {
  late AiProviderId _selectedId;
  late final TextEditingController _keyController;
  late final TextEditingController _ollamaModelController;
  bool _obscure = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedId = ref.read(selectedProviderIdProvider);
    _keyController = TextEditingController(text: ref.read(apiKeyProvider));
    _ollamaModelController =
        TextEditingController(text: ref.read(ollamaModelProvider));
  }

  @override
  void dispose() {
    _keyController.dispose();
    _ollamaModelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final data = SettingsData(
      providerId: _selectedId,
      apiKey: _keyController.text.trim(),
      ollamaModel: _ollamaModelController.text.trim().isEmpty
          ? 'llama3'
          : _ollamaModelController.text.trim(),
    );
    await SettingsService().saveSettings(data);
    ref.read(selectedProviderIdProvider.notifier).state = data.providerId;
    ref.read(apiKeyProvider.notifier).state = data.apiKey;
    ref.read(ollamaModelProvider.notifier).state = data.ollamaModel;
    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _clear() async {
    await SettingsService().clearApiKey();
    ref.read(apiKeyProvider.notifier).state = '';
    _keyController.clear();
  }

  bool get _aiActive =>
      _selectedId != AiProviderId.none &&
      (_selectedId == AiProviderId.ollama ||
          _keyController.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      color: AppColors.surfaceElevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusRow(),
                  const SizedBox(height: 20),
                  _buildProviderSelector(),
                  const SizedBox(height: 20),
                  _buildDynamicFields(),
                  const SizedBox(height: 20),
                  _buildSaveRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 48,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.settings_outlined,
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close,
                size: 16, color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    final meta = _providerMeta[_selectedId]!;
    final active = _aiActive;
    final label = active ? 'AI Active — ${meta.label}' : 'Offline mode';
    return Row(
      children: [
        Icon(Icons.circle,
            size: 8,
            color: active ? AppColors.success : AppColors.textDisabled),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.success : AppColors.textDisabled,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI Provider',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: AiProviderId.values.map((id) {
            final selected = _selectedId == id;
            return GestureDetector(
              onTap: () => setState(() => _selectedId = id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.accentMuted
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: selected
                        ? AppColors.accent
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  _providerMeta[id]!.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDynamicFields() {
    switch (_selectedId) {
      case AiProviderId.none:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text(
            'Using built-in rule-based parser.\nNo API key required.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        );

      case AiProviderId.ollama:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Model Name',
              controller: _ollamaModelController,
              hint: 'llama3',
              obscure: false,
            ),
            const SizedBox(height: 8),
            _buildLinkBox(_providerMeta[AiProviderId.ollama]!.linkLabel,
                _providerMeta[AiProviderId.ollama]!.link),
          ],
        );

      default:
        final meta = _providerMeta[_selectedId]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: meta.keyLabel,
              controller: _keyController,
              hint: meta.keyHint,
              obscure: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: _clear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  child: const Text('Clear Key',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLinkBox(meta.linkLabel, meta.link),
          ],
        );
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            fontFamily: 'Consolas',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textDisabled),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkBox(String label, String url) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.open_in_new, size: 13, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label\n$url',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.accent,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveRow() {
    return SizedBox(
      width: double.infinity,
      child: _saving
          ? const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
                foregroundColor: AppColors.textOnAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              child: const Text('Save Settings',
                  style: TextStyle(fontSize: 13)),
            ),
    );
  }
}
