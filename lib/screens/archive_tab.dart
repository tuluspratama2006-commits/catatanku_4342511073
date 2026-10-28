import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';

/// Tab Arsip (bagian dari Beranda): daftar catatan yang diarsipkan.
class ArchiveTab extends StatelessWidget {
  const ArchiveTab({
    super.key,
    required this.notes,
    required this.onOpen,
    required this.onEdit,
    required this.onToggleArchive,
    required this.onDelete,
  });

  final List<Note> notes;
  final ValueChanged<Note> onOpen;
  final ValueChanged<Note> onEdit;
  final ValueChanged<Note> onToggleArchive;
  final ValueChanged<Note> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arsip',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Catatan yang kamu simpan di arsip',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: notes.isEmpty
              ? const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  message: 'Arsip masih kosong',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: notes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () => onOpen(note),
                      onEdit: () => onEdit(note),
                      onArchive: () => onToggleArchive(note),
                      onDelete: () => onDelete(note),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
