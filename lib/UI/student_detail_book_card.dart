import 'package:buecherteam_2023_desktop/Data/bookLite.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:flutter/material.dart';

class StudentDetailBookCard extends StatefulWidget {
  const StudentDetailBookCard({super.key, required this.clicked, required this.onClick, required this.onDeleteBook, required this.bookLite, this.studentOwnerNum});

  final bool clicked; //state
  final BookLite bookLite; //content
  final int? studentOwnerNum; //content
  final Function() onClick; //callback
  final Function(BookLite bookLite) onDeleteBook; //callback

  @override
  State<StudentDetailBookCard> createState() => _StudentDetailBookCardState();
}

class _StudentDetailBookCardState extends State<StudentDetailBookCard> {
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
        onPressed: widget.onClick,
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll( //custom padding
              EdgeInsets.only(
                left: Dimensions.paddingMedium,
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
                    if(widget.studentOwnerNum != null) //when multiple students selected: Show number how many of them have this specific book
                      Text("${widget.studentOwnerNum.toString()} | ",
                      style: Theme.of(context).textTheme.displaySmall,),

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
              IconButton(onPressed: () => widget.onDeleteBook(widget.bookLite), //propagate delete call
                  icon: const Icon(Icons.close),
              constraints: const BoxConstraints( //determine button size so button is not too big
                maxWidth: Dimensions.iconButtonSizeMedium,
                maxHeight: Dimensions.iconButtonSizeMedium
              ),
              iconSize: Dimensions.iconSizeSmall,
              )
            ],
          ),
      ),
    );
  }
}
