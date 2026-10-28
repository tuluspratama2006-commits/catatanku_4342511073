import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_body.dart';

/// Halaman 4 - Tambah Catatan: form input judul, isi, kategori, warna, prioritas.
/// Jika [note] diisi, halaman yang sama dipakai sebagai mode Edit Catatan.
/// Saat "Simpan" ditekan, catatan dikirim kembali ke pemanggil (tanpa database).
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, this.note});

  final Note? note;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  static const String _emptyContent = '(Tidak ada isi catatan)';

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _category;
  bool _categoryError = false;
  NoteColor _color = AppColors.noteColors.first;
  NotePriority _priority = NotePriority.sedang;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text =
          note.content == _emptyContent ? '' : note.content;
      _category = note.category;
      _color = note.color;
      _priority = note.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    FocusScope.of(context).unfocus();
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in kCategories)
              ListTile(
                leading: Icon(Note.iconFor(c), color: AppColors.primary),
                title: Text(c),
                trailing: c == _category
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, c),
              ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _category = picked;
        _categoryError = false;
      });
    }
  }

  void _save() {
    final valid = _formKey.currentState!.validate();
    setState(() => _categoryError = _category == null);
    if (!valid || _category == null) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final text = content.isEmpty ? _emptyContent : content;

    final old = widget.note;
    final result = old != null
        // Mode edit: pertahankan tanggal & status arsip, ubah sisanya.
        ? old.copyWith(
            title: title,
            content: text,
            category: _category!,
            color: _color,
            priority: _priority,
            icon: _category == old.category
                ? old.icon
                : Note.iconFor(_category!),
          )
        : Note(
            title: title,
            content: text,
            category: _category!,
            date: DateTime.now(),
            color: _color,
            priority: _priority,
            icon: Note.iconFor(_category!),
          );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: SafeArea(
        child: ResponsiveBody(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('Judul Catatan'),
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        AppTheme.inputDecoration(hint: 'Masukkan judul catatan'),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Judul catatan wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Isi Catatan'),
                  TextFormField(
                    controller: _contentController,
                    minLines: 5,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    decoration: AppTheme.inputDecoration(
                        hint: 'Tulis catatan Anda di sini...'),
                  ),
                  const SizedBox(height: 18),
                  const _FieldLabel('Kategori'),
                  _buildCategorySelector(),
                  const SizedBox(height: 18),
                  const _FieldLabel('Warna'),
                  _buildColorPicker(),
                  const SizedBox(height: 18),
                  const _FieldLabel('Prioritas'),
                  _buildPrioritySelector(),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: _save,
                    child: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final radius = BorderRadius.circular(14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: radius,
          onTap: _pickCategory,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.all(
                color: _categoryError ? AppColors.danger : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.label_outline_rounded,
                    size: 20, color: AppColors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _category ?? 'Pilih kategori',
                    style: TextStyle(
                      fontSize: 14,
                      color: _category == null ? AppColors.hint : AppColors.ink,
                    ),
                  ),
                ),
                const Icon(Icons.expand_more_rounded, color: AppColors.muted),
              ],
            ),
          ),
        ),
        if (_categoryError)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 16),
            child: Text(
              'Kategori wajib dipilih',
              style: TextStyle(fontSize: 12, color: AppColors.danger),
            ),
          ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: [
        for (final c in AppColors.noteColors)
          GestureDetector(
            onTap: () => setState(() => _color = c),
            child: Tooltip(
              message: c.name,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: c == _color ? AppColors.ink : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: c == _color
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        for (final p in NotePriority.values)
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _priority = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                height: 42,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  right: p == NotePriority.values.last ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: p == _priority ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: p == _priority ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  p.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: p == _priority ? Colors.white : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTheme.label),
    );
  }
}
