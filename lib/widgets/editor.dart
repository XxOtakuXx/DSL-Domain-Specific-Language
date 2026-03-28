import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../theme/app_colors.dart';

// ── Syntax-highlighting controller ───────────────────────────────────────────

class _DslController extends TextEditingController {
  _DslController(String initial) : super(text: initial);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final spans = <InlineSpan>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (i > 0) spans.add(TextSpan(text: '\n', style: style));

      if (line.trim().isEmpty) {
        spans.add(TextSpan(text: line, style: style));
        continue;
      }

      // Comment
      if (line.trimLeft().startsWith('#')) {
        spans.add(TextSpan(
          text: line,
          style: style?.copyWith(color: AppColors.syntaxComment),
        ));
        continue;
      }

      final spaceIdx = line.indexOf(' ');
      if (spaceIdx == -1) {
        spans.add(TextSpan(
          text: line,
          style: style?.copyWith(color: AppColors.syntaxKey),
        ));
        continue;
      }

      // Leading whitespace
      final leadingSpaces = line.length - line.trimLeft().length;
      if (leadingSpaces > 0) {
        spans.add(TextSpan(text: line.substring(0, leadingSpaces), style: style));
      }

      final trimmed = line.trimLeft();
      final trimmedSpaceIdx = trimmed.indexOf(' ');
      if (trimmedSpaceIdx == -1) {
        spans.add(TextSpan(
          text: trimmed,
          style: style?.copyWith(color: AppColors.syntaxKey),
        ));
        continue;
      }

      final key = trimmed.substring(0, trimmedSpaceIdx);
      final rest = trimmed.substring(trimmedSpaceIdx);

      spans.add(TextSpan(
        text: key,
        style: style?.copyWith(
          color: AppColors.syntaxKey,
          fontWeight: FontWeight.w600,
        ),
      ));

      // Value — highlight commas separately
      _appendValueSpan(spans, rest, style);
    }

    return TextSpan(children: spans, style: style);
  }

  void _appendValueSpan(
      List<InlineSpan> spans, String rest, TextStyle? base) {
    if (!rest.contains(',')) {
      spans.add(TextSpan(
        text: rest,
        style: base?.copyWith(color: AppColors.syntaxValue),
      ));
      return;
    }

    // ' ' space before the value
    final spaceMatch = RegExp(r'^\s+').firstMatch(rest);
    if (spaceMatch != null) {
      spans.add(TextSpan(text: spaceMatch.group(0)!, style: base));
    }
    final valueStr = rest.trimLeft();

    final parts = valueStr.split(',');
    for (int j = 0; j < parts.length; j++) {
      spans.add(TextSpan(
        text: parts[j],
        style: base?.copyWith(color: AppColors.syntaxValue),
      ));
      if (j < parts.length - 1) {
        spans.add(TextSpan(
          text: ',',
          style: base?.copyWith(color: AppColors.syntaxComma),
        ));
      }
    }
  }
}

// ── Editor widget ─────────────────────────────────────────────────────────────

class EditorWidget extends ConsumerStatefulWidget {
  const EditorWidget({super.key});

  @override
  ConsumerState<EditorWidget> createState() => _EditorWidgetState();
}

class _EditorWidgetState extends ConsumerState<EditorWidget> {
  late _DslController _controller;
  final ScrollController _vScroll = ScrollController();
  final ScrollController _lineScroll = ScrollController();
  int _lineCount = 1;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(dslInputProvider);
    _controller = _DslController(initial);
    _lineCount = '\n'.allMatches(initial).length + 1;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _controller.text;
    ref.read(dslInputProvider.notifier).state = text;
    final newCount = '\n'.allMatches(text).length + 1;
    if (newCount != _lineCount) {
      setState(() => _lineCount = newCount);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _vScroll.dispose();
    _lineScroll.dispose();
    super.dispose();
  }

  // Keep line-number scroll in sync with editor scroll
  void _syncScroll() {
    if (_lineScroll.hasClients) {
      _lineScroll.jumpTo(_vScroll.offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync external changes (e.g. Load file)
    final externalText = ref.watch(dslInputProvider);
    if (externalText != _controller.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = externalText;
        _controller.selection = TextSelection.collapsed(
          offset: externalText.length,
        );
      });
    }

    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(child: _buildEditorBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 34,
      color: AppColors.surfaceElevated,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.code, size: 14, color: AppColors.syntaxKey),
          const SizedBox(width: 6),
          const Text('DSL Editor', style: AppTextStyles.labelSmall),
          const Spacer(),
          Text(
            '$_lineCount line${_lineCount == 1 ? '' : 's'}',
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEditorBody() {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        _syncScroll();
        return false;
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLineNumbers(),
          Container(width: 1, color: AppColors.border),
          Expanded(child: _buildTextField()),
        ],
      ),
    );
  }

  Widget _buildLineNumbers() {
    return SizedBox(
      width: 48,
      child: SingleChildScrollView(
        controller: _lineScroll,
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            children: List.generate(_lineCount, (i) {
              return SizedBox(
                height: 22.4, // matches line height: 14 * 1.6
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontFamily: 'Consolas',
                        fontSize: 13,
                        color: AppColors.lineNumber,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Scrollbar(
      controller: _vScroll,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _vScroll,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: TextField(
            controller: _controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppTextStyles.editorText,
            cursorColor: AppColors.accent,
            cursorWidth: 2,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText:
                  '# Write your DSL here\n# Example:\nCREATE app\nTYPE web\nFEATURES login, dashboard',
              hintStyle: TextStyle(
                fontFamily: 'Consolas',
                fontSize: 14,
                height: 1.6,
                color: AppColors.textDisabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
