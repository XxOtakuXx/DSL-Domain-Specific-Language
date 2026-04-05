import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../theme/app_colors.dart';

// ── Command definition ────────────────────────────────────────────────────────

class _Command {
  const _Command({
    required this.label,
    required this.description,
    required this.icon,
    required this.action,
    this.shortcut = '',
  });
  final String label;
  final String description;
  final IconData icon;
  final void Function(WidgetRef ref, BuildContext ctx) action;
  final String shortcut;
}

// ── Palette overlay ───────────────────────────────────────────────────────────

class CommandPalette extends ConsumerStatefulWidget {
  const CommandPalette({super.key, required this.onGenerate});

  final VoidCallback onGenerate;

  @override
  ConsumerState<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<CommandPalette> {
  final TextEditingController _queryCtrl = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  final FocusNode _keyboardFocus = FocusNode();
  final ScrollController _scrollCtrl = ScrollController();
  int _selectedIndex = 0;

  late final List<_Command> _allCommands;

  @override
  void initState() {
    super.initState();
    _allCommands = [
      _Command(
        label: 'Generate',
        description: 'Run the current input through the parser',
        icon: Icons.play_arrow_rounded,
        shortcut: 'Ctrl+Enter',
        action: (ref, ctx) {
          Navigator.pop(ctx);
          widget.onGenerate();
        },
      ),
      _Command(
        label: 'Clear Editor',
        description: 'Clear all input and output',
        icon: Icons.clear_all,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(dslInputProvider.notifier).state = '';
          ref.read(plainInputProvider.notifier).state = '';
          ref.read(generatedOutputProvider.notifier).state = null;
        },
      ),
      _Command(
        label: 'Switch to DSL Mode',
        description: 'Use structured DSL input',
        icon: Icons.code,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(inputModeProvider.notifier).state = InputMode.dsl;
        },
      ),
      _Command(
        label: 'Switch to Plain Talk Mode',
        description: 'Use natural language input',
        icon: Icons.chat_bubble_outline,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(inputModeProvider.notifier).state = InputMode.plainTalk;
        },
      ),
      _Command(
        label: 'Go to Editor',
        description: 'Navigate to the Editor tab',
        icon: Icons.edit_outlined,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(navPageProvider.notifier).state = NavPage.editor;
        },
      ),
      _Command(
        label: 'Go to Templates',
        description: 'Browse the template library',
        icon: Icons.library_books_outlined,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(navPageProvider.notifier).state = NavPage.templates;
        },
      ),
      _Command(
        label: 'Go to History',
        description: 'View past generations',
        icon: Icons.history,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(navPageProvider.notifier).state = NavPage.history;
        },
      ),
      _Command(
        label: 'Go to Reference',
        description: 'Browse all DSL keys with explanations and examples',
        icon: Icons.menu_book_outlined,
        shortcut: 'Ctrl+Shift+R',
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(navPageProvider.notifier).state = NavPage.reference;
        },
      ),
      _Command(
        label: 'Go to Settings',
        description: 'Configure AI provider and API keys',
        icon: Icons.settings_outlined,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(navPageProvider.notifier).state = NavPage.settings;
        },
      ),
      _Command(
        label: 'Copy Compact Prompt',
        description: 'Copy the compact prompt to clipboard',
        icon: Icons.compress,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          final output = ref.read(generatedOutputProvider);
          if (output != null) {
            Clipboard.setData(ClipboardData(text: output.compactPrompt));
            ref.read(statusMessageProvider.notifier).state = 'Copied';
            Future.delayed(const Duration(seconds: 2), () {
              ref.read(statusMessageProvider.notifier).state = '';
            });
          }
        },
      ),
      _Command(
        label: 'Copy Expanded Prompt',
        description: 'Copy the expanded prompt to clipboard',
        icon: Icons.expand,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          final output = ref.read(generatedOutputProvider);
          if (output != null) {
            Clipboard.setData(ClipboardData(text: output.expandedPrompt));
            ref.read(statusMessageProvider.notifier).state = 'Copied';
            Future.delayed(const Duration(seconds: 2), () {
              ref.read(statusMessageProvider.notifier).state = '';
            });
          }
        },
      ),
      _Command(
        label: 'Set Output: Compact',
        description: 'Switch output mode to Compact',
        icon: Icons.compress,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(isCompactModeProvider.notifier).state = true;
          if (ref.read(generatedOutputProvider) != null) {
            ref.read(selectedTabProvider.notifier).state = 1;
          }
        },
      ),
      _Command(
        label: 'Set Output: Expanded',
        description: 'Switch output mode to Expanded',
        icon: Icons.expand,
        action: (ref, ctx) {
          Navigator.pop(ctx);
          ref.read(isCompactModeProvider.notifier).state = false;
          if (ref.read(generatedOutputProvider) != null) {
            ref.read(selectedTabProvider.notifier).state = 2;
          }
        },
      ),
      _Command(
        label: 'Open DSL Reference',
        description: 'Show in-app DSL key reference',
        icon: Icons.menu_book_outlined,
        shortcut: 'Ctrl+Shift+R',
        action: (ref, ctx) {
          Navigator.pop(ctx);
          showDslReference(ctx);
        },
      ),
    ];
    _queryCtrl.addListener(_onQueryChanged);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _inputFocus.requestFocus());
  }

  @override
  void dispose() {
    _queryCtrl.removeListener(_onQueryChanged);
    _queryCtrl.dispose();
    _inputFocus.dispose();
    _keyboardFocus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() => _selectedIndex = 0);
  }

  List<_Command> get _filtered {
    final q = _queryCtrl.text.toLowerCase();
    if (q.isEmpty) return _allCommands;
    return _allCommands
        .where((c) =>
            c.label.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q))
        .toList();
  }

  void _runSelected(BuildContext ctx) {
    final cmds = _filtered;
    if (cmds.isEmpty) return;
    final i = _selectedIndex.clamp(0, cmds.length - 1);
    cmds[i].action(ref, ctx);
  }

  void _moveSelection(int delta) {
    final cmds = _filtered;
    if (cmds.isEmpty) return;
    setState(() {
      _selectedIndex =
          (_selectedIndex + delta).clamp(0, cmds.length - 1);
    });
    // Scroll to keep selected item visible
    final itemHeight = 52.0;
    _scrollCtrl.animateTo(
      _selectedIndex * itemHeight,
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cmds = _filtered;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.only(top: 80),
      alignment: Alignment.topCenter,
      child: KeyboardListener(
        focusNode: _keyboardFocus,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              _moveSelection(1);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              _moveSelection(-1);
            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
              _runSelected(context);
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.pop(context);
            }
          }
        },
        child: Container(
          width: 560,
          constraints: const BoxConstraints(maxHeight: 420),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _queryCtrl,
                        focusNode: _inputFocus,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Type a command…',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text('Esc',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontFamily: 'Consolas')),
                    ),
                  ],
                ),
              ),
              // Command list
              if (cmds.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No commands match',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                )
              else
                Flexible(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: cmds.length,
                    itemBuilder: (ctx, i) => _CommandRow(
                      command: cmds[i],
                      selected: i == _selectedIndex,
                      onTap: () => cmds[i].action(ref, context),
                      onHover: () => setState(() => _selectedIndex = i),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({
    required this.command,
    required this.selected,
    required this.onTap,
    required this.onHover,
  });

  final _Command command;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onHover;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          color: selected ? AppColors.accentMuted : Colors.transparent,
          child: Row(
            children: [
              Icon(
                command.icon,
                size: 16,
                color: selected
                    ? AppColors.accent
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      command.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      command.description,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (command.shortcut.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    command.shortcut,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontFamily: 'Consolas'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── DSL Reference panel ───────────────────────────────────────────────────────

void showDslReference(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const _DslReferenceDialog(),
  );
}

class _DslReferenceDialog extends StatefulWidget {
  const _DslReferenceDialog();

  @override
  State<_DslReferenceDialog> createState() => _DslReferenceDialogState();
}

class _DslReferenceDialogState extends State<_DslReferenceDialog> {
  int _section = 0;

  static const _sections = [
    'Special Keys',
    'Software Dev',
    'API Design',
    'Content',
    'AI/Prompts',
    'DevOps',
    'Data & ML',
  ];

  static const _data = [
    // Special keys
    [
      ('CREATE', 'What to build', 'CREATE app'),
      ('TYPE', 'Category/type', 'TYPE web'),
      ('FEATURES', 'Comma-separated list', 'FEATURES login, dashboard'),
      ('STYLE', 'Visual or tech style', 'STYLE modern dark'),
      ('OUTPUT', 'Desired output format', 'OUTPUT full code'),
    ],
    // Software Dev
    [
      ('STACK', 'Full tech stack', 'STACK React, Node.js, PostgreSQL'),
      ('FRAMEWORK', 'Specific framework', 'FRAMEWORK Next.js'),
      ('LANGUAGE', 'Programming language', 'LANGUAGE TypeScript'),
      ('DATABASE', 'Data store', 'DATABASE PostgreSQL, Redis'),
      ('AUTH', 'Auth method', 'AUTH jwt'),
      ('PLATFORM', 'Target platform', 'PLATFORM AWS'),
      ('ARCHITECTURE', 'Design pattern', 'ARCHITECTURE microservices'),
      ('TESTING', 'Test strategy', 'TESTING unit, integration, e2e'),
    ],
    // API Design
    [
      ('RESOURCE', 'Primary API resource', 'RESOURCE users'),
      ('METHODS', 'HTTP verbs', 'METHODS GET, POST, PUT, DELETE'),
      ('VERSION', 'API version', 'VERSION v1'),
      ('FORMAT', 'Request/response format', 'FORMAT JSON'),
      ('PAGINATION', 'Pagination style', 'PAGINATION cursor-based'),
      ('RATE_LIMIT', 'Rate limiting', 'RATE_LIMIT 100 req/min'),
    ],
    // Content
    [
      ('TOPIC', 'Subject matter', 'TOPIC Flutter desktop development'),
      ('TONE', 'Voice/register', 'TONE professional, technical'),
      ('AUDIENCE', 'Target readers', 'AUDIENCE developers'),
      ('LENGTH', 'Target length', 'LENGTH 1500 words'),
      ('SECTIONS', 'Required sections', 'SECTIONS intro, body, conclusion'),
      ('KEYWORDS', 'SEO/focus terms', 'KEYWORDS Flutter, Dart'),
    ],
    // AI/Prompts
    [
      ('ROLE', 'AI persona', 'ROLE senior engineer'),
      ('TASK', 'Core instruction', 'TASK summarize'),
      ('CONTEXT', 'Background info', 'CONTEXT legacy codebase'),
      ('RULES', 'Hard constraints', 'RULES no jargon, always cite'),
      ('PERSONA', 'Character/voice', 'PERSONA friendly and concise'),
      ('AVOID', 'What to exclude', 'AVOID markdown, assumptions'),
    ],
    // DevOps
    [
      ('TRIGGER', 'CI event', 'TRIGGER push to main'),
      ('STEPS', 'Pipeline stages', 'STEPS lint, test, build, deploy'),
      ('ENVIRONMENT', 'Target env', 'ENVIRONMENT staging'),
      ('RUNNER', 'CI runner', 'RUNNER ubuntu-latest'),
      ('SECRETS', 'Required secrets', 'SECRETS API_KEY, DATABASE_URL'),
      ('ROLLBACK', 'Rollback strategy', 'ROLLBACK automatic on failure'),
    ],
    // Data & ML
    [
      ('MODEL', 'ML model type', 'MODEL classification'),
      ('DATA', 'Dataset description', 'DATA CSV, 50k rows, labeled'),
      ('METRICS', 'Evaluation metrics', 'METRICS accuracy, F1, AUC'),
      ('TRAINING', 'Training approach', 'TRAINING transfer learning'),
      ('INFERENCE', 'Inference target', 'INFERENCE real-time API'),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final rows = _data[_section];

    return Dialog(
      backgroundColor: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: AppColors.border),
      ),
      child: SizedBox(
        width: 660,
        height: 480,
        child: Row(
          children: [
            // Section sidebar
            Container(
              width: 160,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6)),
                border: Border(right: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Text('DSL REFERENCE',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _sections.length,
                      itemBuilder: (_, i) => _RefSideItem(
                        label: _sections[i],
                        active: i == _section,
                        onTap: () => setState(() => _section = i),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _sections[_section],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              size: 16,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          const _RefHeader(),
                          ...rows.map((row) => _RefRow(
                              keyName: row.$1,
                              desc: row.$2,
                              example: row.$3)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RefSideItem extends StatefulWidget {
  const _RefSideItem(
      {required this.label,
      required this.active,
      required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_RefSideItem> createState() => _RefSideItemState();
}

class _RefSideItemState extends State<_RefSideItem> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.surfaceHover
                : _h
                    ? AppColors.surfaceElevated
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color:
                    widget.active ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.active
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.active
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                )),
          ),
        ),
      ),
    );
  }
}

class _RefHeader extends StatelessWidget {
  const _RefHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: const [
          SizedBox(
              width: 110,
              child: Text('KEY',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8))),
          SizedBox(
              width: 140,
              child: Text('PURPOSE',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8))),
          Expanded(
              child: Text('EXAMPLE',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8))),
        ],
      ),
    );
  }
}

class _RefRow extends StatefulWidget {
  const _RefRow(
      {required this.keyName,
      required this.desc,
      required this.example});
  final String keyName;
  final String desc;
  final String example;

  @override
  State<_RefRow> createState() => _RefRowState();
}

class _RefRowState extends State<_RefRow> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              widget.keyName,
              style: const TextStyle(
                fontFamily: 'Consolas',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.syntaxKey,
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(widget.desc,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.example,
                    style: const TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 11,
                      color: AppColors.syntaxValue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.example));
                    setState(() => _copied = true);
                    Future.delayed(const Duration(seconds: 2),
                        () => setState(() => _copied = false));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      _copied ? Icons.check : Icons.copy,
                      size: 12,
                      color: _copied
                          ? AppColors.success
                          : AppColors.textDisabled,
                    ),
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
