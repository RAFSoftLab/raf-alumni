import 'dart:async';

import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/company.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'companies_page_event.dart';
part 'companies_page_state.dart';

class CompaniesPageBloc extends Bloc<CompaniesPageEvent, CompaniesPageState> {
  CompaniesPageBloc({required this.service}) : super(CompaniesPageLoading()) {
    on<CompaniesPageInit>((event, emit) async {
      emit(CompaniesPageLoading());
      try {
        final companies = await service.getCompanies();
        emit(CompaniesPageLoaded(companies: companies));
      } catch (e) {}
    });
  }

  final AlumniNetworkService service;
}
