part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationInit extends AuthenticationEvent {}

class AuthenticationUserAuthenticated extends AuthenticationEvent {
  const AuthenticationUserAuthenticated({required this.jwt});

  final String jwt;

  @override
  List<Object?> get props => [jwt];
}

class AuthenticationUserUnauthenticated extends AuthenticationEvent {}
