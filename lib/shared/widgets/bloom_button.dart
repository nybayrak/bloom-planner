// lib/shared/widgets/bloom_button.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

enum BloomButtonVariant { primary, secondary, ghost, danger }

class BloomButton extends StatelessWidget {
  const BloomButton({super.key, required this.label, required this.onPressed, this.variant = BloomButtonVariant.primary, this.icon, this.loading = false, this.fullWidth = true});
  final String label;
  final VoidCallback? onPressed;
  final BloomButtonVariant variant;
  final String? icon;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    Widget child = loading
        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Text(icon!, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6)],
            Text(label),
          ]);

    final button = switch (variant) {
      BloomButtonVariant.primary   => ElevatedButton(onPressed: loading ? null : onPressed, child: child),
      BloomButtonVariant.secondary => OutlinedButton(onPressed: loading ? null : onPressed, child: child),
      BloomButtonVariant.ghost     => TextButton(onPressed: loading ? null : onPressed, child: child),
      BloomButtonVariant.danger    => ElevatedButton(onPressed: loading ? null : onPressed, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFCA5A5)), child: child),
    };

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
