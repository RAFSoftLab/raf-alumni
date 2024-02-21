import 'package:equatable/equatable.dart';

class ExaminationPeriod extends Equatable {
  const ExaminationPeriod({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory ExaminationPeriod.fromMap(Map<String, dynamic> map) {
    return ExaminationPeriod(
      id: map['id'] as int,
      name: map['name'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
    );
  }

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object> get props => [id];


}
