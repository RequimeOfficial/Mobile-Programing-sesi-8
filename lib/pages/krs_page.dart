import 'package:flutter/material.dart';

import '../data/data_krs.dart';
import '../models/aturan_krs.dart';
import '../models/mata_kuliah.dart';
import '../widgets/kartu_mahasiswa.dart';
import '../widgets/kartu_mata_kuliah.dart';
import 'jadwal_tab.dart';

/// Halaman utama KRS Online.
///
/// Seluruh data yang berubah karena interaksi pengguna disimpan sebagai
/// state di sini dan diperbarui dengan setState():
/// mata kuliah terpilih, kata kunci pencarian, filter, tab aktif,
/// dan status pengajuan KRS.
class KrsPage extends StatefulWidget {
  const KrsPage({super.key});

  @override
  State<KrsPage> createState() => _KrsPageState();
}

enum FilterMk { semua, wajib, pilihan, dipilih }

class _KrsPageState extends State<KrsPage> {
  final Set<String> _kodeDipilih = {};
  final TextEditingController _cariController = TextEditingController();
  String _kataKunci = '';
  FilterMk _filter = FilterMk.semua;
  int _tab = 0;
  StatusKrs _status = StatusKrs.draf;
  DateTime? _waktuAjukan;

  List<MataKuliah> get _dipilih =>
      daftarMataKuliah.where((mk) => _kodeDipilih.contains(mk.kode)).toList();

  int get _totalSks => AturanKrs.totalSks(_dipilih);

  bool get _terkunci => _status == StatusKrs.diajukan;

  List<MataKuliah> get _hasilTampil {
    final kunci = _kataKunci.trim().toLowerCase();
    return daftarMataKuliah.where((mk) {
      final cocokFilter = switch (_filter) {
        FilterMk.semua => true,
        FilterMk.wajib => mk.jenis == JenisMk.wajib,
        FilterMk.pilihan => mk.jenis == JenisMk.pilihan,
        FilterMk.dipilih => _kodeDipilih.contains(mk.kode),
      };
      final cocokCari =
          kunci.isEmpty ||
          mk.nama.toLowerCase().contains(kunci) ||
          mk.kode.toLowerCase().contains(kunci) ||
          mk.dosen.toLowerCase().contains(kunci);
      return cocokFilter && cocokCari;
    }).toList();
  }

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- aksi

  void _togglePilih(MataKuliah mk) {
    if (_terkunci) {
      _pesan(
        'KRS sudah diajukan. Batalkan pengajuan untuk mengubah.',
        Icons.lock,
      );
      return;
    }
    if (_kodeDipilih.contains(mk.kode)) {
      setState(() => _kodeDipilih.remove(mk.kode));
      _pesan('${mk.nama} dihapus dari KRS.', Icons.remove_circle_outline);
      return;
    }
    final hasil = AturanKrs.cekTambah(mk, _dipilih, Mahasiswa.batasSks);
    switch (hasil) {
      case Diterima():
        setState(() => _kodeDipilih.add(mk.kode));
        _pesan('${mk.nama} (${mk.sks} SKS) ditambahkan.', Icons.check_circle);
      case KelasPenuh():
        _pesan('Kelas ${mk.nama} sudah penuh.', Icons.block, galat: true);
      case JadwalBentrok(:final dengan):
        _pesan(
          'Jadwal bentrok dengan ${dengan.nama} (${dengan.jadwal}).',
          Icons.event_busy,
          galat: true,
        );
      case MelebihiBatasSks(:final sisa):
        _pesan(
          'Melebihi batas ${Mahasiswa.batasSks} SKS. Sisa kuota $sisa SKS.',
          Icons.warning_amber,
          galat: true,
        );
    }
  }

