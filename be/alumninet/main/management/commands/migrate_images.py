from django.core.management.base import BaseCommand
from django.db import transaction
from main import models

from django.core import files
from io import BytesIO
import requests

import csv
import re
from datetime import datetime
from datetime import date
import requests

class Command(BaseCommand):

    def handle(self, *args, **options):
        students = self.get_students()

        with transaction.atomic():
            for student in students:
                student = self.get_student(student['id'])
                name = student['ime']
                surname = student['prezime']
                linkedin = self.extract_linkedin_username(student['linkedin'])

                alumni_user = models.AlumniUser.objects.get(
                    full_name=f"{name} {surname}",
                    social_id_1=linkedin,
                )
                if not alumni_user or not student['slika']:
                    continue

                image_url = f"http://alumni.raf.edu.rs/images/slike/{student['slika']}"
                resp = requests.get(image_url)
                
                print('Downloading image for ' + alumni_user.full_name + ' from ' + student['slika'])
                if resp.status_code == 200:
                    fp = BytesIO()
                    fp.write(resp.content)
                    file_name = student['slika']
                    alumni_user.profile_picture.save(file_name, files.File(fp))


    def get_students(self):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/list')
        return response.json()
    
    def get_student(self, id):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/diplomac/' + str(id))
        return response.json()
    
    def extract_linkedin_username(self, url):
        if not url:
            return ""

        # Remove trailing slash if it exists
        if url.endswith('/'):
            url = url[:-1]

        # Split the URL by slashes and get the last element
        parts = url.split('/')
        if parts and len(parts) > 4 and parts[2] == 'www.linkedin.com' and parts[3] == 'in':
            return parts[4]
        else:
            return ""