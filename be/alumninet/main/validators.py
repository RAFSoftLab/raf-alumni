from rest_framework import serializers

class GetAlumniUsersValidator(serializers.Serializer):
    company = serializers.IntegerField(required=False)

class GetAcademicHistoryValidator(serializers.Serializer):
    alumni_user = serializers.IntegerField(required=True)

class GetEmploymentHistoryValidator(serializers.Serializer):
    alumni_user = serializers.IntegerField(required=True)
    
class PostCourseScheduleStudentSubscriptionsValidator(serializers.Serializer):
    course_schedule_entry = serializers.IntegerField(required=True)
    
class DeleteCourseScheduleStudentSubscriptionsValidator(serializers.Serializer):
    course_schedule_student_subscription = serializers.IntegerField(required=True)