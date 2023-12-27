part of 'student_profile_bloc.dart';

abstract class StudentProfileState extends Equatable {
  const StudentProfileState();

  @override
  List<Object> get props => [];
}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  const StudentProfileLoaded({
    required this.alumniUser,
    required this.academicHistory,
    required this.employmentHistory,
  });

  final AlumniUser alumniUser;
  final List<AcademicHistory> academicHistory;
  final List<EmploymentHistory> employmentHistory;

  @override
  List<Object> get props => [alumniUser, academicHistory, employmentHistory];
}

class StudentProfileError extends StudentProfileState {}
