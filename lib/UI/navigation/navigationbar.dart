
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/book_view.dart';
import 'package:buecherteam_2023_desktop/UI/navigation/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Resources/dimensions.dart';
import '../student_view.dart';

class LfgNavigationBar extends StatefulWidget {
  const LfgNavigationBar({super.key});

  @override
  State<LfgNavigationBar> createState() => _LfgNavigationBarState();
}

class _LfgNavigationBarState extends State<LfgNavigationBar> {
  bool isStudentViewClicked = true;
  bool isBookViewClicked = false;

  void onStudentViewClicked () {
    setState(() {
      isStudentViewClicked = true;
      isBookViewClicked = false;
    });
    context.go(StudentView.routeName);
  }

  void onBookViewClicked () {
    setState(() {
      isBookViewClicked = true;
      isStudentViewClicked = false;
    });
    context.go(BookView.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.spaceMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NavigationButton(key: const Key(TextRes.student),
              isClicked: isStudentViewClicked,
              onClickAction: onStudentViewClicked,
              text: TextRes.student),
          const SizedBox(width: Dimensions.spaceMedium,),
          NavigationButton(key: const Key(TextRes.book),
              isClicked: isBookViewClicked,
              onClickAction: onBookViewClicked,
              text: TextRes.book)
        ],
      ),
    );
  }
}



