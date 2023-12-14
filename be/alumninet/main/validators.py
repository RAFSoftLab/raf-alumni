from rest_framework import serializers

class GetAcademicHistoryValidator(serializers.Serializer):
    alumni_user = serializers.IntegerField(required=True)

class GetEmploymentHistoryValidator(serializers.Serializer):
    alumni_user = serializers.IntegerField(required=True)