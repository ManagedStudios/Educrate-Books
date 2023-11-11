
import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';

class StandardFilterButton extends StatefulWidget {
  const StandardFilterButton({super.key, required this.onClick,
    required this.active,
    required this.standardText});
  final Function (bool clicked) onClick;
  final bool active;
  final String standardText;

  @override
  State<StandardFilterButton> createState() => _StandardFilterButtonState();
}

class _StandardFilterButtonState extends State<StandardFilterButton> {

  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
        label: Text(widget.standardText),
        labelStyle: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.secondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.cornerRadiusMedium)),
        side: BorderSide(color: theme.colorScheme.secondary, width: Dimensions.lineWidth),
        padding: const EdgeInsets.all(Dimensions.paddingBetweenVerySmallAndSmall), //controls the size of the checkmark icon
        selected: clicked,
        checkmarkColor: theme.colorScheme.secondary,
        onSelected: widget.active //disable chip when required
          ?(bool selected) {
          setState(() {
            clicked = selected;
          });
          widget.onClick(selected);
    }
    :null
    );
  }
}
