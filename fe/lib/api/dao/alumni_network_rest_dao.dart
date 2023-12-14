import 'package:alumni_network/api/dao/alumni_network_dao.dart';
import 'package:alumni_network/api/rest_client.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:dio/dio.dart';

class AlumniNetworkRestDAO implements AlumniNetworkDAO {
  AlumniNetworkRestDAO({required this.dio}) {
    client = RestClient(dio: dio);
  }

  final Dio dio;
  late final RestClient client;

  @override
  Future<List<AlumniUser>> getAlumniUsers() => client.getAlumniUsers();

  @override
  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) =>
      client.getAcademicHistory(alumniUserId: alumniUserId);

  @override
  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) =>
      client.getEmploymentHistory(alumniUserId: alumniUserId);
}
