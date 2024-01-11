import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/enums/course_schedule_entry_type.dart';
import 'package:alumni_network/ui/schedule/bloc/schedule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseScheduleEntryListItem extends StatelessWidget {
  const CourseScheduleEntryListItem({
    required this.entry,
    required this.isSubscribed,
    required this.onChanged,
    super.key,
  });

  final CourseScheduleEntry entry;

  final bool isSubscribed;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text("${entry.course.name} - ${entry.type.fullName}"),
        subtitle: Text("${entry.classroom}, ${entry.startTime} - ${entry.endTime}"),
        trailing: Checkbox(
          value: isSubscribed,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
