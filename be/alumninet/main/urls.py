from django.urls import path
from . import views

urlpatterns = [
    path('alumni-users', views.AlumniUsers.as_view()),
    path('academic-history', views.AcademicHistory.as_view()),
    path('companies', views.Company.as_view()),
    path('employment-history', views.EmploymentHistory.as_view()),
]