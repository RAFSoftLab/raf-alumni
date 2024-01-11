import 'package:alumni_network/models/academic_history.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/course_schedule_student_subscription.dart';
import 'package:alumni_network/models/employment_history.dart';
import 'package:alumni_network/models/post.dart';
import 'package:dio/dio.dart';

class RestClient {
  RestClient({required this.dio});

  final Dio dio;

  Future<List<AlumniUser>> getAlumniUsers({int? companyId}) async {
    final queryParams = <String, dynamic>{};
    if (companyId != null) {
      queryParams['company'] = companyId;
    }
    final response = await dio.get<List>('alumni-users', queryParameters: queryParams);

    return response.data!.map((e) => AlumniUser.fromMap(e)).toList();
  }

  Future<List<AcademicHistory>> getAcademicHistory({required int alumniUserId}) async {
    final response = await dio.get<List>(
      'academic-history',
      queryParameters: <String, dynamic>{
        'alumni_user': alumniUserId,
      },
    );

    return response.data!.map((e) => AcademicHistory.fromMap(e)).toList();
  }

  Future<List<EmploymentHistory>> getEmploymentHistory({required int alumniUserId}) async {
    final response = await dio.get<List>(
      'employment-history',
      queryParameters: <String, dynamic>{
        'alumni_user': alumniUserId,
      },
    );

    return response.data!.map((e) => EmploymentHistory.fromMap(e)).toList();
  }

  Future<List<Company>> getCompanies() async {
    final response = await dio.get<List>('companies');

    return response.data!.map((e) => Company.fromMap(e)).toList();
  }

  Future<List<Post>> getPosts() async {
    final response = await dio.get<List>('posts');

    return response.data!.map((e) => Post.fromMap(e)).toList();
  }

  Future<List<CourseScheduleEntry>> getSchedule() async {
    final response = await dio.get<List>('course-schedule');

    return response.data!.map((e) => CourseScheduleEntry.fromMap(e)).toList();
  }

  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule({required int studentId}) async {
    final response = await dio.get<List>(
      'course-schedule-student-subscriptions',
      queryParameters: <String, dynamic>{
        'student_user': studentId,
      },
    );

    return response.data!.map((e) => CourseScheduleStudentSubscription.fromMap(e)).toList();
  }

  Future<void> subscribeToCourseScheduleEntry({required int studentId, required int courseScheduleEntryId}) async {
    await dio.post(
      'course-schedule-student-subscriptions',
      data: <String, dynamic>{
        'student_user': studentId,
        'course_schedule_entry': courseScheduleEntryId,
      },
    );
  }

  Future<void> unsubscribeFromCourseScheduleEntry({required int courseScheduleStudentSubscriptionId}) async {
    await dio.delete(
      'course-schedule-student-subscriptions',
      queryParameters: <String, dynamic>{
        'course_schedule_student_subscription': courseScheduleStudentSubscriptionId,
      },
    );
  }
}
