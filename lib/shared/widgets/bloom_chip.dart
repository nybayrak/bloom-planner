// lib/shared/widgets/bloom_chip.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomChip extends StatelessWidget {
  const BloomChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.color,
    this.selectedColor,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;
  final Color? selectedColor;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (selectedColor ?? BloomColors.bloom) : (color ?? BloomColors.petal);
    final fg = selected ? Colors.white : BloomColors.bloom;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.all(BloomRadius.pill),
          border: Border.all(color: selected ? bg : BloomColors.bloom.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Text(icon!, style: const TextStyle(fontSize: 12)), const SizedBox(width: 4)],
            Text(label, style: TextStyle(fontFamily: BloomFonts.body, fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
          ],
        ),
      ),
    );
  }
}
