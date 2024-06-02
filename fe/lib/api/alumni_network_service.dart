import 'package:alumni_network/api/dao/alumni_network_dao.dart';
import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:alumni_network/models/examination_entry.dart';
import 'package:alumni_network/models/examination_period.dart';
import 'package:alumni_network/models/post.dart';
import 'package:alumni_network/models/user.dart';

class AlumniNetworkService {
  AlumniNetworkService({required this.dao});

  static const String baseUrl = 'https://raf.code-dream.com';

  final AlumniNetworkDAO dao;

  Future<User> getUser() => dao.getUser();

  Future<String> googleSignIn({required String accessToken, required String idToken}) => dao.googleSignIn(
        accessToken: accessToken,
        idToken: idToken,
      );

  Future<List<AlumniUser>> getAlumniUsers({int? companyId}) => dao.getAlumniUsers(companyId: companyId);

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) =>
      dao.getAcademicHistory(alumniUserId: alumniUserId);

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) =>
      dao.getEmploymentHistory(alumniUserId: alumniUserId);

  Future<List<Company>> getCompanies() => dao.getCompanies();

  Future<List<Post>> getPosts() => dao.getPosts();

  Future<List<CourseScheduleEntry>> getSchedule() => dao.getSchedule();

  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule() => dao.getStudentSchedule();

  Future<void> subscribeToCourseScheduleEntry({required int courseScheduleEntryId}) =>
      dao.subscribeToCourseScheduleEntry(courseScheduleEntryId: courseScheduleEntryId);

  Future<void> unsubscribeFromCourseScheduleEntry({required int courseScheduleStudentSubscriptionId}) =>
      dao.unsubscribeFromCourseScheduleEntry(
        courseScheduleStudentSubscriptionId: courseScheduleStudentSubscriptionId,
      );

  Future<List<ExaminationPeriod>> getExaminationPeriods() => dao.getExaminationPeriods();

  Future<List<ExaminationEntry>> getExaminationEntries({required int examinationPeriodId}) =>
      dao.getExaminationEntries(examinationPeriodId: examinationPeriodId);
}
