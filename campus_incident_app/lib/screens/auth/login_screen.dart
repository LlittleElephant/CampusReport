import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await context.read<AuthProvider>().signIn(_email.text.trim(), _pass.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(children: [
                const Text('Campus Incident Reporter',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email' : null,
                ),
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) => (v == null || v.length < 6)
                      ? 'At least 6 characters' : null,
                ),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(auth.error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: auth.loading ? null : _submit,
                    child: auth.loading
                        ? const SizedBox(height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Log in'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen())),
                  child: const Text('Create an account'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}