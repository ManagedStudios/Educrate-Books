import 'package:buecherteam_2023_desktop/Models/settings/settings_nav_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, required this.functionToBeExecuted, required this.nextWidget, required this.fallbackWidget, this.progressInformation});
  
  final Future<bool> Function() functionToBeExecuted;
  final MapEntry<SettingsNavButtons, Widget> nextWidget;
  final MapEntry<SettingsNavButtons, Widget> fallbackWidget;
  final Widget? progressInformation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: functionToBeExecuted(),
        builder: (context, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            // Automatically redirect to new Widget after the current frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<SettingsNavState>(context, listen: false)
                  .setCurrWidget(nextWidget.value, nextWidget.key);
            });
              children = [
                  const Icon(Icons.check_circle_outline_rounded),
                  const Text(TextRes.success)
              ];
            } else if (snapshot.hasError) { //show user the error of the function that should be executed
            children = [
              const Icon(Icons.error_outline_rounded),
              const SizedBox(height: Dimensions.spaceSmall,),
              Text(snapshot.error.toString()),
              const SizedBox(height: Dimensions.spaceSmall,),
              OutlinedButton(onPressed: () { //go back to the previous widget (fallback widget) and try again
                Provider.of<SettingsNavState>(context, listen: false)
                    .setCurrWidget(fallbackWidget.value, nextWidget.key);
              }, child: const Text(TextRes.back))
            ];
          } else { //show loading screen
            children = [
              LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).colorScheme.onSurface,
                  size: Dimensions.iconSizeVeryBig),
              if (progressInformation != null)
                  progressInformation!
            ];
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );
          }
        );
  }
}
