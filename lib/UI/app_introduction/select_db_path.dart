import 'package:buecherteam_2023_desktop/Models/app_introduction_state.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectDbPath extends StatelessWidget {
  const SelectDbPath({super.key});

  static String routeName = TextRes.introPaths[0];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
            onPressed: () {
              Provider.of<AppIntroductionState>(context, listen: false)
                  .getAndSavePath();
            },
            child: const Text(
              TextRes.selectPath
            )
        ),
        Consumer<AppIntroductionState>(
          builder: (contex, state, _) {
            if (state.selectedPath != null) {
              return Text(state.selectedPath!);
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }
}
