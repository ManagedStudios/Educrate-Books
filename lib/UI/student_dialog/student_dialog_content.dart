import 'package:buecherteam_2023_desktop/Data/class_data.dart';

import 'package:buecherteam_2023_desktop/Data/student.dart';
import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/input/dialog_text_field.dart';
import 'package:buecherteam_2023_desktop/UI/tag_dropdown/dropdown.dart';
import 'package:flutter/material.dart';


/*
  StudentDialogContent holds all of the content for a dialog to
  create or update a student
 */

class StudentDialogContent extends StatefulWidget {


  const StudentDialogContent({super.key, this.student,
    required this.classes, required this.onStudentClassUpdated,
    required this.trainingDirections,
    required this.onStudentTrainingDirectionsUpdated,
    this.firstNameError, this.lastNameError, this.classError,
    required this.onFirstNameChanged, required this.onLastNameChanged,
    required this.loading, required this.studentClass});

  final Student? student; //update => existing student passed

  final List<ClassData> studentClass;

  final Function(String firstName) onFirstNameChanged;
  final Function(String lastName) onLastNameChanged;

  final List<ClassData> classes;
  final Function(ClassData? classData) onStudentClassUpdated;

  final Function(List<TrainingDirectionsData> trainingDirections) onStudentTrainingDirectionsUpdated;
  final List<TrainingDirectionsData> trainingDirections;


  final String? firstNameError;
  final String? lastNameError;
  final String? classError;

  final bool loading;

  @override
  State<StudentDialogContent> createState() => _StudentDialogContentState();
}

class _StudentDialogContentState extends State<StudentDialogContent> {

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    insertTextController(widget.student); //initialData for firstName and lastName if available

  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth =
    MediaQuery.of(context).size.width*0.5>500?MediaQuery.of(context).size.width*0.5:500;
    double dialogHeight =
        MediaQuery.of(context).size.height*0.7;
    return SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(widget.loading) ...[const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSmall),
                  child: LinearProgressIndicator(),
                )],
                /*
                first segment are the two textfields for first name and last name
                 */
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: DialogTextField(
                          controller: firstNameController,
                          onTextChanged: widget.onFirstNameChanged,
                          hint: TextRes.firstNameHint,
                          errorText: widget.firstNameError,
                        )
                      ),
                      const SizedBox(width: Dimensions.spaceLarge,),
                      Expanded(child: DialogTextField(
                          controller: lastNameController,
                          onTextChanged: widget.onLastNameChanged,
                          hint: TextRes.lastNameHint,
                          errorText: widget.lastNameError)
                      )
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.spaceMedium,),
              /*
              Second segment to select the class
               */
                Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSmall, top: Dimensions.paddingSmall),
                  child: Text(TextRes.classDataDropdownDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if(widget.classError!=null) ...[ //show an error message on demand
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSmall),
                    child: Text(widget.classError!,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error, height: Dimensions.tightTextHeight)
                    ),
                  )
                ],
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingBetweenVerySmallAndSmall),
                  child: Dropdown<ClassData>(availableChips: widget.classes,
                      selectedChips: widget.student!=null
                          ?[ClassData(widget.student!.classLevel, widget.student!.classChar)]
                          :widget.studentClass, //preserve state even after parent rebuilds
                      onAddChip: (classChip){widget.onStudentClassUpdated(classChip as ClassData);},
                      onDeleteChip: (_){},
                      multiSelect: false, width: dialogWidth*0.8,
                      onCloseOverlay: (classes) {
                        widget.onStudentClassUpdated(classes.isNotEmpty
                            ?classes[0] as ClassData
                            :null);
                              },
                          ),
                ),
                const SizedBox(height: Dimensions.spaceMedium,),

                /*
                Third segment to select training directions
                 */

                Padding(
                  padding: const EdgeInsets.only(left: Dimensions.paddingSmall, top: Dimensions.paddingSmall),
                  child: Text(TextRes.trainingDirectionsDataDropdownDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingBetweenVerySmallAndSmall),
                  child: Dropdown(availableChips: widget.trainingDirections,
                      selectedChips: widget.student!=null
                          ?widget.student!.trainingDirections.map((e) => TrainingDirectionsData(e)).toList()
                          :List<TrainingDirectionsData>.empty(),
                        onAddChip: (_){}, onDeleteChip: (_){},
                      multiSelect: true, width: dialogWidth*0.8,
                      onCloseOverlay: (trainingDirections) =>
                          widget.onStudentTrainingDirectionsUpdated(
                              trainingDirections.map((e) => e as TrainingDirectionsData).toList())
                  ),
                ),


              ],
            ),
        );

  }

  void insertTextController(Student? student) {
    if(student != null) {
      firstNameController.text = student.firstName;
      lastNameController.text = student.lastName;
    }
  }

}
