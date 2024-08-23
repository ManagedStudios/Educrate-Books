import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class ChipDisplayCard extends StatelessWidget {
  const ChipDisplayCard({super.key, required this.chipText});

  final String chipText;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: Dimensions.elevationZero,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)),
      child: Padding(
        padding: const EdgeInsets.only(
            left: Dimensions.paddingSmall,
            right: Dimensions.paddingSmall,
            top: Dimensions.paddingVerySmall,
            bottom: Dimensions.paddingVerySmall),
        child: Text(
          chipText,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
