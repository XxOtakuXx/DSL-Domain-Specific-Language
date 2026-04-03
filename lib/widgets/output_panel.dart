import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/token_counter.dart';
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
  bool _wordWrap = true;
  double _fontSize = 13.0;

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

  String _tokenLabel(GeneratedOutput? output) {
    if (output == null) return '';
    final tab = _tabController.index;
    String content;
    if (tab == 0) {
      content = const JsonEncoder.withIndent('  ').convert(output.json);
    } else if (tab == 1) {
      content = output.compactPrompt;
    } else {
      content = output.expandedPrompt;
    }
    return TokenCounter.display(content);
  }

  @override
  Widget build(BuildContext context) {
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
          _buildTabBar(output),
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

  Widget _buildTabBar(GeneratedOutput? output) {
    return Container(
      color: AppColors.surfaceElevated,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                  onTap: (_) => setState(() {}),
                  tabs: _tabs.map((t) => Tab(height: 34, text: t)).toList(),
                ),
              ),
              // Controls row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Token count
                    if (output != null)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _tokenLabel(output),
                          key: ValueKey(_tokenLabel(output)),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textDisabled,
                            fontFamily: 'Consolas',
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    // Font size decrease
                    _IconBtn(
                      icon: Icons.text_decrease,
                      tooltip: 'Decrease font size',
                      onTap: () => setState(
                          () => _fontSize = (_fontSize - 1).clamp(10, 20)),
                    ),
                    const SizedBox(width: 2),
                    // Font size increase
                    _IconBtn(
                      icon: Icons.text_increase,
                      tooltip: 'Increase font size',
                      onTap: () => setState(
                          () => _fontSize = (_fontSize + 1).clamp(10, 20)),
                    ),
                    const SizedBox(width: 4),
                    // Word wrap toggle
                    _IconBtn(
                      icon: _wordWrap
                          ? Icons.wrap_text
                          : Icons.notes,
                      tooltip:
                          _wordWrap ? 'Disable word wrap' : 'Enable word wrap',
                      active: _wordWrap,
                      onTap: () => setState(() => _wordWrap = !_wordWrap),
                    ),
                    const SizedBox(width: 6),
                    // Copy button
                    _CopyButton(
                      justCopied: _justCopied,
                      onPressed: _copyCurrentTab,
                    ),
                  ],
                ),
              ),
            ],
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
          const Icon(Icons.auto_awesome_outlined,
              size: 48, color: AppColors.textDisabled),
          const SizedBox(height: 16),
          const Text(
            'Press Generate to see output',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
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
    return _CodeView(
        content: json,
        language: 'JSON',
        wordWrap: _wordWrap,
        fontSize: _fontSize);
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
    return _CodeView(
        content: content,
        language: label,
        wordWrap: _wordWrap,
        fontSize: _fontSize);
  }
}

// ── Icon button ───────────────────────────────────────────────────────────────

class _IconBtn extends StatefulWidget {
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool active;

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: widget.active
                  ? AppColors.accentMuted
                  : _hovered
                      ? AppColors.surfaceHover
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(
              widget.icon,
              size: 14,
              color:
                  widget.active ? AppColors.accent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Code view ─────────────────────────────────────────────────────────────────

class _CodeView extends StatefulWidget {
  const _CodeView({
    required this.content,
    required this.language,
    required this.wordWrap,
    required this.fontSize,
  });

  final String content;
  final String language;
  final bool wordWrap;
  final double fontSize;

  @override
  State<_CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<_CodeView> {
  final FocusNode _focusNode = FocusNode(canRequestFocus: false);
  final ScrollController _scrollController = ScrollController();
  final ScrollController _hScrollController = ScrollController();

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _hScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Consolas',
      fontSize: widget.fontSize,
      height: 1.6,
      color: AppColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 28,
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(widget.language.toUpperCase(),
              style: AppTextStyles.labelSmall),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: widget.wordWrap
                ? SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      widget.content,
                      style: textStyle,
                      focusNode: _focusNode,
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Scrollbar(
                      controller: _hScrollController,
                      thumbVisibility: true,
                      notificationPredicate: (n) => n.depth == 1,
                      child: SingleChildScrollView(
                        controller: _hScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          widget.content,
                          style: textStyle,
                          focusNode: _focusNode,
                        ),
                      ),
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
                    style: TextStyle(fontSize: 12, color: AppColors.success)),
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
