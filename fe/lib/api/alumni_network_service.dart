import 'package:alumni_network/api/dao/alumni_network_dao.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:alumni_network/models/post.dart';

class AlumniNetworkService {
  AlumniNetworkService({required this.dao});

  static const String baseUrl = 'http://localhost:8080';

  final AlumniNetworkDAO dao;

  Future<List<AlumniUser>> getAlumniUsers({int? companyId}) => dao.getAlumniUsers(companyId: companyId);

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) =>
      dao.getAcademicHistory(alumniUserId: alumniUserId);

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) =>
      dao.getEmploymentHistory(alumniUserId: alumniUserId);

  Future<List<Company>> getCompanies() => dao.getCompanies();

  Future<List<Post>> getPosts() => dao.getPosts();
}
