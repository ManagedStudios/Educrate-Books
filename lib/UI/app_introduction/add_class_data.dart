import 'package:buecherteam_2023_desktop/Models/app_introduction_state.dart';
import 'package:buecherteam_2023_desktop/UI/classes/user_class_data/class_creation_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddClassData extends StatelessWidget {
  const AddClassData({super.key});

  @override
  Widget build(BuildContext context) {
    return ClassCreationSection(
        onClassesUpdated: (controllerToData) {
          Provider.of<AppIntroductionState>(context, listen: false)
              .setClassData(controllerToData);
        }
    );
  }
}
