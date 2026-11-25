import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF29384D);
  static const white = Color(0xFFFFFFFF);
  static const lightBlue = Color(0xFFE2F4F6);
  static const gold = Color(0xFFFFF1D4);
  static const red = Color(0xFFEE403D);
}

           class AppTheme {
          static OutlineInputBorder _border(Color color) => OutlineInputBorder(
             borderRadius: BorderRadius.circular(16),
           borderSide: BorderSide(width: 2, color: color),
           );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    textTheme:  TextTheme(
      titleLarge: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gold),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gold),
      bodySmall: TextStyle(
          fontSize: 10, fontWeight: FontWeight.normal, color: AppColors.gold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBlue,
        textStyle:
         TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        alignment: Alignment.center,
        overlayColor: Colors.transparent,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textSelectionTheme:  TextSelectionThemeData(
      cursorColor: AppColors.gold,
      selectionHandleColor: AppColors.gold,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBlue,
      hintStyle:  TextStyle(fontSize: 16, color: AppColors.lightBlue),
      errorStyle:  TextStyle(color: AppColors.red),
      contentPadding: const EdgeInsets.all(16),
      border: _border(AppColors.gold),
      enabledBorder: _border(AppColors.gold),
      focusedBorder: _border(AppColors.gold),
      errorBorder: _border(AppColors.red),
      focusedErrorBorder: _border(AppColors.red),
    ),
  );
}