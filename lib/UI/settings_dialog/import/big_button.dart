

import 'package:flutter/material.dart';

import '../../../Resources/dimensions.dart';


class BigButton extends StatelessWidget {
  const BigButton({super.key, required this.onPressed, required this.text});

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius
                  .circular(Dimensions.cornerRadiusBetweenSmallAndMedium)
            )
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(width: Dimensions.borderWidthMedium)
          )
        ),
        child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingMedium),
            child: Text(
              text,
              style: Theme.of(context)
                        .textTheme
                        .displayLarge  ,
            ),
        )
    );
  }
}
