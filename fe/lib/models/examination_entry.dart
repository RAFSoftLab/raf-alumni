import 'package:alumni_network/models/course.dart';
import 'package:equatable/equatable.dart';

class ExaminationEntry extends Equatable {

  const ExaminationEntry({
    required this.id,
    required this.time,
    required this.classroom,
    required this.professor,
    required this.date,
    required this.course,
  });

  factory ExaminationEntry.fromMap(Map<String, dynamic> map) {
    return ExaminationEntry(
      id: map['id'] as int,
      time: map['time'] as String,
      classroom: map['classroom'] as String,
      professor: map['professor'] as String,
      date: DateTime.parse(map['date'] as String),
      course: Course.fromMap(map['course'] as Map<String, dynamic>),
    );
  }

  final int id;

  final String time;
  final String classroom;
  final String professor;

  final DateTime date;

  final Course course;

  @override
  List<Object?> get props => [id];
}