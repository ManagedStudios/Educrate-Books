import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/big_button.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/import_preferences.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/select_excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';

class ImportParent extends StatelessWidget {
  const ImportParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(onPressed: (){
          final importState = Provider.of<ImportState>(context, listen: false);
          Provider.of<SettingsNavState>(context, listen: false)
              .setCurrWidget(ImportPreferences(

            importFunction: () => importState.importStudents(),
          ), SettingsNavButtons.IMPORT);
        }, text: TextRes.importNewSchoolYearTitle),
        const SizedBox(height: Dimensions.spaceLarge,),
        BigButton(onPressed: (){
          final importState = Provider.of<ImportState>(context, listen: false);
          importState.setIsClassWithoutCharAllowed(true);

          Provider.of<SettingsNavState>(context, listen: false)
              .setCurrWidget(SelectExcel(previousWidget: MapEntry(SettingsNavButtons.IMPORT, this),

              importFunction: () => importState.updateOrCreateStudents(),
          ), SettingsNavButtons.IMPORT);
        }, text: TextRes.importNewStudents),
        const SizedBox(height: Dimensions.spaceLarge,),
        BigButton(onPressed: (){}, text: TextRes.importNewAttributes)
      ],
    );
  }
}
