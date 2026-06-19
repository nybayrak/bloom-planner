// lib/shared/widgets/sticker_picker.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class StickerPicker extends StatelessWidget {
  const StickerPicker({super.key, required this.onSelected, this.selected = const []});
  final ValueChanged<String> onSelected;
  final List<String> selected;

  static const _stickers = [
    '🌸','🦋','🌈','⭐','🎀','🌺','🍀','🌙',
    '🎉','🦄','🌻','💫','🌟','🍓','🌷','🐝',
    '🎯','✨','🔥','💎','🏆','🎵','🌿','🍵',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: _stickers.map((s) {
        final isSelected = selected.contains(s);
        return GestureDetector(
          onTap: () => onSelected(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? BloomColors.petal : Colors.transparent,
              borderRadius: BorderRadius.all(BloomRadius.md),
              border: Border.all(color: isSelected ? BloomColors.bloom : Colors.transparent, width: 2),
            ),
            child: Text(s, style: const TextStyle(fontSize: 26)),
          ),
        );
      }).toList(),
    );
  }
}
