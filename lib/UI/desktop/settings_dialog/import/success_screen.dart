import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../Resources/dimensions.dart';
import '../../../../Resources/text.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline_rounded),
        const SizedBox(height: Dimensions.spaceSmall,),
        const Text(TextRes.importSuccess),
        const SizedBox(height: Dimensions.spaceSmall,),
        OutlinedButton(
            onPressed: () {
              Provider.of<SettingsNavState>(context, listen: false)
                      .navigateTo(SettingsNavButtons.IMPORT);
              context.pop();
            },
            child: const Text(
              TextRes.finishImport
            )
        )

      ],
    );
  }
}
