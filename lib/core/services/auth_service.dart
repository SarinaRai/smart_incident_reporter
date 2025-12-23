import 'package:firebase_auth/firebase_auth.dart';
import '../../features/profile/model/profile_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  /// 🔹 Current logged-in user
  User? get currentUser => _auth.currentUser;

  /// 🔹 Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final profile = UserProfile(
      uid: cred.user!.uid,
      fullName: fullName,
      email: email,
      phone: phone,
      photoUrl: null,
      joinedOn: DateTime.now(),
    );

    await _firestore.createUserProfile(profile);
  }

  /// 🔹 LOGIN + AUTO CREATE PROFILE IF MISSING
  Future<void> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _createProfileIfNotExists(uid: cred.user!.uid, email: email);
  }

  /// 🔹 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // 🔹 PRIVATE HELPER → AUTO CREATE PROFILE
  // ============================================================
  Future<void> _createProfileIfNotExists({
    required String uid,
    required String email,
  }) async {
    final exists = await _firestore.userProfileExists(uid);

    if (!exists) {
      final profile = UserProfile(
        uid: uid,
        fullName: 'New User',
        email: email,
        phone: '',
        photoUrl: null,
        joinedOn: DateTime.now(),
      );

      await _firestore.createUserProfile(profile);
    }
  }
}
