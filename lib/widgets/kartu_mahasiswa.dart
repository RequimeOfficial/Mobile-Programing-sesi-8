import 'package:flutter/material.dart';

import '../data/data_krs.dart';

/// Kartu identitas mahasiswa + indikator SKS yang berubah sesuai state.
class KartuMahasiswa extends StatelessWidget {
  const KartuMahasiswa({
    super.key,
    required this.totalSks,
    required this.batasSks,
  });

  final int totalSks;
  final int batasSks;

  @override
  Widget build(BuildContext context) {
    final rasio = (totalSks / batasSks).clamp(0.0, 1.0);
    final warnaBar = rasio >= 1
        ? const Color(0xFFFFB74D)
        : rasio >= 0.75
        ? const Color(0xFF81C784)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF283593), Color(0xFF5C6BC0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white24,
                child: Icon(Icons.school, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Mahasiswa.nama,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'NIM ${Mahasiswa.nim}  •  Kelas ${Mahasiswa.kelas}',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              _Info(label: 'Semester', nilai: '${Mahasiswa.semester}'),
              _Info(label: 'IPK lalu', nilai: '${Mahasiswa.ipkLalu}'),
              _Info(label: 'T.A.', nilai: Mahasiswa.tahunAkademik),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                'SKS diambil',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$totalSks dari maks. $batasSks SKS',
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Batang progres SKS dengan animasi lebar & warna.
          LayoutBuilder(
            builder: (context, c) => Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                width: c.maxWidth * rasio,
                decoration: BoxDecoration(
                  color: warnaBar,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            nilai,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
