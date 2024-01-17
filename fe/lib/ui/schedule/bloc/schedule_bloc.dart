import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({required this.service}) : super(ScheduleLoading()) {
    on<ScheduleViewStudentSchedule>((event, emit) async {
      emit(ScheduleLoading());
      try {
        final mySchedule = await service.getStudentSchedule();
        emit(ScheduleStudentEntriesLoaded(mySchedule: mySchedule));
      } catch (_) {
        print(_);
      }
    });
    on<ScheduleViewAllSchedule>((event, emit) async {
      final currState = state as ScheduleStudentEntriesLoaded;
      emit(ScheduleLoading());
      try {
        final fullSchedule = await service.getSchedule();
        emit(ScheduleAllEntriesLoaded(fullSchedule: fullSchedule, mySchedule: currState.mySchedule));
      } catch (_) {
        print(_);
      }
    });
    on<ScheduleSubscribeToCourseScheduleEntry>((event, emit) async {
      final oldState = state;
      emit(ScheduleLoading());
      try {
        await service.subscribeToCourseScheduleEntry(
          courseScheduleEntryId: event.courseScheduleEntryId,
        );
        final mySchedule = await service.getStudentSchedule();
        if (oldState is ScheduleAllEntriesLoaded) {
          emit(ScheduleAllEntriesLoaded(fullSchedule: oldState.fullSchedule, mySchedule: mySchedule));
        } else {
          emit(ScheduleStudentEntriesLoaded(mySchedule: mySchedule));
        }
      } catch (_) {
        print(_);
        emit(oldState);
      }
    });
    on<ScheduleUnsubscribeFromCourseScheduleEntry>((event, emit) async {
      final oldState = state;
      emit(ScheduleLoading());
      try {
        await service.unsubscribeFromCourseScheduleEntry(
          courseScheduleStudentSubscriptionId: event.courseScheduleStudentSubscriptionId,
        );
        final mySchedule = await service.getStudentSchedule();
        if (oldState is ScheduleAllEntriesLoaded) {
          emit(ScheduleAllEntriesLoaded(fullSchedule: oldState.fullSchedule, mySchedule: mySchedule));
        } else {
          emit(ScheduleStudentEntriesLoaded(mySchedule: mySchedule));
        }
      } catch (_) {
        print(_);
        emit(oldState);
      }
    });
  }

  final AlumniNetworkService service;
}
