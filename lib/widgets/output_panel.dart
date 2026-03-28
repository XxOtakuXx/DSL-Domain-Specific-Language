import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../theme/app_colors.dart';

class OutputPanel extends ConsumerStatefulWidget {
  const OutputPanel({super.key});

  @override
  ConsumerState<OutputPanel> createState() => _OutputPanelState();
}

class _OutputPanelState extends ConsumerState<OutputPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _justCopied = false;

  static const _tabs = ['JSON', 'Compact Prompt', 'Expanded Prompt'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(selectedTabProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyCurrentTab() {
    final output = ref.read(generatedOutputProvider);
    if (output == null) return;

    final tab = _tabController.index;
    String text;
    if (tab == 0) {
      text = const JsonEncoder.withIndent('  ').convert(output.json);
    } else if (tab == 1) {
      text = output.compactPrompt;
    } else {
      text = output.expandedPrompt;
    }

    Clipboard.setData(ClipboardData(text: text));
    setState(() => _justCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _justCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sync external tab changes (e.g. from mode toggle)
    final selectedTab = ref.watch(selectedTabProvider);
    if (_tabController.index != selectedTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _tabController.animateTo(selectedTab);
      });
    }

    final output = ref.watch(generatedOutputProvider);

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: output == null
                ? _buildEmptyState()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildJsonTab(output),
                      _buildPromptTab(output.compactPrompt, 'Compact'),
                      _buildPromptTab(output.expandedPrompt, 'Expanded'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surfaceElevated,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              indicator: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.tabBorder, width: 2),
                ),
                color: AppColors.tabActive,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColors.border,
              tabs: _tabs
                  .map((t) => Tab(height: 34, text: t))
                  .toList(),
            ),
          ),
          // Copy button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _CopyButton(
              justCopied: _justCopied,
              onPressed: _copyCurrentTab,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_outlined,
              size: 48, color: AppColors.textDisabled),
          const SizedBox(height: 16),
          const Text(
            'Press Generate to see output',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ctrl + Enter',
            style: TextStyle(
              color: AppColors.textDisabled,
              fontSize: 12,
              fontFamily: 'Consolas',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonTab(GeneratedOutput output) {
    final json = const JsonEncoder.withIndent('  ').convert(output.json);
    return _CodeView(content: json, language: 'JSON');
  }

  Widget _buildPromptTab(String content, String label) {
    if (content.isEmpty) {
      return const Center(
        child: Text(
          'No output — press Generate',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      );
    }
    return _CodeView(content: content, language: label);
  }
}

// ── Code view ─────────────────────────────────────────────────────────────────

class _CodeView extends StatelessWidget {
  const _CodeView({required this.content, required this.language});

  final String content;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 28,
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(language.toUpperCase(), style: AppTextStyles.labelSmall),
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                content,
                style: AppTextStyles.outputText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Copy button ───────────────────────────────────────────────────────────────

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.justCopied, required this.onPressed});

  final bool justCopied;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: justCopied
          ? const Row(
              key: ValueKey('copied'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 14, color: AppColors.success),
                SizedBox(width: 4),
                Text('Copied',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.success)),
              ],
            )
          : InkWell(
              key: const ValueKey('copy'),
              onTap: onPressed,
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Text('Copy',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
    );
  }
}
