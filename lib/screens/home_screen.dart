import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/parser.dart';
import '../services/prompt_builder.dart';
import '../theme/app_colors.dart';
import '../widgets/editor.dart';
import '../widgets/output_panel.dart';
import '../widgets/toolbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _splitRatio = 0.45;
  double _totalWidth = 0;

  // ── Keyboard shortcut: Ctrl/Cmd + Enter ──────────────────────────────────

  void _generate() {
    final input = ref.read(dslInputProvider);
    final parser = DslParser();
    final builder = PromptBuilder();

    final parsed = parser.parse(input);
    ref.read(generatedOutputProvider.notifier).state = GeneratedOutput(
      json: parsed,
      compactPrompt: builder.buildCompact(parsed),
      expandedPrompt: builder.buildExpanded(parsed),
    );
    final isCompact = ref.read(isCompactModeProvider);
    ref.read(selectedTabProvider.notifier).state = isCompact ? 1 : 2;
    ref.read(statusMessageProvider.notifier).state = 'Generated';
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(statusMessageProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter, control: true):
            _generate,
        const SingleActivator(LogicalKeyboardKey.enter, meta: true):
            _generate,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const ToolbarWidget(),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        _totalWidth = constraints.maxWidth;
        final leftWidth = (_totalWidth * _splitRatio).clamp(180.0, _totalWidth - 180);

        return Row(
          children: [
            SizedBox(width: leftWidth, child: const EditorWidget()),
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
    return Container(
      height: 22,
      color: AppColors.accentMuted,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: AppColors.success),
          const SizedBox(width: 6),
          const Text(
            'DSL Prompt Studio  —  Flutter Native Desktop',
            style: TextStyle(
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
