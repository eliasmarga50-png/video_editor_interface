import 'package:flutter/cupertino.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CineAITheme {
  CineAITheme._();

  // Brand colors
  static const Color background = Color(0xFF0B0F1A);
  static const Color surface = Color(0xFF1A1F2E);
  static const Color surfaceElevated = Color(0xFF222A3B);

  static const Color violet = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color lavender = Color(0xFFC4B5FD);

  static const Color textPrimary = Color(0xFFF7F8FC);
  static const Color textSecondary = Color(0xFF9AA6BC);
  static const Color border = Color(0xFF2A3347);
  static const Color success = Color(0xFF34D399);
  static const Color danger = Color(0xFFF87171);

  // Radii
  static const double cardRadius = 16;
  static const double buttonRadius = 12;

  // Shared brand gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [violet, blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Subtle card shadow
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  // Violet → blue glow used by primary buttons and FABs
  static List<BoxShadow> glow({double alpha = .35, double blur = 24}) {
    return [
      BoxShadow(
        color: violet.withValues(alpha: alpha),
        blurRadius: blur,
        offset: const Offset(-3, 8),
      ),
      BoxShadow(
        color: blue.withValues(alpha: alpha * .7),
        blurRadius: blur * 1.2,
        offset: const Offset(4, 10),
      ),
    ];
  }

  // Main application theme
  static ThemeData get dark {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: violet,
      brightness: Brightness.dark,
      surface: surface,
    ).copyWith(
      primary: violet,
      secondary: blue,
      surface: surface,
      onSurface: textPrimary,
      outline: border,
    );

    final TextTheme base = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    final TextTheme textTheme = base
        .copyWith(
          headlineLarge: base.headlineLarge?.copyWith(
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          headlineMedium: base.headlineMedium?.copyWith(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 15, height: 1.45),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 13, height: 1.45),
          bodySmall: base.bodySmall?.copyWith(fontSize: 11, height: 1.4),
        )
        .apply(bodyColor: textPrimary, displayColor: textPrimary);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: border,
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // Smooth route transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // App bars
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
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
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: border),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      // Primary buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: violet,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
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
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lavender,
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),

      // Text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius + 2),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius + 2),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(buttonRadius + 2),
          borderSide: const BorderSide(color: violet, width: 1.4),
        ),
      ),

      // Selection chips (Material chips; custom GradientChip is preferred)
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: violet,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      ),

      // Sliders
      sliderTheme: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: violet,
        inactiveTrackColor: border,
        thumbColor: Colors.white,
        overlayColor: const Color(0x338B5CF6),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10,
          elevation: 4,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
        trackShape: const RoundedRectSliderTrackShape(),
        tickMarkShape: SliderTickMarkShape.noTickMark,
      ),

      // Switches
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return states.contains(WidgetState.selected)
              ? Colors.white
              : textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return states.contains(WidgetState.selected)
              ? violet
              : surfaceElevated;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return states.contains(WidgetState.selected)
              ? Colors.transparent
              : border;
        }),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: violet,
        linearTrackColor: surfaceElevated,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: surfaceElevated,
        contentTextStyle: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }
}