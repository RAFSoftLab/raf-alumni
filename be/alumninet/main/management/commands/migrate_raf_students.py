from django.core.management.base import BaseCommand
from django.db import transaction
from main import models

import csv
import requests

class Command(BaseCommand):

    def handle(self, *args, **options):
        students = self.get_students()
        with transaction.atomic():
            for student in students:
                id = student['id']
                student = self.get_student(id)
                name = student['ime']
                surname = student['prezime']
                image_url = f"http://alumni.raf.edu.rs/images/slike/{student['slika']}"
                
                student_draft, created = models.AlumniStudentDraft.objects.update_or_create(
                    ext_id=id,
                    first_name=name,
                    last_name=surname,
                    image_url=image_url,
                )
                student_draft.save()


    def get_students(self):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/list')
        return response.json()
    
    def get_student(self, id):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/diplomac/' + str(id))
        return response.json()
