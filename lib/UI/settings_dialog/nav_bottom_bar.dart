import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBottomBar extends StatelessWidget {
  const NavBottomBar({super.key, required this.nextWidget, required this.previousWidget});

  final Widget nextWidget;
  final Widget previousWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () =>
              Provider.of<SettingsNavState>(context, listen: false)
                      .setCurrWidget(previousWidget),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_outlined,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: Dimensions.spaceVerySmall,),
                  Text(
                    TextRes.back,
                    style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color:
                                Theme.of(context).colorScheme.secondary),
                  ),
                ],
              )
          ),
          TextButton(onPressed: () =>
              Provider.of<SettingsNavState>(context, listen: false)
                  .setCurrWidget(nextWidget),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    TextRes.next,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color:
                    Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(width: Dimensions.spaceVerySmall,),
                  Icon(Icons.arrow_forward_outlined,
                      color: Theme.of(context).colorScheme.secondary,)
                ],
              )
          )
        ],
      ),
    );
  }
}
