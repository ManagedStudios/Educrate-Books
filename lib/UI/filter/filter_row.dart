import 'package:buecherteam_2023_desktop/UI/filter/add_filter_button.dart';
import 'package:buecherteam_2023_desktop/UI/filter/standard_filter_button.dart';
import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingVerySmall, bottom: Dimensions.paddingSmall),
      child: Row(
        children: [
          StandardFilterButton(
              onClick: (click){},
              active: true,
              standardText: "standardText"),
          const SizedBox(width: Dimensions.spaceVerySmall,),
          Expanded(child: AddFilterButton(globalKey: GlobalKey(), onClick: (){}))

        ],
      ),
    );
  }
}
