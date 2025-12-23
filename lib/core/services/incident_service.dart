import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/incidents/model/incident_model.dart';

class IncidentService {
  final CollectionReference<Map<String, dynamic>> _db = FirebaseFirestore
      .instance
      .collection('incidents');

  Future<void> createIncident(Incident incident) async {
    final docRef = _db.doc();
    await docRef.set(incident.copyWith(id: docRef.id).toMap());
  }

  /// ✅ FETCH BY USER
  Stream<List<Incident>> getIncidents(String userId) {
    return _db
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Incident.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<Incident> getIncidentById(String id) async {
    final doc = await _db.doc(id).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Incident not found');
    }
    return Incident.fromMap(doc.data()!, doc.id);
  }
}
