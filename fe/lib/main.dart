import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/ui/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting('sr', null);
  Initializer().initServices();
  runApp(const AlumniNetworkApp());
}

class AlumniNetworkApp extends StatelessWidget {
  const AlumniNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alumni Network',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      locale: const Locale('sr', 'RS'),
      home: NavigationExample(),
    );
  }
}
