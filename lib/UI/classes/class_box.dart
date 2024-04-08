

import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class ClassBox extends StatelessWidget {
  const ClassBox({super.key, required this.classContent, required this.radius,
    required this.dark});

  final String classContent;
  final double radius;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius)
      ),
      margin: EdgeInsets.zero,
      color: dark
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.secondaryContainer,
      elevation: Dimensions.elevationZero,
      child: Container(
        height: Dimensions.boxWidthSmall,
        width: Dimensions.boxWidthSmall,
        alignment: Alignment.center,
        child: Text(
            classContent,
            style: Theme.of(context).textTheme.displayLarge
                      ?.copyWith(
                          color: dark
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context).colorScheme.onSecondaryContainer
                       ),
          ),
      ),
    );
  }
}
