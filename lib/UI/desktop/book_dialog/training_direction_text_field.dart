import 'package:flutter/material.dart';

import '../../../Resources/dimensions.dart';

/*
TrainingDirectionTextField is a textfield that is used to enter the training direction of a student
 */

class TrainingDirectionTextField extends StatelessWidget {
  const TrainingDirectionTextField(
      {super.key,
      required this.controller,
      required this.errorText,
      required this.hint,
      required this.onTextChanged});

  final TextEditingController controller;
  final String? errorText;
  final String hint;

  final Function(String text) onTextChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (text) {

          final capitalizedText = text.toUpperCase();
          controller.value = TextEditingValue(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );

        onTextChanged(controller.text);
      },
      autocorrect: false,
      style: Theme.of(context).textTheme.labelSmall,
      decoration: InputDecoration(
          labelText: hint,
          labelStyle: Theme.of(context).textTheme.labelSmall,
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(Dimensions.cornerRadiusSmall)),
          errorText: errorText,
          contentPadding: const EdgeInsets.all(Dimensions.paddingMedium),
          isDense: true),
    );
  }
}
