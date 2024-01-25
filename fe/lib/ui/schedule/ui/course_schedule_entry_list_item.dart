import 'package:alumni_network/models/course_schedule_entry.dart';
import 'package:alumni_network/models/enums/course_schedule_entry_type.dart';
import 'package:flutter/material.dart';

class CourseScheduleEntryListItem extends StatelessWidget {
  const CourseScheduleEntryListItem({
    required this.entry,
    required this.isSubscribed,
    required this.onChanged,
    this.showCheckbox = false,
    super.key,
  });

  final CourseScheduleEntry entry;

  final bool isSubscribed;
  final bool showCheckbox;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text("${entry.course.name} - ${entry.type.fullName}"),
        subtitle: Text(
          "${_dayToString(entry.day)} ${_timeToString(entry.startTime)} - ${_timeToString(entry.endTime)}, ${entry.classroom}",
        ),
        trailing: isSubscribed && !showCheckbox ? PopupMenuButton<int>(
          onSelected: (value) {
            onChanged(null);
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 1,
              child: Text('Obriši'),
            ),
          ],
          child: Icon(Icons.more_vert),
        ) : Checkbox(
          value: isSubscribed,
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _dayToString(String day) {
    switch (day) {
      case 'PON':
        return 'Ponedeljak';
      case 'UTO':
        return 'Utorak';
      case 'SRE':
        return 'Sreda';
      case 'ČET':
        return 'Četvrtak';
      case 'PET':
        return 'Petak';
      case 'SUB':
        return 'Subota';
      case 'NED':
        return 'Nedelja';
      default:
        return '';
    }
  }

  String _timeToString(String time) {
    return time.substring(0, 5);
  }
}
