import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Daftar kategori yang tersedia.
const List<String> kCategories = ['Penting', 'Pribadi', 'Kerja', 'Kuliah'];

enum NotePriority {
  rendah('Rendah'),
  sedang('Sedang'),
  tinggi('Tinggi');

  const NotePriority(this.label);
  final String label;
}

/// Model data satu catatan (hanya untuk keperluan tampilan UI).
/// Objek bersifat immutable; perubahan dilakukan lewat [copyWith].
class Note {
  const Note({
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    required this.color,
    required this.priority,
    required this.icon,
    this.archived = false,
  });

  final String title;
  final String content;
  final String category;
  final DateTime date;
  final NoteColor color;
  final NotePriority priority;
  final IconData icon;
  final bool archived;

  Note copyWith({
    String? title,
    String? content,
    String? category,
    DateTime? date,
    NoteColor? color,
    NotePriority? priority,
    IconData? icon,
    bool? archived,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      date: date ?? this.date,
      color: color ?? this.color,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      archived: archived ?? this.archived,
    );
  }

  /// Ikon bawaan untuk catatan baru berdasarkan kategorinya.
  static IconData iconFor(String category) {
    switch (category) {
      case 'Penting':
        return Icons.lightbulb_rounded;
      case 'Pribadi':
        return Icons.favorite_rounded;
      case 'Kerja':
        return Icons.work_rounded;
      case 'Kuliah':
        return Icons.menu_book_rounded;
      default:
        return Icons.sticky_note_2_rounded;
    }
  }
}
