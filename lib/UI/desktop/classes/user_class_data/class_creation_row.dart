import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/input/dialog_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../Util/stringUtil.dart';

class ClassCreationRow extends StatefulWidget {
  const ClassCreationRow({super.key, required this.levelToLettersController, required this.onClassesUpdated, required this.onDeleted});

  final MapEntry<TextEditingController, TextEditingController> levelToLettersController;
  final Function(List<ClassData>? classData, TextEditingController controller) onClassesUpdated;
  final Function(TextEditingController controller) onDeleted;

  @override
  State<ClassCreationRow> createState() => _ClassCreationRowState();
}

class _ClassCreationRowState extends State<ClassCreationRow> {

  String? levelError = TextRes.classLevelError;
  String? lettersError;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateClassLevelError();
    updateClassLettersError();

  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: DialogTextField(
              controller: widget.levelToLettersController.key,
              onTextChanged: (text){
                updateClassLevelError();
                if (lettersError != null || levelError != null) {
                  widget.onClassesUpdated(null, widget.levelToLettersController.key);
                } else {
                  widget.onClassesUpdated(parseClasses(), widget.levelToLettersController.key);
                }
              },
              hint: TextRes.classLevelHint,
              errorText: levelError,
              enabled: true),
        ),
        Expanded(
            flex: 3,
            child: DialogTextField(
                controller: widget.levelToLettersController.value,
                onTextChanged: (text){
                  updateClassLettersError();
                  if (lettersError != null || levelError != null) {
                    widget.onClassesUpdated(null, widget.levelToLettersController.key);
                  } else {
                    widget.onClassesUpdated(parseClasses(), widget.levelToLettersController.key);
                  }
                },
                hint: TextRes.classLettersHint,
                errorText: lettersError,
                enabled: true),
        ),

        IconButton(onPressed: () {
          widget.onDeleted(widget.levelToLettersController.key);
        }, icon: const Icon(Icons.close))

      ],
    );
  }

  void updateClassLevelError() {
    setState(() {
      if (isNumeric(widget.levelToLettersController.key.text)) {
        levelError = null;
      } else {
        levelError = TextRes.classLevelError;
      }
    });

  }

  void updateClassLettersError() {
    setState(() {
      String text = widget.levelToLettersController.value.text;
      if (text.isEmpty) return;
      List<String> classLetters = text.split(TextRes.comma);
      classLetters = classLetters.map((e) => e.trim().toUpperCase()).toList();
      String? error;
      for (String str in classLetters) {
        if (!containsOnlyLetters(str)) {
          error = TextRes.classLettersError;
        }
      }
      lettersError = error;
    });

  }

  List<ClassData> parseClasses() {
    List<ClassData> res = [];
    int level = int.parse(widget.levelToLettersController.key.text);
    String lettersText = widget.levelToLettersController.value.text;
    Set<String> classLetters = lettersText.split(TextRes.comma).toSet();
    classLetters = classLetters.map((e) => e.trim().toUpperCase()).toSet();

    if (lettersText.isEmpty) {
      res.add(ClassData(level, ""));
    } else {
      for (String str in classLetters) {
        res.add(ClassData(level, str));
      }
    }

    return res;
  }
}
