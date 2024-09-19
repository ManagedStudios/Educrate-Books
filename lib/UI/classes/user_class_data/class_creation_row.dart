import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/input/dialog_text_field.dart';
import 'package:flutter/material.dart';

class ClassCreationRow extends StatefulWidget {
  const ClassCreationRow({super.key, required this.levelToLettersController, required this.onClassesUpdated});

  static String routeName = '/classCreationRow';

  final MapEntry<TextEditingController, TextEditingController> levelToLettersController;
  final Function(List<ClassData>? classData) onClassesUpdated;

  @override
  State<ClassCreationRow> createState() => _ClassCreationRowState();
}

class _ClassCreationRowState extends State<ClassCreationRow> {

  String? levelError = TextRes.classLevelError;
  String? lettersError = TextRes.classLettersError;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DialogTextField(
              controller: widget.levelToLettersController.key,
              onTextChanged: (text){},
              hint: TextRes.classLevelHint,
              errorText: levelError,
              enabled: true),
        ),
        Expanded(
            flex: 3,
            child: DialogTextField(
                controller: widget.levelToLettersController.value,
                onTextChanged: (text){},
                hint: TextRes.classLettersHint,
                errorText: levelError,
                enabled: true),
        )

      ],
    );
  }
}
