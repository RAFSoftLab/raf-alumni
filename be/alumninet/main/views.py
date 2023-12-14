from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions

from . import models
from . import serializers
from . import validators

class AlumniUsers(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):        
        alumni = models.AlumniUser.objects.all().order_by('full_name')
        serializer = serializers.AlumniUserSerializer(alumni, many=True)

        return Response(serializer.data)
    

class AcademicHistory(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        validator = validators.GetAcademicHistoryValidator(data=request.query_params)
        if not validator.is_valid():
            return Response(status=400)
        
        data = validator.validated_data
        alumni_user = data['alumni_user']
        academic_history = models.AcademicHistory.objects.filter(alumni_user=alumni_user)
        serializer = serializers.AcademicHistorySerializer(academic_history, many=True)

        return Response(serializer.data)
    

class Company(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        companies = models.Company.objects.all()
        serializer = serializers.CompanySerializer(companies, many=True)

        return Response(serializer.data)
    

class EmploymentHistory(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        validator = validators.GetEmploymentHistoryValidator(data=request.query_params)
        if not validator.is_valid():
            return Response(status=400)
        
        data = validator.validated_data
        alumni_user = data['alumni_user']
        employment_history = models.EmploymentHistory.objects.filter(alumni_user=alumni_user)
        serializer = serializers.EmploymentHistorySerializer(employment_history, many=True)

        return Response(serializer.data)