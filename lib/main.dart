import 'package:flutter/material.dart';

import 'pages/krs_page.dart';

void main() {
  runApp(const KrsApp());
}

class KrsApp extends StatelessWidget {
  const KrsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KRS Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF283593)),
        scaffoldBackgroundColor: const Color(0xFFF5F6FB),
      ),
      home: const KrsPage(),
    );
  }
}
