part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleLoading extends ScheduleState {}

class ScheduleStudentEntriesLoaded extends ScheduleState {
  const ScheduleStudentEntriesLoaded({required this.mySchedule});

  final List<CourseScheduleStudentSubscription> mySchedule;

  @override
  List<Object> get props => [mySchedule];
}

class ScheduleAllEntriesLoaded extends ScheduleState {
  const ScheduleAllEntriesLoaded({
    required this.fullSchedule,
    required this.filteredSchedule,
    required this.mySchedule,
  });

  final List<CourseScheduleEntry> fullSchedule;
  final List<CourseScheduleEntry> filteredSchedule;
  final List<CourseScheduleStudentSubscription> mySchedule;

  @override
  List<Object> get props => [fullSchedule, filteredSchedule, mySchedule];
}
