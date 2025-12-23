import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';

import '../viewmodel/profile_viewmodel.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/common_widgets/app_button.dart';
import '../../../core/services/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: profile.photoUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),

              Text(profile.email),
              const SizedBox(height: 24),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(AppStrings.phone),
                      subtitle: Text(
                        profile.phone.isEmpty ? 'Not set' : profile.phone,
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(AppStrings.joinedOn),
                      subtitle: Text(
                        profile.joinedOn.toLocal().toString().split(' ')[0],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              AppButton(
                text: AppStrings.logout,
                onPressed: () async {
                  await AuthService().logout();
                  context.beamToNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
