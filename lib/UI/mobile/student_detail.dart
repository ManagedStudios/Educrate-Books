
import 'package:buecherteam_2023_desktop/Models/studentListState.dart';
import 'package:buecherteam_2023_desktop/Models/student_detail_state.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/books/add_books_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/books/book_section.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/student_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Data/student.dart';
import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../desktop/student_detail/student_detail_tag_dropdown.dart';

class StudentDetail extends StatelessWidget {
  static String routeName = "/student-detail";
  const StudentDetail({super.key, required this.currStudentId});
  final String currStudentId;

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentListState>(
      builder: (context, state, _)
      {
        int currStudentIndex =
            state.students.indexWhere((student) => student.id == currStudentId);
        Student currStudent = state.students[currStudentIndex];
             return Padding(
               padding: const EdgeInsets.all(Dimensions.paddingSmall),
               child: Column(
                  children: [
                    Stack(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      context.pop(),
                                  icon: const Icon(Icons.arrow_back)),
                              Text(
                                "${currStudent.classLevel}${currStudent.classChar}",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                TextRes.next,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (currStudentIndex < state.students.length-1) {
                                      if (currStudent.classChar.isNotEmpty) {
                                        context.go("${StudentListView.routeName}/${currStudent.classLevel.toString()}/${currStudent.classChar}/${state.students[currStudentIndex+1].id}");
                                      } else {
                                        context.go("${StudentListView.routeName}/${currStudent.classLevel.toString()}/${state.students[currStudentIndex+1].id}");
                                      }
                                    } else {
                                      context.pop();
                                    }
                                  },

                                  icon: const Icon(Icons.arrow_forward)),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSmall),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${currStudent.firstName}\n${currStudent.lastName}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      )
                    ]),
                    const SizedBox(height: Dimensions.spaceMedium,),
                    SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                for(String tr in currStudent.trainingDirections)
                                  Text("$tr  ", style: Theme.of(context).textTheme.bodyMedium,)
                              ],),
                            ),
                            const SizedBox(height: Dimensions.spaceSmall,),
                            StudentDetailTagDropdown(
                              tags: currStudent.tags,
                              onTagAdded: (tag) {
                                Provider.of<StudentDetailState>(context, listen: false)
                                    .addTagToStudents([currStudent], tag);
                              } ,
                              onTagDeleted: (tag) {
                                Provider.of<StudentDetailState>(context, listen: false)
                                    .removeTagFromStudents([currStudent], tag);
                              },
                              onFocusChanged: (_) {},
                              width: MediaQuery.of(context).size.width*0.9,
                              offset: -Dimensions.paddingVeryBig,
                            ),

                            const SizedBox(height: Dimensions.spaceMedium,),

                          ],
                        ),
                      ),
                    Expanded(
                      child: BookSection(
                          student: currStudent,
                          onAddBooks: (){
                            context.push(AddBooksView.routeName, extra: currStudent);
                          },
                          onDeleteBooks: (books){
                            var state =
                            Provider.of<StudentDetailState>(context, listen: false);
                            state.deleteBooksOfStudents([currStudent], books);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                              child: IconButton(
                                  onPressed: () {
                                    StudentListState studentListState =
                                    Provider.of<StudentListState>(
                                      //delete the student
                                        context,
                                        listen: false);
                                    studentListState
                                        .deleteStudent(currStudent);
                                    if (currStudentIndex < state.students.length-1) {
                                      if (currStudent.classChar.isNotEmpty) {
                                        context.go("${StudentListView.routeName}/${currStudent.classLevel.toString()}/${currStudent.classChar}/${state.students[currStudentIndex+1].id}");
                                      } else {
                                        context.go("${StudentListView.routeName}/${currStudent.classLevel.toString()}/${state.students[currStudentIndex+1].id}");
                                      }
                                    } else {
                                      context.pop();
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  iconSize: Dimensions.iconSizeVeryBig,
                              )
                          )
                        ],
                      ),
                    )
                  ],


                ),
             );
            });
  }
}
