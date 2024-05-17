
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

void showBookNotDeletableSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(TextRes.bookNotDeletable),
        margin: EdgeInsets.only(left: Dimensions.largeMargin,
            right: Dimensions.largeMargin,
            bottom: Dimensions.minMarginStudentView
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.cornerRadiusSmall))),
        padding: EdgeInsets.all(Dimensions.paddingMedium),
      )
  );
}