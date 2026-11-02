import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose(); _email.dispose(); _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>()
        .signUp(_name.text.trim(), _email.text.trim(), _pass.text);
    if (ok && mounted) Navigator.pop(context); // AuthGate shows the home
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (v) => (v == null || v.trim().length < 2)
                  ? 'Enter your name' : null,
            ),
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
            TextFormField(
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirm password'),
              validator: (v) =>
                  v != _pass.text ? 'Passwords do not match' : null,
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
                child: const Text('Create account'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}