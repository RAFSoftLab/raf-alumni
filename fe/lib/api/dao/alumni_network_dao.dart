import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/employment_history.dart';

abstract interface class AlumniNetworkDAO {

  Future<List<AlumniUser>> getAlumniUsers();

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId});

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId});
}