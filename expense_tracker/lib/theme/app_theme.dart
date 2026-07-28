import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the app.
///
/// Palette is deliberately restrained: a warm paper background, near-black
/// ink for text, and exactly one brand accent (a muted forest green — a
/// nod to currency without tipping into a neon "fintech" look). Income and
/// expense each get their own quiet, desaturated hue so the ledger reads
/// at a glance without shouting.
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF14181C);
  static const Color inkSoft = Color(0xFF4A5158);
  static const Color paper = Color(0xFFFAF9F6);
  static const Color paperElevated = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFE7E4DD);
  static const Color muted = Color(0xFF8A8F98);

  static const Color accent = Color(0xFF1F6F54); // forest — income / primary
  static const Color accentSoft = Color(0xFFDCEEE6);
  static const Color expense = Color(0xFFA65340); // muted clay — outflow
  static const Color expenseSoft = Color(0xFFF3E2DC);

  // Category palette — muted, distinct, non-neon.
  static const Color catFood = Color(0xFFD9A441);
  static const Color catTransport = Color(0xFF3B6EA5);
  static const Color catShopping = Color(0xFF7C5EA6);
  static const Color catBills = Color(0xFFA65340);
  static const Color catFun = Color(0xFFB85C7A);
  static const Color catHealth = Color(0xFF2F8F82);
  static const Color catOther = Color(0xFF8A8F98);
}

class AppText {
  AppText._();

  // Sora: geometric, a little architectural — used for headings only.
  static TextStyle display = GoogleFonts.sora(
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.5,
  );

  // Inter: workhorse body face.
  static TextStyle body = GoogleFonts.inter(
    color: AppColors.ink,
    fontWeight: FontWeight.w400,
  );

  // JetBrains Mono: every money figure in the app renders in mono with
  // tabular figures — the app's one signature typographic move, so
  // amounts always line up like a real ledger.
  static TextStyle mono = GoogleFonts.jetBrainsMono(
    color: AppColors.ink,
    fontWeight: FontWeight.w500,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
        primary: AppColors.accent,
        surface: AppColors.paper,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: AppText.display.copyWith(fontSize: 34),
        headlineMedium: AppText.display.copyWith(fontSize: 22),
        titleMedium: AppText.display.copyWith(fontSize: 16),
        bodyLarge: AppText.body.copyWith(fontSize: 15),
        bodyMedium: AppText.body.copyWith(fontSize: 14, color: AppColors.inkSoft),
        labelSmall: AppText.body.copyWith(fontSize: 12, color: AppColors.muted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.ink),
        titleTextStyle: AppText.display.copyWith(fontSize: 20),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.paper,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paperElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
        ),
        hintStyle: AppText.body.copyWith(color: AppColors.muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.paper,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppText.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.paperElevated,
        selectedItemColor: AppColors.ink,
        unselectedItemColor: AppColors.muted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
