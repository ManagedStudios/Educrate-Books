import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';

class ClassLevelCard extends StatelessWidget {
  const ClassLevelCard({super.key, required this.classLevel, required this.onClick, required this.clicked});

  final int classLevel;
  final Function(int level) onClick;
  final bool clicked;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSmall),
      child: Card(
        elevation: Dimensions.elevationVerySmall,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall),
              side: clicked //when clicked, show border else not
                  ? BorderSide(width: Dimensions.borderWidthMedium,
                  color: Theme.of(context).colorScheme.secondary)
                  :BorderSide.none
          ),
        child: TextButton(
                onPressed: () => onClick(classLevel),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)
                      )
                  )
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "$classLevel${TextRes.classLevel}",
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]
                ),

        ),
      ),
    );
  }
}
