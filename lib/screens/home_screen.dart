import 'package:flutter/material.dart';

import '../data/dummy_notes.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/ui_helpers.dart';
import '../widgets/note_card.dart';
import '../widgets/responsive_body.dart';
import 'add_note_screen.dart';
import 'login_screen.dart';
import 'note_detail_screen.dart';

/// Halaman 3 - Beranda: daftar catatan + pencarian + filter kategori.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = ['Semua', ...kCategories];

  final List<Note> _notes = List.of(dummyNotes);
  String _category = 'Semua';
  String _query = '';

  List<Note> get _visibleNotes {
    final q = _query.trim().toLowerCase();
    return _notes.where((note) {
      final matchCategory = _category == 'Semua' || note.category == _category;
      final matchQuery = note.title.toLowerCase().contains(q);
      return matchCategory && matchQuery;
    }).toList();
  }

  Future<void> _openAdd() async {
    final note = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (note == null || !mounted) return;
    setState(() => _notes.insert(0, note));
    showInfo(context, 'Catatan berhasil disimpan');
  }

  Future<void> _openDetail(Note note) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
    );
    if (deleted == true && mounted) {
      setState(() => _notes.remove(note));
    }
  }

  Future<void> _delete(Note note) async {
    final ok = await confirmDelete(context);
    if (ok && mounted) {
      setState(() => _notes.remove(note));
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Anda akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    // Hapus semua halaman sebelumnya agar tombol Back tidak kembali ke Beranda.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = _visibleNotes;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _Header(name: 'Tulus', onLogout: _logout),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: AppTheme.inputDecoration(
                          hint: 'Cari catatan...',
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.muted),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: IconButton(
                        tooltip: 'Filter',
                        icon: const Icon(Icons.tune_rounded, color: AppColors.muted),
                        onPressed: () =>
                            showInfo(context, 'Filter lanjutan belum tersedia'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final label = _categories[index];
                    return _CategoryChip(
                      label: label,
                      selected: label == _category,
                      onTap: () => setState(() => _category = label),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Stack(
                  children: [
                    notes.isEmpty
                        ? const _EmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                            itemCount: notes.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return NoteCard(
                                note: note,
                                onTap: () => _openDetail(note),
                                onDelete: () => _delete(note),
                              );
                            },
                          ),
                    Positioned(
                      right: 20,
                      bottom: 16,
                      child: FloatingActionButton(
                        heroTag: null,
                        tooltip: 'Tambah catatan',
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        onPressed: _openAdd,
                        child: const Icon(Icons.add_rounded, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
              NavigationBar(
                selectedIndex: 0,
                backgroundColor: Colors.white,
                indicatorColor: AppColors.primary.withValues(alpha: 0.12),
                onDestinationSelected: (index) {
                  if (index != 0) {
                    showInfo(context,
                        'Halaman ini di luar lingkup tugas (hanya 5 halaman)');
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                    label: 'Beranda',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.folder_outlined),
                    label: 'Arsip',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    label: 'Profil',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.onLogout});

  final String name;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo,',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '$name \u{1F44B}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Apa yang ingin kamu catat hari ini?',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Keluar',
          icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
          onPressed: onLogout,
        ),
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.border,
          child: Icon(Icons.person_rounded, color: AppColors.muted),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_alt_outlined, size: 56, color: AppColors.hint),
          SizedBox(height: 12),
          Text(
            'Belum ada catatan',
            style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
