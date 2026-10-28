import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/date_format.dart';
import '../utils/ui_helpers.dart';
import '../widgets/responsive_body.dart';
import 'add_note_screen.dart';

/// Halaman 5 - Detail Catatan: menampilkan isi catatan.
/// Perubahan (edit, arsip, hapus) dikabarkan ke Beranda lewat callback.
class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggleArchive,
  });

  final Note note;
  final void Function(Note old, Note updated) onUpdate;
  final ValueChanged<Note> onDelete;
  final ValueChanged<Note> onToggleArchive;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Note _note = widget.note;

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => AddNoteScreen(note: _note)),
    );
    if (updated == null || !mounted) return;
    widget.onUpdate(_note, updated);
    setState(() => _note = updated);
    showInfo(context, 'Catatan berhasil diperbarui');
  }

  Future<void> _delete() async {
    final ok = await confirmDelete(context);
    if (!ok || !mounted) return;
    widget.onDelete(_note);
    Navigator.of(context).pop();
  }

  void _toggleArchive() {
    widget.onToggleArchive(_note);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final note = _note;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: note.archived ? 'Kembalikan' : 'Arsipkan',
            icon: Icon(
              note.archived ? Icons.unarchive_outlined : Icons.archive_outlined,
              color: AppColors.muted,
            ),
            onPressed: _toggleArchive,
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            onPressed: _delete,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: note.color.soft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(note.icon, color: note.color.accent, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _Tag(label: note.category, color: note.color.accent),
                                _Tag(
                                  label: 'Prioritas ${note.priority.label}',
                                  color: note.color.accent,
                                ),
                                if (note.archived)
                                  _Tag(label: 'Diarsipkan', color: AppColors.muted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.muted),
                    const SizedBox(width: 8),
                    Text(
                      '${formatTanggal(note.date)}  \u00B7  ${formatJam(note.date)}',
                      style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),
                Text(
                  note.content,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}
