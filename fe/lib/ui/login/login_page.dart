import 'package:alumni_network/auth/authentication_bloc.dart';
import 'package:alumni_network/ui/common/colors.dart';
import 'package:alumni_network/ui/common/easy_text.dart';
import 'package:alumni_network/ui/common/easy_text_icon_button.dart';
import 'package:alumni_network/ui/home_page.dart';
import 'package:alumni_network/ui/login/bloc/login_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationAuthenticated) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
              Image.asset(
                'assets/raf_logo.jpg',
                height: MediaQuery.of(context).size.height / 3,
              ),
              const Spacer(
                flex: 2,
              ),
              Column(
                children: [
                  const EasyText.headline1(text: 'Prijavi se'),
                  const SizedBox(
                    height: 32,
                  ),
                  EasyTextIconButton.dialog(
                    text: 'Sign in with Google',
                    width: MediaQuery.of(context).size.width,
                    path: 'assets/google_icon.png',
                    fontWeight: FontWeight.w700,
                    isIconOnRight: false,
                    iconSize: 24,
                    height: 56,
                    backgroundColor: kColorRed,
                    onPressed: () => context.read<LoginPageBloc>().add(LoginPageGoogleSignIn()),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
              const Spacer(
                flex: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
