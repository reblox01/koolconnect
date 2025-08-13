import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the educational application.
/// Implements Contemporary Educational Minimalism with Trusted Academic Palette.
class AppTheme {
  AppTheme._();

  // Trusted Academic Palette - Educational color system
  static const Color primaryLight = Color(0xFF1B365D); // Deep educational blue
  static const Color primaryVariantLight =
      Color(0xFF0F2A47); // Darker blue variant
  static const Color secondaryLight = Color(0xFF4A90A4); // Supporting blue-teal
  static const Color secondaryVariantLight =
      Color(0xFF357A8F); // Darker teal variant
  static const Color successLight = Color(0xFF2D5A27); // Forest green
  static const Color warningLight = Color(0xFFB7791F); // Warm amber
  static const Color errorLight = Color(0xFFC5282F); // Confident red
  static const Color backgroundLight = Color(0xFFFAFBFC); // Soft off-white
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimaryLight = Color(0xFF1A1D21); // Near-black
  static const Color textSecondaryLight = Color(0xFF6B7280); // Medium gray
  static const Color borderLight = Color(0xFFE5E7EB); // Light gray

  // Dark theme variants
  static const Color primaryDark = Color(0xFF4A90A4); // Blue-teal for dark mode
  static const Color primaryVariantDark = Color(0xFF357A8F); // Darker variant
  static const Color secondaryDark = Color(0xFF6BA3B5); // Lighter teal
  static const Color secondaryVariantDark = Color(0xFF5A96A8); // Medium teal
  static const Color successDark = Color(0xFF4A7A44); // Lighter forest green
  static const Color warningDark = Color(0xFFD4943A); // Lighter amber
  static const Color errorDark = Color(0xFFE04A52); // Lighter red
  static const Color backgroundDark = Color(0xFF0F1419); // Dark background
  static const Color surfaceDark = Color(0xFF1A1D21); // Dark surface
  static const Color textPrimaryDark = Color(0xFFFAFBFC); // Light text
  static const Color textSecondaryDark = Color(0xFF9CA3AF); // Light gray
  static const Color borderDark = Color(0xFF374151); // Dark border

  // Card and dialog colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2937);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF1F2937);

  // Shadow colors with educational-appropriate opacity
  static const Color shadowLight =
      Color(0x14000000); // 8% opacity for subtle depth
  static const Color shadowDark =
      Color(0x1AFFFFFF); // 10% opacity for dark mode

