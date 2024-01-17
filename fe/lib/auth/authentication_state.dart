part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  const AuthenticationAuthenticated({required this.user});

  final User user;

  @override
  List<Object?> get props => [user];
}
