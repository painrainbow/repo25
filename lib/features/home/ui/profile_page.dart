import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.displayName ?? 'Без имени', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    Text(user?.email ?? ''),
                    const SizedBox(height: 6),
                    Text('UID: ${user?.uid ?? ''}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                await ref.read(authRepoProvider).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Выйти'),
            ),
            const SizedBox(height: 24),
            const Text(
              'MyShelf: личный каталог книг/комиксов/винила/настолок.\nДрузья/рекомендации не реализованы по ТЗ.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
