import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/template_library.dart';
import '../providers/dsl_providers.dart';
import '../services/custom_template_service.dart';
import '../theme/app_colors.dart';

// ── Unified template card model ───────────────────────────────────────────────

class _CardData {
  const _CardData({
    required this.title,
    required this.description,
    required this.category,
    required this.dsl,
    this.isCustom = false,
    this.customId,
  });
  final String title;
  final String description;
  final String category;
  final String dsl;
  final bool isCustom;
  final int? customId;
}

// ── Screen ────────────────────────────────────────────────────────────────────

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadCustomTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomTemplates() async {
    final all = await CustomTemplateService().loadAll();
    if (mounted) ref.read(customTemplatesProvider.notifier).state = all;
  }

  List<_CardData> _allCards(List<CustomTemplate> custom) {
    final builtIn = kTemplates.map((t) => _CardData(
          title: t.title,
          description: t.description,
          category: t.category,
          dsl: t.dsl,
        ));
    final userCards = custom.map((t) => _CardData(
          title: t.title,
          description: t.description,
          category: t.category,
          dsl: t.dsl,
          isCustom: true,
          customId: t.id,
        ));
    return [...userCards, ...builtIn];
  }

  List<_CardData> _filtered(
      List<_CardData> all, String? category, String query) {
    var items = all;
    if (category != null) {
      items = items.where((t) => t.category == category).toList();
    }
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      items = items
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              t.description.toLowerCase().contains(q) ||
              t.dsl.toLowerCase().contains(q))
          .toList();
    }
    return items;
  }

  void _useTemplate(_CardData card) {
    ref.read(dslInputProvider.notifier).state = card.dsl;
    ref.read(navPageProvider.notifier).state = NavPage.editor;
    ref.read(statusMessageProvider.notifier).state = 'Template loaded';
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) ref.read(statusMessageProvider.notifier).state = '';
    });
  }

  Future<void> _deleteCustomTemplate(int id) async {
    await CustomTemplateService().delete(id);
    await _loadCustomTemplates();
  }

  @override
  Widget build(BuildContext context) {
    final custom = ref.watch(customTemplatesProvider);
    final selectedCategory = ref.watch(templateCategoryProvider);
    final searchQuery = ref.watch(templateSearchProvider);
    final all = _allCards(custom);
    final filtered = _filtered(all, selectedCategory, searchQuery);
    final totalCustom = custom.length;
    final totalBuiltIn = kTemplates.length;

    return Row(
      children: [
        _CategorySidebar(
          selectedCategory: selectedCategory,
          customCount: totalCustom,
          builtInCount: totalBuiltIn,
          onCategorySelected: (cat) =>
              ref.read(templateCategoryProvider.notifier).state = cat,
        ),
        Container(width: 1, color: AppColors.border),
        Expanded(
          child: Column(
            children: [
              _SearchBar(
                controller: _searchController,
                query: searchQuery,
                onChanged: (v) =>
                    ref.read(templateSearchProvider.notifier).state = v,
                onClear: () {
                  _searchController.clear();
                  ref.read(templateSearchProvider.notifier).state = '';
                },
              ),
              Container(height: 1, color: AppColors.border),
              _ResultsHeader(count: filtered.length, query: searchQuery),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyState()
                    : _TemplateGrid(
                        templates: filtered,
                        onUse: _useTemplate,
                        onDelete: (id) => _deleteCustomTemplate(id),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Category sidebar ──────────────────────────────────────────────────────────

class _CategorySidebar extends StatelessWidget {
  const _CategorySidebar({
    required this.selectedCategory,
    required this.customCount,
    required this.builtInCount,
    required this.onCategorySelected,
  });

  final String? selectedCategory;
  final int customCount;
  final int builtInCount;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: const Text(
              'CATEGORIES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
          ),
          _SidebarItem(
            label: 'All Templates',
            icon: Icons.grid_view,
            count: builtInCount + customCount,
            active: selectedCategory == null,
            onTap: () => onCategorySelected(null),
          ),
          if (customCount > 0) ...[
            _SidebarItem(
              label: 'My Templates',
              icon: Icons.bookmark_outlined,
              count: customCount,
              active: selectedCategory == 'My Templates',
              onTap: () => onCategorySelected('My Templates'),
              highlight: true,
            ),
          ],
          const Divider(color: AppColors.border, height: 1, thickness: 1),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: kTemplateCategories.length,
              itemBuilder: (context, i) {
                final cat = kTemplateCategories[i];
                final count =
                    kTemplates.where((t) => t.category == cat.name).length;
                return _SidebarItem(
                  label: cat.name,
                  icon: cat.icon,
                  count: count,
                  active: selectedCategory == cat.name,
                  onTap: () => onCategorySelected(cat.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.count,
    required this.active,
    required this.onTap,
    this.highlight = false,
  });

  final String label;
  final IconData icon;
  final int count;
  final bool active;
  final VoidCallback onTap;
  final bool highlight;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final labelColor = widget.highlight && !widget.active
        ? AppColors.accent
        : widget.active
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.surfaceHover
                : _hovered
                    ? AppColors.surfaceElevated
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.active ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 13, color: labelColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: widget.active || widget.highlight
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: labelColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.active
                      ? AppColors.accentMuted
                      : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.active
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
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

// ── Search bar (stateful to fix clear button reactivity) ──────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search templates by title, description, or DSL…',
          hintStyle: const TextStyle(
              fontSize: 13, color: AppColors.textSecondary),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 4, right: 8),
            child:
                Icon(Icons.search, size: 16, color: AppColors.textSecondary),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 36, minHeight: 36),
          suffixIcon: widget.controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: widget.onClear,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: const Icon(Icons.close,
                        size: 14, color: AppColors.textSecondary),
                  ),
                )
              : null,
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
          filled: true,
          fillColor: AppColors.surfaceElevated,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }
}

// ── Results header ────────────────────────────────────────────────────────────

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count, required this.query});

  final int count;
  final String query;

  @override
  Widget build(BuildContext context) {
    final label = query.isNotEmpty
        ? '$count result${count == 1 ? '' : 's'} for "$query"'
        : '$count template${count == 1 ? '' : 's'}';

    return Container(
      height: 32,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500)),
    );
  }
}

