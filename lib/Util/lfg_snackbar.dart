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
