part of 'companies_page_bloc.dart';

abstract class CompaniesPageState extends Equatable {
  const CompaniesPageState();

  @override
  List<Object> get props => [];
}

class CompaniesPageLoading extends CompaniesPageState {}

class CompaniesPageLoaded extends CompaniesPageState {
  const CompaniesPageLoaded({
    required this.companies,
  });

  final List<Company> companies;

  @override
  List<Object> get props => [
        companies,
      ];
}
