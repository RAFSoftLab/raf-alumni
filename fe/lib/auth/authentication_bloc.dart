import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/auth/repository/authentication_repository.dart';
import 'package:alumni_network/models/user.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.service, required this.repository}) : super(AuthenticationUnauthenticated()) {
    on<AuthenticationInit>((event, emit) async {
      final jwt = await repository.jwt;
      if (jwt == null) {
        emit(AuthenticationUnauthenticated());
        return;
      }
      final user = await service.getUser();
      emit(AuthenticationAuthenticated(user: user));
    });
    on<AuthenticationUserAuthenticated>((event, emit) async {
      await repository.setJwt(event.jwt);
      final user = await service.getUser();
      emit(AuthenticationAuthenticated(user: user));
    });
    on<AuthenticationUserUnauthenticated>((event, emit) async {
      await repository.clearAll();
      emit(AuthenticationUnauthenticated());
    });
  }

  final AlumniNetworkService service;
  final AuthenticationRepository repository;
}
