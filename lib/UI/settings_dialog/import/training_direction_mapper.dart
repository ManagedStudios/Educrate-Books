import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/settings/import_state.dart';
import '../../../Resources/dimensions.dart';
import 'attribute_mapper_list.dart';

class TrainingDirectionMapper extends StatelessWidget {
  const TrainingDirectionMapper({super.key});

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
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

                    },
                    width: availableWidth * 0.4),
              )),
        ),
      ],
    );
  }
}
