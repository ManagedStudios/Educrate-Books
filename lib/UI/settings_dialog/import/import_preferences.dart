import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/input/check_preference.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/select_excel.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/nav_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Resources/text.dart';

class ImportPreferences extends StatelessWidget {
  const ImportPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: Column(

        children: [
          CheckPreference(onChanged: (allowClassWithoutChar){
            Provider.of<ImportState>(context, listen: false)
                .setIsClassWithoutCharAllowed(allowClassWithoutChar);
          },
              text: TextRes.importPreferencesClassCharDescription),
          const SizedBox(height: Dimensions.spaceMedium,),
          CheckPreference(onChanged: (updateExistingStudents){
            Provider.of<ImportState>(context, listen: false)
                .setUpdateExistingStudent(updateExistingStudents);
          },
              text: TextRes.importPreferencesExistingStudentsDescription),
          const Spacer(),
          NavBottomBar(
              nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                  SelectExcel(previousWidget: MapEntry(SettingsNavButtons.IMPORT, this),)
              ),
              previousWidget: const MapEntry(SettingsNavButtons.IMPORT, ImportParent()))
        ],
      ),
    );
  }
}
