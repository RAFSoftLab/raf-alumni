import 'package:equatable/equatable.dart';

class Company extends Equatable {

  Company({required this.id, required this.name});

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  final int id;

  final String name;

  @override
  List<Object?> get props => [id];
}