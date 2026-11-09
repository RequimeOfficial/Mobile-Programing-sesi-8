import 'package:flutter/material.dart';

import '../models/mata_kuliah.dart';

/// Kartu satu mata kuliah. Tampilannya mengikuti state dari halaman:
/// terpilih / tidak, terkunci, bentrok, atau kelas penuh.
class KartuMataKuliah extends StatelessWidget {
  const KartuMataKuliah({
    super.key,
    required this.mk,
    required this.dipilih,
    required this.terkunci,
    required this.onTap,
    this.bentrokDengan,
  });

  final MataKuliah mk;
  final bool dipilih;
  final bool terkunci;
  final MataKuliah? bentrokDengan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final redup = !dipilih && (mk.penuh || bentrokDengan != null);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: dipilih ? const Color(0xFFE8EAF6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dipilih ? const Color(0xFF3949AB) : const Color(0xFFE0E0E0),
          width: dipilih ? 2 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Opacity(
            opacity: redup ? 0.6 : 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Lencana(
                              teks: mk.kode,
                              warna: const Color(0xFF3949AB),
                            ),
                            const SizedBox(width: 6),
                            _Lencana(
                              teks: mk.jenis == JenisMk.wajib
                                  ? 'Wajib'
                                  : 'Pilihan',
                              warna: mk.jenis == JenisMk.wajib
                                  ? const Color(0xFF00897B)
                                  : const Color(0xFF8E24AA),
                            ),
                            const SizedBox(width: 6),
                            _Lencana(
                              teks: '${mk.sks} SKS',
                              warna: const Color(0xFF546E7A),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mk.nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _Baris(ikon: Icons.person_outline, teks: mk.dosen),
                        _Baris(
                          ikon: Icons.schedule,
                          teks: '${mk.jadwal}  •  ${mk.ruang}',
                        ),
                        _Baris(
                          ikon: Icons.groups_outlined,
                          teks: mk.penuh
                              ? 'Kuota penuh (${mk.terisi}/${mk.kuota})'
                              : 'Kuota ${mk.terisi}/${mk.kuota}',
                          warna: mk.penuh ? skema.error : null,
                        ),
                        if (bentrokDengan != null)
                          _Baris(
                            ikon: Icons.event_busy,
                            teks: 'Bentrok dengan ${bentrokDengan!.nama}',
                            warna: skema.error,
                          ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: dipilih,
                    onChanged: terkunci ? null : (_) => onTap(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Lencana extends StatelessWidget {
  const _Lencana({required this.teks, required this.warna});

  final String teks;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        teks,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: warna,
        ),
      ),
    );
  }
}

class _Baris extends StatelessWidget {
  const _Baris({required this.ikon, required this.teks, this.warna});

  final IconData ikon;
  final String teks;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    final w = warna ?? Colors.black54;
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(ikon, size: 15, color: w),
          const SizedBox(width: 6),
          Expanded(
            child: Text(teks, style: TextStyle(fontSize: 12.5, color: w)),
          ),
        ],
      ),
    );
  }
}
