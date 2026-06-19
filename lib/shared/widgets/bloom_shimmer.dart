// lib/shared/widgets/bloom_shimmer.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomShimmer extends StatefulWidget {
  const BloomShimmer({super.key, this.width = double.infinity, this.height = 16, this.borderRadius});
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<BloomShimmer> createState() => _BloomShimmerState();
}

class _BloomShimmerState extends State<BloomShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _anim = Tween(begin: -2.0, end: 2.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width, height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.all(BloomRadius.md),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0), end: Alignment(_anim.value + 1, 0),
            colors: const [BloomColors.cloud, Color(0xFFEEEEEE), BloomColors.cloud],
          ),
        ),
      ),
    );
  }
}
