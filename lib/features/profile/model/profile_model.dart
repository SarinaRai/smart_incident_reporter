class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String? photoUrl;
  final DateTime joinedOn;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.joinedOn,
    this.photoUrl,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      joinedOn: DateTime.parse(map['joinedOn']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'joinedOn': joinedOn.toIso8601String(),
    };
  }
}
