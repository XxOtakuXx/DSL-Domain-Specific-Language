import 'package:flutter/material.dart';

abstract final class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFF252526);
  static const Color surfaceElevated = Color(0xFF2D2D30);
  static const Color surfaceHover = Color(0xFF37373D);

  // Borders & dividers
  static const Color border = Color(0xFF3C3C3C);
  static const Color divider = Color(0xFF474747);

  // Accent
  static const Color accent = Color(0xFF0078D4);
  static const Color accentHover = Color(0xFF1A8FE3);
  static const Color accentMuted = Color(0xFF1F4E79);

  // Text
  static const Color textPrimary = Color(0xFFD4D4D4);
  static const Color textSecondary = Color(0xFF858585);
  static const Color textDisabled = Color(0xFF5A5A5A);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // DSL Syntax highlighting
  static const Color syntaxKey = Color(0xFF4EC9B0);      // teal — DSL keys
  static const Color syntaxValue = Color(0xFFCE9178);    // orange — values
  static const Color syntaxComment = Color(0xFF6A9955);  // green — # comments
  static const Color syntaxNumber = Color(0xFFB5CEA8);   // light green — numbers
  static const Color syntaxComma = Color(0xFF569CD6);    // blue — separators

  // Status
  static const Color success = Color(0xFF4EC9B0);
  static const Color warning = Color(0xFFCCA700);
  static const Color error = Color(0xFFF44747);

  // Tab bar
  static const Color tabActive = Color(0xFF1E1E1E);
  static const Color tabInactive = Color(0xFF2D2D30);
  static const Color tabBorder = Color(0xFF007ACC);

  // Toolbar
  static const Color toolbarBg = Color(0xFF3C3C3C);
  static const Color buttonPrimary = Color(0xFF0E639C);
  static const Color buttonPrimaryHover = Color(0xFF1177BB);
  static const Color buttonSecondary = Color(0xFF3C3C3C);
  static const Color buttonSecondaryHover = Color(0xFF505050);
  static const Color buttonDanger = Color(0xFF6C2020);
  static const Color buttonDangerHover = Color(0xFF8A2020);

  // Line numbers
  static const Color lineNumber = Color(0xFF858585);
  static const Color lineNumberBg = Color(0xFF1E1E1E);

  // Scrollbar
  static const Color scrollbar = Color(0xFF424242);
  static const Color scrollbarHover = Color(0xFF686868);
}

abstract final class AppTextStyles {
  static const String monoFamily = 'Consolas, "Cascadia Code", "Courier New", monospace';

  static const TextStyle editorText = TextStyle(
    fontFamily: 'Consolas',
    fontSize: 14,
    height: 1.6,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle outputText = TextStyle(
    fontFamily: 'Consolas',
    fontSize: 13,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.8,
  );

  static const TextStyle toolbarButton = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
