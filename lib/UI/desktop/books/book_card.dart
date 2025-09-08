import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

import '../../../Resources/text.dart';

class BookCard extends StatefulWidget {
  const BookCard(
      {super.key,
      required this.clicked,
      required this.onClick,
      required this.onDeleteBook,
      required this.bookLite,
      required this.leadingWidget,
      required this.isDeletable,
      required this.bookAvailableAmount,
      this.error});

  final bool clicked; //state to determine the border
  final BookLite bookLite; //content
  final Widget? leadingWidget; //conditional content
  final Function(BookLite bookLite) onClick; //callback
  final Function(BookLite bookLite) onDeleteBook; //callback
  final bool isDeletable; //conditional content
  final int? bookAvailableAmount; //conditional content
  final bool? error; //state to determine border color

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    BorderSide border = BorderSide.none;
    if (widget.error != null && widget.error == true && !widget.clicked) {
      border = BorderSide(
          width: Dimensions.borderWidthMedium,
          color: Theme.of(context).colorScheme.error);
    }
    if (widget.clicked) {
      border = const BorderSide(width: Dimensions.borderWidthMedium);
    }
    return Card(
      elevation: Dimensions.elevationVerySmall,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.cornerRadiusMedium),
          side: border),
      child: TextButton(
        //make the card clickable
        onPressed: () => widget.onClick(widget.bookLite),
        style: const ButtonStyle(
            padding: WidgetStatePropertyAll(//custom padding
                EdgeInsets.only(
                    left: Dimensions.paddingSmall,
                    top: Dimensions.paddingVerySmall,
                    bottom: Dimensions.paddingVerySmall,
                    right: Dimensions.paddingBetweenVerySmallAndSmall))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, //delete button on the very right, content on the very left
          children: [
            Expanded(
              //content should take up as much space as possible
              child: Row(
                //group content
                children: [
                  if (widget.leadingWidget !=
                      null) //show leading widget on demand
                    widget.leadingWidget!,
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.leadingWidget == null
                            ? Dimensions.paddingSmall
                            : 0),
                    child: Text(
                        "${widget.bookLite.subject} ${widget.bookLite.classLevel}  ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(widget.bookLite.name,
                              style: Theme.of(context).textTheme.labelSmall,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: Dimensions.spaceSmall,),
                        if (widget.bookLite.satzNummer != null)
                          Text("${widget.bookLite.satzNummer}${TextRes.dot} ${TextRes.satz}",
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isDeletable)
              IconButton(
                onPressed: () => widget
                    .onDeleteBook(widget.bookLite), //propagate delete call
                icon: const Icon(Icons.close),
                constraints: const BoxConstraints(
                    //determine button size so button is not too big
                    maxWidth: Dimensions.iconButtonSizeMedium,
                    maxHeight: Dimensions.iconButtonSizeMedium),
                iconSize: Dimensions.iconSizeSmall,
              )
            else if (widget.bookAvailableAmount != null)
              Text("| ${widget.bookAvailableAmount}")
          ],
        ),
      ),
    );
  }
}