  void _resetPilihan() {
    if (_kodeDipilih.isEmpty || _terkunci) return;
    final cadangan = Set<String>.of(_kodeDipilih);
    setState(() => _kodeDipilih.clear());
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Semua pilihan dikosongkan.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'URUNGKAN',
            onPressed: () => setState(() => _kodeDipilih.addAll(cadangan)),
          ),
        ),
      );
  }

  Future<void> _ajukan() async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.send),
        title: const Text('Ajukan KRS?'),
        content: Text(
          'Anda akan mengajukan ${_kodeDipilih.length} mata kuliah '
          '($_totalSks SKS) ke Dosen Wali. Setelah diajukan, KRS tidak '
          'dapat diubah kecuali pengajuan dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
    if (setuju != true) return;
    setState(() {
      _status = StatusKrs.diajukan;
      _waktuAjukan = DateTime.now();
    });
    _pesan('KRS berhasil diajukan ke Dosen Wali.', Icons.verified);
  }

  void _batalkanPengajuan() {
    setState(() {
      _status = StatusKrs.draf;
      _waktuAjukan = null;
    });
    _pesan('Pengajuan dibatalkan. KRS bisa diubah kembali.', Icons.undo);
  }

  void _pesan(String teks, IconData ikon, {bool galat = false}) {
    final warna = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: galat ? warna.error : null,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(ikon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(teks)),
            ],
          ),
        ),
      );
  }

  // ---------------------------------------------------------------- tampilan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF283593),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KRS Online',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Sistem Informasi Akademik',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          if (_tab == 0)
            IconButton(
              tooltip: 'Kosongkan pilihan',
              onPressed: _kodeDipilih.isEmpty || _terkunci
                  ? null
                  : _resetPilihan,
              icon: const Icon(Icons.restart_alt),
              color: Colors.white,
              disabledColor: Colors.white38,
            ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          _tabPilih(),
          JadwalTab(dipilih: _dipilih, status: _status),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_tab == 0) _ringkasanBawah(),
          NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist),
                label: 'Isi KRS',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: _kodeDipilih.isNotEmpty,
                  label: Text('${_kodeDipilih.length}'),
                  child: const Icon(Icons.calendar_month_outlined),
                ),
                selectedIcon: const Icon(Icons.calendar_month),
                label: 'Jadwal Saya',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabPilih() {
    final hasil = _hasilTampil;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KartuMahasiswa(
                  totalSks: _totalSks,
                  batasSks: Mahasiswa.batasSks,
                ),
                if (_terkunci) ...[
                  const SizedBox(height: 12),
                  _bannerDiajukan(),
                ],
                const SizedBox(height: 14),
                TextField(
                  controller: _cariController,
                  onChanged: (v) => setState(() => _kataKunci = v),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, kode, atau dosen',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _kataKunci.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _cariController.clear();
                              setState(() => _kataKunci = '');
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final f in FilterMk.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(_labelFilter(f)),
                            selected: _filter == f,
                            onSelected: (_) => setState(() => _filter = f),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${hasil.length} mata kuliah ditampilkan',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        if (hasil.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off, size: 56, color: Colors.black26),
                    SizedBox(height: 8),
                    Text(
                      'Mata kuliah tidak ditemukan.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList.builder(
              itemCount: hasil.length,
              itemBuilder: (context, i) {
                final mk = hasil[i];
                final dipilih = _kodeDipilih.contains(mk.kode);
                final bentrok = dipilih
                    ? null
                    : _dipilih.where(mk.bentrokDengan).firstOrNull;
                return KartuMataKuliah(
                  mk: mk,
                  dipilih: dipilih,
                  terkunci: _terkunci,
                  bentrokDengan: bentrok,
                  onTap: () => _togglePilih(mk),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _bannerDiajukan() {
    final w = _waktuAjukan!;
    String dua(int n) => n.toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFB300)),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top, color: Color(0xFFFF8F00)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Menunggu persetujuan Dosen Wali\n'
              'Diajukan pukul ${dua(w.hour)}.${dua(w.minute)}',
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ringkasanBawah() {
    final kosong = _kodeDipilih.isEmpty;
    return Material(
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_totalSks / ${Mahasiswa.batasSks} SKS',
                    key: const Key('total-sks'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_kodeDipilih.length} mata kuliah dipilih',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (_terkunci)
              OutlinedButton.icon(
                onPressed: _batalkanPengajuan,
                icon: const Icon(Icons.undo),
                label: const Text('Batalkan'),
              )
            else
              FilledButton.icon(
                onPressed: kosong ? null : _ajukan,
                icon: const Icon(Icons.send),
                label: const Text('Ajukan KRS'),
              ),
          ],
        ),
      ),
    );
  }

  String _labelFilter(FilterMk f) => switch (f) {
    FilterMk.semua => 'Semua',
    FilterMk.wajib => 'Wajib',
    FilterMk.pilihan => 'Pilihan',
    FilterMk.dipilih => 'Dipilih (${_kodeDipilih.length})',
  };
}
