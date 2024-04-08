import 'package:buecherteam_2023_desktop/UI/chips/chip_display_card.dart';
import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class ChipDisplayRow extends StatelessWidget {
  const ChipDisplayRow({super.key, required this.chips});

  final List<String> chips;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        children: [
          for (String chip in chips)
            ...[
              ChipDisplayCard(chipText: chip),
              const SizedBox(width: Dimensions.paddingSmall,)
            ]


        ],
      ),
    );
  }
}
