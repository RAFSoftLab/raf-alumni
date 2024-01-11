import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:equatable/equatable.dart';

class CourseScheduleStudentSubscription extends Equatable {

  CourseScheduleStudentSubscription({required this.id, required this.entry});

  factory CourseScheduleStudentSubscription.fromMap(Map<String, dynamic> map) {
    return CourseScheduleStudentSubscription(
      id: map['id'] as int,
      entry: CourseScheduleEntry.fromMap(map['course_schedule_entry'] as Map<String, dynamic>),
    );
  }

  final int id;

  final CourseScheduleEntry entry;

  @override
  List<Object?> get props => [id];
}