// ── Template grid ─────────────────────────────────────────────────────────────

class _TemplateGrid extends StatelessWidget {
  const _TemplateGrid({
    required this.templates,
    required this.onUse,
    required this.onDelete,
  });

  final List<_CardData> templates;
  final ValueChanged<_CardData> onUse;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.7,
        ),
        itemCount: templates.length,
        itemBuilder: (context, i) => _TemplateCard(
          card: templates[i],
          onUse: () => onUse(templates[i]),
          onDelete: templates[i].isCustom && templates[i].customId != null
              ? () => onDelete(templates[i].customId!)
              : null,
        ),
      ),
    );
  }
}

// ── Template card ─────────────────────────────────────────────────────────────

const Map<String, Color> _categoryColors = {
  'Software Dev': Color(0xFF569CD6),
  'Mobile': Color(0xFF4EC9B0),
  'API Design': Color(0xFFDCDCAA),
  'Content & Writing': Color(0xFFCE9178),
  'AI & Prompts': Color(0xFFC586C0),
  'DevOps': Color(0xFFF44747),
  'Data & ML': Color(0xFF4EC9B0),
  'Business': Color(0xFFDCDCAA),
  'Education': Color(0xFF6A9955),
  'Creative': Color(0xFFD7BA7D),
  'Legal & HR': Color(0xFF858585),
  'Research': Color(0xFF9CDCFE),
  'My Templates': Color(0xFF0078D4),
};

class _TemplateCard extends StatefulWidget {
  const _TemplateCard({
    required this.card,
    required this.onUse,
    this.onDelete,
  });

  final _CardData card;
  final VoidCallback onUse;
  final VoidCallback? onDelete;

  @override
  State<_TemplateCard> createState() => _TemplateCardState();
}

class _TemplateCardState extends State<_TemplateCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animController);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _hovered = true);
    _animController.forward();
  }

  void _onExit() {
    setState(() => _hovered = false);
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor =
        _categoryColors[widget.card.category] ?? AppColors.accent;
    final preview = widget.card.dsl.split('\n').take(4).join('\n');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color:
              _hovered ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _hovered ? AppColors.divider : AppColors.border,
          ),
        ),
        child: Stack(
          children: [
            // Left accent bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
            // Custom badge
            if (widget.card.isCustom)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentMuted,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'MINE',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent),
                  ),
                ),
              ),
            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.card.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.card.description,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        preview,
                        style: const TextStyle(
                          fontFamily: 'Consolas',
                          fontSize: 10.5,
                          height: 1.5,
                          color: AppColors.syntaxValue,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Hover action buttons
            Positioned(
              bottom: 10,
              right: 10,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Delete button (custom only)
                      if (widget.onDelete != null) ...[
                        GestureDetector(
                          onTap: widget.onDelete,
                          child: Container(
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(
                              color: AppColors.buttonDanger,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Icon(Icons.delete_outline,
                                size: 14, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      GestureDetector(
                        onTap: widget.onUse,
                        child: Container(
                          height: 26,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Use Template',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.search_off, size: 48, color: AppColors.textDisabled),
          SizedBox(height: 12),
          Text('No templates found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          SizedBox(height: 6),
          Text('Try a different search term or category',
              style:
                  TextStyle(fontSize: 13, color: AppColors.textDisabled)),
        ],
      ),
    );
  }
}
