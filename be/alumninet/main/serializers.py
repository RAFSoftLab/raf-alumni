from rest_framework import serializers

from . import models

class AlumniUserSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.AlumniUser
        fields = ('__all__')


class AcademicDegreeSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.AcademicDegree
        fields = ('id', 'name', 'ects', 'level', 'level_name', 'title')


class ThesisDefenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.ThesisDefense
        fields = '__all__'


class AcademicHistorySerializer(serializers.ModelSerializer):
    academic_degree = AcademicDegreeSerializer()
    thesis = serializers.SerializerMethodField()

    class Meta:
        model = models.AcademicHistory
        fields = '__all__' 

    def get_thesis(self, obj):
        thesis = models.ThesisDefense.objects.filter(academic_history=obj).first()
        if thesis:
            return ThesisDefenseSerializer(thesis).data
        return None
    

class CompanySerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Company
        fields = ('id', 'name', 'logo', 'description', 'website', 'social_id_1', 'social_id_2')


class EmploymentHistorySerializer(serializers.ModelSerializer):
    company = CompanySerializer()

    class Meta:
        model = models.EmploymentHistory
        fields = '__all__'