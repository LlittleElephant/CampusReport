import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
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

  static const _destinations = <NeoNavDestination<int>>[
    NeoNavDestination(
        value: 0,
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Home')),
    NeoNavDestination(
        value: 1,
        icon: Icon(Icons.search),
        selectedIcon: Icon(Icons.search),
        label: Text('Search')),
    NeoNavDestination(
        value: 2,
        icon: Icon(Icons.add_circle_outline),
        selectedIcon: Icon(Icons.add_circle),
        label: Text('Report')),
    NeoNavDestination(
        value: 3,
        icon: Icon(Icons.list_alt_outlined),
        selectedIcon: Icon(Icons.list_alt),
        label: Text('Mine')),
    NeoNavDestination(
        value: 4,
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onNewReport: () => setState(() => _i = 2),
        onSeeAll: () => setState(() => _i = 1),
      ),
      const SearchScreen(),
      const AddReportScreen(),
      const MyReportsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _i, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: NeoBottomBar<int>(
          value: _i,
          destinations: _destinations,
          onChanged: (v) => setState(() => _i = v),
        ),
      ),
    );
  }
}