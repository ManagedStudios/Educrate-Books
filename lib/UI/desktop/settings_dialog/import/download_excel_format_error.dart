import 'package:buecherteam_2023_desktop/Models/settings/import_state.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/settings_dialog/import/training_direction_mapper.dart';
import 'package:buecherteam_2023_desktop/Util/lfg_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/settings/settings_nav_state.dart';
import '../nav_bottom_bar.dart';


class DownloadExcelFormatError extends StatelessWidget {
  const DownloadExcelFormatError({super.key, required this.previousWidget, required this.importFunction});

  final MapEntry<SettingsNavButtons, Widget> previousWidget;
  final Future<bool> Function() importFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Text(
          TextRes.downloadExcelFormatError
        ),
        OutlinedButton(
            onPressed: () async{
              final saved = await Provider.of<ImportState>(context, listen: false)
                  .downloadExcelFormatErrorFile();
            if (saved) {
              showLFGSnackbar(context, TextRes.fileSaved);
            }
           },

            child: const Text (TextRes.download)
        ),
        const Spacer(),
         NavBottomBar(
            nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                TrainingDirectionMapper(previousWidget: MapEntry(SettingsNavButtons.IMPORT, this),
                  importFunction: importFunction,) ),
            previousWidget: previousWidget
        ),
      ],
    );
  }
}
