import 'package:alumni_network/ui/schedule/bloc/schedule_bloc.dart';
import 'package:alumni_network/ui/schedule/ui/course_schedule_entry_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ScheduleStudentEntriesLoaded)
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Icon(Icons.calendar_month),
                  title: Text('Moj raspored'),
                  subtitle: Text('Današnji dan: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.'),
                  trailing: InkWell(
                    onTap: () => context.read<ScheduleBloc>().add(ScheduleViewAllSchedule()),
                    child: Text(
                      'CEO\nRASPORED',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  indent: 24,
                  endIndent: 24,
                ),
                Expanded(
                  child: state.mySchedule.isNotEmpty ? ListView.builder(
                    itemCount: state.mySchedule.length,
                    itemBuilder: (context, index) {
                      final entry = state.mySchedule[index].entry;
                      return CourseScheduleEntryListItem(
                        key: ValueKey(entry.id),
                        entry: entry,
                        isSubscribed: true,
                        onChanged: (_) {
                          context.read<ScheduleBloc>().add(ScheduleUnsubscribeFromCourseScheduleEntry(
                                courseScheduleStudentSubscriptionId: state.mySchedule[index].id,
                              ));
                        },
                      );
                    },
                  ) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 48,),
                      const SizedBox(height: 16),
                      Text('Nema odabranih predavanja'),
                    ],
                  )
                ),
              ],
            );
          if (state is ScheduleAllEntriesLoaded)
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: InkWell(
                    onTap: () => context.read<ScheduleBloc>().add(ScheduleViewStudentSchedule()),
                    child: Icon(Icons.arrow_back),
                  ),
                  title: Text('Ceo raspored'),
                ),
                const Divider(
                  height: 0,
                  indent: 24,
                  endIndent: 24,
                ),
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Pretraži raspored',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<ScheduleBloc>().add(ScheduleSearch(value));
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredSchedule.length,
                    itemBuilder: (context, index) {
                      final entry = state.filteredSchedule[index];
                      final isSubscribed = state.mySchedule.any((element) => entry == element.entry);
                      return CourseScheduleEntryListItem(
                        key: ValueKey(entry.id),
                        entry: entry,
                        isSubscribed: isSubscribed,
                        showCheckbox: true,
                        onChanged: (_) {
                          if (isSubscribed) {
                            context.read<ScheduleBloc>().add(ScheduleUnsubscribeFromCourseScheduleEntry(
                                  courseScheduleStudentSubscriptionId:
                                      state.mySchedule.firstWhere((element) => entry == element.entry).id,
                                ));
                          } else {
                            context.read<ScheduleBloc>().add(ScheduleSubscribeToCourseScheduleEntry(
                                  courseScheduleEntryId: entry.id,
                                ));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );

          return const Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}
