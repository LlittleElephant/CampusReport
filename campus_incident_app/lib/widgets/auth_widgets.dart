import 'package:flutter/material.dart';
import 'package:neobrutalism_ui/neobrutalism_ui.dart';
import '../constants.dart';

class AuthHeader extends StatelessWidget {
  final String title, subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      color: kYellow,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w900, height: 1.05,
                color: Colors.black)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
      ]),
    );
  }
}

class AuthField extends StatefulWidget {
  final String label, placeholder;
  final TextEditingController controller;
  final String? error;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;

  const AuthField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.error,
    this.obscure = false,
    this.keyboardType,
    this.onSubmitted,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label.toUpperCase(),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
      const SizedBox(height: 6),
      NeoTextField(
        controller: widget.controller,
        placeholder: widget.placeholder,
        obscureText: widget.obscure && _hidden,
        keyboardType: widget.keyboardType,
        onSubmitted: widget.onSubmitted,
        suffix: widget.obscure
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _hidden = !_hidden),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    _hidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              )
            : null,
      ),
      if (widget.error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(widget.error!,
              style: const TextStyle(
                  color: Color(0xFFD00000), fontWeight: FontWeight.w700)),
        ),
    ]);
  }
}

class AuthErrorBox extends StatelessWidget {
  final String message;
  const AuthErrorBox(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kPink,
        border: Border.all(width: 3),
      ),
      child: Text(message,
          style: const TextStyle(
              fontWeight: FontWeight.w800, color: Colors.black)),
    );
  }
}