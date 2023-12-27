import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/alumni_user.dart';
import 'package:alumni_network/models/company.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'company_details_event.dart';
part 'company_details_state.dart';

class CompanyDetailsBloc extends Bloc<CompanyDetailsEvent, CompanyDetailsState> {
  CompanyDetailsBloc({required this.company, required this.service}) : super(CompanyDetailsLoading()) {
    on<CompanyDetailsInit>((event, emit) async {
      emit(CompanyDetailsLoading());
      try {
        final students = await service.getAlumniUsers(companyId: company.id);
        emit(CompanyDetailsLoaded(students: students));
      } catch (e) {}
    });
  }

  final Company company;
  final AlumniNetworkService service;
}
