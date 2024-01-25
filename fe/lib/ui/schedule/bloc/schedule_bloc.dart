import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/enums/course_schedule_entry_type.dart';
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
        emit(
          ScheduleAllEntriesLoaded(
            fullSchedule: fullSchedule,
            filteredSchedule: fullSchedule,
            mySchedule: currState.mySchedule,
          ),
        );
      } catch (_) {
        print(_);
      }
    });
    on<ScheduleSubscribeToCourseScheduleEntry>((event, emit) async {
      final oldState = state;
      try {
        await service.subscribeToCourseScheduleEntry(
          courseScheduleEntryId: event.courseScheduleEntryId,
        );
        final mySchedule = await service.getStudentSchedule();
        if (oldState is ScheduleAllEntriesLoaded) {
          emit(
            ScheduleAllEntriesLoaded(
              fullSchedule: oldState.fullSchedule,
              filteredSchedule: oldState.filteredSchedule,
              mySchedule: mySchedule,
            ),
          );
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
      try {
        await service.unsubscribeFromCourseScheduleEntry(
          courseScheduleStudentSubscriptionId: event.courseScheduleStudentSubscriptionId,
        );
        final mySchedule = await service.getStudentSchedule();
        if (oldState is ScheduleAllEntriesLoaded) {
          emit(
            ScheduleAllEntriesLoaded(
              fullSchedule: oldState.fullSchedule,
              filteredSchedule: oldState.filteredSchedule,
              mySchedule: mySchedule,
            ),
          );
        } else {
          emit(ScheduleStudentEntriesLoaded(mySchedule: mySchedule));
        }
      } catch (_) {
        print(_);
        emit(oldState);
      }
    });
    on<ScheduleSearch>((event, emit) async {
      final oldState = state;
      if (oldState is ScheduleAllEntriesLoaded) {
        final allEntries = List<CourseScheduleEntry>.from(oldState.fullSchedule);
        if (event.query.trim().isEmpty) {
          emit(
            ScheduleAllEntriesLoaded(
              fullSchedule: oldState.fullSchedule,
              filteredSchedule: oldState.fullSchedule,
              mySchedule: oldState.mySchedule,
            ),
          );
          return;
        }
        final filteredEntries = allEntries.where((element) {
          final courseName = element.course.name.toLowerCase();
          final courseType = element.type.fullName.toLowerCase();
          final classroom = element.classroom.toLowerCase();
          final day = _dayToString(element.day).toLowerCase();
          final queryKeywords = event.query.toLowerCase().split(' ');

          return queryKeywords.every((keyword) =>
          courseName.contains(keyword) ||
              courseType.contains(keyword) ||
              classroom.contains(keyword) ||
              day.contains(keyword)
          );
        }).toList();

        emit(
          ScheduleAllEntriesLoaded(
            fullSchedule: oldState.fullSchedule,
            filteredSchedule: filteredEntries,
            mySchedule: oldState.mySchedule,
          ),
        );
      }
    });
  }

  final AlumniNetworkService service;

  String _dayToString(String day) {
    switch (day) {
      case 'PON':
        return 'Ponedeljak';
      case 'UTO':
        return 'Utorak';
      case 'SRE':
        return 'Sreda';
      case 'ČET':
        return 'Četvrtak';
      case 'PET':
        return 'Petak';
      case 'SUB':
        return 'Subota';
      case 'NED':
        return 'Nedelja';
      default:
        return '';
    }
  }
}
