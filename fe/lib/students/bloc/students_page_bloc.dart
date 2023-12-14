import 'dart:async';

import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'students_page_event.dart';
part 'students_page_state.dart';

class StudentsPageBloc extends Bloc<StudentsPageEvent, StudentsPageState> {
  StudentsPageBloc({required this.service}) : super(StudentsPageLoading()) {
    on<StudentsPageInit>((event, emit) async {
      emit(StudentsPageLoading());
      try {
        final students = await service.getAlumniUsers();
        emit(StudentsPageLoaded(students: students));
      } catch (e) {
        emit(StudentsPageError());
      }
    });
  }

  final AlumniNetworkService service;
}
