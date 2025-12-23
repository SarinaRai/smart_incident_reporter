import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/profile/model/profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Create user profile
  Future<void> createUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toMap());
  }

  /// 🔹 Check if profile exists
  Future<bool> userProfileExists(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  /// 🔹 Fetch profile
  Future<UserProfile> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('Profile not found');
    }

    return UserProfile.fromMap(doc.data()!, uid);
  }
}
