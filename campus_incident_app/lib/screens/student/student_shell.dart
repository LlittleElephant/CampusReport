import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});
  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final pages = <Widget>[
      Center(child: Text('Home - hello ${user.name}')),
      const Center(child: Text('Search')),
      const Center(child: Text('Add Report')),
      const Center(child: Text('My Reports')),
      Center(
        child: FilledButton(
          onPressed: () => context.read<AuthProvider>().signOut(),
          child: const Text('Log out'),
        ),
      ),
    ];
    return Scaffold(
      body: SafeArea(child: pages[_i]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => setState(() => _i = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'My Reports'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}