import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../viewmodel/incident_viewmodel.dart';

class IncidentDetailScreen extends ConsumerWidget {
  const IncidentDetailScreen({super.key});

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;

    final id = beamState.pathParameters['id'];

    if (id == null) {
      return const Scaffold(body: Center(child: Text('Incident ID not found')));
    }

    final incidentAsync = ref.watch(incidentDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.incidents)),
      body: incidentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (incident) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incident.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _priorityColor(incident.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  incident.priority,
                  style: TextStyle(
                    color: _priorityColor(incident.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                incident.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
