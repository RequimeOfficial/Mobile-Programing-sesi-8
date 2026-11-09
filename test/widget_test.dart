import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krs_online/data/data_krs.dart';
import 'package:krs_online/main.dart';
import 'package:krs_online/models/aturan_krs.dart';
import 'package:krs_online/models/mata_kuliah.dart';

MataKuliah mk(String kode) =>
    daftarMataKuliah.firstWhere((m) => m.kode == kode);

Future<void> jalankan(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const KrsApp());
}

/// Menekan kartu mata kuliah berdasarkan namanya (menggulir bila perlu).
Future<void> tekanMk(WidgetTester tester, String nama) async {
  final f = find.text(nama);
  await tester.scrollUntilVisible(
    f,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(f);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(f);
  await tester.pump();
  // beri waktu animasi SnackBar sebelumnya tertutup
  await tester.pump(const Duration(milliseconds: 400));
}

String totalSks(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('total-sks'))).data!;

void main() {
  group('AturanKrs', () {
    test('menghitung total SKS', () {
      expect(AturanKrs.totalSks([mk('IF501'), mk('IF508')]), 5);
    });

    test('menolak jadwal bentrok', () {
      final hasil = AturanKrs.cekTambah(mk('IF552'), [mk('IF551')], 24);
      expect(hasil, isA<JadwalBentrok>());
      expect((hasil as JadwalBentrok).dengan.kode, 'IF551');
    });

    test('menolak kelas penuh', () {
      expect(AturanKrs.cekTambah(mk('IF553'), [], 24), isA<KelasPenuh>());
    });

    test('menolak bila melebihi batas SKS', () {
      final wajib = daftarMataKuliah.where((m) => m.jenis == JenisMk.wajib);
      expect(AturanKrs.totalSks(wajib), 23);
      final hasil = AturanKrs.cekTambah(mk('IF551'), wajib, 24);
      expect(hasil, isA<MelebihiBatasSks>());
      expect((hasil as MelebihiBatasSks).sisa, 1);
    });

    test('batas SKS 24 untuk IPK di atas 3.0', () {
      expect(Mahasiswa.batasSks, 24);
    });
  });

  testWidgets('mencentang mata kuliah menambah total SKS', (tester) async {
    await jalankan(tester);
    expect(totalSks(tester), '0 / 24 SKS');

    await tekanMk(tester, 'Pemrograman Mobile');
    expect(totalSks(tester), '3 / 24 SKS');
    expect(find.textContaining('ditambahkan'), findsOneWidget);

    await tekanMk(tester, 'Pemrograman Mobile');
    expect(totalSks(tester), '0 / 24 SKS');
  });

  testWidgets('jadwal bentrok dan kelas penuh ditolak', (tester) async {
    await jalankan(tester);
    await tekanMk(tester, 'Data Mining');
    await tekanMk(tester, 'Keamanan Siber');
    expect(
      find.textContaining('Jadwal bentrok dengan Data Mining'),
      findsOneWidget,
    );
    expect(totalSks(tester), '3 / 24 SKS');

    await tekanMk(tester, 'Cloud Computing');
    expect(find.textContaining('sudah penuh'), findsOneWidget);
    expect(totalSks(tester), '3 / 24 SKS');
  });

  testWidgets('pencarian dan filter menyaring daftar', (tester) async {
    await jalankan(tester);
    await tester.enterText(find.byType(TextField), 'graf');
    await tester.pump();
    expect(find.text('1 mata kuliah ditampilkan'), findsOneWidget);
    expect(find.text('Teori Graf'), findsOneWidget);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    await tester.tap(find.text('Pilihan'));
    await tester.pump();
    expect(find.text('4 mata kuliah ditampilkan'), findsOneWidget);
  });

  testWidgets('mengajukan KRS mengunci pilihan lalu bisa dibatalkan', (
    tester,
  ) async {
    await jalankan(tester);
    await tekanMk(tester, 'Pemrograman Mobile');
    await tekanMk(tester, 'Teori Graf');

    await tester.tap(find.text('Ajukan KRS'));
    await tester.pumpAndSettle();
    expect(find.text('Ajukan KRS?'), findsOneWidget);
    await tester.tap(find.text('Ajukan'));
    await tester.pumpAndSettle();
    await tester.fling(
      find.byType(Scrollable).first,
      const Offset(0, 2000),
      3000,
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Menunggu persetujuan'), findsOneWidget);
    // tunggu SnackBar "berhasil diajukan" hilang agar tidak menutupi kartu
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tekanMk(tester, 'Teori Graf');
    expect(find.textContaining('KRS sudah diajukan'), findsOneWidget);
    expect(totalSks(tester), '6 / 24 SKS');

    await tester.tap(find.text('Batalkan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Menunggu persetujuan'), findsNothing);
    expect(find.text('Ajukan KRS'), findsOneWidget);
  });

  testWidgets('kosongkan pilihan dapat diurungkan', (tester) async {
    await jalankan(tester);
    await tekanMk(tester, 'Pemrograman Mobile');
    await tester.tap(find.byTooltip('Kosongkan pilihan'));
    await tester.pumpAndSettle();
    expect(totalSks(tester), '0 / 24 SKS');

    await tester.tap(find.text('URUNGKAN'));
    await tester.pumpAndSettle();
    expect(totalSks(tester), '3 / 24 SKS');
  });

  testWidgets('tab Jadwal Saya menampilkan mata kuliah per hari', (
    tester,
  ) async {
    await jalankan(tester);
    await tester.tap(find.text('Jadwal Saya'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Belum ada mata kuliah'), findsOneWidget);

    await tester.tap(find.text('Isi KRS'));
    await tester.pumpAndSettle();
    await tekanMk(tester, 'Pemrograman Mobile');
    await tester.tap(find.text('Jadwal Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Senin'), findsOneWidget);
    expect(find.text('Pemrograman Mobile'), findsOneWidget);
  });
}
