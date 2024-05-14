
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:flutter/material.dart';

class LfgSearchbar extends StatefulWidget {
  const LfgSearchbar({super.key, required this.onChangeText, required this.amountOfFilteredItems, required this.onFocusChange, required this.onTap, required this.amountType});

  final Function(String search) onChangeText;
  final Function (bool focused) onFocusChange;
  final Function () onTap;
  final int amountOfFilteredItems; //amount of students/books that are retrieved after applying filters
  final String amountType;
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
            elevation: const WidgetStatePropertyAll(Dimensions.elevationMedium),
            textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelMedium),
            hintStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            leading: const Padding(
              padding: EdgeInsets.all(Dimensions.paddingSmall),
              child: Icon(Icons.search, size: 28,),
            ),
            trailing: [Padding( //trailing displays the amount of students
              padding: const EdgeInsets.all(Dimensions.paddingSmall),
              child: Text("${widget.amountOfFilteredItems} ${widget.amountType}",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.surfaceTint),
                overflow: TextOverflow.ellipsis,),
            )],
            surfaceTintColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surface),
            overlayColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.surfaceContainerHighest),
            onSubmitted: (text) => textEditingController.clear(), //on enter searchbar should be cleared
            onChanged: widget.onChangeText, //search while typing
          );
  }
}
