
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

class LfgSearchbar extends StatelessWidget {
  LfgSearchbar({super.key, required this.onChangeText, required this.amountOfFilteredStudents});

  final Function(String search) onChangeText;
  final int amountOfFilteredStudents;

  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: textEditingController,
            hintText: TextRes.studentSearchHint,
            elevation: const MaterialStatePropertyAll(4),
            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.labelMedium),
            hintStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            leading: const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSmall),
              child: Icon(Icons.search, size: 28,),
            ),
            trailing: [Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSmall),
              child: Text("$amountOfFilteredStudents ${TextRes.student}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surfaceTint)),
            )],
            surfaceTintColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
            overlayColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surfaceVariant),
            onSubmitted: (text) => textEditingController.clear(),
            onChanged: onChangeText,
          ),
        ),
      ],
    );
  }
}
