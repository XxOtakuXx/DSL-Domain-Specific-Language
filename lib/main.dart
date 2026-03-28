import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(800, 560),
    center: true,
    backgroundColor: Color(0xFF1E1E1E),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'DSL Prompt Studio',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSL Prompt Studio',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.accent,
        onPrimary: AppColors.textOnAccent,
        secondary: AppColors.accent,
        onSecondary: AppColors.textOnAccent,
        error: AppColors.error,
      ),
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.border),
          ),
        ),
        textStyle: TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        waitDuration: Duration(milliseconds: 600),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.scrollbar),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(2),
        thickness: WidgetStateProperty.all(6),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: AppColors.border),
        ),
        textStyle: TextStyle(color: AppColors.textPrimary, fontSize: 13),
      ),
    );
  }
}
