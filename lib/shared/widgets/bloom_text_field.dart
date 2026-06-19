// lib/shared/widgets/bloom_text_field.dart
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class BloomTextField extends StatelessWidget {
  const BloomTextField({super.key, required this.controller, this.label, this.hint, this.prefix, this.suffix, this.maxLines = 1, this.keyboardType, this.obscureText = false, this.onChanged, this.validator});
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
      controller: controller, maxLines: maxLines, keyboardType: keyboardType,
      obscureText: obscureText, onChanged: onChanged, validator: validator,
      style: const TextStyle(fontFamily: BloomFonts.body, fontSize: 14, color: BloomColors.ink),
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: prefix, suffixIcon: suffix),
    );
  }
}
