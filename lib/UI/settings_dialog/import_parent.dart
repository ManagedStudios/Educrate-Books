import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/nav_bottom_bar.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/print_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/warning_parent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImportParent extends StatelessWidget {
  const ImportParent({super.key});



  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

            ],
          ),
        ),
         const Spacer(),

         NavBottomBar(nextWidget: PrintParent(),
             previousWidget: WarningParent())
      ],
    );
  }
}
