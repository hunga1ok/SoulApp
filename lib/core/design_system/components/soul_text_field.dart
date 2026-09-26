import 'package:flutter/material.dart';

/// Single text input using the theme's Soul input decoration. [label] stays
/// visible (floating) and is announced by assistive technology.
class SoulTextField extends StatelessWidget {
  const SoulTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
      ),
    );
  }
}
