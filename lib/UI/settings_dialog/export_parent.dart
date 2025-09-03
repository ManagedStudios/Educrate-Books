import 'package:buecherteam_2023_desktop/Models/settings/export_state.dart';
import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/common/big_button.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/common/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';

class ExportParent extends StatelessWidget {
  const ExportParent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(

      children: [
        const SizedBox(height: Dimensions.spaceLarge,),
        Align(
          child: BigButton(
              onPressed: () {
                final exportState = Provider.of<ExportState>(context,
                    listen: false);
                Provider.of<SettingsNavState>(context, listen: false)
                    .setCurrWidget(
                      Loading(
                          functionToBeExecuted: exportState.downloadAllBooksExcel,
                          nextWidget: const MapEntry(
                              SettingsNavButtons.EXPORT,
                              ExportParent()),
                          fallbackWidget: const MapEntry(
                              SettingsNavButtons.EXPORT,
                              ExportParent()),
                      ),
                    SettingsNavButtons.EXPORT);
              },
              text: TextRes.exportAllBooks),
        ),
        const SizedBox(height: Dimensions.spaceLarge,),
        Align(
          child: BigButton(
              onPressed: () {
                final exportState = Provider.of<ExportState>(context,
                    listen: false);
                Provider.of<SettingsNavState>(context, listen: false)
                    .setCurrWidget(
                    Loading(
                      functionToBeExecuted: exportState.downloadAllBasicBookLists,
                      nextWidget: const MapEntry(
                          SettingsNavButtons.EXPORT,
                          ExportParent()),
                      fallbackWidget: const MapEntry(
                          SettingsNavButtons.EXPORT,
                          ExportParent()),
                    ),
                    SettingsNavButtons.EXPORT);
              },
              text: TextRes.exportBasicBooksToPdf),
        ),
        const SizedBox(height: Dimensions.spaceLarge,),
        Align(
          child: BigButton(
              onPressed: () {
                final exportState = Provider.of<ExportState>(context,
                    listen: false);
                Provider.of<SettingsNavState>(context, listen: false)
                    .setCurrWidget(
                    Loading(
                      functionToBeExecuted: exportState.downloadClassLists,
                      nextWidget: const MapEntry(
                          SettingsNavButtons.EXPORT,
                          ExportParent()),
                      fallbackWidget: const MapEntry(
                          SettingsNavButtons.EXPORT,
                          ExportParent()),
                    ),
                    SettingsNavButtons.EXPORT);
              },
              text: TextRes.exportClassLists),
        )

      ],
    );
  }
}
