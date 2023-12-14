import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/students/bloc/students_page_bloc.dart';
import 'package:alumni_network/students/student_profile/bloc/student_profile_bloc.dart';
import 'package:alumni_network/students/student_profile/student_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Alumni Mreža'),
      ),
      body: BlocBuilder<StudentsPageBloc, StudentsPageState>(
        builder: (context, state) {
          if (state is StudentsPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is StudentsPageLoaded)
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<StudentProfileBloc>(
                          create: (context) => StudentProfileBloc(
                            alumniUserId: student.id,
                            service: getService<AlumniNetworkService>(),
                          )..add(StudentProfileInit(alumniUser: student)),
                          child: const StudentProfilePage(),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(student.fullName),
                  ),
                );
              },
            );

          return const Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}
