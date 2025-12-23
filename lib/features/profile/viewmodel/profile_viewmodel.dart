import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/service_providers.dart';
import '../model/profile_model.dart';

final profileViewModelProvider = FutureProvider<UserProfile>((ref) async {
  final auth = ref.read(authServiceProvider);
  final firestore = ref.read(firestoreServiceProvider);

  final user = auth.currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }

  return firestore.getUserProfile(user.uid);
});
