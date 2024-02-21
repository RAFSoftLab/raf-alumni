import 'package:alumni_network/ui/calendar/bloc/calendar_page_bloc.dart';
import 'package:alumni_network/ui/calendar/pdf_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<CalendarPageBloc, CalendarPageState>(
      builder: (context, state) {
        if (state is CalendarPageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CalendarPageLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: IconButton(
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      onPressed: () async {
                        final byteData = await rootBundle.load('assets/kalendar.pdf');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PdfViewPage(
                              data: byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButton(
                      alignment: Alignment.center,
                      elevation: 0,
                      hint: const Text('Izaberite ispitni rok'),
                      value: state.selectedExaminationPeriod,
                      items: state.examinationPeriods
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                              alignment: Alignment.center,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context.read<CalendarPageBloc>().add(
                              CalendarPageExaminationPeriodSelected(examinationPeriod: value!),
                            );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              const Divider(height: 0,),
              Expanded(
                child: ListView.builder(
                  itemCount: state.examinationEntries.length,
                  itemBuilder: (context, index) {
                    final entry = state.examinationEntries[index];
                    final isSubscribed = state.courseSubscriptions.any(
                      (element) => element.entry.course.id == entry.course.id,
                    );
                    return Card(
                      color: isSubscribed ? Colors.green[100] : null,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Icon(isSubscribed ? Icons.notification_important : Icons.calendar_today),
                        title: Text(
                            '${entry.course.name}, ${_dayToString(entry.date)} ${DateFormat('dd.MM.').format(entry.date)}'),
                        subtitle:
                            Text('Prof. ${entry.professor} - Učionice: ${entry.classroom}  - Vreme: ${entry.time}h'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const Center(
          child: Text('Error'),
        );
      },
    ));
  }

  String _dayToString(DateTime day) {
    switch (day.weekday) {
      case 1:
        return 'Ponedeljak';
      case 2:
        return 'Utorak';
      case 3:
        return 'Sreda';
      case 4:
        return 'Četvrtak';
      case 5:
        return 'Petak';
      case 6:
        return 'Subota';
      case 7:
        return 'Nedelja';
      default:
        return '';
    }
  }
}
