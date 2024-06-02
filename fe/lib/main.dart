import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/auth/authentication_bloc.dart';
import 'package:alumni_network/auth/repository/authentication_repository.dart';
import 'package:alumni_network/firebase/firebase_options.dart';
import 'package:alumni_network/ui/login/bloc/login_page_bloc.dart';
import 'package:alumni_network/ui/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('sr', null);
  await Initializer().initServices();

  await Firebase.initializeApp(name: 'raf-mobile-app-411514', options: AppFirebaseOptions.currentPlatform);
  // await FirebaseMessaging.instance.requestPermission(provisional: true);
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM token: $fcmToken');

  runApp(const AlumniNetworkApp());
}

class AlumniNetworkApp extends StatelessWidget {
  const AlumniNetworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        service: getService<AlumniNetworkService>(),
        repository: getService<AuthenticationRepository>(),
      )..add(AuthenticationInit()),
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Alumni Network',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          locale: const Locale('sr', 'RS'),
          home: BlocProvider<LoginPageBloc>(
            create: (context) => LoginPageBloc(
              authenticationBloc: context.read<AuthenticationBloc>(),
              service: getService<AlumniNetworkService>(),
            ),
            child: LoginPage(),
          ),
        );
      }),
    );
  }
}
