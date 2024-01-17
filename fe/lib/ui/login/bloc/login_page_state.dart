part of 'login_page_bloc.dart';

abstract class LoginPageState extends Equatable {
  const LoginPageState();

  @override
  List<Object?> get props => [];
}

class LoginPageLoading extends LoginPageState {}

class LoginPageLoaded extends LoginPageState {}

class LoginPageError extends LoginPageState {}
