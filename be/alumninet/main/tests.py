from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from main import models
from rest_framework.test import APIClient

class CourseScheduleStudentSubscriptionsTests(APITestCase):

    def setUp(self):
        # Set up data for the tests
        self.user = models.AppUser.objects.create_user(email='testuser@test.com', password='12345')
        self.client = APIClient()
        self.client.force_authenticate(user=self.user)

        # Create test data for CourseScheduleEntry and StudentUser
        self.course_schedule_entry = models.CourseScheduleEntry.objects.create(
            course=models.Course.objects.create(name='Test Course'),
            type='lecture',
            day='monday',
            start_time='12:00',
            end_time='13:00',
            classroom='Test Location',
            professor='Test Professor',
        )
        self.student_user = models.StudentUser.objects.create(user=self.user, full_name='Test Student')

        self.url = reverse('course-schedule-student-subscriptions')

    def test_get_subscriptions(self):
        # Create a subscription
        subscription = models.CourseScheduleStudentSubscription.objects.create(student=self.student_user, course_schedule_entry=self.course_schedule_entry)

        # Make a GET request
        response = self.client.get(self.url)

        # Check that the response is 200 OK
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Check that the response contains the subscription
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['id'], subscription.id)

    def test_post_subscription(self):
        # Data to be sent in POST request
        post_data = {
            'course_schedule_entry': self.course_schedule_entry.id,
        }

        # Make a POST request
        response = self.client.post(self.url, post_data)

        # Check that the response is 200 OK and subscription is created
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(models.CourseScheduleStudentSubscription.objects.filter(student=self.student_user).exists())

    def test_delete_subscription(self):
        # Create a subscription
        subscription = models.CourseScheduleStudentSubscription.objects.create(student=self.student_user, course_schedule_entry=self.course_schedule_entry)

        # Make a DELETE request
        response = self.client.delete(f'{self.url}?course_schedule_student_subscription={subscription.id}')


        # Check that the response is 204 NO CONTENT and subscription is deleted
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(models.CourseScheduleStudentSubscription.objects.filter(id=subscription.id).exists())
