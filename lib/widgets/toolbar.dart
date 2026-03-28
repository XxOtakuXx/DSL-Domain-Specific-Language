import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/parser.dart';
import '../services/prompt_builder.dart';
import '../services/file_service.dart';
import '../theme/app_colors.dart';

class ToolbarWidget extends ConsumerWidget {
  const ToolbarWidget({super.key});

  void _generate(WidgetRef ref) {
    final input = ref.read(dslInputProvider);
    final parser = DslParser();
    final builder = PromptBuilder();

    final parsed = parser.parse(input);
    final compact = builder.buildCompact(parsed);
    final expanded = builder.buildExpanded(parsed);

    ref.read(generatedOutputProvider.notifier).state = GeneratedOutput(
      json: parsed,
      compactPrompt: compact,
      expandedPrompt: expanded,
    );

    // Switch to the tab matching the current mode
    final isCompact = ref.read(isCompactModeProvider);
    ref.read(selectedTabProvider.notifier).state = isCompact ? 1 : 2;

    _showStatus(ref, 'Generated');
  }

  void _clear(WidgetRef ref) {
    ref.read(dslInputProvider.notifier).state = '';
    ref.read(generatedOutputProvider.notifier).state = null;
    _showStatus(ref, 'Cleared');
  }

  Future<void> _load(WidgetRef ref) async {
    final content = await FileService().loadDslFile();
    if (content != null) {
      ref.read(dslInputProvider.notifier).state = content;
      _showStatus(ref, 'Loaded');
    }
  }

  Future<void> _save(WidgetRef ref) async {
    final content = ref.read(dslInputProvider);
    final ok = await FileService().saveDslFile(content);
    _showStatus(ref, ok ? 'Saved' : 'Cancelled');
  }

  Future<void> _export(WidgetRef ref, BuildContext context) async {
    final output = ref.read(generatedOutputProvider);
    if (output == null) {
      _showStatus(ref, 'Generate first');
      return;
    }

    showMenu<String>(
      context: context,
      color: AppColors.surfaceElevated,
      position: const RelativeRect.fromLTRB(0, 40, 0, 0),
      items: const [
        PopupMenuItem(
          value: 'json',
          child: _MenuLabel(icon: Icons.data_object, label: 'Export JSON'),
        ),
        PopupMenuItem(
          value: 'compact',
          child: _MenuLabel(icon: Icons.compress, label: 'Export Compact Prompt'),
        ),
        PopupMenuItem(
          value: 'expanded',
          child: _MenuLabel(icon: Icons.expand, label: 'Export Expanded Prompt'),
        ),
      ],
    ).then((value) async {
      if (value == null) return;
      final fs = FileService();
      bool ok;
      if (value == 'json') {
        ok = await fs.exportJson(
            const JsonEncoder.withIndent('  ').convert(output.json));
      } else if (value == 'compact') {
        ok = await fs.exportPrompt(output.compactPrompt);
      } else {
        ok = await fs.exportPrompt(output.expandedPrompt);
      }
      _showStatus(ref, ok ? 'Exported' : 'Cancelled');
    });
  }

  void _showStatus(WidgetRef ref, String message) {
    ref.read(statusMessageProvider.notifier).state = message;
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(statusMessageProvider.notifier).state = '';
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(statusMessageProvider);
    final isCompact = ref.watch(isCompactModeProvider);
    final hasOutput = ref.watch(generatedOutputProvider) != null;

    return Container(
      height: 48,
      color: AppColors.toolbarBg,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // App name
          const Row(
            children: [
              Icon(Icons.terminal, size: 16, color: AppColors.accent),
              SizedBox(width: 8),
              Text(
                'DSL Prompt Studio',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),
          Container(width: 1, height: 24, color: AppColors.divider),
          const SizedBox(width: 12),

          // Generate (primary action)
          _PrimaryButton(
            label: 'Generate',
            icon: Icons.play_arrow_rounded,
            tooltip: 'Generate output (Ctrl+Enter)',
            onPressed: () => _generate(ref),
          ),

          const SizedBox(width: 6),

          // Clear
          _SecondaryButton(
            label: 'Clear',
            icon: Icons.clear_all,
            tooltip: 'Clear editor and output',
            onPressed: () => _clear(ref),
          ),

          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.divider),
          const SizedBox(width: 12),

          // Mode toggle
          _ModeToggle(
            isCompact: isCompact,
            onChanged: (compact) {
              ref.read(isCompactModeProvider.notifier).state = compact;
              // If output exists, switch to matching tab
              if (hasOutput) {
                ref.read(selectedTabProvider.notifier).state = compact ? 1 : 2;
              }
            },
          ),

          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.divider),
          const SizedBox(width: 12),

          // File operations
          _SecondaryButton(
            label: 'Load',
            icon: Icons.folder_open_outlined,
            tooltip: 'Load .dsl file',
            onPressed: () => _load(ref),
          ),
          const SizedBox(width: 6),
          _SecondaryButton(
            label: 'Save',
            icon: Icons.save_outlined,
            tooltip: 'Save as .dsl',
            onPressed: () => _save(ref),
          ),
          const SizedBox(width: 6),
          _SecondaryButton(
            label: 'Export',
            icon: Icons.upload_file_outlined,
            tooltip: 'Export JSON or Prompt',
            onPressed: () => _export(ref, context),
          ),

          const Spacer(),

          // Status message
          if (status.isNotEmpty)
            AnimatedOpacity(
              opacity: status.isNotEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 14, color: AppColors.success),
                  const SizedBox(width: 5),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Button components ─────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.buttonPrimary,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          hoverColor: AppColors.buttonPrimaryHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: AppColors.textOnAccent),
                const SizedBox(width: 5),
                Text(label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOnAccent,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.buttonSecondary,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          hoverColor: AppColors.buttonSecondaryHover,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text(label, style: AppTextStyles.toolbarButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.isCompact, required this.onChanged});

  final bool isCompact;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Switch output mode',
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ToggleSegment(
              label: 'Compact',
              active: isCompact,
              onTap: () => onChanged(true),
            ),
            Container(width: 1, height: 20, color: AppColors.border),
            _ToggleSegment(
              label: 'Expanded',
              active: !isCompact,
              onTap: () => onChanged(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.accentMuted : Colors.transparent,
          borderRadius: active
              ? (label == 'Compact'
                  ? const BorderRadius.horizontal(left: Radius.circular(3))
                  : const BorderRadius.horizontal(right: Radius.circular(3)))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MenuLabel extends StatelessWidget {
  const _MenuLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }
}
