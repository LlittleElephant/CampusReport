import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, String current) async {
    final ctrl = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (name != null && name.length >= 2 && context.mounted) {
      await context.read<AuthProvider>().updateName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(user.name),
          subtitle: const Text('Name'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editName(context, user.name),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text(user.email),
          subtitle: const Text('Email'),
        ),
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: Text(user.role),
          subtitle: const Text('Role'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () => context.read<AuthProvider>().signOut(),
        ),
      ]),
    );
  }
}