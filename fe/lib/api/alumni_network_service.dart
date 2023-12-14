import 'package:alumni_network/api/dao/alumni_network_dao.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/employment_history.dart';

class AlumniNetworkService {
  AlumniNetworkService({required this.dao});

  static const String baseUrl = 'http://localhost:8080';

  final AlumniNetworkDAO dao;

  Future<List<AlumniUser>> getAlumniUsers() => dao.getAlumniUsers();

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) =>
      dao.getAcademicHistory(alumniUserId: alumniUserId);

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) =>
      dao.getEmploymentHistory(alumniUserId: alumniUserId);
}
