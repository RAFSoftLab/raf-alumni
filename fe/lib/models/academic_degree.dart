import 'package:equatable/equatable.dart';

class AcademicDegree extends Equatable {

  AcademicDegree({
    required this.id,
    required this.ects,
    required this.name,
    required this.title,
    required this.level,
    required this.levelName,
  });

  factory AcademicDegree.fromMap(Map<String, dynamic> map) {
    return AcademicDegree(
      id: map['id'] as int,
      ects: map['ects'] as int,
      name: map['name'] as String,
      title: map['title'] as String,
      level: map['level'] as String,
      levelName: map['level_name'] as String,
    );
  }

  final int id;

  final int ects;
  final String name;
  final String title;
  final String level;

  final String levelName;

  @override
  List<Object?> get props => [id];
}
