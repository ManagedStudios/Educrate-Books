import 'package:flutter/material.dart';

import '../../../Resources/dimensions.dart';
import '../../../Resources/text.dart';

class SwitchBook extends StatelessWidget {
  const SwitchBook({super.key, required this.onSwitchBookView});

  final Function() onSwitchBookView;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  TextRes.classLevels,
                  style: Theme.of(context).textTheme.displayLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                message: TextRes.switchStackBookView,
                child: IconButton(
                    onPressed: onSwitchBookView,
                    icon: const Icon(Icons.compare_arrows,
                        size: Dimensions.iconButtonSizeMedium)),
              )
            ]),
        const SizedBox(
          height: Dimensions.spaceMedium,
        ),
      ],
    );
  }
}
