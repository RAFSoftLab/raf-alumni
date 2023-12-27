from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .forms import CustomUserCreationForm, CustomUserChangeForm
from main import models


class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    model = models.AppUser
    list_display = ("email", "is_staff", "is_active", "first_name", "last_name")
    list_filter = ("email", "is_staff", "is_active",)
    fieldsets = (
        (None, {"fields": ("email", "password", "first_name", "last_name")}),
        ("Permissions", {"fields": ("is_staff", "is_active", "groups", "user_permissions")}),
    )
    add_fieldsets = (
        (None, {
            "classes": ("wide",),
            "fields": (
                "email", "password1", "password2", "is_staff",
                "is_active", "groups", "user_permissions"
            )}
        ),
    )
    search_fields = ("email",)
    ordering = ("email",)


admin.site.register(models.AppUser, CustomUserAdmin)
admin.site.register(models.FacultyAdministratorUser)
admin.site.register(models.AlumniUser)
admin.site.register(models.Company)
admin.site.register(models.EmploymentHistory)
admin.site.register(models.AcademicDegree)
admin.site.register(models.AcademicHistory)
admin.site.register(models.ThesisDefense)
admin.site.register(models.Post)
admin.site.register(models.PostComment)