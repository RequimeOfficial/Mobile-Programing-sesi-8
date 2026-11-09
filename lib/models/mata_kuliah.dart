/// Jenis mata kuliah pada KRS.
enum JenisMk { wajib, pilihan }

/// Satu mata kuliah yang ditawarkan pada semester berjalan.
class MataKuliah {
  const MataKuliah({
    required this.kode,
    required this.nama,
    required this.sks,
    required this.jenis,
    required this.dosen,
    required this.hari,
    required this.jam,
    required this.ruang,
    required this.kuota,
    required this.terisi,
  });

  final String kode;
  final String nama;
  final int sks;
  final JenisMk jenis;
  final String dosen;
  final String hari;
  final String jam;
  final String ruang;
  final int kuota;
  final int terisi;

  String get jadwal => '$hari, $jam';
  bool get penuh => terisi >= kuota;

  /// Dua mata kuliah bentrok bila hari dan jamnya sama.
  bool bentrokDengan(MataKuliah lain) =>
      kode != lain.kode && hari == lain.hari && jam == lain.jam;
}

/// Status pengajuan KRS.
enum StatusKrs { draf, diajukan }

/// Hasil pengecekan ketika mahasiswa mencentang sebuah mata kuliah.
sealed class HasilPilih {
  const HasilPilih();
}

class Diterima extends HasilPilih {
  const Diterima();
}

class MelebihiBatasSks extends HasilPilih {
  const MelebihiBatasSks(this.sisa);
  final int sisa;
}

class JadwalBentrok extends HasilPilih {
  const JadwalBentrok(this.dengan);
  final MataKuliah dengan;
}

class KelasPenuh extends HasilPilih {
  const KelasPenuh();
}
