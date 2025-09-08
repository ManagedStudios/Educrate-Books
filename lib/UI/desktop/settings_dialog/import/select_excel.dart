import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/header_to_attribute_mapper.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/common/loading.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/nav_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Resources/text.dart';

class SelectExcel extends StatelessWidget {
  const SelectExcel({super.key, required this.previousWidget, required this.importFunction});

  final MapEntry<SettingsNavButtons, Widget> previousWidget;
  final Future<bool> Function() importFunction;

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
                nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                    Loading(
                        functionToBeExecuted: state.getExcelHeaders,
                        nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                            HeaderToAttributeMapper(previousWidget: MapEntry(SettingsNavButtons.IMPORT, this), importFunction: importFunction)
                        ),
                        fallbackWidget: MapEntry(SettingsNavButtons.IMPORT, this
                        )
                    )
                ),
                previousWidget: previousWidget,
                error: state.selectExcelFileError
            ),
          )
        ],
      ),
    );
  }
}
