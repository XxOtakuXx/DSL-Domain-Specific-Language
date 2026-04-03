import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/ai_parser.dart';
import '../services/history_service.dart';
import '../services/parser.dart';
import '../services/plain_talk_parser.dart';
import '../services/prompt_builder.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';
import '../widgets/command_palette.dart';
import '../widgets/editor.dart';
import '../widgets/output_panel.dart';
import '../widgets/plain_talk_editor.dart';
import '../widgets/toolbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _splitRatio = 0.45;
  double _totalWidth = 0;

  @override
  void initState() {
    super.initState();
    SettingsService().loadSettings().then((data) {
      if (mounted) {
        ref.read(selectedProviderIdProvider.notifier).state = data.providerId;
        ref.read(apiKeyProvider.notifier).state = data.apiKey;
        ref.read(ollamaModelProvider.notifier).state = data.ollamaModel;
      }
    });
  }

  // ── Keyboard shortcut: Ctrl/Cmd + Enter ──────────────────────────────────

  void _generate() {
    final mode = ref.read(inputModeProvider);
    if (mode == InputMode.plainTalk) {
      _generatePlainTalk();
    } else {
      _generateDsl();
    }
  }

  void _generateDsl() {
    final input = ref.read(dslInputProvider);
    final parsed = DslParser().parse(input);
    _finishGenerate(parsed);
  }

  void _generatePlainTalk() {
    final input = ref.read(plainInputProvider);
    final providerId = ref.read(selectedProviderIdProvider);
    final apiKey = ref.read(apiKeyProvider);
    final ollamaModel = ref.read(ollamaModelProvider);

    if (providerId == AiProviderId.none) {
      // No provider — rule-based, instant
      final parsed = PlainTalkParser().parse(input);
      _finishGenerate(parsed);
      return;
    }

    // AI path — async
    ref.read(isAiLoadingProvider.notifier).state = true;
    AiParser.parse(
      input: input,
      providerId: providerId,
      apiKey: apiKey,
      ollamaModel: ollamaModel,
    ).then((result) {
      final (parsed, usedAi, error) = result;
      if (mounted) {
        ref.read(isAiLoadingProvider.notifier).state = false;
        _finishGenerate(parsed,
            statusOverride: usedAi ? null : (error != null ? 'AI error: $error' : 'AI unavailable — used offline parser'));
      }
    });
  }

  void _finishGenerate(Map<String, dynamic> parsed, {String? statusOverride}) {
    final builder = PromptBuilder();
    final compact = builder.buildCompact(parsed);
    final expanded = builder.buildExpanded(parsed);
    ref.read(generatedOutputProvider.notifier).state = GeneratedOutput(
      json: parsed,
      compactPrompt: compact,
      expandedPrompt: expanded,
    );
    final isCompact = ref.read(isCompactModeProvider);
    ref.read(selectedTabProvider.notifier).state = isCompact ? 1 : 2;
    final msg = statusOverride ?? 'Generated';
    ref.read(statusMessageProvider.notifier).state = msg;
    final delay = statusOverride != null ? 8 : 3;
    Future.delayed(Duration(seconds: delay), () {
      if (mounted) ref.read(statusMessageProvider.notifier).state = '';
    });

    // Save to history (fire-and-forget)
    final mode = ref.read(inputModeProvider);
    final dslInput = mode == InputMode.dsl
        ? ref.read(dslInputProvider)
        : ref.read(plainInputProvider);
    HistoryService().insert(HistoryEntry(
      id: 0,
      timestamp: DateTime.now(),
      inputMode: mode == InputMode.plainTalk ? 'plainTalk' : 'dsl',
      dslInput: dslInput,
      compactPrompt: compact,
      expandedPrompt: expanded,
      json: parsed,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, control: true):
            _generate,
        const SingleActivator(LogicalKeyboardKey.enter, meta: true):
            _generate,
        const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (_) => CommandPalette(onGenerate: _generate),
          );
        },
        const SingleActivator(LogicalKeyboardKey.keyP, meta: true): () {
          showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (_) => CommandPalette(onGenerate: _generate),
          );
        },
        const SingleActivator(LogicalKeyboardKey.keyR,
            control: true, shift: true): () => showDslReference(context),
        const SingleActivator(LogicalKeyboardKey.keyR,
            meta: true, shift: true): () => showDslReference(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              ToolbarWidget(onGenerate: _generate),
              Container(height: 1, color: AppColors.border),
              Expanded(child: _buildSplitPane()),
              _buildStatusBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSplitPane() {
    final isPlainTalk =
        ref.watch(inputModeProvider) == InputMode.plainTalk;
    return LayoutBuilder(
      builder: (context, constraints) {
        _totalWidth = constraints.maxWidth;
        final leftWidth =
            (_totalWidth * _splitRatio).clamp(180.0, _totalWidth - 180);

        return Row(
          children: [
            SizedBox(
              width: leftWidth,
              child: isPlainTalk
                  ? const PlainTalkEditor()
                  : const EditorWidget(),
            ),
            _buildDivider(),
            const Expanded(child: OutputPanel()),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (_totalWidth == 0) return;
          setState(() {
            _splitRatio =
                (_splitRatio * _totalWidth + details.delta.dx) / _totalWidth;
            _splitRatio = _splitRatio.clamp(0.15, 0.80);
          });
        },
        child: Container(
          width: 5,
          color: AppColors.background,
          child: Center(
            child: Container(
              width: 1,
              color: AppColors.divider,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    final isPlainTalk =
        ref.watch(inputModeProvider) == InputMode.plainTalk;
    final providerId = ref.watch(selectedProviderIdProvider);
    final apiKey = ref.watch(apiKeyProvider);

    final aiLabel = providerId == AiProviderId.none
        ? 'AI: Offline'
        : (providerId == AiProviderId.ollama || apiKey.isNotEmpty)
            ? 'AI: ${providerId.name[0].toUpperCase()}${providerId.name.substring(1)}'
            : 'AI: Offline';

    final modeLabel = isPlainTalk
        ? 'Plain Talk → Prompt  •  $aiLabel'
        : 'DSL Prompt Studio  —  Flutter Native Desktop';

    return Container(
      height: 22,
      color: AppColors.accentMuted,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            modeLabel,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          const Text(
            'Ctrl+Enter: Generate  •  UTF-8',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
