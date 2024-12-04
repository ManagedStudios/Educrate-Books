import 'package:flutter/material.dart';

import '../Resources/dimensions.dart';

void showLFGSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    margin: const EdgeInsets.only(
        left: Dimensions.largeMargin,
        right: Dimensions.largeMargin,
        bottom: Dimensions.minMarginStudentView),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(Dimensions.cornerRadiusSmall))),
    padding: const EdgeInsets.all(Dimensions.paddingMedium),
  ));
}

void showNotificationSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodySmall,),
      ],
    ),
    width: Dimensions.widthMedium,
    backgroundColor: Theme.of(context).colorScheme.background,
    elevation: Dimensions.elevationSmall,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius:
        BorderRadius.all(Radius.circular(Dimensions.cornerRadiusBig))),
    padding: const EdgeInsets.all(Dimensions.paddingMedium),
  ));
}
