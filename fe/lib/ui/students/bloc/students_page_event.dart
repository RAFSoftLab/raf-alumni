part of 'students_page_bloc.dart';

abstract class StudentsPageEvent extends Equatable {
  const StudentsPageEvent();

  @override
  List<Object?> get props => [];
}

class StudentsPageInit extends StudentsPageEvent {}
