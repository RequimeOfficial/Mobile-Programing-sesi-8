import 'mata_kuliah.dart';

/// Aturan pengisian KRS yang dipakai oleh halaman (dipisah agar mudah diuji).
class AturanKrs {
  AturanKrs._();

  static int totalSks(Iterable<MataKuliah> dipilih) =>
      dipilih.fold(0, (jumlah, mk) => jumlah + mk.sks);

  /// Mengecek apakah [mk] boleh ditambahkan ke daftar [dipilih].
  static HasilPilih cekTambah(
    MataKuliah mk,
    Iterable<MataKuliah> dipilih,
    int batasSks,
  ) {
    if (mk.penuh) return const KelasPenuh();
    for (final lain in dipilih) {
      if (mk.bentrokDengan(lain)) return JadwalBentrok(lain);
    }
    final sisa = batasSks - totalSks(dipilih);
    if (mk.sks > sisa) return MelebihiBatasSks(sisa);
    return const Diterima();
  }
}
