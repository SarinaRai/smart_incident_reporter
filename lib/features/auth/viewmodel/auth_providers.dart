import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/services/auth_service.dart';
import 'auth_viewmodel.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>(
      (ref) => AuthViewModel(ref),
    );
