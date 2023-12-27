import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/post_comment.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  const Post({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.user,
    required this.comments,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      title: map['title'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['date_created'] as String),
      user: AlumniUser.fromMap(map['author'] as Map<String, dynamic>),
      comments: (map['comments'] as List).cast<Map<String, dynamic>>().map<PostComment>(PostComment.fromMap).toList(),
    );
  }

  final int id;

  final String title;
  final String text;

  final DateTime createdAt;

  final AlumniUser user;

  final List<PostComment> comments;

  @override
  List<Object?> get props => [id];
}