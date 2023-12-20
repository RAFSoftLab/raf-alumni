from django.core.management.base import BaseCommand
from django.db import transaction
from main import models

import csv
import re
from datetime import datetime
from datetime import date
import requests

class Command(BaseCommand):

    def handle(self, *args, **options):
        companies = requests.get('http://alumni.raf.edu.rs/rs/api/kompanije').json()
        students = self.get_students()
        study_programs = self.get_study_programs()

        with transaction.atomic():
            for student in students:
                id = student['id']
                student = self.get_student(id)
                name = student['ime']
                surname = student['prezime']
                biography = student['biografija'] or ''
                linkedin = self.extract_linkedin_username(student['linkedin'])
                
                alumni_student, created = models.AlumniUser.objects.update_or_create(
                    full_name=name + " " + surname,
                    biography=biography,
                    social_id_1=linkedin,
                )

                if created:
                    studies = []
                    if student['studije']['osnovne']:
                        studies.append(student['studije']['osnovne'])
                    if student['studije']['master']:
                        studies.append(student['studije']['master'])
                    if student['studije']['doktorske']:
                        studies.append(student['studije']['doktorske'])

                    for study in studies:
                        study_program_id = study['studijski_program_id']
                        study_program = next((item for item in study_programs if item["id"] == study_program_id), None)
                        if not study_program:
                            print(f"Study program with id {study_program_id} not found")
                            continue
                        
                        study_program = self.create_study_program(study_program, study['steceno_zvanje'])
                        enrollment_year = int(study['generacija_id'])
                        enrollment_date = date(enrollment_year, 1, 1)
                        end_date = datetime.strptime(study['datum_diplomiranja'], "%Y-%m-%d").date()

                        academic_history, _ = models.AcademicHistory.objects.update_or_create(
                            alumni_user=alumni_student,
                            academic_degree=study_program,
                            start_date=enrollment_date,
                            end_date=end_date,
                            student_number=study['broj_indeksa'] or '',
                        )

                        if not study['tema_rada']:
                            continue

                        thesis_title = study['tema_rada']
                        thesis_date = datetime.strptime(study['datum_diplomiranja'], "%Y-%m-%d").date()
                        grade = 10
                        mentor = study['mentor']
                        comission = study['komisija'].split(', ') if study['komisija'] else []
                        get_value = lambda lst, idx: lst[idx] if 0 <= idx < len(lst) else None

                        comission_member_1 = get_value(comission, 0) or ''
                        comission_member_2 = get_value(comission, 1) or ''
                        comission_member_3 = get_value(comission, 2) or ''
                        thesis_defense, _ = models.ThesisDefense.objects.update_or_create(
                            academic_history=academic_history,
                            date=thesis_date,
                            thesis_title=thesis_title,
                            grade=grade,
                            mentor=mentor,
                            commission_member_1=comission_member_1,
                            commission_member_2=comission_member_2,
                            commission_member_3=comission_member_3,
                        )
                    
                    work_experiences = student['zaposlenja']
                    for work_experience in work_experiences:
                        company_data = self.get_company(companies, work_experience['kompanija_id'])
                        company = self.create_company(company_data)
                        role = work_experience['radno_mesto'] or ''
                        print(work_experience)
                        start_date = self.convert_cyrillic_date_to_datetime(work_experience['pocetak'])

                        # print(work_experience['pocetak'])
                        # print(start_date)
                        end_date = self.convert_cyrillic_date_to_datetime(work_experience['kraj'])

                        employment_history, _ = models.EmploymentHistory.objects.update_or_create(
                            alumni_user=alumni_student,
                            company=company,
                            role=role,
                            start_date=start_date,
                            end_date=end_date,
                        )





    def get_students(self):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/list')
        return response.json()
    
    def get_student(self, id):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/diplomac/' + str(id))
        return response.json()
    
    def get_study_programs(self):
        response = requests.get('http://alumni.raf.edu.rs/rs/api/smerovi')
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
        
    def create_study_program(self, study_program, title):
        name = study_program['naziv']
        level_id = study_program['nivo_studija_id']
        level = self.get_study_level(level_id)
        level_name = self.get_study_level_name(level_id)
        ects = self.get_study_ects(level_id)
        study_program, _ = models.AcademicDegree.objects.update_or_create(
            name=name,
            ects=ects,
            title=title,
            level=level,
            level_name=level_name,
        )
        return study_program
    
    def get_study_level(self, level):
        if level == '108':
            return 1
        elif level == '109':
            return 1
        elif level == '110':
            return 2
        elif level == '229':
            return 2
        elif level == '210':
            return 3
        
    def get_study_level_name(self, level):
        if level == '108':
            return 'Основне струковне студије'
        elif level == '109':
            return 'Основне академске студије'
        elif level == '110':
            return 'Мастер акадмеске студије'
        elif level == '229':
            return 'Магистарске студије'
        elif level == '210':
            return 'Докторске акадмеске студије'
        
    def get_study_ects(self, level):
        print('Called get_study_ects with level ' + str(level) + '.')
        if level == '108':
            return 180
        elif level == '109':
            return 240
        elif level == '110':
            return 60
        elif level == '229':
            return 60
        elif level == '210':
            return 180
        
        print(f"Unknown study level {level}")
        
    
    def get_company(self, companies, id):
        company = next((item for item in companies if item["id"] == id), None)
        return company

    def create_company(self, company):
        name = company['naziv']
        company, _ = models.Company.objects.update_or_create(
            name=name,
        )
        return company

    def convert_cyrillic_date_to_datetime(self, date_string):
        capitalize_first = lambda s: s[0].upper() + s[1:] if s else ''
        date_string = capitalize_first(date_string)
        # Create a dictionary mapping Cyrillic month names to numbers
        months = {
            'Јан': 1, 'Феб': 2, 'Мар': 3, 'Апр': 4, 'Мај': 5, 'Јун': 6, 'Агв': 8,
            'Јул': 7, 'Авг': 8, 'Сеп': 9, 'Окт': 10, 'Нов': 11, 'Дец': 12,
            'Март': 3,  'Avgust': 8, 'Septembar': 9, 'Oktobar': 10, 'Novembar': 11, 'Decembar': 12,
            'Januar': 1, 'Februar': 2, 'Mart': 3, 'April': 4, 'Maj': 5, 'Jun': 6, 'Jul': 7, 'Okt': 10, 'Nov': 11, 'Dec': 12,
            'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'Jun': 6, 'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
            'Јануар': 1, 'Фебруар': 2, 'Март': 3, 'Април': 4, 'Мај': 5, 'Јун': 6,
            'Јул': 7, 'Август': 8, 'Септембар': 9, 'Октобар': 10, 'Новембар': 11, 'Децембар': 12, 'Децембар': 12,
            'Јуни': 6, 'Јули': 7, 'Окотобар': 10, 'Октобра': 10, 'May': 5,  'Маy': 5, 'Јулy': 7, 'Новебар': 11, 'Агвуст': 8,
            'Јуниi': 6, 'Аугуст': 8, 'Марцх': 8, 'Јуне': 6, 'Juni': 6, 'Juli': 7, 'Фебрура': 2, 'Септебар': 9,
        }
        
        # Split the input string into words
        parts = date_string.split()
        parts = parts[:2]
        print(parts)
        if len(parts) == 0:
            print(f"Lenght of parts is 0 for {date_string}")
            return None

        if len(parts) == 1:
            if parts[0] == 'Јануар2016':
                return date(2016, 1, 1)
            if parts[0] == 'Август2015':
                return date(2015, 8, 1)
            if parts[0] == 'Јануар':
                return None
            
            print(f"!!! Converted {date_string} to {date_string}-1-1")
            date_string = re.sub(r'\D', '', date_string)
            return date(int(date_string), 1, 1)
        
        if len(parts) != 2:
            raise Exception(f"Invalid date string {date_string}")
        
        if 'Тренутно' in parts or 'Година' in parts:
            return None
        
        # Extract the month and year from the parts
        month_name, year = parts
        year = re.sub(r'\D', '', year)
        month = months.get(month_name)
        if not month or not year.isdigit():
            print('Month name: ' + month_name)
            print('Year: ' + year)
            raise Exception(f"Invalid date string {date_string}")
        
        year = int(year)
        if year == 20152019:
            year = 2019
        if year == 20219:
            year = 2019
        
        # Return the corresponding datetime.date object
        return date(int(year), month, 1)
