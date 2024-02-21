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

abstract interface class AlumniNetworkDAO {

  Future<User> getUser();

  Future<String> googleSignIn({required String accessToken, required String idToken});

  Future<List<AlumniUser>> getAlumniUsers({int? companyId});

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId});

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId});

  Future<List<Company>> getCompanies();

  Future<List<Post>> getPosts();

  Future<List<CourseScheduleEntry>> getSchedule();

  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule();

  Future<void> subscribeToCourseScheduleEntry({required int courseScheduleEntryId});

  Future<void> unsubscribeFromCourseScheduleEntry({required int courseScheduleStudentSubscriptionId});

  Future<List<ExaminationPeriod>> getExaminationPeriods();

  Future<List<ExaminationEntry>> getExaminationEntries({required int examinationPeriodId});
}