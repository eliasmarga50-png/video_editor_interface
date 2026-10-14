


import 'package:flutter/material.dart';

class CineAITheme {
  CineAITheme._();

  // Brand colors
  static const Color background = Color(0xFF0B0F1A);
  static const Color surface = Color(0xFF1A1F2E);
  static const Color surfaceElevated = Color(0xFF222A3B);

  static const Color violet = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);

  static const Color textPrimary = Color(0xFFF7F8FC);
  static const Color textSecondary = Color(0xFF9AA6BC);
  static const Color border = Color(0xFF2A3347);
  static const Color success = Color(0xFF34D399);

  // Shared brand gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [violet, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Main application theme
  static ThemeData get dark {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: violet,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: scheme.copyWith(
        primary: violet,
        secondary: blue,
        surface: surface,
      ),

      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,

      // App bars
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),

      // Typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          height: 1.2,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.45,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          height: 1.4,
        ),
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      // Primary buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        hintStyle: const TextStyle(
          color: textSecondary,
        ),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: violet,
            width: 1.4,
          ),
        ),
      ),

      // Selection chips
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: violet,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 7,
        ),
      ),

      // Duration and sensitivity sliders
      sliderTheme: const SliderThemeData(
        activeTrackColor: violet,
        inactiveTrackColor: border,
        thumbColor: Colors.white,
        overlayColor: Color(0x338B5CF6),
      ),

      // Settings switches
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            return states.contains(WidgetState.selected)
                ? Colors.white
                : textSecondary;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            return states.contains(WidgetState.selected)
                ? violet
                : surfaceElevated;
          },
        ),
      ),
    );
  }
}



