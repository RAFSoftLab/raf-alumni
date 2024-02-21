part of 'calendar_page_bloc.dart';

abstract class CalendarPageState extends Equatable {
  const CalendarPageState();

  @override
  List<Object?> get props => [];
}

class CalendarPageLoading extends CalendarPageState {}

class CalendarPageLoaded extends CalendarPageState {
  CalendarPageLoaded({
    required this.examinationPeriods,
    required this.examinationEntries,
    required this.courseSubscriptions,
    required this.selectedExaminationPeriod,
  });

  final List<ExaminationPeriod> examinationPeriods;
  final List<ExaminationEntry> examinationEntries;
  final List<CourseScheduleStudentSubscription> courseSubscriptions;

  final ExaminationPeriod? selectedExaminationPeriod;

  @override
  List<Object?> get props => [examinationPeriods, examinationEntries, courseSubscriptions, selectedExaminationPeriod];
}
