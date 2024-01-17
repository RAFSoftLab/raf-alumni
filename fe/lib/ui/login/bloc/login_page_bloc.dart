import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/auth/authentication_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_page_event.dart';

part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc({required this.authenticationBloc, required this.service}) : super(LoginPageLoaded()) {
    on<LoginPageGoogleSignIn>((event, emit) async {
      try {
        // Trigger the authentication flow
        final googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final googleAuth = await googleUser?.authentication;
        final token = await service.googleSignIn(
          accessToken: googleAuth!.accessToken!,
          idToken: googleAuth.idToken!,
        );

        authenticationBloc.add(AuthenticationUserAuthenticated(jwt: token));

        // Once signed in, return the UserCredential
      } catch (error, _) {
        emit(LoginPageError());
      }
    });
  }

  final AlumniNetworkService service;
  final AuthenticationBloc authenticationBloc;
}
