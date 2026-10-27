import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Menampilkan pesan singkat (SnackBar).
void showInfo(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}

/// Dialog konfirmasi hapus. Mengembalikan true bila pengguna memilih "Hapus".
Future<bool> confirmDelete(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Hapus catatan?'),
      content: const Text('Catatan yang dihapus tidak dapat dikembalikan.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return result ?? false;
}
