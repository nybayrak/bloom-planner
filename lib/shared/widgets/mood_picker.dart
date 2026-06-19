// lib/shared/widgets/mood_picker.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class MoodPicker extends StatelessWidget {
  const MoodPicker({super.key, required this.selectedMood, required this.onChanged});
  final int? selectedMood;
  final ValueChanged<int> onChanged;

  static const _moods  = ['😔','😕','😐','🙂','😄'];
  static const _labels = ['Low','Meh','Okay','Good','Great'];
  static const _colors = [Color(0xFFFCA5A5), Color(0xFFFED7AA), Color(0xFFFDE68A), Color(0xFF86EFAC), Color(0xFF6EE7B7)];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(5, (i) {
        final selected = selectedMood == i + 1;
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(color: selected ? _colors[i] : Colors.transparent, borderRadius: BorderRadius.all(BloomRadius.md)),
            child: Column(children: [
              Text(_moods[i], style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 2),
              Text(_labels[i], style: TextStyle(fontFamily: BloomFonts.body, fontSize: 9, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: BloomColors.stone)),
            ]),
          ),
        );
      }),
    );
  }
}
