enum UserRole {
  facultyAdministrator,
  alumni,
  student,
  unknown,
}

UserRole userRoleFromJson(String? value) {
  switch (value) {
    case 'faculty_administrator':
      return UserRole.facultyAdministrator;
    case 'alumni':
      return UserRole.alumni;
    case 'student':
      return UserRole.student;
    default:
      return UserRole.unknown;
  }
}
