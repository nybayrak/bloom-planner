// lib/shared/widgets/confetti_overlay.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class ConfettiOverlay extends StatelessWidget {
  const ConfettiOverlay({super.key, this.message = 'Great job! 🎉'});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFDE68A), Color(0xFFFCA5A5)]),
        borderRadius: BorderRadius.all(BloomRadius.lg),
        boxShadow: BloomShadows.float,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text('🎉', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Text(message, style: const TextStyle(fontFamily: BloomFonts.display, fontSize: 16, fontWeight: FontWeight.w700, color: BloomColors.ink)),
      ]),
    );
  }
}
