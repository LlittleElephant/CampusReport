import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, String current) async {
    final ctrl = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: NeoCard(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('EDIT NAME',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                NeoTextField(controller: ctrl, autofocus: true),
                const SizedBox(height: 16),
                NeoButton(
                  onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                  child: const Text('SAVE',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 10),
                NeoButton(
                  backgroundColor: Colors.white,
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL',
                      style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (name != null && name.length >= 2 && context.mounted) {
      await context.read<AuthProvider>().updateName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
        children: [
          NeoCard(
            color: kBlue,
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kYellow,
                  border: Border.all(width: 3),
                ),
                child: Text(
                  user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 2)),
                        child: Text(user.role.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ]),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          NeoCard(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('EMAIL',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(user.email,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 24),
          NeoButton(
            width: double.infinity,
            backgroundColor: kYellow,
            onPressed: () => _editName(context, user.name),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('EDIT NAME',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ),
          const SizedBox(height: 14),
          NeoButton(
            width: double.infinity,
            backgroundColor: kPink,
            onPressed: () => context.read<AuthProvider>().signOut(),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('LOG OUT',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }
}