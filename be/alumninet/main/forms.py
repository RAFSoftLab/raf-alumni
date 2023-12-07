from django.contrib.auth.forms import UserCreationForm, UserChangeForm

from .models import AppUser


class CustomUserCreationForm(UserCreationForm):

    class Meta:
        model = AppUser
        fields = ("email",)


class CustomUserChangeForm(UserChangeForm):

    class Meta:
        model = AppUser
        fields = ("email",)