import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';

/// Kartu satu catatan (dipakai di Beranda dan Arsip).
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onArchive,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Material(
      color: note.color.soft,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(note.icon, color: note.color.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatTanggal(note.date),
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.muted, size: 20),
                onSelected: (value) {
                  switch (value) {
                    case 'detail':
                      onTap();
                    case 'edit':
                      onEdit();
                    case 'arsip':
                      onArchive();
                    case 'hapus':
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'detail', child: Text('Lihat detail')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'arsip',
                    child: Text(note.archived ? 'Kembalikan' : 'Arsipkan'),
                  ),
                  const PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
