import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthenticationRepository {
  AuthenticationRepository({required FlutterSecureStorage storage}) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<void> initialize() async {
    _jwt = await _storage.read(key: kTokenKey);
  }

  String? _jwt;

  String? get jwt => _jwt;

  Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: kTokenKey),
    ]);

    _jwt = null;
  }

  Future<void> setJwt(String jwt) async {
    await _storage.write(key: kTokenKey, value: jwt);
    _jwt = jwt;
  }
}

const String kTokenKey = 'sJwt';