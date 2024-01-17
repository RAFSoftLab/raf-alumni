import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/dao/alumni_network_mock_dao.dart';
import 'package:alumni_network/api/dao/alumni_network_rest_dao.dart';
import 'package:alumni_network/auth/repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final getService = GetIt.instance;
final getRepository = GetIt.instance;

const bool isProduction = false;

class Initializer {
  factory Initializer() {
    return _instance;
  }

  Initializer._internal();

  static final Initializer _instance = Initializer._internal();

  void _initRestServices() {
    getService.registerLazySingleton<AlumniNetworkService>(
      () => AlumniNetworkService(
        dao: AlumniNetworkRestDAO(
          dio: _initDio(),
        ),
      ),
    );
  }

  void _initMockServices() {
    getService.registerLazySingleton<AlumniNetworkService>(
      () => AlumniNetworkService(
        dao: AlumniNetworkMockDAO(),
      ),
    );
  }

  Future<void> initServices({bool isMock = false}) async {
    getService.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepository(storage: FlutterSecureStorage()),
    );
    if (isMock) {
      _initMockServices();
    } else {
      _initRestServices();
    }
    await getService<AuthenticationRepository>().initialize();
  }

  void initBlocObserver() => Bloc.observer = GlobalBlocObserver();

  Dio _initDio() {
    final interceptorExclude = <String>[
      '${AlumniNetworkService.baseUrl}/api/google-login',
    ];

    final dio = Dio();
    dio.options.baseUrl = '${AlumniNetworkService.baseUrl}/api/';
    dio.options.connectTimeout = const Duration(minutes: 1);
    dio.options.receiveTimeout = const Duration(minutes: 1);

    dio.options.validateStatus = (status) => status != null && (status < 300 && status >= 200);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.uri.toString().contains(AlumniNetworkService.baseUrl)) {
            if (interceptorExclude.any((exclude) => options.uri.toString().contains(exclude))) {
              return handler.next(options);
            }
            final jwt = getService<AuthenticationRepository>().jwt;
            options.headers['Authorization'] = 'Bearer $jwt';
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  }
}

class GlobalBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    debugPrint('onCreate -- bloc: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('onError -- bloc: ${bloc.runtimeType}, error: $error');

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    debugPrint('onTransition -- bloc: ${bloc.runtimeType}, transition: $transition');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    debugPrint('onEvent -- bloc: ${bloc.runtimeType}, event: $event');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    debugPrint('onClose -- bloc: ${bloc.runtimeType}');
  }
}
