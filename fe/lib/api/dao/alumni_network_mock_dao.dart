import 'package:alumni_network/api/dao/alumni_network_dao.dart';
import 'package:alumni_network/api/rest_client.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:alumni_network/models/post.dart';

class AlumniNetworkMockDAO implements AlumniNetworkDAO {
  AlumniNetworkMockDAO();

  @override
  Future<List<AlumniUser>> getAlumniUsers({int? companyId}) {
    // TODO: implement getAlumniUsers
    throw UnimplementedError();
  }

  @override
  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) {
    // TODO: implement getAcademicHistory
    throw UnimplementedError();
  }

  @override
  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) {
    // TODO: implement getEmploymentHistory
    throw UnimplementedError();
  }

  @override
  Future<List<Company>> getCompanies() {
    // TODO: implement getCompanies
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

  @override
  Future<List<CourseScheduleEntry>> getSchedule() {
    // TODO: implement getSchedule
    throw UnimplementedError();
  }

  @override
  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule({required int studentId}) {
    // TODO: implement getStudentSchedule
    throw UnimplementedError();
  }

  @override
  Future<void> subscribeToCourseScheduleEntry({required int studentId, required int courseScheduleEntryId}) {
    // TODO: implement subscribeToCourseScheduleEntry
    throw UnimplementedError();
  }

  @override
  Future<void> unsubscribeFromCourseScheduleEntry({required int courseScheduleStudentSubscriptionId}) {
    // TODO: implement unsubscribeFromCourseScheduleEntry
    throw UnimplementedError();
  }
}