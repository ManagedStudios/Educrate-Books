import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/import_preferences.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/nav_bottom_bar.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/warning_parent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Resources/text.dart';

class SelectExcel extends StatelessWidget {
  const SelectExcel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          OutlinedButton(onPressed: () async{
              Provider.of<ImportState>(context, listen: false)
                  .getImportFile();
          },
              child: const Text(TextRes.openExcelFileLabel)
          ),
          Consumer<ImportState>(
            builder: (context, state, _) {
              if (state.importFileName != null) {
                return Text("${state.importFileName} ${TextRes.selected}");
              } else {
                return Container();
              }
            },
          ),
          const Spacer(),
          Consumer<ImportState>(
            builder: (context, state, _) => NavBottomBar(
                nextWidget: const MapEntry(SettingsNavButtons.MAHNUNG, WarningParent()),
                previousWidget: const MapEntry(SettingsNavButtons.IMPORT, ImportPreferences()),
                error: state.selectExcelFileError
            ),
          )
        ],
      ),
    );
  }
}
