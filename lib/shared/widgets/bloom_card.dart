// lib/shared/widgets/bloom_card.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomCard extends StatelessWidget {
  const BloomCard({
    super.key,
    required this.child,
    this.color,
    this.gradient,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.all(BloomRadius.lg);

    final container = Container(
      margin: margin ?? const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? Colors.white) : null,
        gradient: gradient,
        borderRadius: br,
        boxShadow: BloomShadows.card,
      ),
      child: ClipRRect(
        borderRadius: br,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap == null) return container;

    return GestureDetector(
      onTap: onTap,
      child: container,
    );
  }
}
