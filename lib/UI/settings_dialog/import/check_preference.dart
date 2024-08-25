import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class CheckPreference extends StatefulWidget {
  const CheckPreference({super.key, required this.onChanged, required this.text});

  final Function(bool updatedValue) onChanged;
  final String text;

  @override
  State<CheckPreference> createState() => _CheckPreferenceState();
}

class _CheckPreferenceState extends State<CheckPreference> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: isClicked,
            onChanged: (updatedValue) {
              widget.onChanged(updatedValue??false);
              setState(() {
                isClicked = updatedValue??false;
              });
            }),
        const SizedBox(width: Dimensions.spaceSmall,),
        Expanded(
          child: Card(
            elevation: Dimensions.elevationSmall,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingMedium),
              child: Text(
                widget.text,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        )
      ],
    );
  }
}
