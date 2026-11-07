import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants.dart';

enum _ShapeType { square, circle, triangle }

class _ShapeSpec {
  final double x, y, size, phase, spin;
  final Color color;
  final _ShapeType type;
  const _ShapeSpec(
      this.x, this.y, this.size, this.color, this.type, this.phase, this.spin);
}

const _specs = [
  _ShapeSpec(0.06, 0.05, 56, kYellow, _ShapeType.square, 0.0, 1),
  _ShapeSpec(0.78, 0.08, 64, kPink, _ShapeType.circle, 0.3, -1),
  _ShapeSpec(0.62, 0.32, 48, kBlue, _ShapeType.triangle, 0.6, 1),
  _ShapeSpec(0.04, 0.68, 60, kGreen, _ShapeType.triangle, 0.15, -1),
  _ShapeSpec(0.80, 0.80, 52, kYellow, _ShapeType.circle, 0.8, 1),
  _ShapeSpec(0.40, 0.92, 44, kPink, _ShapeType.square, 0.5, -1),
];

class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});
  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(seconds: 8))
    ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _shape(_ShapeSpec s) {
    switch (s.type) {
      case _ShapeType.triangle:
        return CustomPaint(
            size: Size(s.size, s.size), painter: _TrianglePainter(s.color));
      case _ShapeType.circle:
      case _ShapeType.square:
        return Container(
          width: s.size,
          height: s.size,
          decoration: BoxDecoration(
            color: s.color,
            shape: s.type == _ShapeType.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            border: Border.all(width: 3),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(4, 4)),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, box) => AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = _c.value;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                for (final s in _specs)
                  Positioned(
                    left: s.x * (box.maxWidth - s.size),
                    top: s.y * (box.maxHeight - s.size) +
                        math.sin((t + s.phase) * 2 * math.pi) * 14,
                    child: Transform.rotate(
                      angle: t * 2 * math.pi * s.spin + s.phase * math.pi,
                      child: _shape(s),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  Path _path(Size s) => Path()
    ..moveTo(s.width / 2, 0)
    ..lineTo(s.width, s.height)
    ..lineTo(0, s.height)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final path = _path(size);
    canvas.drawPath(path.shift(const Offset(4, 4)), Paint()..color = Colors.black);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter old) => old.color != color;
}