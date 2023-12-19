import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class BookCard extends StatefulWidget {
  const BookCard({super.key, required this.clicked, required this.onClick,
    required this.onDeleteBook, required this.bookLite,
    required this.leadingWidget, required this.isDeletable,
    required this.bookAvailableAmount});

  final bool clicked; //state
  final BookLite bookLite; //content
  final Widget? leadingWidget; //conditional content
  final Function(BookLite bookLite) onClick; //callback
  final Function(BookLite bookLite) onDeleteBook; //callback
  final bool isDeletable; //conditional content
  final int? bookAvailableAmount; //conditional content


  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Dimensions.elevationVerySmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.cornerRadiusMedium),
        side: widget.clicked //when clicked, show border else not
          ? const BorderSide(width: Dimensions.borderWidthMedium)
            :BorderSide.none
      ),
      child: TextButton( //make the card clickable
        onPressed: () => widget.onClick(widget.bookLite),
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll( //custom padding
              EdgeInsets.only(
                left: Dimensions.paddingSmall,
                top: Dimensions.paddingVerySmall,
                bottom: Dimensions.paddingVerySmall,
                right: Dimensions.paddingBetweenVerySmallAndSmall
              )
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //delete button on the very right, content on the very left
            children: [
              Expanded( //content should take up as much space as possible
                child: Row( //group content
                  children: [
                    if(widget.leadingWidget != null) //show leading widget on demand
                        widget.leadingWidget!,

                    Text("${widget.bookLite.subject} ${widget.bookLite.classLevel}  ",
                        style: Theme.of(context).textTheme.bodyLarge),
                    Flexible( //names can be very long - show ... when too long
                      fit: FlexFit.loose,
                      child: Text(widget.bookLite.name,
                          style: Theme.of(context).textTheme.labelSmall,
                      overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              if(widget.isDeletable)
                IconButton(onPressed: () => widget.onDeleteBook(widget.bookLite), //propagate delete call
                  icon: const Icon(Icons.close),
              constraints: const BoxConstraints( //determine button size so button is not too big
                maxWidth: Dimensions.iconButtonSizeMedium,
                maxHeight: Dimensions.iconButtonSizeMedium
              ),
              iconSize: Dimensions.iconSizeSmall,
              )
              else if(widget.bookAvailableAmount != null)
                Text("| ${widget.bookAvailableAmount}")

            ],
          ),
      ),
    );
  }
}
