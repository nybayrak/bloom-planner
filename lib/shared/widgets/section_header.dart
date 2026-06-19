// lib/shared/widgets/section_header.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.emoji, this.trailing, this.onTrailingTap});
  final String title;
  final String? emoji;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(children: [
        if (emoji != null) ...[Text(emoji!, style: const TextStyle(fontSize: 14)), const SizedBox(width: 6)],
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        if (trailing != null) ...[
          const Spacer(),
          GestureDetector(
            onTap: onTrailingTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: BloomColors.petal, borderRadius: BorderRadius.all(BloomRadius.pill)),
              child: Text(trailing!, style: const TextStyle(fontFamily: BloomFonts.body, fontSize: 11, fontWeight: FontWeight.w700, color: BloomColors.bloom)),
            ),
          ),
        ],
      ]),
    );
  }
}
