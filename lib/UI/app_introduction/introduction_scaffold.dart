import 'package:buecherteam_2023_desktop/Models/app_introduction_state.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroductionScaffold extends StatelessWidget {
  const IntroductionScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size availableSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: availableSize.width * 0.8,
                height: availableSize.height * 0.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadiusBetweenSmallAndMedium),
                  border: Border.all(width: Dimensions.borderWidthMedium)
                ),
                child: child,
              ),
            ),
            const SizedBox(
              height: Dimensions.spaceMedium,
            ),
            OutlinedButton(
                onPressed: (){
                  Provider.of<AppIntroductionState>(context, listen: false)
                      .goToNextPage(context);
                },
                child: const SizedBox(
                  width: Dimensions.boxWidthSmall,
                  child: Icon(Icons.arrow_forward_outlined),
                )
            ),
            Consumer<AppIntroductionState>(
              builder: (contex, state, _) {
                if (state.currError != null) {
                  return Text(
                    state.currError!,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
      ),
    );
  }
}
