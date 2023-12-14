import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/students/bloc/students_page_bloc.dart';
import 'package:alumni_network/students/students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
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
      home: BlocProvider<StudentsPageBloc>(
        create: (context) => StudentsPageBloc(
          service: getService<AlumniNetworkService>(),
        )..add(StudentsPageInit()),
        child: const StudentsPage(),
      )
    );
  }
}
