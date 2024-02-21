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
import 'package:dio/dio.dart';

class RestClient {
  RestClient({required this.dio});

  final Dio dio;

  Future<User> getUser() async {
    final response = await dio.get<Map<String, dynamic>>('me');

    return User.fromMap(response.data!);
  }

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

  Future<List<CourseScheduleStudentSubscription>> getStudentSchedule() async {
    final response = await dio.get<List>(
      'course-schedule-student-subscriptions',
    );

    return response.data!.map((e) => CourseScheduleStudentSubscription.fromMap(e)).toList();
  }

  Future<void> subscribeToCourseScheduleEntry({required int courseScheduleEntryId}) async {
    await dio.post(
      'course-schedule-student-subscriptions',
      data: <String, dynamic>{
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

  Future<String> googleSignIn({required String accessToken, required String idToken}) async {
    final response = await dio.post<Map<String, dynamic>>(
      'google-login',
      data: <String, dynamic>{
        'id_token': idToken,
      },
    );

    return response.data!['token'];
  }

  Future<List<ExaminationPeriod>> getExaminationPeriods() async {
    final response = await dio.get<List>('examination-periods');

    return response.data!.map((e) => ExaminationPeriod.fromMap(e)).toList();
  }

  Future<List<ExaminationEntry>> getExaminationEntries({required int examinationPeriodId}) async {
    final response = await dio.get<List>(
      'examination-entries',
      queryParameters: <String, dynamic>{
        'examination_period': examinationPeriodId,
      },
    );

    return response.data!.map((e) => ExaminationEntry.fromMap(e)).toList();
  }
}
