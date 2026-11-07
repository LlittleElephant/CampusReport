import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_widgets.dart';
import '../../widgets/floating_shapes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  String? _nameError, _emailError, _passError, _confirmError;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _email.text.trim();
    setState(() {
      _nameError = _name.text.trim().length < 2 ? 'Enter your name' : null;
      _emailError =
          (!email.contains('@') || !email.contains('.')) ? 'Enter a valid email' : null;
      _passError = _pass.text.length < 6 ? 'At least 6 characters' : null;
      _confirmError = _confirm.text != _pass.text ? 'Passwords do not match' : null;
    });
    return _nameError == null &&
        _emailError == null &&
        _passError == null &&
        _confirmError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    final ok = await context
        .read<AuthProvider>()
        .signUp(_name.text.trim(), _email.text.trim(), _pass.text);
    if (ok && mounted) Navigator.pop(context); // AuthGate shows the home
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
                    title: 'JOIN THE\nCAMPUS',
                    subtitle: 'Create a student account to start reporting issues.',
                  ),
                  const SizedBox(height: 24),
                  NeoCard(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthField(
                          label: 'Full name',
                          placeholder: 'Jane Doe',
                          controller: _name,
                          error: _nameError,
                        ),
                        const SizedBox(height: 16),
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
                        ),
                        const SizedBox(height: 16),
                        AuthField(
                          label: 'Confirm password',
                          placeholder: 'Repeat your password',
                          controller: _confirm,
                          error: _confirmError,
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
                          child: const Text('CREATE ACCOUNT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ),
                        const SizedBox(height: 12),
                        NeoButton(
                          width: double.infinity,
                          backgroundColor: kBlue,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('BACK TO LOG IN',
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