import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/common/input/check_preference.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/select_excel.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import_parent.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/nav_bottom_bar.dart';
import 'package:flutter/material.dart';

class ImportPreferences extends StatelessWidget {
  const ImportPreferences({super.key, required this.importFunction, required this.checkPreferences});

  final Future<bool> Function() importFunction;
  final List<CheckPreference> checkPreferences;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: Column(

        children: [
          for (CheckPreference preference in checkPreferences)
            ...[
              preference,
              const SizedBox(height: Dimensions.spaceMedium,)
            ]
          ,
          const Spacer(),
          NavBottomBar(
              nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                  SelectExcel(previousWidget: MapEntry(SettingsNavButtons.IMPORT, this),
                    importFunction: importFunction)
              ),
              previousWidget: const MapEntry(SettingsNavButtons.IMPORT, ImportParent()))
        ],
      ),
    );
  }
}
