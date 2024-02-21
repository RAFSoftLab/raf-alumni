from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from .managers import CustomUserManager
from django.utils import timezone
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator

class AppUser(AbstractUser):
    username = None
    email = models.EmailField(_("email address"), unique=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []

    objects = CustomUserManager()

    def is_faculty_administrator(self):
        return hasattr(self, 'facultyadministratoruser')
    
    def is_alumni(self):
        return hasattr(self, 'alumniuser')
    
    def is_student(self):
        return hasattr(self, 'studentuser')
    
    def get_role(self):
        if self.is_faculty_administrator():
            return "faculty_administrator"
        elif self.is_alumni():
            return "alumni"
        elif self.is_student():
            return "student"
        else:
            return "unknown"

    def __str__(self):
        return self.email
    

class FacultyAdministratorUser(models.Model):
    user = models.OneToOneField(AppUser, on_delete=models.CASCADE)

    def __str__(self):
        return self.user.email


class AlumniUser(models.Model):
    user = models.OneToOneField(AppUser, on_delete=models.CASCADE, null=True, blank=True)
    full_name = models.CharField(max_length=100, blank=True)
    biography = models.TextField(blank=True)
    date_of_birth = models.DateField(blank=True, null=True)
    phone = models.CharField(max_length=20, blank=True)
    profile_picture = models.ImageField(upload_to='profile_pictures', blank=True)
    social_id_1 = models.CharField(max_length=100, blank=True)
    social_id_2 = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return self.full_name


class StudentUser(models.Model):
    user = models.OneToOneField(AppUser, on_delete=models.CASCADE, null=True, blank=True)
    full_name = models.CharField(max_length=100, blank=True)
    student_number = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return self.full_name + " - " + self.student_number


class Company(models.Model):
    employees = models.ManyToManyField(AlumniUser, through='EmploymentHistory')
    name = models.CharField(max_length=100)
    logo = models.ImageField(upload_to='company_logos', blank=True)
    description = models.TextField(blank=True)
    website = models.URLField(blank=True)
    social_id_1 = models.CharField(max_length=100, blank=True)
    social_id_2 = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return self.name
    

class EmploymentHistory(models.Model):
    alumni_user = models.ForeignKey(AlumniUser, on_delete=models.CASCADE)
    company = models.ForeignKey(Company, on_delete=models.CASCADE)
    role = models.CharField(max_length=100)
    start_date = models.DateField(blank=True, null=True)
    end_date = models.DateField(blank=True, null=True)
    description = models.TextField(blank=True)

    def __str__(self):
        return f"{self.alumni_user.full_name} - {self.company.name} - {self.role}"
    

class AcademicDegree(models.Model):
    students = models.ManyToManyField(AlumniUser, through='AcademicHistory')
    name = models.CharField(max_length=100)
    ects = models.IntegerField()
    title = models.CharField(max_length=100)
    level = models.CharField(max_length=100)
    level_name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class AcademicHistory(models.Model):
    alumni_user = models.ForeignKey(AlumniUser, on_delete=models.CASCADE)
    academic_degree = models.ForeignKey(AcademicDegree, on_delete=models.CASCADE)
    start_date = models.DateField()
    end_date = models.DateField(blank=True, null=True)
    student_number = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.alumni_user.full_name} - {self.academic_degree.name} - {self.student_number}"
    

class ThesisDefense(models.Model):
    academic_history = models.ForeignKey(AcademicHistory, on_delete=models.CASCADE)
    date = models.DateField()
    thesis_title = models.CharField(max_length=100)
    grade = models.IntegerField(validators=[MinValueValidator(5), MaxValueValidator(10)])
    abstract = models.TextField(blank=True)
    mentor = models.CharField(max_length=100)
    commission_member_1 = models.CharField(max_length=100, blank=True)
    commission_member_2 = models.CharField(max_length=100, blank=True)
    commission_member_3 = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return f"{self.thesis_title} - {self.date} - {self.grade}"
    

class Post(models.Model):
    title = models.CharField(max_length=255)
    text = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(AlumniUser, on_delete=models.CASCADE)

    def __str__(self):
        return self.title
    

class PostComment(models.Model):
    text = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(AlumniUser, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)

    def __str__(self):
        return self.text


class Course(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    
    
class CourseScheduleEntry(models.Model):
    LECTURE = "LEC"
    LAB = "LAB"
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    subscribed_students = models.ManyToManyField(StudentUser, through='CourseScheduleStudentSubscription', related_name='subscribed_courses', blank=True)
    professor = models.CharField(max_length=100)
    type = models.CharField(max_length=3, choices=[
        (LECTURE, "Lecture"),
        (LAB, "Lab")
    ])
    day = models.CharField(max_length=100)
    start_time = models.TimeField()
    end_time = models.TimeField()
    classroom = models.CharField(max_length=100)
    groups = models.CharField(max_length=100, blank=True)

    def __str__(self):
        return f"{self.course.name} - {self.day} - {self.start_time} - {self.end_time}"


class CourseScheduleStudentSubscription(models.Model):
    student = models.ForeignKey(StudentUser, on_delete=models.CASCADE)
    course_schedule_entry = models.ForeignKey(CourseScheduleEntry, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"{self.student.full_name} - {self.course_schedule_entry.course.name} - {self.course_schedule_entry.day} - {self.course_schedule_entry.start_time} - {self.course_schedule_entry.end_time}"


class ExaminationPeriod(models.Model):
    name = models.CharField(max_length=100)
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return self.name


class ExaminationEntry(models.Model):
    examination_period = models.ForeignKey(ExaminationPeriod, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    date = models.DateField()
    time = models.CharField(max_length=100)
    classroom = models.CharField(max_length=100)
    professor = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.course.name} - {self.date} - {self.time} - {self.classroom}"