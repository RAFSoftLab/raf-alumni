import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/ui/companies/details/bloc/company_details_bloc.dart';
import 'package:alumni_network/ui/students/student_profile/bloc/student_profile_bloc.dart';
import 'package:alumni_network/ui/students/student_profile/student_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyDetailsPage extends StatelessWidget {
  const CompanyDetailsPage({required this.company, super.key});

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(company.name),
      ),
      body: BlocBuilder<CompanyDetailsBloc, CompanyDetailsState>(
        builder: (context, state) {
          if (state is CompanyDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CompanyDetailsLoaded)
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
                    leading: CircleAvatar(
                      backgroundImage:
                          student.profileImageUrl != null ? CachedNetworkImageProvider(student.profileImageUrl!) : null,
                      child: student.profileImageUrl == null ? Icon(Icons.person) : null,
                    ),
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
