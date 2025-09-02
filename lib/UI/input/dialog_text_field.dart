import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class DialogTextField extends StatefulWidget {
  const DialogTextField(
      {super.key,
      required this.controller,
      required this.onTextChanged,
      required this.hint,
      required this.errorText,
      required this.enabled});

  final TextEditingController controller;
  final Function(String text) onTextChanged;
  final String hint;
  final String? errorText;

  final bool? enabled;

  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onTextChanged,
        autocorrect: false,
        decoration: InputDecoration(
            labelText: widget.hint,
            labelStyle: Theme.of(context).textTheme.labelMedium,
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.cornerRadiusSmall)),
            errorText: widget.errorText,
            isDense: true),
        enabled: widget.enabled,
      ),
    );
  }
}
