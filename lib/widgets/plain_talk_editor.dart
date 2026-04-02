import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/plain_talk_parser.dart';
import '../theme/app_colors.dart';

class PlainTalkEditor extends ConsumerStatefulWidget {
  const PlainTalkEditor({super.key});

  @override
  ConsumerState<PlainTalkEditor> createState() => _PlainTalkEditorState();
}

class _PlainTalkEditorState extends ConsumerState<PlainTalkEditor> {
  late final TextEditingController _controller;
  Map<String, dynamic> _liveDetection = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(plainInputProvider));
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    ref.read(plainInputProvider.notifier).state = text;
    setState(() {
      _liveDetection =
          text.trim().isEmpty ? {} : PlainTalkParser().parse(text);
    });
  }


  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerText = ref.watch(plainInputProvider);
    // Sync controller when provider is cleared externally (e.g. Clear button)
    if (providerText.isEmpty && _controller.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.clear();
          setState(() => _liveDetection = {});
        }
      });
    }

    final providerId = ref.watch(selectedProviderIdProvider);
    final apiKey = ref.watch(apiKeyProvider);
    final ollamaModel = ref.watch(ollamaModelProvider);

    String? badgeLabel;
    if (providerId == AiProviderId.ollama) {
      badgeLabel = 'AI: Ollama ($ollamaModel)';
    } else if (providerId != AiProviderId.none && apiKey.isNotEmpty) {
      badgeLabel = 'AI: ${providerId.name[0].toUpperCase()}${providerId.name.substring(1)}';
    }

    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(badgeLabel),
          Expanded(child: _buildTextField()),
          _buildDetectionStrip(),
        ],
      ),
    );
  }

  Widget _buildHeader(String? badgeLabel) {
    return Container(
      height: 34,
      color: AppColors.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 14, color: AppColors.syntaxKey),
          const SizedBox(width: 6),
          const Text('Plain Talk', style: AppTextStyles.labelSmall),
          const SizedBox(width: 8),
          if (badgeLabel != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentMuted,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome,
                      size: 10, color: AppColors.accent),
                  const SizedBox(width: 3),
                  Text(
                    badgeLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              '\u2298 Offline',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textDisabled,
              ),
            ),
          const Spacer(),
          const Text('Plain Talk Mode', style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 15,
              height: 1.7,
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.accent,
            cursorWidth: 2,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText:
                  'Describe what you want to build in plain English...',
              hintStyle: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 15,
                height: 1.7,
                color: AppColors.textDisabled,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'e.g. "build me a modern e-commerce website with login and payments"',
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionStrip() {
    if (_liveDetection.isEmpty) {
      return Container(
        height: 28,
        color: AppColors.surfaceElevated,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: const Text(
          'Start typing to see live detection…',
          style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
        ),
      );
    }

    final type = _liveDetection['type'] as String?;
    final features = _liveDetection['features'];
    final featCount = features is List ? features.length : 0;
    final style = _liveDetection['style'] as String?;

    final parts = <String>[
      if (type != null) 'type: $type',
      'features: $featCount detected',
      if (style != null) 'style: $style',
    ];

    return Container(
      height: 28,
      color: AppColors.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.visibility_outlined,
              size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            parts.join('  •  '),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
