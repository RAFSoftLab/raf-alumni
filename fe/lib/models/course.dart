import 'package:equatable/equatable.dart';

class Course extends Equatable {

  Course({required this.id, required this.name});

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  final int id;

  final String name;

  @override
  List<Object?> get props => [id];
}