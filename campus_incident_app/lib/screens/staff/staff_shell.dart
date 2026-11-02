import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class StaffShell extends StatelessWidget {
  const StaffShell({super.key});
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: Center(child: Text('Welcome staff: ${user.name}')),
    );
  }
}