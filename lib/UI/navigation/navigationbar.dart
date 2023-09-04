
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/navigation/navigation_button.dart';
import 'package:flutter/material.dart';

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
  }

  void onBookViewClicked () {
    setState(() {
      isBookViewClicked = true;
      isStudentViewClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationButton(key: const Key(TextRes.student),
            isClicked: isStudentViewClicked,
            onClickAction: onStudentViewClicked,
            text: TextRes.student),
        NavigationButton(key: const Key(TextRes.book),
            isClicked: isBookViewClicked,
            onClickAction: onBookViewClicked,
            text: TextRes.book)
      ],
    );
  }
}



