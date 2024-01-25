part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class ScheduleViewStudentSchedule extends ScheduleEvent {}

class ScheduleViewAllSchedule extends ScheduleEvent {}

class ScheduleSubscribeToCourseScheduleEntry extends ScheduleEvent {
  const ScheduleSubscribeToCourseScheduleEntry({required this.courseScheduleEntryId});

  final int courseScheduleEntryId;

  @override
  List<Object?> get props => [courseScheduleEntryId];
}

class ScheduleUnsubscribeFromCourseScheduleEntry extends ScheduleEvent {
  const ScheduleUnsubscribeFromCourseScheduleEntry({required this.courseScheduleStudentSubscriptionId});

  final int courseScheduleStudentSubscriptionId;

  @override
  List<Object?> get props => [courseScheduleStudentSubscriptionId];
}

class ScheduleSearch extends ScheduleEvent {
  const ScheduleSearch(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