  // Divider colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  /// Light theme with Contemporary Educational Minimalism
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: Colors.white,
          primaryContainer: primaryVariantLight,
          onPrimaryContainer: Colors.white,
          secondary: secondaryLight,
          onSecondary: Colors.white,
          secondaryContainer: secondaryVariantLight,
          onSecondaryContainer: Colors.white,
          tertiary: successLight,
          onTertiary: Colors.white,
          tertiaryContainer: successLight.withAlpha(26),
          onTertiaryContainer: successLight,
          error: errorLight,
          onError: Colors.white,
          surface: surfaceLight,
          onSurface: textPrimaryLight,
          onSurfaceVariant: textSecondaryLight,
          outline: borderLight,
          outlineVariant: borderLight.withAlpha(128),
          shadow: shadowLight,
          scrim: Colors.black54,
          inverseSurface: surfaceDark,
          onInverseSurface: textPrimaryDark,
          inversePrimary: primaryDark),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      dividerColor: dividerLight,

      // AppBar theme for educational professionalism
      appBarTheme: AppBarTheme(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 2.0,
          shadowColor: shadowLight,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.15),
          toolbarTextStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white, size: 24),
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 24)),

      // Card theme with subtle elevation
      cardTheme: CardTheme(
          color: cardLight,
          elevation: 2.0,
          shadowColor: shadowLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation for educational workflows
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),

      // Contextual FAB theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryLight,
          foregroundColor: Colors.white,
          elevation: 4.0,
          focusElevation: 6.0,
          hoverElevation: 6.0,
          highlightElevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),

      // Button themes for educational interactions
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2.0,
              shadowColor: shadowLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: primaryLight, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),

      // Typography for educational content
      textTheme: _buildTextTheme(isLight: true),

      // Input decoration for forms
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceLight,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: borderLight)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: borderLight)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: primaryLight, width: 2.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorLight)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorLight, width: 2.0)),
          labelStyle: GoogleFonts.inter(color: textSecondaryLight, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryLight.withAlpha(179), fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorLight, fontSize: 12, fontWeight: FontWeight.w400)),

      // Interactive elements
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey[300];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withAlpha(128);
        }
        return Colors.grey[300];
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: const BorderSide(color: borderLight, width: 2.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      })),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryLight, linearTrackColor: borderLight, circularTrackColor: borderLight),
      sliderTheme: SliderThemeData(activeTrackColor: primaryLight, thumbColor: primaryLight, overlayColor: primaryLight.withAlpha(51), inactiveTrackColor: borderLight, trackHeight: 4.0),

      // Tab bar theme for navigation
      tabBarTheme: TabBarTheme(labelColor: primaryLight, unselectedLabelColor: textSecondaryLight, indicatorColor: primaryLight, indicatorSize: TabBarIndicatorSize.tab, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimaryLight.withAlpha(230), borderRadius: BorderRadius.circular(8.0)), textStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimaryLight, contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: secondaryLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),

      // List tile theme for educational content
      listTileTheme: ListTileThemeData(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), tileColor: surfaceLight, selectedTileColor: primaryLight.withAlpha(26), iconColor: textSecondaryLight, textColor: textPrimaryLight, titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryLight), subtitleTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondaryLight)), dialogTheme: DialogThemeData(backgroundColor: dialogLight));

  /// Dark theme with Contemporary Educational Minimalism
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: Colors.black,
          primaryContainer: primaryVariantDark,
          onPrimaryContainer: Colors.white,
          secondary: secondaryDark,
          onSecondary: Colors.black,
          secondaryContainer: secondaryVariantDark,
          onSecondaryContainer: Colors.white,
          tertiary: successDark,
          onTertiary: Colors.black,
          tertiaryContainer: successDark.withAlpha(51),
          onTertiaryContainer: successDark,
          error: errorDark,
          onError: Colors.black,
          surface: surfaceDark,
          onSurface: textPrimaryDark,
          onSurfaceVariant: textSecondaryDark,
          outline: borderDark,
          outlineVariant: borderDark.withAlpha(128),
          shadow: shadowDark,
          scrim: Colors.black87,
          inverseSurface: surfaceLight,
          onInverseSurface: textPrimaryLight,
          inversePrimary: primaryLight),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      dividerColor: dividerDark,
      appBarTheme: AppBarTheme(
          backgroundColor: surfaceDark,
          foregroundColor: textPrimaryDark,
          elevation: 2.0,
          shadowColor: shadowDark,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimaryDark,
              letterSpacing: 0.15),
          toolbarTextStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimaryDark),
          iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
          actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24)),
      cardTheme: CardTheme(
          color: cardDark,
          elevation: 2.0,
          shadowColor: shadowDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          selectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryDark,
          foregroundColor: Colors.black,
          elevation: 4.0,
          focusElevation: 6.0,
          hoverElevation: 6.0,
          highlightElevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2.0,
              shadowColor: shadowDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              side: const BorderSide(color: primaryDark, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1))),
      textTheme: _buildTextTheme(isLight: false),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceDark,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: borderDark)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: borderDark)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: primaryDark, width: 2.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorDark)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorDark, width: 2.0)),
          labelStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 14, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryDark.withAlpha(179), fontSize: 14, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorDark, fontSize: 12, fontWeight: FontWeight.w400)),
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey[600];
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withAlpha(128);
        }
        return Colors.grey[600];
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryDark;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.black),
          side: const BorderSide(color: borderDark, width: 2.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      })),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryDark, linearTrackColor: borderDark, circularTrackColor: borderDark),
      sliderTheme: SliderThemeData(activeTrackColor: primaryDark, thumbColor: primaryDark, overlayColor: primaryDark.withAlpha(51), inactiveTrackColor: borderDark, trackHeight: 4.0),
      tabBarTheme: TabBarTheme(labelColor: primaryDark, unselectedLabelColor: textSecondaryDark, indicatorColor: primaryDark, indicatorSize: TabBarIndicatorSize.tab, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400)),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimaryDark.withAlpha(230), borderRadius: BorderRadius.circular(8.0)), textStyle: GoogleFonts.inter(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimaryDark, contentTextStyle: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: secondaryDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      listTileTheme: ListTileThemeData(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), tileColor: surfaceDark, selectedTileColor: primaryDark.withAlpha(51), iconColor: textSecondaryDark, textColor: textPrimaryDark, titleTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryDark), subtitleTextStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textSecondaryDark)), dialogTheme: DialogThemeData(backgroundColor: dialogDark));

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for educational content clarity
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
        // Display styles for large headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles for section headers
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.33),

        // Title styles for cards and components
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.15,
            height: 1.50),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),

        // Body styles for content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.5,
            height: 1.50),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4,
            height: 1.33),

        // Label styles for buttons and form elements
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.5,
            height: 1.33),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.5,
            height: 1.45));
  }
}
