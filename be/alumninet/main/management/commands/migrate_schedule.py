from django.core.management.base import BaseCommand
from django.db import transaction
from main.models import Course, CourseScheduleEntry

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
        
        # Open raspored.csv file
        with open('raspored.csv', newline='', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile, delimiter=',', quotechar='"')
            with transaction.atomic():
                for row in reader:
                    course_name = row[0]
                    course_type = row[1]
                    professor = row[2]
                    groups = row[3]
                    day = row[4].strip()
                    time = row[5]
                    classroom = row[6]
                    
                    # get or create
                    course = Course.objects.get_or_create(name=course_name)[0]
                    start_time, end_time = self.parse_time_range(time)
                    
                    course_type = None
                    if course_type == 'P':
                        course_type = CourseScheduleEntry.LECTURE
                    elif course_type == 'V':
                        course_type = CourseScheduleEntry.LAB
                    else:
                        entry = CourseScheduleEntry(
                            course=course,
                            professor=professor,
                            type=CourseScheduleEntry.LECTURE,
                            day=day,
                            classroom=classroom,
                            groups=groups,
                            start_time=start_time,
                            end_time=end_time,
                        )
                        entry.save()
                        entry = CourseScheduleEntry(
                            course=course,
                            professor=professor,
                            type=CourseScheduleEntry.LAB,
                            day=day,
                            classroom=classroom,
                            groups=groups,
                            start_time=start_time,
                            end_time=end_time,
                        )
                        entry.save()
                        continue
                    
                    entry = CourseScheduleEntry(
                        course=course,
                        professor=professor,
                        type=course_type,
                        day=day,
                        classroom=classroom,
                        groups=groups,
                        start_time=start_time,
                        end_time=end_time,
                    )
                    entry.save()


    def parse_time_range(self, time_range):
        # Split the string into start and end times
        start_str, end_str = time_range.split('-')

        # Add ":00" to the end time if it doesn't have minutes
        if len(end_str) <= 2:
            end_str += ":00"

        # Convert the start and end strings to time objects
        time_format = "%H:%M"
        start_time = datetime.strptime(start_str, time_format).time()
        end_time = datetime.strptime(end_str, time_format).time()

        return start_time, end_time