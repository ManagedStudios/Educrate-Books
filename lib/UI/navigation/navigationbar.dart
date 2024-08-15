
import 'package:buecherteam_2023_desktop/Models/navigation_state.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/book_depot_view.dart';
import 'package:buecherteam_2023_desktop/UI/navigation/navigation_button.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Resources/dimensions.dart';
import '../student_view.dart';

class LfgNavigationBar extends StatelessWidget {
  const LfgNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.spaceMedium),
      child: Consumer<NavigationState>(
        builder: (context, state, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            NavigationButton(key: const Key(TextRes.student),
                isClicked: state.isStudentViewClicked,
                onClickAction: () {
                  state.onStudentViewClicked();
                  context.go(StudentView.routeName);
                },
                text: TextRes.student),
            const SizedBox(width: Dimensions.spaceMedium,),
            NavigationButton(key: const Key(TextRes.books),
                isClicked: state.isBookViewClicked,
                onClickAction: () {
                  state.onBookViewClicked();
                  context.go(BookDepotView.routeName);
                },
                text: TextRes.books),
            const Spacer(),
            Tooltip(
              message: TextRes.settingsTooltip,
              child: IconButton(onPressed: (){
                showDialog(context: context,
                    builder: (context) => SettingsDialog());
              }, icon: const Icon(Icons.settings)),
            ),
            const SizedBox(width: Dimensions.spaceMedium,)
          ],
        ),
      ),
    );
  }
}



