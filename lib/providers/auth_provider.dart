import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

class AuthNotifier extends AsyncNotifier<String?> {
  final _authService = AuthService.instance;

  @override
  Future<String?> build() async {
    return _authService.token;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final token = await _authService.login(email: email, password: password);
      state = AsyncData(token);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(AuthNotifier.new);
