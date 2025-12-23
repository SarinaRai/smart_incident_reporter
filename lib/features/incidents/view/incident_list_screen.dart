import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/common_widgets/app_empty_state.dart';
import '../../../core/services/auth_service.dart';
import '../viewmodel/incident_viewmodel.dart';
import '../widgets/incident_card.dart';

class IncidentListScreen extends ConsumerWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AuthService().currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    final incidentsAsync = ref.watch(incidentListProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myIncidents),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.beamToNamed('/profile'),
          ),
        ],
      ),
      body: incidentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (incidents) => incidents.isEmpty
            ? const AppEmptyState(message: AppStrings.noDataFound)
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: incidents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final incident = incidents[index];

                  return IncidentCard(
                    title: incident.title,
                    type: incident.type,
                    priority: incident.priority,
                    createdAt: incident.createdAt,
                    imageUrl: incident.imageUrl,
                    onTap: () {
                      context.beamToNamed(
                        '/incidents/${incident.id}',
                        stacked: true,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
