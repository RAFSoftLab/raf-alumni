import 'package:alumni_network/students/student_profile/bloc/student_profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profil studenta'),
      ),
      body: BlocBuilder<StudentProfileBloc, StudentProfileState>(
        builder: (context, state) {
          if (state is StudentProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is StudentProfileLoaded) {
            return ListView(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person),
                      const SizedBox(width: 8),
                      Text(
                        state.alumniUser.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: state.alumniUser.profileImageUrl != null ? CachedNetworkImage(
                    imageUrl: state.alumniUser.profileImageUrl ?? '',
                    placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ) : null,
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.school),
                      const SizedBox(width: 8),
                      Text(
                        'Studije:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Card(
                    child: Column(
                      children: state.academicHistory
                          .map(
                            (e) => ListTile(
                              title: Text(e.academicDegree.levelName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Studijski program: ${e.academicDegree.title}'),
                                  Text('Zvanje: ${e.academicDegree.title}'),
                                  if (e.thesisDefense != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Divider(),
                                        Text('Tema: ${e.thesisDefense!.thesisTitle}'),
                                        Text('Odbranjen: ${e.thesisDefense!.date}'),
                                        Text('Mentor: ${e.thesisDefense!.mentor}'),
                                        Text(
                                            'Komisija: ${e.thesisDefense!.commissionMember1} ${e.thesisDefense!.commissionMember2} ${e.thesisDefense!.commissionMember3}'),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.work),
                      const SizedBox(width: 8),
                      Text(
                        'Zaposlenja:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Card(
                    child: Column(
                      children: state.employmentHistory
                          .map(
                            (e) => ListTile(
                              title: Text(e.company.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pozicija: ${e.role}'),
                                  Text('Od: ${e.startDate}'),
                                  Text('Do: ${e.endDate ?? 'Trenutno zaposlenje'}'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is StudentProfileError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
    );
  }
}
