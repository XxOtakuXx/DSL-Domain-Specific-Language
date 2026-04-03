import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dsl_providers.dart';
import '../services/history_service.dart';
import '../theme/app_colors.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final entries = await HistoryService().loadAll();
    if (mounted) ref.read(historyProvider.notifier).state = entries;
  }

  Future<void> _delete(int id) async {
    await HistoryService().delete(id);
    await _load();
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        title: const Text('Clear History',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        content: const Text(
          'Delete all generation history? This cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await HistoryService().clearAll();
      await _load();
    }
  }

  void _restore(HistoryEntry entry) {
    final isPlainTalk = entry.inputMode == 'plainTalk';
    if (isPlainTalk) {
      ref.read(plainInputProvider.notifier).state = entry.dslInput;
    } else {
      ref.read(dslInputProvider.notifier).state = entry.dslInput;
    }
    ref.read(inputModeProvider.notifier).state =
        isPlainTalk ? InputMode.plainTalk : InputMode.dsl;
    ref.read(navPageProvider.notifier).state = NavPage.editor;
    ref.read(statusMessageProvider.notifier).state = 'History loaded';
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(statusMessageProvider.notifier).state = '';
    });
  }

  List<HistoryEntry> _filtered(List<HistoryEntry> all, String q) {
    if (q.isEmpty) return all;
    final lower = q.toLowerCase();
    return all
        .where((e) =>
            e.title.toLowerCase().contains(lower) ||
            e.dslInput.toLowerCase().contains(lower) ||
            e.compactPrompt.toLowerCase().contains(lower))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(historyProvider);
    final query = ref.watch(historySearchProvider);
    final filtered = _filtered(all, query);

    return Column(
      children: [
        _buildTopBar(all),
        Container(height: 1, color: AppColors.border),
        Expanded(
          child: all.isEmpty
              ? _buildEmptyState()
              : filtered.isEmpty
                  ? _buildNoResults()
                  : _buildList(filtered),
        ),
      ],
    );
  }

  Widget _buildTopBar(List<HistoryEntry> all) {
    final query = ref.watch(historySearchProvider);
    return Container(
      height: 48,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.history, size: 15, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            'Generation History  •  ${all.length} entries',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    ref.read(historySearchProvider.notifier).state = v,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search history…',
                  hintStyle: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      size: 14, color: AppColors.textSecondary),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 32, minHeight: 30),
                  suffixIcon: query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            ref
                                .read(historySearchProvider.notifier)
                                .state = '';
                          },
                          child: const Icon(Icons.close,
                              size: 13, color: AppColors.textSecondary),
                        )
                      : null,
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  contentPadding: EdgeInsets.zero,
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (all.isNotEmpty)
            _TextBtn(
              label: 'Clear All',
              icon: Icons.delete_sweep_outlined,
              color: AppColors.error,
              onTap: _clearAll,
            ),
        ],
      ),
    );
  }

  Widget _buildList(List<HistoryEntry> entries) {
    return Scrollbar(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) => _HistoryCard(
          entry: entries[i],
          onRestore: () => _restore(entries[i]),
          onDelete: () => _delete(entries[i].id),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.history_toggle_off,
              size: 48, color: AppColors.textDisabled),
          SizedBox(height: 12),
          Text('No history yet',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          SizedBox(height: 6),
          Text('Generate something in the Editor to see it here',
              style: TextStyle(
                  fontSize: 12, color: AppColors.textDisabled)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 40, color: AppColors.textDisabled),
          SizedBox(height: 10),
          Text('No results',
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ── History card ──────────────────────────────────────────────────────────────

class _HistoryCard extends StatefulWidget {
  const _HistoryCard({
    required this.entry,
    required this.onRestore,
    required this.onDelete,
  });

  final HistoryEntry entry;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool _hovered = false;

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final isBadgeDsl = entry.inputMode == 'dsl';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color:
              _hovered ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _hovered ? AppColors.divider : AppColors.border,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode badge
            Container(
              margin: const EdgeInsets.only(top: 1),
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isBadgeDsl
                    ? AppColors.accentMuted
                    : AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                isBadgeDsl ? 'DSL' : 'PT',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isBadgeDsl
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(entry.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.preview,
                    style: const TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Actions (visible on hover)
            AnimatedOpacity(
              opacity: _hovered ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconActionBtn(
                    icon: Icons.restore,
                    tooltip: 'Load into editor',
                    color: AppColors.accent,
                    onTap: widget.onRestore,
                  ),
                  const SizedBox(width: 4),
                  _IconActionBtn(
                    icon: Icons.delete_outline,
                    tooltip: 'Delete',
                    color: AppColors.error,
                    onTap: widget.onDelete,
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

// ── Shared small widgets ──────────────────────────────────────────────────────

class _TextBtn extends StatefulWidget {
  const _TextBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_TextBtn> createState() => _TextBtnState();
}

class _TextBtnState extends State<_TextBtn> {
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
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _h ? AppColors.surfaceHover : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 13, color: widget.color),
              const SizedBox(width: 5),
              Text(widget.label,
                  style: TextStyle(fontSize: 12, color: widget.color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconActionBtn extends StatefulWidget {
  const _IconActionBtn({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_IconActionBtn> createState() => _IconActionBtnState();
}

class _IconActionBtnState extends State<_IconActionBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _h ? AppColors.surfaceHover : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child:
                Icon(widget.icon, size: 15, color: widget.color),
          ),
        ),
      ),
    );
  }
}
