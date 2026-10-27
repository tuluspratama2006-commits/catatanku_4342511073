import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';

/// Data contoh (statis) agar halaman Beranda terlihat berisi.
final List<Note> dummyNotes = [
  Note(
    title: 'Ide Aplikasi',
    content:
        'Ide untuk membuat aplikasi catatan sederhana dengan fitur kategori, '
        'warna, dan prioritas. Aplikasi ini digunakan untuk mencatat ide, '
        'rencana, dan hal penting sehari-hari.',
    category: 'Penting',
    date: DateTime(2026, 10, 19, 9, 30),
    color: AppColors.yellow,
    priority: NotePriority.sedang,
    icon: Icons.lightbulb_rounded,
  ),
  Note(
    title: 'Rencana Mingguan',
    content:
        'Senin: rapat tim proyek.\nRabu: kumpulkan tugas Pemrograman '
        'Perangkat Bergerak.\nJumat: olahraga sore dan merapikan catatan.',
    category: 'Kerja',
    date: DateTime(2026, 10, 18, 8, 0),
    color: AppColors.green,
    priority: NotePriority.tinggi,
    icon: Icons.calendar_month_rounded,
  ),
  Note(
    title: 'Catatan Kuliah',
    content:
        'Widget pada Flutter dibagi menjadi StatelessWidget dan '
        'StatefulWidget. Gunakan StatefulWidget bila tampilan perlu berubah '
        'saat pengguna berinteraksi.',
    category: 'Kuliah',
    date: DateTime(2026, 10, 17, 13, 15),
    color: AppColors.purple,
    priority: NotePriority.sedang,
    icon: Icons.menu_book_rounded,
  ),
  Note(
    title: 'Hal yang Perlu Dibeli',
    content: 'Buku tulis, pulpen, kabel charger, dan alat kebersihan.',
    category: 'Pribadi',
    date: DateTime(2026, 10, 16, 17, 45),
    color: AppColors.pink,
    priority: NotePriority.rendah,
    icon: Icons.shopping_cart_rounded,
  ),
  Note(
    title: 'Jurnal Harian',
    content:
        'Hari ini mulai mengerjakan desain antarmuka CatatanKu. '
        'Targetnya lima halaman selesai dengan tampilan yang konsisten.',
    category: 'Pribadi',
    date: DateTime(2026, 10, 15, 21, 0),
    color: AppColors.blue,
    priority: NotePriority.rendah,
    icon: Icons.favorite_rounded,
  ),
];
