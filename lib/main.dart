import 'package:flutter/material.dart';
import 'package:capture_costs_for_household/components/menu_page.dart';
import 'package:capture_costs_for_household/components/notizen.dart';
import 'package:capture_costs_for_household/pages/start_page.dart';

void main() async {
  runApp(const CaptureCostsApp());
}

class CaptureCostsApp extends StatelessWidget {
  const CaptureCostsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartPage(),
      routes: {
        '/startpage': (context) => const StartPage(),
        '/menuepage': (context) => const Menupage(),
        '/notizen': (context) => const NotizenSeite(),
      },
    );
  }
}
