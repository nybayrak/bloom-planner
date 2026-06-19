// lib/shared/widgets/progress_ring.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/theme.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.percent,
    this.size = 64,
    this.strokeWidth = 7,
    this.color,
    this.trackColor,
    this.label,
    this.subLabel,
    this.animate = true,
  });

  final double percent;       // 0.0 – 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final String? label;
  final String? subLabel;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final ringColor = color ?? BloomColors.bloom;
    final bg       = trackColor ?? BloomColors.cloud;
    final pct      = percent.clamp(0.0, 1.0);

    Widget ring = CustomPaint(
      size: Size(size, size),
      painter: _RingPainter(
        percent: pct,
        color: ringColor,
        trackColor: bg,
        strokeWidth: strokeWidth,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            '${(pct * 100).round()}%',
            style: TextStyle(
              fontFamily: BloomFonts.body,
              fontSize: size * 0.19,
              fontWeight: FontWeight.w700,
              color: BloomColors.ink,
            ),
          ),
        ),
      ),
    );

    if (animate) {
      ring = ring
          .animate()
          .fadeIn(duration: 400.ms)
          .scale(begin: const Offset(0.8, 0.8), duration: 400.ms, curve: Curves.easeOut);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ring,
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: const TextStyle(
              fontFamily: BloomFonts.body,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: BloomColors.ink,
            ),
          ),
        ],
        if (subLabel != null)
          Text(
            subLabel!,
            style: const TextStyle(
              fontFamily: BloomFonts.body,
              fontSize: 9,
              color: BloomColors.stone,
            ),
          ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.percent,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double percent;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Progress
    if (percent > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,          // start at 12 o'clock
        math.pi * 2 * percent,
        false,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.percent != percent || old.color != color;
}
