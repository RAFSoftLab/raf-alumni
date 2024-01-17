import 'package:alumni_network/models/enums/user_role.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {

  User({required this.id, required this.name, required this.surname, required this.email, required this.role});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['first_name'] as String,
      surname: map['last_name'] as String,
      email: map['email'] as String,
      role: userRoleFromJson(map['role'] as String),
    );
  }

  final int id;

  final String name;
  final String surname;
  final String email;

  final UserRole role;

  @override
  List<Object?> get props => [id];
}