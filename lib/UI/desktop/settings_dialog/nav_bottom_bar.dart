import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBottomBar extends StatelessWidget {
  const NavBottomBar(
      {super.key,
      required this.nextWidget,
      required this.previousWidget,
      this.error});

  final MapEntry<SettingsNavButtons, Widget> nextWidget;
  final MapEntry<SettingsNavButtons, Widget> previousWidget;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                      Provider.of<SettingsNavState>(context, listen: false)
                          .setCurrWidget(previousWidget.value, previousWidget.key);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_outlined,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(
                        width: Dimensions.spaceVerySmall,
                      ),
                      Text(
                        TextRes.back,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    if (error == null) {
                      Provider.of<SettingsNavState>(context, listen: false)
                          .setCurrWidget(nextWidget.value, nextWidget.key);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TextRes.next,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const SizedBox(
                        width: Dimensions.spaceVerySmall,
                      ),
                      Icon(
                        Icons.arrow_forward_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ],
                  ))
            ],
          ),
          if (error != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  error!,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                )
              ],
            )
        ],
      ),
    );
  }
}
