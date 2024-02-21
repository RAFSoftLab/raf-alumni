from django.core.management.base import BaseCommand
from django.db import transaction
from main.models import ExaminationPeriod, ExaminationEntry, Course

from django.core import files
from thefuzz import fuzz
from io import BytesIO
import requests

import csv
import re
from datetime import datetime
from datetime import date
import requests

class Command(BaseCommand):

    def handle(self, *args, **options):
        
        start_date = date(2023, 11, 18)
        end_date = date(2023, 11, 26)
        examination_period = ExaminationPeriod.objects.get_or_create(name='I kolokvijumska nedelja 2023/2024', start_date=start_date, end_date=end_date)[0]
        courses = list(Course.objects.all())
        
        YEAR = 2023
        
        # Open kol_nedelja.csv file
        # Predmet;Profesor;Učionice;Vreme;Dan;Datum;;;;; ; ; ;Učionice;Vreme
        with open('kol_nedelja.csv', newline='', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile, delimiter=';', quotechar='"')
            with transaction.atomic():
                for row in reader:
                    course_name = row[0]
                    professor = row[1]
                    classroom = row[2]
                    time = row[3]
                    exam_date = row[5]
                    
                    # get or create
                    # course = Course.objects.get_or_create(name=course_name)[0]
                    course = None
                    for c in courses:
                        if fuzz.ratio(c.name, course_name) > 85:
                            print(f"Matched {c.name} with {course_name}")
                            course = c
                            break
                    
                    if course is None:
                        print(f"Course {course_name} not found")
                        continue
                    
                    entry = ExaminationEntry(
                        examination_period=examination_period,
                        course=course,
                        professor=professor,
                        date=datetime.strptime(f"{exam_date}{YEAR}", "%d.%m.%Y"),
                        time=time,
                        classroom=classroom,
                    )
                    entry.save()
