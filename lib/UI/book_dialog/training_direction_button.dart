import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

/*
trainingDirectionButton is a button that is used to select the front part of training directions
 */

class TrainingDirectionButton extends StatelessWidget {
  const TrainingDirectionButton(
      {super.key,
      required this.text,
      required this.isClicked,
      required this.onClick});

  final String text;
  final bool isClicked;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onClick,
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(Dimensions.cornerRadiusSmall))),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.all(Dimensions.paddingBetweenVerySmallAndSmall)),
          backgroundColor: MaterialStatePropertyAll(isClicked
              ? Theme.of(context).colorScheme.secondaryContainer
              : null)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
