const List<String> _bulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// Contoh: 19 Oktober 2026
String formatTanggal(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

/// Contoh: 09.30
String formatJam(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}.${d.minute.toString().padLeft(2, '0')}';
