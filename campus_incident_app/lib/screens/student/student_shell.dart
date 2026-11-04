import 'package:flutter/material.dart';
import 'add_report_screen.dart';
import 'home_screen.dart';
import 'my_reports_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});
  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onNewReport: () => setState(() => _i = 2)),
      const SearchScreen(),
      const AddReportScreen(),
      const MyReportsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _i, children: pages),
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