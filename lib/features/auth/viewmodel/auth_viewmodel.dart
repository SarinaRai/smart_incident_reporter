import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>(
      (ref) => AuthViewModel(ref),
    );

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  AuthViewModel(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .login(email: email, password: password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(authServiceProvider)
          .register(
            email: email,
            password: password,
            fullName: fullName,
            phone: phone,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
  }
}
