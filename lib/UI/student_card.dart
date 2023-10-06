
import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatefulWidget {

  const StudentCard(this.student,
      this.isClicked,
      {super.key,
    required this.setClickedStudent,
    required this.notifyDetailPage,
    required this.onDeleteStudent,
    required this.openEditDialog});


  final Function(String id) setClickedStudent;
  final Function(Student currStudent) notifyDetailPage;
  final Function(Student currStudent) openEditDialog;
  final Function(Student currStudent) onDeleteStudent;

  final Student student;
  final bool isClicked;

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    String classRaw = widget.student.classLevel.toString();
    String classLevel = classRaw.length==1?"  $classRaw" : classRaw;
    return MouseRegion( //enable tracking hover states
      onEnter: (_) => setState(() {
        _hovering = true;
      }),
      onExit: (_) => setState(() {
        _hovering = false;
      }),
      child: Tooltip( //if name can't be fully displayed show tooltip
        message: "${widget.student.firstName} ${widget.student.lastName}",
        waitDuration: const Duration(seconds: 1),
        preferBelow: false,
        child: TextButton(onPressed: ()  { //TextButton acts as the base container providing out of the box click functionality as well as a hover state
          widget.setClickedStudent(widget.student.id);
          widget.notifyDetailPage(widget.student);
        },
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              backgroundColor: widget.isClicked ? MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiaryContainer) : const MaterialStatePropertyAll(Colors.transparent)
            ),

             /*
            High level layout: Row1<Row2<Column1,Column2<Text1, Row3>>, Column3<Row4>>
            First Column acts as leading text and shows class of student. It adds the appropriate
            horizontal space. Second column for student name and trainingDirections.
            Due to the horizontal space from the first column trainingDirections is
            aligned to the start of the student name. Both columns are packed into a row to group them together.
            Last Column consists of a row of the 2 action buttons for student. The first row spaces
            between the text group and the button group.

            Sizing: The student card takes up as much width as possible. Its size depends on other widgets and
            the margins which are set higher in the widget tree. The height of the card is adjusted to the content
             */

            child: Row( //1 Row
              crossAxisAlignment: CrossAxisAlignment.start, //crossAxis.start ensures that all the text is positioned the same way at the very top
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row( //2 Row
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column( //1 Column
                          children: [
                            Text("$classLevel${widget.student.classChar} — ",
                            style: Theme.of(context).textTheme.bodyLarge,)
                          ],
                        ),
                        Expanded(
                          child: Column( //2 Column
                            crossAxisAlignment: CrossAxisAlignment.start, //ensure that text is aligned left
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("${widget.student.firstName} ${widget.student.lastName}", //Text 1
                                        style: Theme.of(context).textTheme.bodyLarge,
                                        overflow: TextOverflow.ellipsis,),
                                  ),
                                ],
                              ),
                              Row( //3 Row
                                children: [
                                  for (var trainingDirection in widget.student.trainingDirections)
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Text("$trainingDirection  ",
                                          style: Theme.of(context).textTheme.labelSmall,
                                          overflow: TextOverflow.ellipsis,),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column( //Column 4
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: () => widget.openEditDialog(widget.student), icon: const Icon(Icons.edit),
                            style: ButtonStyle(
                              iconSize: _hovering ? const MaterialStatePropertyAll(16) : const MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),

                            ),
                          ),
                          IconButton(onPressed: () => widget.onDeleteStudent(widget.student), icon: const Icon(Icons.close),
                            style: ButtonStyle(
                              iconSize: _hovering ? const MaterialStatePropertyAll(16) : const MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
