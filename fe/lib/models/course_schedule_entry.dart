import 'package:alumni_network/models/course.dart';
import 'package:alumni_network/models/enums/course_schedule_entry_type.dart';
import 'package:equatable/equatable.dart';

class CourseScheduleEntry extends Equatable {

  CourseScheduleEntry({
    required this.id,
    required this.professor,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.classroom,
    required this.groups,
    required this.type,
    required this.course,
  });

  factory CourseScheduleEntry.fromMap(Map<String, dynamic> map) {
    return CourseScheduleEntry(
      id: map['id'] as int,
      professor: map['professor'] as String? ?? '',
      day: map['day'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      classroom: map['classroom'] as String,
      groups: map['groups'] as String,
      type: courseScheduleEntryTypeFromString(map['type'] as String),
      course: Course.fromMap(map['course'] as Map<String, dynamic>),
    );
  }

  final int id;

  final String professor;
  final String day;
  final String startTime;
  final String endTime;
  final String classroom;
  final String groups;

  final CourseScheduleEntryType type;
  final Course course;

  @override
  List<Object?> get props => [id];
}
