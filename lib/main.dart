// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:three_d_portfolio/screens/splash_screen.dart';
import 'screens/home_page.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Himanshu\'s Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        hintColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: AppColors.textPrimary),
        ).copyWith(
          displayLarge: GoogleFonts.inter(
              fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          displayMedium: GoogleFonts.inter(
              fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          displaySmall: GoogleFonts.inter(
              fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineLarge: GoogleFonts.inter(
              fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          headlineMedium: GoogleFonts.inter(
              fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          headlineSmall: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleLarge: GoogleFonts.inter(
              fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          titleMedium: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          titleSmall: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          bodyLarge: GoogleFonts.inter(
              fontSize: 16, color: AppColors.textSecondary),
          bodyMedium: GoogleFonts.inter(
              fontSize: 14, color: AppColors.textSecondary),
          bodySmall: GoogleFonts.inter(
              fontSize: 12, color: AppColors.textSecondary),
          labelLarge: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          labelMedium: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          labelSmall: GoogleFonts.inter(
              fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// lib/utils/constants.dart


// lib/utils/data.dart


// lib/widgets/responsive_layout.dart


// lib/widgets/section_title.dart


// lib/widgets/navbar.dart


// lib/widgets/hero_section.dart


// lib/widgets/about_section.dart


// lib/widgets/skill_section.dart


// lib/widgets/portfolio_section.dart


// lib/widgets/contact_section.dart


// lib/widgets/footer_section.dart


// lib/screens/home_page.dart

