import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class TrainingDirectionButton extends StatelessWidget {
  const TrainingDirectionButton({super.key, required this.text, required this.isClicked, required this.onClick});

  final String text;
  final bool isClicked;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onClick,
        style: ButtonStyle(
            shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .circular(Dimensions.cornerRadiusSmall)
                )
            ),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.all(0)
            ),
            backgroundColor: MaterialStatePropertyAll(
                isClicked
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : null
            )
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
        )
    );
  }
}
