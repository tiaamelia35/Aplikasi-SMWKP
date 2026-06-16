import 'package:flutter/material.dart';
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.darkRed,
        surface: AppColors.white,
        error: AppColors.error,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.xl,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),
      
      // Text Theme
      textTheme: _buildTextTheme(),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.lightGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.lightGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        hintStyle: const TextStyle(
          color: AppColors.grey,
          fontFamily: 'Poppins',
        ),
        labelStyle: const TextStyle(
          color: AppColors.darkGrey,
          fontFamily: 'Poppins',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: const TextStyle(
            fontSize: AppFontSize.md,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        surfaceTintColor: AppColors.white,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGrey,
        thickness: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primary,
      ),
      
      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: AppFontSize.xxxl,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: AppFontSize.xl,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        fontSize: AppFontSize.xl,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: AppFontSize.lg,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrey,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrey,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGrey,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: AppFontSize.md,
        fontWeight: FontWeight.normal,
        color: AppColors.black,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.normal,
        color: AppColors.darkGrey,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: AppFontSize.xs,
        fontWeight: FontWeight.normal,
        color: AppColors.grey,
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        fontSize: AppFontSize.sm,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        fontFamily: 'Poppins',
      ),
    );
  }
}
