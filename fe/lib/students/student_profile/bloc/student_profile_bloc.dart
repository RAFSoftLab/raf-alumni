import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_profile_event.dart';

part 'student_profile_state.dart';

class StudentProfileBloc extends Bloc<StudentProfileEvent, StudentProfileState> {
  StudentProfileBloc({required this.alumniUserId, required this.service}) : super(StudentProfileLoading()) {
    on<StudentProfileInit>((event, emit) async {
      emit(StudentProfileLoading());
      try {
        final alumniUser = event.alumniUser!;
        final academicHistory = await service.getAcademicHistory(alumniUserId: alumniUserId);
        final employmentHistory = await service.getEmploymentHistory(alumniUserId: alumniUserId);
        emit(
          StudentProfileLoaded(
            alumniUser: alumniUser,
            academicHistory: academicHistory,
            employmentHistory: employmentHistory,
          ),
        );
      } catch (e) {
        emit(StudentProfileError());
      }
    });
  }

  final AlumniNetworkService service;
  final int alumniUserId;
}
