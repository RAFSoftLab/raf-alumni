import 'package:alumni_network/models/company.dart';
import 'package:equatable/equatable.dart';

class EmploymentHistory extends Equatable {

  EmploymentHistory({
    required this.id,
    required this.company,
    required this.role,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory EmploymentHistory.fromMap(Map<String, dynamic> map) {
    return EmploymentHistory(
      id: map['id'] as int,
      company: Company.fromMap(map['company'] as Map<String, dynamic>),
      role: map['role'] as String,
      description: map['description'] as String,
      startDate: DateTime.tryParse(map['start_date'] as String? ?? ''),
      endDate: DateTime.tryParse(map['end_date'] as String? ?? ''),
    );
  }

  final int id;

  final Company company;

  final String role;
  final String description;

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [id];
}
