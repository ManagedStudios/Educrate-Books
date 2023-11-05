import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, required this.onClick});

  final String label;
  final Function () onClick;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(onPressed: onClick,
              style: ButtonStyle(
                alignment: Alignment.centerLeft,
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.cornerRadiusSmall)
                  )
                )
              ),
              child: Text(
                label
              )
          ),
        ),
      ],
    );
  }
}
