import 'package:flutter/material.dart';

/// Pasangan warna untuk sebuah catatan.
/// [accent] dipakai untuk ikon/lingkaran pilihan, [soft] untuk latar kartu.
class NoteColor {
  const NoteColor({
    required this.name,
    required this.accent,
    required this.soft,
  });

  final String name;
  final Color accent;
  final Color soft;
}

/// Palet warna yang dipakai di seluruh aplikasi agar tampilan konsisten.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2F6BFF);
  static const Color ink = Color(0xFF14213D);
  static const Color muted = Color(0xFF6B7A99);
  static const Color hint = Color(0xFF9AA7C2);
  static const Color background = Color(0xFFF5F8FF);
  static const Color border = Color(0xFFE3E9F7);
  static const Color danger = Color(0xFFE53E3E);

  static const NoteColor blue = NoteColor(
    name: 'Biru',
    accent: Color(0xFF2FA8F5),
    soft: Color(0xFFDCEEFF),
  );
  static const NoteColor green = NoteColor(
    name: 'Hijau',
    accent: Color(0xFF3FC79A),
    soft: Color(0xFFDDF6EA),
  );
  static const NoteColor yellow = NoteColor(
    name: 'Kuning',
    accent: Color(0xFFFFC83D),
    soft: Color(0xFFFFF4CC),
  );
  static const NoteColor pink = NoteColor(
    name: 'Merah Muda',
    accent: Color(0xFFFF6FA5),
    soft: Color(0xFFFFE1EC),
  );
  static const NoteColor purple = NoteColor(
    name: 'Ungu',
    accent: Color(0xFFA78BFA),
    soft: Color(0xFFEAE4FF),
  );

  static const List<NoteColor> noteColors = [blue, green, yellow, pink, purple];
}

/// Tema global (Material 3) + gaya komponen yang dipakai ulang.
class AppTheme {
  AppTheme._();

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.primary)
        .copyWith(primary: AppColors.primary, surface: Colors.white);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.ink,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Gaya input yang sama untuk halaman Login dan Tambah Catatan.
  static InputDecoration inputDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.hint, fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.primary, 1.6),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger, 1.6),
    );
  }
}
