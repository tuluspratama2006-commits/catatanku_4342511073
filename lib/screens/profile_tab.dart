import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tab Profil (bagian dari Beranda): data diri statis + ringkasan catatan.
class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.activeCount,
    required this.archivedCount,
    required this.onLogout,
  });

  final int activeCount;
  final int archivedCount;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 92,
              height: 92,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF55B0FF), AppColors.primary],
                ),
              ),
              child: const Text(
                'TP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tulus Pratama',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mahasiswa TRPL - Politeknik Negeri Batam',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '$activeCount',
                  label: 'Catatan',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: '$archivedCount',
                  label: 'Arsip',
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: '${activeCount + archivedCount}',
                  label: 'Total',
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                _InfoRow(
                  icon: Icons.badge_outlined,
                  label: 'NIM',
                  value: '4342511073',
                ),
                Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.groups_outlined,
                  label: 'Kelas',
                  value: 'TRPL 3C Malam',
                ),
                Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.school_outlined,
                  label: 'Program Studi',
                  value: 'Teknologi Rekayasa Perangkat Lunak',
                ),
                Divider(height: 1, color: AppColors.border),
                _InfoRow(
                  icon: Icons.phone_android_rounded,
                  label: 'Mata Kuliah',
                  value: 'Pemrograman Perangkat Bergerak',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
          ),
          const SizedBox(height: 16),
          const Text(
            'CatatanKu v1.0',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.hint),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
