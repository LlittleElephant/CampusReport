import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_widgets.dart';
import '../../widgets/floating_shapes.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _emailError, _passError;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _email.text.trim();
    setState(() {
      _emailError =
          (!email.contains('@') || !email.contains('.')) ? 'Enter a valid email' : null;
      _passError = _pass.text.length < 6 ? 'At least 6 characters' : null;
    });
    return _emailError == null && _passError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    await context.read<AuthProvider>().signIn(_email.text.trim(), _pass.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: kCream,
      body: Stack(children: [
        const Positioned.fill(child: FloatingShapes()),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const AuthHeader(
                    title: 'CAMPUS\nINCIDENT\nREPORTER',
                    subtitle: 'Spot a problem on campus? Report it, track it, see it fixed.',
                  ),
                  const SizedBox(height: 24),
                  NeoCard(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthField(
                          label: 'Email',
                          placeholder: 'you@school.edu',
                          controller: _email,
                          error: _emailError,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AuthField(
                          label: 'Password',
                          placeholder: 'At least 6 characters',
                          controller: _pass,
                          error: _passError,
                          obscure: true,
                          onSubmitted: (_) => _submit(),
                        ),
                        if (auth.error != null) ...[
                          const SizedBox(height: 16),
                          AuthErrorBox(auth.error!),
                        ],
                        const SizedBox(height: 20),
                        NeoButton(
                          width: double.infinity,
                          isLoading: auth.loading,
                          onPressed: auth.loading ? null : _submit,
                          child: const Text('LOG IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                        const SizedBox(height: 12),
                        NeoButton(
                          width: double.infinity,
                          backgroundColor: kBlue,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen())),
                          child: const Text('CREATE AN ACCOUNT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}