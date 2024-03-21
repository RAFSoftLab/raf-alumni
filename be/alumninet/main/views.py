from rest_framework_jwt.utils import jwt_encode_payload
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import permissions
from alumninet.decorators import custom_cache
from . import utils

from . import models
from . import serializers
from . import validators
from . import utils

import requests
import json
import re

class GoogleLogin(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        id_token = request.data.get('id_token')
        
        google_info = requests.get(f'https://www.googleapis.com/oauth2/v3/tokeninfo?id_token={id_token}')
        google_info.raise_for_status()

        google_data = google_info.json()
        email = google_data.get('email')
        first_name = google_data.get('given_name')
        last_name = google_data.get('family_name')
        
        user, created = models.AppUser.objects.get_or_create(email=email, defaults={'first_name': first_name, 'last_name': last_name})
        if created:
            if email.endswith('@raf.rs'):
                pattern = r"(\d+.*?)(?=@)"
                match = re.search(pattern, email)
                if match:
                    index = match.group(1)
                    models.StudentUser.objects.create(user=user, full_name=f"{first_name} {last_name}", student_number=self.convert_index_format(index))
                else:
                    models.FacultyAdministratorUser.objects.create(user=user)
            else:
                models.AlumniUser.objects.create(user=user, full_name=f"{first_name} {last_name}")
            
        payload = utils.jwt_create_payload(user)
        token = jwt_encode_payload(payload)

        return Response({"token": token})
    
    def convert_index_format(self, index):
        pattern = r"(\d+)([a-zA-Z]+)"
        match = re.match(pattern, index)
        if match:
            numbers = match.group(1)
            letters = match.group(2)
            return f"{letters.upper()}{''.join(numbers[i] for i in range(0, 2))}/{''.join(numbers[i] for i in range(2, len(numbers)))}"
        else:
            return "Invalid format"


class Me(APIView):
    
    def get(self, request):
        user = request.user
        serializer = serializers.AppUserSerializer(user)
        
        return Response(serializer.data)


class AlumniUsers(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):        
        validator = validators.GetAlumniUsersValidator(data=request.query_params)
        if not validator.is_valid():
            return Response(status=400)
        
        data = validator.validated_data
        company = data['company'] if 'company' in data else None

        alumni = models.AlumniUser.objects.all().order_by('full_name')

        if company:
            alumni = models.AlumniUser.objects.filter(employmenthistory__company_id=company).order_by('full_name').distinct()

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
    
    @custom_cache(timeout = 60 * 60 * 12, key = 'get-all-companies')    
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
        employment_history = models.EmploymentHistory.objects.filter(alumni_user=alumni_user).order_by('-start_date')
        serializer = serializers.EmploymentHistorySerializer(employment_history, many=True)

        return Response(serializer.data)
    

class Posts(APIView):
    permission_classes = [permissions.AllowAny]

    @custom_cache(timeout = 60 * 60 * 12, key = 'get-all-posts')
    def get(self, request):
        posts = models.Post.objects.all().order_by('-date_created')
        serializer = serializers.PostSerializer(posts, many=True)

        return Response(serializer.data)
    
class Courses(APIView):
    permission_classes = [permissions.AllowAny]

    @custom_cache(timeout = 60 * 60 * 12, key = 'get-all-courses')
    def get(self, request):
        courses = models.Course.objects.all().order_by('name')
        serializer = serializers.CourseSerializer(courses, many=True)

        return Response(serializer.data)
    

class CourseSchedule(APIView):
    permission_classes = [permissions.AllowAny]

    @custom_cache(timeout = 60 * 60 * 12, key = 'get-course-schedule')
    def get(self, request):
        course_schedule = models.CourseScheduleEntry.objects.all().order_by('course__name', 'type', 'day', 'start_time')
        serializer = serializers.CourseScheduleEntrySerializer(course_schedule, many=True)

        return Response(serializer.data)
    

class CourseScheduleStudentSubscriptions(APIView):

    def get(self, request):        
        subscriptions = models.CourseScheduleStudentSubscription.objects.filter(student__user=request.user)
        serializer = serializers.CourseScheduleStudentSubscriptionSerializer(subscriptions, many=True)

        return Response(serializer.data)
    
    def post(self, request):
        validator = validators.PostCourseScheduleStudentSubscriptionsValidator(data=request.data)
        if not validator.is_valid():
            return Response(status=400)
        
        data = validator.validated_data
        course_schedule_entry_id = data['course_schedule_entry']
        
        student_user = models.StudentUser.objects.get(user=request.user)
        course_schedule_entry = models.CourseScheduleEntry.objects.get(id=course_schedule_entry_id)
        subscription = models.CourseScheduleStudentSubscription.objects.create(student=student_user, course_schedule_entry=course_schedule_entry)
        serializer = serializers.CourseScheduleStudentSubscriptionSerializer(subscription)

        return Response(serializer.data)
    

    def delete(self, request):
        validator = validators.DeleteCourseScheduleStudentSubscriptionsValidator(data=request.query_params)
        if not validator.is_valid():
            return Response(status=400)
        
        data = validator.validated_data
        course_schedule_subscription = data['course_schedule_student_subscription']
        models.CourseScheduleStudentSubscription.objects.get(id=course_schedule_subscription).delete()

        return Response(status=204)
    

class ExaminationPeriods(APIView):
    permission_classes = [permissions.AllowAny]

    @custom_cache(timeout = 60 * 60 * 6, key = 'get-all-examination-periods')
    def get(self, request):
        examination_periods = models.ExaminationPeriod.objects.all().filter(show=True).order_by('start_date')
        serializer = serializers.ExaminationPeriodSerializer(examination_periods, many=True)

        return Response(serializer.data)
    

class ExaminationEntries(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        validator = validators.GetExaminationEntriesValidator(data=request.query_params)
        if not validator.is_valid():
            return Response(status=400)
        
        examination_period_id = validator.validated_data['examination_period']
        
        examination_entries = models.ExaminationEntry.objects.filter(examination_period=examination_period_id).order_by('date', 'time')        
        serializer = serializers.ExaminationEntrySerializer(examination_entries, many=True)

        return Response(serializer.data)


class RafServiceWebhook(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        print(request)

        return Response('Received data via webhook')
    
class RafServiceMessageBroker(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        exchange_name = 'raf_service_exchange'
        routing_key = 'raf_service_key'
        message = {
            'course_name': 'Uvod u programiranje'
        }
        
        with utils.rabbit_connection() as channel:
            channel.basic_publish(exchange=exchange_name, routing_key=routing_key, body=json.dumps(message), mandatory=True)
        
        return Response('Sent message to RabbitMQ')