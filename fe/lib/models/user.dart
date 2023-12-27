import 'package:equatable/equatable.dart';

class User extends Equatable {

  User({required this.id, required this.name, required this.surname, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['first_name'] as String,
      surname: map['last_name'] as String,
      email: map['email'] as String,
    );
  }

  final int id;

  final String name;
  final String surname;
  final String email;

  @override
  List<Object?> get props => [id];
}