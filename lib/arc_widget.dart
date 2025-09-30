import 'dart:math' as math;
import 'package:flutter/material.dart';

// Drop this somewhere in your file:
class MomentsArc extends StatelessWidget {
  final List<Widget> items; // your _MomentButton widgets
  final List<double> sizes; // matching sizes for each item
  final double startAngle; // radians, e.g. -math.pi for left â†’ right
  final double endAngle; // radians, e.g. 0 for a top semicircle
  final double radiusFactor; // 0..1 of the shortest side, e.g. 0.42
  final Alignment centerAlignment; // where the circle center sits in the box
  final Widget? centerOverlay; // e.g., _AddButton at the circle center

  const MomentsArc({
    super.key,
    required this.items,
    required this.sizes,
    this.startAngle = -math.pi / 2, // left
    this.endAngle =
        math.pi / 2, // to right (drawn above center) â†’ top semicircle
    this.radiusFactor = 0.42,
    this.centerAlignment = Alignment.centerRight,
    this.centerOverlay,
  }) : assert(items.length == sizes.length);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final r = math.min(w, h) * radiusFactor;

        // Circle center relative to the container
        final center = Offset(
          (centerAlignment.x + 1) * 0.5 * w,
          (centerAlignment.y + 1) * 0.5 * h,
        );

        final N = items.length;
        final step = (N == 1) ? 0.0 : (endAngle - startAngle) / (N - 1);

        return Stack(
          children: [
            for (int i = 0; i < N; i++)
              _positionedPolar(
                center: center,
                radius: r,
                angle: startAngle + i * step,
                size: sizes[i],
                child: items[i],
              ),
            if (centerOverlay != null)
              Positioned(
                left: center.dx - 30,
                top: center.dy - 30,
                width: 60,
                height: 60,
                child: centerOverlay!,
              ),
          ],
        );
      },
    );
  }

  Widget _positionedPolar({
    required Offset center,
    required double radius,
    required double angle,
    required double size,
    required Widget child,
  }) {
    final x = center.dx + radius * math.cos(angle) - size / 2;
    final y = center.dy + radius * math.sin(angle) - size / 2;
    return Positioned(left: x, top: y, width: size, height: size, child: child);
  }
}
