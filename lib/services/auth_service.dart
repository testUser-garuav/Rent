import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final Dio _dio = Dio(BaseOptions(baseUrl: kBaseUrl));
  final _storage = const FlutterSecureStorage();

  Future<String?> get token async => _storage.read(key: kAuthTokenKey);

  Future<void> _saveToken(String token) => _storage.write(key: kAuthTokenKey, value: token);
  Future<void> logout() async => _storage.delete(key: kAuthTokenKey);

  Future<String?> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final token = response.data['token'] as String?;
      if (token != null) {
        await _saveToken(token);
      }
      return token;
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }
}
