import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/staff/staff_shell.dart';
import 'screens/student/student_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (_) => AuthProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Campus Incident Reporter',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const AuthGate(),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (auth.user == null) return const LoginScreen();
    return auth.user!.isStaff ? const StaffShell() : const StudentShell();
  }
}