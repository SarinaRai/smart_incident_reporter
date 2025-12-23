import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final String type;
  final String priority;
  final DateTime createdAt;
  final String userId;
  final String? imageUrl;

  Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.userId,
    this.imageUrl,
  });

  factory Incident.fromMap(Map<String, dynamic> map, String id) {
    return Incident(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      priority: map['priority'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'priority': priority,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }

  Incident copyWith({String? id}) {
    return Incident(
      id: id ?? this.id,
      title: title,
      description: description,
      type: type,
      priority: priority,
      createdAt: createdAt,
      userId: userId,
      imageUrl: imageUrl,
    );
  }
}
