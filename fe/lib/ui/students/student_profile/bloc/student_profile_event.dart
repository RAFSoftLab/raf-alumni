part of 'student_profile_bloc.dart';

abstract class StudentProfileEvent extends Equatable {
  const StudentProfileEvent();

  @override
  List<Object?> get props => [];
}

class StudentProfileInit extends StudentProfileEvent {

  StudentProfileInit({this.alumniUser});

  final AlumniUser? alumniUser;

  @override
  List<Object?> get props => [alumniUser];
}
