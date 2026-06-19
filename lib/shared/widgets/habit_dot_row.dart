// lib/shared/widgets/habit_dot_row.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class HabitDotRow extends StatelessWidget {
  const HabitDotRow({super.key, required this.days, this.color, this.size = 20});
  final List<bool> days;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dotColor = color ?? BloomColors.bloom;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: days.map((done) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size, height: size,
          decoration: BoxDecoration(
            color: done ? dotColor : Colors.transparent,
            border: Border.all(color: done ? dotColor : BloomColors.cloud, width: 2),
            shape: BoxShape.circle,
          ),
          child: done ? Icon(Icons.check, size: size * 0.55, color: Colors.white) : null,
        ),
      )).toList(),
    );
  }
}
