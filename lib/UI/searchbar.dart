
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

class LfgSearchbar extends StatefulWidget {
  const LfgSearchbar({super.key, required this.onChangeText, required this.amountOfFilteredStudents, required this.onFocusChange, required this.onTap});

  final Function(String search) onChangeText;
  final Function (bool focused) onFocusChange;
  final Function () onTap;
  final int amountOfFilteredStudents; //amount of students that are retrieved after applying filters
  @override
  State<LfgSearchbar> createState() => _LfgSearchbarState();
}

class _LfgSearchbarState extends State<LfgSearchbar> {

  late TextEditingController textEditingController;
  late FocusNode focusNode;


  @override
  void initState() {
    super.initState();
     textEditingController = TextEditingController();
     focusNode = FocusNode();
     focusNode.attach(context);
     focusNode.addListener(() {
        widget.onFocusChange(focusNode.hasFocus);
     });

  }


  @override
  Widget build(BuildContext context) {
    return SearchBar(
            controller: textEditingController,
            hintText: TextRes.studentSearchHint,
            focusNode: focusNode,
            onTap: widget.onTap,
            elevation: const MaterialStatePropertyAll(Dimensions.elevationMedium),
            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.labelMedium),
            hintStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            leading: const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSmall),
              child: Icon(Icons.search, size: 28,),
            ),
            trailing: [Padding( //trailing displays the amount of students
              padding: const EdgeInsets.all(Dimensions.paddingSmall),
              child: Text("${widget.amountOfFilteredStudents} ${TextRes.student}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surfaceTint),
                overflow: TextOverflow.ellipsis,),
            )],
            surfaceTintColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),
            overlayColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surfaceVariant),
            onSubmitted: (text) => textEditingController.clear(), //on enter searchbar should be cleared
            onChanged: widget.onChangeText, //search while typing
          );
  }
}
