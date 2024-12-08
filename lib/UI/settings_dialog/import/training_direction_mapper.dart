import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/settings/import_state.dart';
import '../../../Models/settings/settings_nav_state.dart';
import '../../../Resources/dimensions.dart';
import '../../../Resources/text.dart';
import '../nav_bottom_bar.dart';
import 'attribute_mapper_list.dart';
import 'import_error_screen.dart';
import 'loading.dart';

class TrainingDirectionMapper extends StatelessWidget {
  const TrainingDirectionMapper({super.key, required this.previousWidget});

  final MapEntry<SettingsNavButtons, Widget> previousWidget;

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    final stateListenFalse = Provider.of<ImportState>(context, listen: false);
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(
                  top: Dimensions.paddingSmall,
                  left: Dimensions.paddingVeryBig,
                  right: Dimensions.paddingVeryBig
              ),
              child: Consumer<ImportState>(
                builder: (context, state, _) => AttributeMapperList<TrainingDirectionsData>(
                    availableDropdownItems: state.availableTrainingDirections,
                    initialMap: state.currTrainingDirectionMap,
                    onUpdatedMap: (updatedMap) {
                        state.setCurrTrainingDirectionMap(updatedMap);
                    },
                    width: availableWidth * 0.4),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSmall),
          child: NavBottomBar(
            nextWidget: MapEntry(SettingsNavButtons.IMPORT,
                Loading(
                  functionToBeExecuted: () => stateListenFalse
                                                  .importStudents(),
                  nextWidget: const MapEntry(SettingsNavButtons.IMPORT, SuccessScreen()),
                  fallbackWidget: const MapEntry(SettingsNavButtons.IMPORT, ImportErrorScreen()),
                  goToFallbackText: TextRes.goToImportError,
                )
            ),
            previousWidget: previousWidget,
          ),
        )
      ],
    );
  }
}
