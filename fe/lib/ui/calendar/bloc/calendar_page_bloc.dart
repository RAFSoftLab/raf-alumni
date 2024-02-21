import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/examination_entry.dart';
import 'package:alumni_network/models/examination_period.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calendar_page_event.dart';
part 'calendar_page_state.dart';

class CalendarPageBloc extends Bloc<CalendarPageEvent, CalendarPageState> {
  CalendarPageBloc({required this.service}) : super(CalendarPageLoading()) {
    on<CalendarPageInit>((event, emit) async {
      emit(CalendarPageLoading());
      try {
        final examinationPeriods = await service.getExaminationPeriods();
        final courseSubscriptions = await service.getStudentSchedule();

        emit(CalendarPageLoaded(
          examinationPeriods: examinationPeriods,
          examinationEntries: [],
          courseSubscriptions: courseSubscriptions,
          selectedExaminationPeriod: null,
        ));

        add(CalendarPageExaminationPeriodSelected(examinationPeriod: examinationPeriods.first));
      } catch (e) {}
    });
    on<CalendarPageExaminationPeriodSelected>((event, emit) async {
      final currState = state as CalendarPageLoaded;
      emit(CalendarPageLoading());
      try {
        final examinationEntries = await service.getExaminationEntries(examinationPeriodId: event.examinationPeriod.id);
        // Sort entries first by those that the student is subscribed to, then by date
        examinationEntries.sort((a, b) {
          final aSubscribed = currState.courseSubscriptions.any((sub) => sub.entry.course.id == a.course.id);
          final bSubscribed = currState.courseSubscriptions.any((sub) => sub.entry.course.id == b.course.id);
          if (aSubscribed && !bSubscribed) {
            return -1;
          } else if (!aSubscribed && bSubscribed) {
            return 1;
          } else {
            return a.date.compareTo(b.date);
          }
        });
        emit(CalendarPageLoaded(
          examinationPeriods: currState.examinationPeriods,
          examinationEntries: examinationEntries,
          courseSubscriptions: currState.courseSubscriptions,
          selectedExaminationPeriod: event.examinationPeriod,
        ));
      } catch (e) {}
    });
  }

  final AlumniNetworkService service;
}
