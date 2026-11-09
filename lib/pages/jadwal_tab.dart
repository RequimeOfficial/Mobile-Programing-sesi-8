import 'package:flutter/material.dart';

import '../data/data_krs.dart';
import '../models/aturan_krs.dart';
import '../models/mata_kuliah.dart';

/// Tab "Jadwal Saya": jadwal kuliah mingguan dari mata kuliah yang dipilih.
class JadwalTab extends StatelessWidget {
  const JadwalTab({super.key, required this.dipilih, required this.status});

  final List<MataKuliah> dipilih;
  final StatusKrs status;

  @override
  Widget build(BuildContext context) {
    if (dipilih.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_note, size: 64, color: Colors.black26),
              SizedBox(height: 12),
              Text(
                'Belum ada mata kuliah dipilih.\n'
                'Centang mata kuliah pada tab Isi KRS.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    final diajukan = status == StatusKrs.diajukan;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _Ringkas(
                label: 'Mata kuliah',
                nilai: '${dipilih.length}',
                ikon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Ringkas(
                label: 'Total SKS',
                nilai: '${AturanKrs.totalSks(dipilih)}',
                ikon: Icons.timelapse,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Ringkas(
                label: 'Status',
                nilai: diajukan ? 'Diajukan' : 'Draf',
                ikon: diajukan ? Icons.hourglass_top : Icons.edit_note,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final hari in urutanHari)
          if (dipilih.any((mk) => mk.hari == hari)) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
              child: Text(
                hari,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF283593),
                ),
              ),
            ),
            for (final mk in dipilih.where((mk) => mk.hari == hari))
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: Container(
                    width: 64,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      mk.jam.replaceAll('-', '\n'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF283593),
                      ),
                    ),
                  ),
                  title: Text(
                    mk.nama,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${mk.ruang}  •  ${mk.sks} SKS\n${mk.dosen}'),
                  isThreeLine: true,
                ),
              ),
          ],
      ],
    );
  }
}

class _Ringkas extends StatelessWidget {
  const _Ringkas({
    required this.label,
    required this.nilai,
    required this.ikon,
  });

  final String label;
  final String nilai;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, size: 20, color: const Color(0xFF3949AB)),
          const SizedBox(height: 6),
          Text(
            nilai,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
