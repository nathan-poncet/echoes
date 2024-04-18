import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/constants/paddings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pb = ref.watch(pocketBaseProvider);
    final profile = pb.authStore.model;
    final avatarUrl = pb.files.getUrl(profile, profile.getDataValue<String>('avatar'));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: Paddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Account Screen', style: Theme.of(context).textTheme.headlineMedium),
              gapH24,
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl.toString() != "" ? NetworkImage(avatarUrl.toString()) : null,
                    child: avatarUrl.toString() == "" ? const Icon(Icons.image) : null,
                  ),
                  gapW12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile.getDataValue<String>('name')}', style: Theme.of(context).textTheme.titleMedium),
                      Text('${profile.getDataValue<String>('email')}'),
                      Text('${profile.getDataValue<String>('bio')}', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
              ),
              gapH24,
              OutlinedButton(
                onPressed: ref.read(pocketBaseProvider).authStore.clear,
                child: const Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
