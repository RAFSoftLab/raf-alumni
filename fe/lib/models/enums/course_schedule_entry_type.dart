enum CourseScheduleEntryType {
  lecture, lab
}

CourseScheduleEntryType courseScheduleEntryTypeFromString(String type) {
  switch (type) {
    case 'LEC':
      return CourseScheduleEntryType.lecture;
    case 'LAB':
      return CourseScheduleEntryType.lab;
    default:
      throw Exception('Invalid course schedule entry type: $type');
  }
}

extension CourseScheduleEntryTypeExtension on CourseScheduleEntryType {
  String get fullName {
    switch (this) {
      case CourseScheduleEntryType.lecture:
        return 'Predavanja';
      case CourseScheduleEntryType.lab:
        return 'Vežbe';
    }
  }
}
