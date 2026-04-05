import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';

const _providerMeta = {
  AiProviderId.none: (
    label: 'None (offline)',
    keyHint: '',
    keyLabel: '',
    link: '',
    linkLabel: '',
  ),
  AiProviderId.studio: (
    label: 'Studio AI',
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
    linkLabel: 'Get a free Gemini API key →  aistudio.google.com/apikey',
  ),
  AiProviderId.openai: (
    label: 'OpenAI',
    keyHint: 'sk-...',
    keyLabel: 'OpenAI API Key',
    link: 'platform.openai.com/api-keys',
    linkLabel: 'Get an OpenAI API key →  platform.openai.com/api-keys',
  ),
  AiProviderId.anthropic: (
    label: 'Anthropic',
    keyHint: 'sk-ant-...',
    keyLabel: 'Anthropic API Key',
    link: 'console.anthropic.com/settings/keys',
    linkLabel: 'Get an Anthropic API key →  console.anthropic.com/settings/keys',
  ),
  AiProviderId.ollama: (
    label: 'Ollama (local)',
    keyHint: '',
    keyLabel: '',
    link: 'ollama.com/download',
    linkLabel: 'Download Ollama (free, runs locally) →  ollama.com/download',
  ),
};

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late AiProviderId _selectedId;
  late final TextEditingController _keyController;
  late final TextEditingController _ollamaModelController;
  bool _obscure = true;
  bool _saving = false;
  bool _saved = false;

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
    setState(() { _saving = true; _saved = false; });
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
    setState(() { _saving = false; _saved = true; });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  Future<void> _clear() async {
    await SettingsService().clearApiKey();
    ref.read(apiKeyProvider.notifier).state = '';
    _keyController.clear();
    setState(() {});
  }

  bool get _aiActive =>
      _selectedId != AiProviderId.none &&
      (_selectedId == AiProviderId.studio ||
          _selectedId == AiProviderId.ollama ||
          _keyController.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left: section list
          Container(
            width: 200,
            color: AppColors.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDisabled,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                _SectionItem(label: 'AI Provider', icon: Icons.auto_awesome, active: true),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          // Right: content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('AI Provider'),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose which AI model to use when generating prompts in Plain Talk mode.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _buildStatusRow(),
                    const SizedBox(height: 24),
                    _buildProviderSelector(),
                    const SizedBox(height: 24),
                    _buildDynamicFields(),
                    const SizedBox(height: 32),
                    _buildSaveRow(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatusRow() {
    final meta = _providerMeta[_selectedId]!;
    final active = _aiActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF1A3A1A)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? const Color(0xFF2E6A2E) : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: active ? AppColors.success : AppColors.textDisabled,
          ),
          const SizedBox(width: 10),
          Text(
            active
                ? (_selectedId == AiProviderId.studio
                    ? 'Studio AI Active — built-in, no API required'
                    : 'AI Active — ${meta.label}')
                : 'Offline mode — using rule-based parser',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: active ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provider',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AiProviderId.values.map((id) {
            final selected = _selectedId == id;
            return GestureDetector(
              onTap: () => setState(() => _selectedId = id),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accentMuted : AppColors.surface,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: selected ? AppColors.accent : AppColors.border,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    _providerMeta[id]!.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? AppColors.accent : AppColors.textPrimary,
                    ),
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text(
            'No API key required.\nThe app will use the built-in rule-based parser to generate prompts from your Plain Talk input.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
          ),
        );

      case AiProviderId.studio:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2E1A),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF2E6A2E)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome, size: 15, color: Color(0xFF4EC9B0)),
                  SizedBox(width: 8),
                  Text(
                    'Studio AI — Built-in, no setup required',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4EC9B0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Studio AI is a multi-pass NLP engine built directly into this app. '
                'It requires no API key, no internet connection, and has no token limits.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 10),
              const _FeatureRow(icon: Icons.bolt, label: 'Instant — zero latency, pure Dart'),
              const _FeatureRow(icon: Icons.wifi_off, label: 'Fully offline — no network calls'),
              const _FeatureRow(icon: Icons.token, label: 'No token limits — any length input'),
              const _FeatureRow(icon: Icons.category, label: 'Detects 5 content modes automatically'),
              const _FeatureRow(icon: Icons.layers, label: 'Extracts 20+ DSL keys from natural language'),
              const _FeatureRow(icon: Icons.code, label: 'Knows 100+ technologies, frameworks, databases'),
            ],
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
            const SizedBox(height: 12),
            _buildLinkRow(_providerMeta[AiProviderId.ollama]!.linkLabel),
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
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.delete_outline, size: 14),
              label: const Text('Clear saved key'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            _buildLinkRow(meta.linkLabel),
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
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textDisabled, fontFamily: 'Consolas'),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkRow(String label) {
    return Row(
      children: [
        const Icon(Icons.open_in_new, size: 12, color: AppColors.accent),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.accent),
        ),
      ],
    );
  }

  Widget _buildSaveRow() {
    return Row(
      children: [
        SizedBox(
          width: 160,
          height: 38,
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
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Save Settings',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
        ),
        if (_saved) ...[
          const SizedBox(width: 14),
          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          const Text('Saved', style: TextStyle(fontSize: 13, color: AppColors.success)),
        ],
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SectionItem extends StatelessWidget {
  const _SectionItem({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: active ? AppColors.accentMuted : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: active ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14,
              color: active ? AppColors.accent : AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
