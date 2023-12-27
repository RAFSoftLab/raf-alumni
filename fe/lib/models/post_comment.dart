import 'package:alumni_network/models/alumni_user.dart';
import 'package:equatable/equatable.dart';

class PostComment extends Equatable {

  PostComment({required this.id, required this.text, required this.createdAt, required this.user});

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      id: map['id'] as int,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['date_created'] as String),
      user: AlumniUser.fromMap(map['author'] as Map<String, dynamic>),
    );
  }

  final int id;

  final String text;

  final DateTime createdAt;

  final AlumniUser user;

  @override
  List<Object?> get props => [id];


}