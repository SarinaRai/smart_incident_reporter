class FirebaseCollections {
  // firestore Collections
  static const String users = "users";
  static const String incidents = "incidents";
  static const String incidentTypes = "incident_types";

  // firestore Common Fields
  static const String userId = "userId";
  static const String createdAt = "createdAt";
  static const String updatedAt = "updatedAt";

  // user fields
  static const String name = "name";
  static const String email = "email";
  static const String profileImage = "profileImage";

  // incident fields
  static const String title = "title";
  static const String description = "description";
  static const String type = "type";
  static const String priority = "priority";
  static const String imageUrl = "imageUrl";

  // firebase storage paths
  static const String incidentImages = "incident_images";
  static const String profileImages = "profile_images";
}
