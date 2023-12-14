part of 'students_page_bloc.dart';

abstract class StudentsPageState extends Equatable {
  const StudentsPageState();

  @override
  List<Object?> get props => [];
}

class StudentsPageLoading extends StudentsPageState {}

class StudentsPageLoaded extends StudentsPageState {
  const StudentsPageLoaded({required this.students});

  final List<AlumniUser> students;

  @override
  List<Object?> get props => [students];
}

class StudentsPageError extends StudentsPageState {}
