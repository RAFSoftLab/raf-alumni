import 'package:alumni_network/models/academic_degree.dart';
import 'package:alumni_network/models/thesis_defense.dart';
import 'package:equatable/equatable.dart';

class AcademicHistory extends Equatable {
  AcademicHistory({
    required this.id,
    required this.alumniUserId,
    required this.studentNumber,
    required this.startDate,
    required this.endDate,
    required this.academicDegree,
    required this.thesisDefense,
  });

  factory AcademicHistory.fromMap(Map<String, dynamic> map) {
    return AcademicHistory(
      id: map['id'] as int,
      alumniUserId: map['alumni_user'] as int,
      studentNumber: map['student_number'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.tryParse(map['end_date'] as String? ?? ''),
      academicDegree: AcademicDegree.fromMap(map['academic_degree'] as Map<String, dynamic>),
      thesisDefense: map['thesis'] != null
          ? ThesisDefense.fromMap(
              map['thesis'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final int id;
  final int alumniUserId;

  final String studentNumber;

  final DateTime startDate;
  final DateTime? endDate;

  final AcademicDegree academicDegree;
  final ThesisDefense? thesisDefense;

  @override
  List<Object?> get props => [id];
}
