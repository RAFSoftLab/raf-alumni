part of 'companies_page_bloc.dart';

abstract class CompaniesPageEvent extends Equatable {
  const CompaniesPageEvent();

  @override
  List<Object?> get props => [];
}

class CompaniesPageInit extends CompaniesPageEvent {}
