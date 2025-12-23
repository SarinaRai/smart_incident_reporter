import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/incident_service.dart';
import '../model/incident_model.dart';

final incidentServiceProvider = Provider((ref) => IncidentService());

final incidentListProvider = StreamProvider.autoDispose
    .family<List<Incident>, String>((ref, userId) {
      return ref.read(incidentServiceProvider).getIncidents(userId);
    });

final incidentDetailProvider = FutureProvider.family<Incident, String>((
  ref,
  id,
) {
  return ref.read(incidentServiceProvider).getIncidentById(id);
});
