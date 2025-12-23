// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AIThemeExtension extends ThemeExtension<AIThemeExtension> {
  final Color? glowColor;
  final LinearGradient? glassGradient;

  const AIThemeExtension({this.glowColor, this.glassGradient});

  @override
  AIThemeExtension copyWith({Color? glowColor, LinearGradient? glassGradient}) => 
      AIThemeExtension(glowColor: glowColor ?? this.glowColor, glassGradient: glassGradient ?? this.glassGradient);

  @override
  AIThemeExtension lerp(ThemeExtension<AIThemeExtension>? other, double t) {
    if (other is! AIThemeExtension) return this;
    return AIThemeExtension(
      glowColor: Color.lerp(glowColor, other.glowColor, t),
      glassGradient: LinearGradient.lerp(glassGradient, other.glassGradient, t),
    );
  }
}

class AppTheme {
  static const primaryPurple = Color(0xFF9C27B0);
  static const accentCyan = Color(0xFF00E5FF);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: primaryPurple,
    extensions: [
      AIThemeExtension(
        glowColor: primaryPurple.withOpacity(0.1),
        glassGradient: LinearGradient(colors: [primaryPurple.withOpacity(0.2), primaryPurple.withOpacity(0.1)]),
      ),
    ],
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: primaryPurple,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F),
    extensions: [
      AIThemeExtension(
        glowColor: accentCyan.withOpacity(0.1),
        glassGradient: LinearGradient(colors: [Colors.white10, Colors.white.withOpacity(0.05)]),
      ),
    ],
    cardTheme: CardThemeData(
      color: const Color(0xFF1A1A1A),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.white.withOpacity(0.05))),
    ),
  );
}