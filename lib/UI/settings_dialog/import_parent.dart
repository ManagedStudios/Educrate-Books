import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/common/big_button.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/import_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../input/check_preference.dart';

class ImportParent extends StatelessWidget {
  const ImportParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BigButton(onPressed: (){ //new school year import
          final importState = Provider.of<ImportState>(context, listen: false);
          Provider.of<SettingsNavState>(context, listen: false)
              .setCurrWidget(ImportPreferences(

            checkPreferences: [
              CheckPreference(onChanged: (allowClassWithoutChar){
                importState
                    .setIsClassWithoutCharAllowed(allowClassWithoutChar);
              },
                  text: TextRes.importPreferencesClassCharDescription),
              CheckPreference(onChanged: (updateExistingStudents){
                importState
                    .setUpdateExistingStudent(updateExistingStudents);
              },
                  text: TextRes.importPreferencesExistingStudentsDescription)
            ],

            importFunction: () => importState.importStudents(),
          ), SettingsNavButtons.IMPORT);
        }, text: TextRes.importNewSchoolYearTitle),
        const SizedBox(height: Dimensions.spaceLarge,),
        BigButton(onPressed: (){ //add new students / attributes import
          final importState = Provider.of<ImportState>(context, listen: false);
          //all classes are allowed when importing/updating students
          importState.setIsClassWithoutCharAllowed(true);
          //Basic books are not imported on default
          importState.setImportBasicBooks(false);

          Provider.of<SettingsNavState>(context, listen: false)
              .setCurrWidget(ImportPreferences(
              importFunction: () => importState.updateOrCreateStudents(),
              checkPreferences: [
                CheckPreference(onChanged: (importBasicBooks){
                  importState
                      .setImportBasicBooks(importBasicBooks);
                },
                    text: TextRes.importPreferencesBasicBooks),
                CheckPreference(onChanged: (overwriteClasses){
                  importState
                      .setOverwriteClasses(overwriteClasses);
                },
                    text: TextRes.importPreferencesOverwriteClasses),

              ]), SettingsNavButtons.IMPORT);

        }, text: TextRes.importNewStudents),
        const SizedBox(height: Dimensions.spaceLarge,),
        BigButton(onPressed: (){}, text: TextRes.importNewAttributes)
      ],
    );
  }
}
