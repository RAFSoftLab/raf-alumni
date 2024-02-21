part of 'calendar_page_bloc.dart';

abstract class CalendarPageEvent extends Equatable {
  const CalendarPageEvent();

  @override
  List<Object?> get props => [];
}

class CalendarPageInit extends CalendarPageEvent {}

class CalendarPageExaminationPeriodSelected extends CalendarPageEvent {
  const CalendarPageExaminationPeriodSelected({required this.examinationPeriod});

  final ExaminationPeriod examinationPeriod;

  @override
  List<Object?> get props => [examinationPeriod];
}
