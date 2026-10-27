import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo CatatanKu (dibuat dari ikon bawaan, tanpa file gambar eksternal).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF55B0FF), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: size * 0.22,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Icon(Icons.edit_note_rounded, color: Colors.white, size: size * 0.62),
    );
  }
}
