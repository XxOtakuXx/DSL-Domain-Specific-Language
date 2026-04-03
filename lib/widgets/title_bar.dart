import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import '../providers/dsl_providers.dart';
import '../theme/app_colors.dart';

class TitleBar extends ConsumerWidget implements PreferredSizeWidget {
  const TitleBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(38);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(navPageProvider);

    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: Container(
        height: 38,
        color: AppColors.surface,
        child: Row(
          children: [
            // App icon + name
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.terminal, size: 14, color: AppColors.accent),
                  SizedBox(width: 7),
                  Text(
                    'DSL Prompt Studio',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            Container(width: 1, height: 18, color: AppColors.border),

            // Nav tabs
            _NavTab(
              label: 'Editor',
              icon: Icons.code,
              active: currentPage == NavPage.editor,
              onTap: () => ref.read(navPageProvider.notifier).state = NavPage.editor,
            ),
            _NavTab(
              label: 'Templates',
              icon: Icons.library_books_outlined,
              active: currentPage == NavPage.templates,
              onTap: () => ref.read(navPageProvider.notifier).state = NavPage.templates,
            ),
            _NavTab(
              label: 'History',
              icon: Icons.history,
              active: currentPage == NavPage.history,
              onTap: () => ref.read(navPageProvider.notifier).state = NavPage.history,
            ),
            _NavTab(
              label: 'Settings',
              icon: Icons.settings_outlined,
              active: currentPage == NavPage.settings,
              onTap: () => ref.read(navPageProvider.notifier).state = NavPage.settings,
            ),

            const Spacer(),

            // Window controls
            _WindowButton(
              icon: Icons.remove,
              tooltip: 'Minimize',
              onTap: () => windowManager.minimize(),
            ),
            _WindowButton(
              icon: Icons.crop_square,
              tooltip: 'Maximize',
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  await windowManager.unmaximize();
                } else {
                  await windowManager.maximize();
                }
              },
            ),
            _CloseButton(),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active ? AppColors.background : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  const _WindowButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 46,
            height: 38,
            color: _hovered ? AppColors.surfaceHover : Colors.transparent,
            child: Icon(widget.icon, size: 14, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Close',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => windowManager.close(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 46,
            height: 38,
            color: _hovered ? const Color(0xFFC42B1C) : Colors.transparent,
            child: Icon(
              Icons.close,
              size: 14,
              color: _hovered ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
