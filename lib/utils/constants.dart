import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF67B0AE); // A teal/greenish color
  static const Color accent = Color(0xFFC70039); // A vibrant red
  static const Color background = Color(0xFF1A1A2E); // Dark blue/purple background
  static const Color cardBackground = Color(0xFF1F2039); // Slightly lighter card background
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color border = Color(0xFF33334A);
  static const Color error = Color(0xFFEF5350); // Red color for error/shockwave (NEW!)

}

class AppTextStyles {
  static TextStyle sectionTitle(BuildContext context) => Theme.of(context).textTheme.displaySmall!.copyWith(
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading1(BuildContext context) => Theme.of(context).textTheme.displayLarge!.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading2(BuildContext context) => Theme.of(context).textTheme.displayMedium!.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyText(BuildContext context) => Theme.of(context).textTheme.bodyLarge!.copyWith(
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle buttonText(BuildContext context) => Theme.of(context).textTheme.labelLarge!.copyWith(
    color: AppColors.textPrimary,
  );
}

class AppPaddings {
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 80.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
}

class AppDurations {
  static const Duration defaultAnimation = Duration(milliseconds: 500);
  static const Duration scrollAnimation = Duration(milliseconds: 800);
}

class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1000;
}