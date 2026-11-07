import 'package:flutter/material.dart';
import '../constants.dart';

class BrutalChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  const BrutalChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? (color ?? kYellow) : Colors.white,
          border: Border.all(width: 3),
          borderRadius: BorderRadius.circular(6),
          boxShadow: selected
              ? []
              : const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
        ),
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final Color Function(String)? colorFor;
  const FilterRow({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.colorFor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 16, top: 8),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
      ),
      SizedBox(
        height: 54,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: BrutalChip(
                  label: 'All',
                  selected: selected == null,
                  onTap: () => onSelected(null)),
            ),
            for (final o in options)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: BrutalChip(
                  label: o,
                  selected: selected == o,
                  color: colorFor?.call(o),
                  onTap: () => onSelected(selected == o ? null : o),
                ),
              ),
          ],
        ),
      ),
    ]);
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(text.toUpperCase(),
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
      );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, message;
  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: kPink,
              shape: BoxShape.circle,
              border: Border.all(width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4))
              ],
            ),
            child: Icon(icon, size: 40),
          ),
          const SizedBox(height: 20),
          Text(title.toUpperCase(),
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class ChipSelect extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final Color Function(String)? colorFor;
  const ChipSelect({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.colorFor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, runSpacing: 12, children: [
      for (final o in options)
        BrutalChip(
          label: o,
          selected: selected == o,
          color: colorFor?.call(o),
          onTap: () => onSelected(o),
        ),
    ]);
  }
}

class FieldBlock extends StatelessWidget {
  final String label;
  final Widget child;
  final String? error;
  const FieldBlock(
      {super.key, required this.label, required this.child, this.error});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
      const SizedBox(height: 8),
      child,
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(error!,
              style: const TextStyle(
                  color: Color(0xFFD00000), fontWeight: FontWeight.w700)),
        ),
    ]);
  }
}