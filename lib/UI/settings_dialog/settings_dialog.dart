import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/text.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width * 0.5 > 500
        ? MediaQuery.of(context).size.width * 0.7
        : 700;
    double dialogHeight = MediaQuery.of(context).size.height * 0.7;
    return Dialog(
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.paddingVeryBig,
              right: Dimensions.paddingVeryBig,
              top: Dimensions.paddingMedium,
              bottom: Dimensions.paddingSmall
            ),
            child: Consumer<SettingsNavState>(
              builder: (context, state, _) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i<SettingsNavButtons.values.length; i++)
                            ...[
                              TextButton(onPressed: () =>
                                  state.navigateTo(SettingsNavButtons.values[i]),
                                  child: Text(
                                    SettingsNavButtons.values[i].value,
                                    style: state.selectedButton==SettingsNavButtons.values[i]
                                        ? Theme.of(context).textTheme.bodyLarge
                                        : Theme.of(context).textTheme.bodyMedium,
                                  )
                              ),
                              if (i != SettingsNavButtons.values.length-1)
                                ...[
                                  const SizedBox(width: Dimensions.paddingSmall,),
                                  Text(
                                    TextRes.seperator,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: Dimensions.paddingSmall,)
                                ]
                            ]
                        ],
                      )

                    ],
                  ),
                  state.currWidget
                ],
              ),
            ),
          ),
        ),
      );
  }
}
