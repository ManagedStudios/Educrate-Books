import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/classes/user_class_data/class_creation_row.dart';

import 'package:flutter/material.dart';

class ClassCreationSection extends StatefulWidget {
  const ClassCreationSection({super.key, required this.onClassesUpdated});

  final Function(Map<TextEditingController, List<ClassData>?> controllerToData) onClassesUpdated;

  @override
  State<ClassCreationSection> createState() => _ClassCreationSectionState();
}

class _ClassCreationSectionState extends State<ClassCreationSection> {

  late Map<TextEditingController, TextEditingController> textRows;
  late Map<TextEditingController, List<ClassData>?> controllerToData;


  @override
  void initState () {
    super.initState();
    textRows = {TextEditingController():TextEditingController()};
    controllerToData = {textRows.entries.first.key:null};

  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              for (MapEntry<TextEditingController, TextEditingController> entry in textRows.entries)
                ClassCreationRow(
                    levelToLettersController: entry,
                    onClassesUpdated: (List<ClassData>? classes, TextEditingController controller) {
                      controllerToData[controller] = classes;
                      widget.onClassesUpdated(controllerToData);
                    },
                    onDeleted: (controller) {
                      setState(() {
                        textRows.remove(controller);
                        controllerToData.remove(controller);
                      });
                      widget.onClassesUpdated(controllerToData);
                    })
            ],
          ),
        ),
        IconButton(onPressed: () {
          setState(() {
            TextEditingController key = TextEditingController();
            textRows[key] = TextEditingController();
            controllerToData[key] = null;
          });
          widget.onClassesUpdated(controllerToData);
        }, icon: const Icon(Icons.add_circle_outline))
      ],
    );
  }
}
