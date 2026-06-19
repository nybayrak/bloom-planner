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
    final bg = selected
        ? (selectedColor ?? BloomColors.bloom)
        : (color ?? BloomColors.petal);
    final fg = selected ? Colors.white : BloomColors.bloom;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.all(BloomRadius.pill),
          border: Border.all(
            color: selected ? bg : BloomColors.bloom.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Text(icon!, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: BloomFonts.body,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/habit_dot_row.dart
class HabitDotRow extends StatelessWidget {
  const HabitDotRow({
    super.key,
    required this.days, // 7 booleans Mon–Sun
    this.color,
    this.size = 20,
  });

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
          child: done
              ? Icon(Icons.check, size: size * 0.55, color: Colors.white)
              : null,
        ),
      )).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/section_header.dart
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.emoji,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? emoji;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
          ],
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          if (trailing != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onTrailingTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: BloomColors.petal,
                  borderRadius: BorderRadius.all(BloomRadius.pill),
                ),
                child: Text(
                  trailing!,
                  style: const TextStyle(
                    fontFamily: BloomFonts.body,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: BloomColors.bloom,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/empty_state.dart
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (action != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                child: Text(action!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/bloom_shimmer.dart
class BloomShimmer extends StatefulWidget {
  const BloomShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<BloomShimmer> createState() => _BloomShimmerState();
}

class _BloomShimmerState extends State<BloomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.all(BloomRadius.md),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              BloomColors.cloud,
              Color(0xFFEEEEEE),
              BloomColors.cloud,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/mood_picker.dart
class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.selectedMood,
    required this.onChanged,
  });

  final int? selectedMood; // 1–5
  final ValueChanged<int> onChanged;

  static const _moods = ['😔', '😕', '😐', '🙂', '😄'];
  static const _labels = ['Low', 'Meh', 'Okay', 'Good', 'Great'];
  static const _colors = [
    Color(0xFFFCA5A5),
    Color(0xFFFED7AA),
    Color(0xFFFDE68A),
    Color(0xFF86EFAC),
    Color(0xFF6EE7B7),
  ];

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
            decoration: BoxDecoration(
              color: selected ? _colors[i] : Colors.transparent,
              borderRadius: BorderRadius.all(BloomRadius.md),
            ),
            child: Column(
              children: [
                Text(_moods[i], style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 2),
                Text(
                  _labels[i],
                  style: TextStyle(
                    fontFamily: BloomFonts.body,
                    fontSize: 9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: BloomColors.stone,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/bloom_text_field.dart
class BloomTextField extends StatelessWidget {
  const BloomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontFamily: BloomFonts.body,
        fontSize: 14,
        color: BloomColors.ink,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/bloom_button.dart
enum BloomButtonVariant { primary, secondary, ghost, danger }

class BloomButton extends StatelessWidget {
  const BloomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BloomButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final BloomButtonVariant variant;
  final String? icon;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    Widget child = loading
        ? const SizedBox(
            width: 18, height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Text(icon!, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
              ],
              Text(label),
            ],
          );

    final button = switch (variant) {
      BloomButtonVariant.primary => ElevatedButton(
          onPressed: loading ? null : onPressed,
          child: child,
        ),
      BloomButtonVariant.secondary => OutlinedButton(
          onPressed: loading ? null : onPressed,
          child: child,
        ),
      BloomButtonVariant.ghost => TextButton(
          onPressed: loading ? null : onPressed,
          child: child,
        ),
      BloomButtonVariant.danger => ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCA5A5)),
          child: child,
        ),
    };

    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/confetti_overlay.dart
class ConfettiOverlay extends StatelessWidget {
  const ConfettiOverlay({super.key, this.message = 'Great job! 🎉'});

  final String message;

  @override
  Widget build(BuildContext context) {
    // Requires confetti: ^0.7.0 in pubspec
    // Full implementation uses ConfettiController + ConfettiWidget
    // Placeholder returns a simple banner for now
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDE68A), Color(0xFFFCA5A5)],
        ),
        borderRadius: BorderRadius.all(BloomRadius.lg),
        boxShadow: BloomShadows.float,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(
              fontFamily: BloomFonts.display,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BloomColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

// lib/shared/widgets/sticker_picker.dart
class StickerPicker extends StatelessWidget {
  const StickerPicker({
    super.key,
    required this.onSelected,
    this.selected = const [],
  });

  final ValueChanged<String> onSelected;
  final List<String> selected;

  static const _stickers = [
    '🌸', '🦋', '🌈', '⭐', '🎀', '🌺', '🍀', '🌙',
    '🎉', '🦄', '🌻', '💫', '🌟', '🍓', '🌷', '🐝',
    '🎯', '✨', '🔥', '💎', '🏆', '🎵', '🌿', '🍵',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
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
              border: Border.all(
                color: isSelected ? BloomColors.bloom : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(s, style: const TextStyle(fontSize: 26)),
          ),
        );
      }).toList(),
    );
  }
}
