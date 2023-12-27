part of 'company_details_bloc.dart';

abstract class CompanyDetailsEvent extends Equatable {
  const CompanyDetailsEvent();

  @override
  List<Object?> get props => [];
}

class CompanyDetailsInit extends CompanyDetailsEvent {}
