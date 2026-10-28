import 'package:flutter/material.dart';

import '../data/dummy_notes.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils/ui_helpers.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/responsive_body.dart';
import 'add_note_screen.dart';
import 'archive_tab.dart';
import 'login_screen.dart';
import 'note_detail_screen.dart';
import 'profile_tab.dart';

/// Pilihan urutan daftar catatan pada filter.
enum SortOrder {
  terbaru('Terbaru'),
  terlama('Terlama'),
  judul('Judul A-Z'),
  prioritas('Prioritas tertinggi');

  const SortOrder(this.label);
  final String label;
}

/// Halaman 3 - Beranda: daftar catatan + pencarian + filter kategori.
/// Bottom navigation memuat tab Beranda, Arsip, dan Profil (tetap satu halaman).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _categories = ['Semua', ...kCategories];

  final List<Note> _notes = List.of(dummyNotes);
  int _tab = 0;
  String _category = 'Semua';
  String _query = '';
  NotePriority? _priorityFilter;
  SortOrder _sort = SortOrder.terbaru;

  List<Note> get _activeNotes => _notes.where((n) => !n.archived).toList();
  List<Note> get _archivedNotes => _notes.where((n) => n.archived).toList();

  bool get _filterActive =>
      _priorityFilter != null || _sort != SortOrder.terbaru;

  List<Note> get _visibleNotes {
    final q = _query.trim().toLowerCase();
    final result = _activeNotes.where((note) {
      final matchCategory = _category == 'Semua' || note.category == _category;
      final matchQuery = note.title.toLowerCase().contains(q);
      final matchPriority =
          _priorityFilter == null || note.priority == _priorityFilter;
      return matchCategory && matchQuery && matchPriority;
    }).toList();

    switch (_sort) {
      case SortOrder.terbaru:
        result.sort((a, b) => b.date.compareTo(a.date));
      case SortOrder.terlama:
        result.sort((a, b) => a.date.compareTo(b.date));
      case SortOrder.judul:
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case SortOrder.prioritas:
        result.sort((a, b) {
          final byPriority = b.priority.index.compareTo(a.priority.index);
          return byPriority != 0 ? byPriority : b.date.compareTo(a.date);
        });
    }
    return result;
  }

  // ---------- operasi data ----------

  void _replace(Note old, Note updated) {
    final index = _notes.indexOf(old);
    if (index < 0) return;
    setState(() => _notes[index] = updated);
  }

  void _remove(Note note) {
    setState(() => _notes.remove(note));
    showInfo(context, 'Catatan dihapus');
  }

  void _toggleArchive(Note note) {
    _replace(note, note.copyWith(archived: !note.archived));
    showInfo(
      context,
      note.archived
          ? 'Catatan dikembalikan ke Beranda'
          : 'Catatan dipindahkan ke Arsip',
    );
  }

  // ---------- navigasi ----------

  Future<void> _openAdd() async {
    final note = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => const AddNoteScreen()),
    );
    if (note == null || !mounted) return;
    setState(() => _notes.insert(0, note));
    showInfo(context, 'Catatan berhasil disimpan');
  }

  Future<void> _openEdit(Note note) async {
    final updated = await Navigator.of(context).push<Note>(
      MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
    );
    if (updated == null || !mounted) return;
    _replace(note, updated);
    showInfo(context, 'Catatan berhasil diperbarui');
  }

  void _openDetail(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(
          note: note,
          onUpdate: _replace,
          onDelete: _remove,
          onToggleArchive: _toggleArchive,
        ),
      ),
    );
  }

  Future<void> _delete(Note note) async {
    final ok = await confirmDelete(context);
    if (ok && mounted) _remove(note);
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

  Future<void> _openFilter() async {
    // Nilai sementara: baru dipakai saat tombol "Terapkan" ditekan.
    NotePriority? tempPriority = _priorityFilter;
    SortOrder tempSort = _sort;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter & Urutkan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Prioritas', style: AppTheme.label),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in <NotePriority?>[null, ...NotePriority.values])
                      _OptionPill(
                        label: p?.label ?? 'Semua',
                        selected: tempPriority == p,
                        onTap: () => setSheet(() => tempPriority = p),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text('Urutkan berdasarkan', style: AppTheme.label),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final order in SortOrder.values)
                      _OptionPill(
                        label: order.label,
                        selected: tempSort == order,
                        onTap: () => setSheet(() => tempSort = order),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setSheet(() {
                          tempPriority = null;
                          tempSort = SortOrder.terbaru;
                        }),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            _priorityFilter = tempPriority;
                            _sort = tempSort;
                          });
                          Navigator.pop(ctx);
                        },
                        child: const Text('Terapkan'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- tampilan ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveBody(
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: [
                    _buildBeranda(),
                    ArchiveTab(
                      notes: _archivedNotes,
                      onOpen: _openDetail,
                      onEdit: _openEdit,
                      onToggleArchive: _toggleArchive,
                      onDelete: _delete,
                    ),
                    ProfileTab(
                      activeCount: _activeNotes.length,
                      archivedCount: _archivedNotes.length,
                      onLogout: _logout,
                    ),
                  ],
                ),
              ),
              NavigationBar(
                selectedIndex: _tab,
                backgroundColor: Colors.white,
                indicatorColor: AppColors.primary.withValues(alpha: 0.12),
                onDestinationSelected: (index) => setState(() => _tab = index),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                    label: 'Beranda',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.inventory_2_outlined),
                    selectedIcon:
                        Icon(Icons.inventory_2_rounded, color: AppColors.primary),
                    label: 'Arsip',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon:
                        Icon(Icons.person_rounded, color: AppColors.primary),
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

  Widget _buildBeranda() {
    final notes = _visibleNotes;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: const _Header(name: 'Tulus'),
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
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: AppColors.muted),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Filter',
                      icon: Icon(
                        Icons.tune_rounded,
                        color: _filterActive ? AppColors.primary : AppColors.muted,
                      ),
                      onPressed: _openFilter,
                    ),
                    if (_filterActive)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
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
                  ? EmptyState(
                      icon: Icons.note_alt_outlined,
                      message: (_query.isNotEmpty ||
                              _category != 'Semua' ||
                              _filterActive)
                          ? 'Tidak ada catatan yang cocok'
                          : 'Belum ada catatan',
                    )
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
                          onEdit: () => _openEdit(note),
                          onArchive: () => _toggleArchive(note),
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
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

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

/// Pilihan (pill) di dalam bottom sheet filter.
class _OptionPill extends StatelessWidget {
  const _OptionPill({
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
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
