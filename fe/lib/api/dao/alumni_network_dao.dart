import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:alumni_network/models/post.dart';

abstract interface class AlumniNetworkDAO {

  Future<List<AlumniUser>> getAlumniUsers({int? companyId});

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId});

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId});

  Future<List<Company>> getCompanies();

  Future<List<Post>> getPosts();

  Future<List<CourseScheduleEntry>> getSchedule();

  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule({required int studentId});

  Future<void> subscribeToCourseScheduleEntry({required int studentId, required int courseScheduleEntryId});

  Future<void> unsubscribeFromCourseScheduleEntry({required int courseScheduleStudentSubscriptionId});
}