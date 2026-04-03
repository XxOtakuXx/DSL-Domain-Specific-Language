import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/custom_template_service.dart';
import '../services/file_service.dart';
import '../theme/app_colors.dart';

class ToolbarWidget extends ConsumerWidget {
  const ToolbarWidget({required this.onGenerate, super.key});

  final VoidCallback onGenerate;

  void _clear(WidgetRef ref) {
    ref.read(dslInputProvider.notifier).state = '';
    ref.read(plainInputProvider.notifier).state = '';
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

  Future<void> _saveAsTemplate(WidgetRef ref, BuildContext context) async {
    final dsl = ref.read(dslInputProvider).trim();
    if (dsl.isEmpty) {
      _showStatus(ref, 'Editor is empty');
      return;
    }
    final result = await showDialog<_TemplateFormResult>(
      context: context,
      builder: (_) => _SaveTemplateDialog(dslPreview: dsl),
    );
    if (result == null) return;
    final template = CustomTemplate(
      id: 0,
      title: result.title,
      description: result.description,
      category: result.category,
      tags: result.tags,
      dsl: dsl,
      createdAt: DateTime.now(),
    );
    await CustomTemplateService().insert(template);
    // Refresh provider
    final all = await CustomTemplateService().loadAll();
    ref.read(customTemplatesProvider.notifier).state = all;
    _showStatus(ref, 'Template saved');
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
      // Only clear if this message is still showing (avoids race with newer messages)
      if (ref.read(statusMessageProvider) == message) {
        ref.read(statusMessageProvider.notifier).state = '';
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(statusMessageProvider);
    final isCompact = ref.watch(isCompactModeProvider);
    final hasOutput = ref.watch(generatedOutputProvider) != null;
    final inputMode = ref.watch(inputModeProvider);
    final isAiLoading = ref.watch(isAiLoadingProvider);
    final providerId = ref.watch(selectedProviderIdProvider);
    final apiKey = ref.watch(apiKeyProvider);
    final isPlainTalk = inputMode == InputMode.plainTalk;
    final aiLabel = providerId == AiProviderId.none
        ? 'AI: Offline'
        : (providerId == AiProviderId.ollama || apiKey.isNotEmpty)
            ? 'AI: ${providerId.name[0].toUpperCase()}${providerId.name.substring(1)}'
            : 'AI: Offline';
    final aiActive = providerId != AiProviderId.none &&
        (providerId == AiProviderId.ollama || apiKey.isNotEmpty);

    return Container(
      height: 48,
      color: AppColors.toolbarBg,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Input mode toggle: DSL ↔ Plain Talk
          _InputModeToggle(
            isPlainTalk: isPlainTalk,
            onChanged: (plainTalk) {
              ref.read(inputModeProvider.notifier).state =
                  plainTalk ? InputMode.plainTalk : InputMode.dsl;
            },
          ),

          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.divider),
          const SizedBox(width: 12),

          // Generate (primary action) — shows spinner while AI is loading
          isAiLoading
              ? _LoadingButton()
              : _PrimaryButton(
                  label: 'Generate',
                  icon: Icons.play_arrow_rounded,
                  tooltip: 'Generate output (Ctrl+Enter)',
                  onPressed: onGenerate,
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

          // Output mode toggle (Compact / Expanded)
          _ModeToggle(
            isCompact: isCompact,
            onChanged: (compact) {
              ref.read(isCompactModeProvider.notifier).state = compact;
              if (hasOutput) {
                ref.read(selectedTabProvider.notifier).state = compact ? 1 : 2;
              }
            },
          ),

          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.divider),
          const SizedBox(width: 12),

          // File operations (DSL mode only)
          if (!isPlainTalk) ...[
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
              label: 'Save Template',
              icon: Icons.bookmark_add_outlined,
              tooltip: 'Save current DSL as a custom template',
              onPressed: () => _saveAsTemplate(ref, context),
            ),
            const SizedBox(width: 6),
          ],
          _SecondaryButton(
            label: 'Export',
            icon: Icons.upload_file_outlined,
            tooltip: 'Export JSON or Prompt',
            onPressed: () => _export(ref, context),
          ),

          const Spacer(),

          // Status bar: Plain Talk mode AI indicator
          if (isPlainTalk) ...[
            Text(
              aiLabel,
              style: TextStyle(
                fontSize: 11,
                color: aiActive
                    ? AppColors.success
                    : AppColors.textDisabled,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Status message
          if (status.isNotEmpty)
            AnimatedOpacity(
              opacity: status.isNotEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status.startsWith('AI error:') || status.startsWith('AI unavailable')
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    size: 14,
                    color: status.startsWith('AI error:') || status.startsWith('AI unavailable')
                        ? Colors.orange
                        : AppColors.success,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: status.startsWith('AI error:') || status.startsWith('AI unavailable')
                          ? Colors.orange
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 8),
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
              isLeft: true,
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
    this.isLeft = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool isLeft;

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
              ? (isLeft
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

class _LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.buttonPrimary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textOnAccent,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Thinking…',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputModeToggle extends StatelessWidget {
  const _InputModeToggle({
    required this.isPlainTalk,
    required this.onChanged,
  });

  final bool isPlainTalk;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Switch input mode',
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
              label: 'DSL',
              active: !isPlainTalk,
              isLeft: true,
              onTap: () => onChanged(false),
            ),
            Container(width: 1, height: 20, color: AppColors.border),
            _ToggleSegment(
              label: 'Plain Talk',
              active: isPlainTalk,
              onTap: () => onChanged(true),
            ),
          ],
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

// ── Save Template dialog ──────────────────────────────────────────────────────

class _TemplateFormResult {
  const _TemplateFormResult({
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
  });
  final String title;
  final String description;
  final String category;
  final List<String> tags;
}

const _kCategories = [
  'Software Dev', 'Mobile', 'API Design', 'Content & Writing',
  'AI & Prompts', 'DevOps', 'Data & ML', 'Business',
  'Education', 'Creative', 'Legal & HR', 'Research', 'My Templates',
];

class _SaveTemplateDialog extends StatefulWidget {
  const _SaveTemplateDialog({required this.dslPreview});
  final String dslPreview;

  @override
  State<_SaveTemplateDialog> createState() => _SaveTemplateDialogState();
}

class _SaveTemplateDialogState extends State<_SaveTemplateDialog> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  String _category = 'My Templates';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: AppColors.border),
      ),
      child: SizedBox(
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Save as Template',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dslPreview.split('\n').take(3).join(' · '),
                  style: const TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 11,
                    color: AppColors.textDisabled,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                _FormField(
                  label: 'Title',
                  controller: _titleCtrl,
                  hint: 'e.g. My API Template',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                _FormField(
                  label: 'Description',
                  controller: _descCtrl,
                  hint: 'Short description of what this template does',
                ),
                const SizedBox(height: 12),
                // Category dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Container(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _category,
                          dropdownColor: AppColors.surfaceElevated,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textPrimary),
                          isExpanded: true,
                          items: _kCategories
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _category = v ?? _category),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _FormField(
                  label: 'Tags (comma-separated)',
                  controller: _tagsCtrl,
                  hint: 'e.g. api, rest, node',
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final tags = _tagsCtrl.text
                              .split(',')
                              .map((t) => t.trim())
                              .where((t) => t.isNotEmpty)
                              .toList();
                          Navigator.pop(
                            context,
                            _TemplateFormResult(
                              title: _titleCtrl.text.trim(),
                              description: _descCtrl.text.trim(),
                              category: _category,
                              tags: tags,
                            ),
                          );
                        }
                      },
                      child: const Text('Save Template',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint = '',
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 13, color: AppColors.textDisabled),
            filled: true,
            fillColor: AppColors.background,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
