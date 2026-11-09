import '../models/mata_kuliah.dart';

/// Data mahasiswa yang sedang login.
class Mahasiswa {
  static const nama = 'Ahmad Mofidur Robbiyal Aqla';
  static const nim = '2495114006';
  static const kelas = '5 - A';
  static const semester = 5;
  static const ipkLalu = 3.62;
  static const tahunAkademik = '2026/2027 Ganjil';

  /// Batas SKS ditentukan dari IPK semester lalu (aturan umum kampus).
  static int get batasSks {
    if (ipkLalu >= 3.0) return 24;
    if (ipkLalu >= 2.5) return 21;
    if (ipkLalu >= 2.0) return 18;
    return 15;
  }
}

/// Daftar mata kuliah yang ditawarkan semester ini.
const List<MataKuliah> daftarMataKuliah = [
  MataKuliah(
    kode: 'IF501',
    nama: 'Pemrograman Mobile',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Rizky Pratama, M.Kom.',
    hari: 'Senin',
    jam: '08.00-10.30',
    ruang: 'Lab Komputer 2',
    kuota: 40,
    terisi: 31,
  ),
  MataKuliah(
    kode: 'IF502',
    nama: 'Teori Graf',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Dr. Siti Aminah, M.Si.',
    hari: 'Senin',
    jam: '13.00-15.30',
    ruang: 'R. 3.04',
    kuota: 40,
    terisi: 28,
  ),
  MataKuliah(
    kode: 'IF503',
    nama: 'Pemrograman Web Lanjut',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Fajar Hidayat, M.T.',
    hari: 'Selasa',
    jam: '08.00-10.30',
    ruang: 'Lab Komputer 1',
    kuota: 40,
    terisi: 35,
  ),
  MataKuliah(
    kode: 'IF504',
    nama: 'Rekayasa Perangkat Lunak',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Nur Laili, M.Kom.',
    hari: 'Selasa',
    jam: '13.00-15.30',
    ruang: 'R. 3.02',
    kuota: 40,
    terisi: 22,
  ),
  MataKuliah(
    kode: 'IF505',
    nama: 'Kecerdasan Buatan',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Dr. Hendra Wijaya, M.Kom.',
    hari: 'Rabu',
    jam: '08.00-10.30',
    ruang: 'R. 3.01',
    kuota: 40,
    terisi: 39,
  ),
  MataKuliah(
    kode: 'IF506',
    nama: 'Jaringan Komputer',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Bagus Setiawan, M.T.',
    hari: 'Rabu',
    jam: '13.00-15.30',
    ruang: 'Lab Jaringan',
    kuota: 35,
    terisi: 30,
  ),
  MataKuliah(
    kode: 'IF507',
    nama: 'Interaksi Manusia dan Komputer',
    sks: 3,
    jenis: JenisMk.wajib,
    dosen: 'Dewi Kartika, M.Ds.',
    hari: 'Kamis',
    jam: '08.00-10.30',
    ruang: 'R. 3.03',
    kuota: 40,
    terisi: 18,
  ),
  MataKuliah(
    kode: 'IF508',
    nama: 'Metodologi Penelitian',
    sks: 2,
    jenis: JenisMk.wajib,
    dosen: 'Dr. Muhammad Ilham, M.Pd.',
    hari: 'Kamis',
    jam: '13.00-14.40',
    ruang: 'R. 2.05',
    kuota: 45,
    terisi: 40,
  ),
  MataKuliah(
    kode: 'IF551',
    nama: 'Data Mining',
    sks: 3,
    jenis: JenisMk.pilihan,
    dosen: 'Rina Oktaviani, M.Kom.',
    hari: 'Jumat',
    jam: '08.00-10.30',
    ruang: 'Lab Komputer 3',
    kuota: 30,
    terisi: 12,
  ),
  MataKuliah(
    kode: 'IF552',
    nama: 'Keamanan Siber',
    sks: 3,
    jenis: JenisMk.pilihan,
    dosen: 'Arif Rahman, M.Kom.',
    hari: 'Jumat',
    jam: '08.00-10.30',
    ruang: 'Lab Jaringan',
    kuota: 30,
    terisi: 25,
  ),
  MataKuliah(
    kode: 'IF553',
    nama: 'Cloud Computing',
    sks: 3,
    jenis: JenisMk.pilihan,
    dosen: 'Yusuf Maulana, M.T.',
    hari: 'Jumat',
    jam: '13.30-16.00',
    ruang: 'Lab Komputer 1',
    kuota: 30,
    terisi: 30,
  ),
  MataKuliah(
    kode: 'UN501',
    nama: 'Kewirausahaan',
    sks: 2,
    jenis: JenisMk.pilihan,
    dosen: 'Lina Marlina, S.E., M.M.',
    hari: 'Sabtu',
    jam: '08.00-09.40',
    ruang: 'Aula Kampus',
    kuota: 60,
    terisi: 41,
  ),
];

/// Urutan hari untuk tab jadwal.
const List<String> urutanHari = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
];
