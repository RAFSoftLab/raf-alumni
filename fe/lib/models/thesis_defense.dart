import 'package:equatable/equatable.dart';

class ThesisDefense extends Equatable {

  ThesisDefense({
    required this.id,
    required this.grade,
    required this.date,
    required this.thesisTitle,
    required this.abstract,
    required this.mentor,
    required this.commissionMember1,
    required this.commissionMember2,
    required this.commissionMember3,
  });

  factory ThesisDefense.fromMap(Map<String, dynamic> map) {
    return ThesisDefense(
      id: map['id'] as int,
      grade: map['grade'] as int,
      date: DateTime.parse(map['date'] as String),
      thesisTitle: map['thesis_title'] as String,
      abstract: map['abstract'] as String,
      mentor: map['mentor'] as String,
      commissionMember1: map['commission_member_1'] as String,
      commissionMember2: map['commission_member_2'] as String,
      commissionMember3: map['commission_member_3'] as String,
    );
  }

  final int id;
  final int grade;

  final DateTime date;

  final String thesisTitle;
  final String abstract;
  final String mentor;
  final String commissionMember1;
  final String commissionMember2;
  final String commissionMember3;

  @override
  List<Object?> get props => [id];
}
