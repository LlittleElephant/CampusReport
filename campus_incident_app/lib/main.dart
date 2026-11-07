import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/report_provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/staff/staff_shell.dart';
import 'screens/student/student_shell.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ReportProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Campus Incident Reporter',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'SpaceGrotesk',
          colorSchemeSeed: kYellow,
          scaffoldBackgroundColor: kCream,
          appBarTheme: const AppBarTheme(
            backgroundColor: kYellow,
            foregroundColor: Colors.black,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            shape: Border(bottom: BorderSide(width: 3)),
            titleTextStyle: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black),
          ),
        ),
        builder: (context, child) => NeoTheme(
          data: NeoThemeData.light(),
          child: child!,
        ),
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