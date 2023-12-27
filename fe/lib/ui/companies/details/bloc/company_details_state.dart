part of 'company_details_bloc.dart';

abstract class CompanyDetailsState extends Equatable {
  const CompanyDetailsState();

  @override
  List<Object?> get props => [];
}

class CompanyDetailsLoading extends CompanyDetailsState {}

class CompanyDetailsLoaded extends CompanyDetailsState {

  final List<AlumniUser> students;

  CompanyDetailsLoaded({required this.students});

  @override
  List<Object?> get props => [students];
}
