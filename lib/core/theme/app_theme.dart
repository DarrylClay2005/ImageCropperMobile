import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF00D4FF);
  static const Color primaryBlueDark = Color(0xFF0099CC);
  static const Color accentCyan = Color(0xFF00BCD4);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color backgroundMedium = Color(0xFF1A1A1A);
  static const Color backgroundLight = Color(0xFF2A2A2A);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceMedium = Color(0xFF2E2E2E);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [primaryBlue, primaryBlueDark];
  static const List<Color> backgroundGradient = [backgroundDark, backgroundMedium, backgroundDark];
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF8A8A8A);
  
  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color warningColor = Color(0xFFFFC107);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: accentCyan,
        surface: Colors.white,
        background: Colors.grey[50]!,
        error: errorColor,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      scaffoldBackgroundColor: Colors.grey[50],
      cardTheme: _buildCardTheme(Brightness.light),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.light),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.light),
      textButtonTheme: _buildTextButtonTheme(Brightness.light),
      floatingActionButtonTheme: _buildFABTheme(Brightness.light),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: primaryBlue,
        secondary: accentCyan,
        surface: surfaceDark,
        background: backgroundDark,
        error: errorColor,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      scaffoldBackgroundColor: backgroundDark,
      cardTheme: _buildCardTheme(Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(Brightness.dark),
      outlinedButtonTheme: _buildOutlinedButtonTheme(Brightness.dark),
      textButtonTheme: _buildTextButtonTheme(Brightness.dark),
      floatingActionButtonTheme: _buildFABTheme(Brightness.dark),
      inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
      dividerTheme: const DividerThemeData(
        color: backgroundLight,
        thickness: 1,
      ),
    );
  }
  
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final textColor = brightness == Brightness.dark ? textPrimary : Colors.black87;
    
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: brightness == Brightness.dark ? textSecondary : Colors.black54,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        color: brightness == Brightness.dark ? textTertiary : Colors.black38,
        fontWeight: FontWeight.normal,
      ),
    );
  }
  
  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: brightness == Brightness.dark ? backgroundMedium : primaryBlue,
      foregroundColor: brightness == Brightness.dark ? primaryBlue : Colors.white,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark ? primaryBlue : Colors.white,
      ),
      iconTheme: IconThemeData(
        color: brightness == Brightness.dark ? primaryBlue : Colors.white,
      ),
    );
  }
  
  static CardTheme _buildCardTheme(Brightness brightness) {
    return CardTheme(
      elevation: brightness == Brightness.dark ? 8 : 2,
      color: brightness == Brightness.dark ? backgroundMedium : Colors.white,
      shadowColor: brightness == Brightness.dark ? Colors.black54 : Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
  
  static ElevatedButtonThemeData _buildElevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: brightness == Brightness.dark ? 8 : 2,
        shadowColor: primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(Brightness brightness) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  static TextButtonThemeData _buildTextButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  static FloatingActionButtonThemeData _buildFABTheme(Brightness brightness) {
    return FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: brightness == Brightness.dark ? 8 : 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
  
  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.dark ? backgroundLight : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.dark ? backgroundLight : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: brightness == Brightness.dark ? backgroundLight : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: brightness == Brightness.dark ? textSecondary : Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: brightness == Brightness.dark ? textTertiary : Colors.grey[400],
      ),
    );
  }
  
  // Gradient Decorations
  static BoxDecoration get primaryGradientDecoration => const BoxDecoration(
    gradient: LinearGradient(
      colors: primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
  
  static BoxDecoration get backgroundGradientDecoration => const BoxDecoration(
    gradient: LinearGradient(
      colors: backgroundGradient,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 0.5, 1.0],
    ),
  );
  
  // Shadow Styles
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];
}