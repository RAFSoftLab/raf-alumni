part of 'login_page_bloc.dart';

abstract class LoginPageEvent extends Equatable {
  const LoginPageEvent();

  @override
  List<Object?> get props => [];
}

class LoginPageGoogleSignIn extends LoginPageEvent {
  @override
  List<Object?> get props => [];
}
