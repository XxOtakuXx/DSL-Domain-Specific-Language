import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/template_library.dart';
import '../providers/dsl_providers.dart';
import '../theme/app_colors.dart';

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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TemplateItem> _filteredTemplates(String? category, String query) {
    var items = kTemplates;

    if (category != null) {
      items = items.where((t) => t.category == category).toList();
    }

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      items = items.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q) ||
            t.tags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();
    }

    return items;
  }

  void _useTemplate(TemplateItem template) {
    ref.read(dslInputProvider.notifier).state = template.dsl;
    ref.read(navPageProvider.notifier).state = NavPage.editor;
    ref.read(statusMessageProvider.notifier).state = 'Template loaded';
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(statusMessageProvider.notifier).state = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(templateCategoryProvider);
    final searchQuery = ref.watch(templateSearchProvider);
    final filtered = _filteredTemplates(selectedCategory, searchQuery);

    return Row(
      children: [
        _CategorySidebar(
          selectedCategory: selectedCategory,
          onCategorySelected: (cat) {
            ref.read(templateCategoryProvider.notifier).state = cat;
          },
        ),
        Container(width: 1, color: AppColors.border),
        Expanded(
          child: Column(
            children: [
              _SearchBar(
                controller: _searchController,
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
    required this.onCategorySelected,
  });

  final String? selectedCategory;
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
            child: Text(
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
            count: kTemplates.length,
            active: selectedCategory == null,
            onTap: () => onCategorySelected(null),
          ),
          const Divider(color: AppColors.border, height: 1, thickness: 1),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: kTemplateCategories.length,
              itemBuilder: (context, i) {
                final cat = kTemplateCategories[i];
                final count = kTemplates.where((t) => t.category == cat.name).length;
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
  });

  final String label;
  final IconData icon;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
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
              Icon(
                widget.icon,
                size: 13,
                color: widget.active
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        widget.active ? FontWeight.w600 : FontWeight.w400,
                    color: widget.active
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
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

// ── Search bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search templates by title, description, or tags…',
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 4, right: 8),
            child: Icon(Icons.search, size: 16, color: AppColors.textSecondary),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 36, minHeight: 36),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: onClear,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Template grid ─────────────────────────────────────────────────────────────

class _TemplateGrid extends StatelessWidget {
  const _TemplateGrid({required this.templates, required this.onUse});

  final List<TemplateItem> templates;
  final ValueChanged<TemplateItem> onUse;

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
          template: templates[i],
          onUse: () => onUse(templates[i]),
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
};

class _TemplateCard extends StatefulWidget {
  const _TemplateCard({required this.template, required this.onUse});

  final TemplateItem template;
  final VoidCallback onUse;

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
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
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
        _categoryColors[widget.template.category] ?? AppColors.accent;
    final previewLines = widget.template.dsl
        .split('\n')
        .take(4)
        .join('\n');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceElevated : AppColors.surface,
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
            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.template.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Description
                  Text(
                    widget.template.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // DSL preview
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        previewLines,
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
            // Hover: Use Template button
            Positioned(
              bottom: 10,
              right: 10,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: GestureDetector(
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
                          color: Colors.white,
                        ),
                      ),
                    ),
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
          Text(
            'No templates found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try a different search term or category',
            style: TextStyle(fontSize: 13, color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }
}
