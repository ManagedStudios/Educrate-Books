import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

import '../../Resources/text.dart';

class AddFilterButton extends StatelessWidget {
  const AddFilterButton({super.key, required this.globalKey, required this.onClick});
  final GlobalKey globalKey;
  final Function () onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        key: globalKey, //identify the button to position the add filter overlay
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall))
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(Dimensions.paddingVerySmall))
        ),
        onPressed: onClick,
        child: Row(
          children: [
            Icon(Icons.add, size: Dimensions.iconSizeVerySmall, color: Theme.of(context).colorScheme.outline,),
            const SizedBox(width: Dimensions.spaceVerySmall,),
            Text(TextRes.addFilter,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.outline),)
          ],
        )
    );
  }
}
