import 'package:buecherteam_2023_desktop/Data/training_directions_data.dart';
import 'package:buecherteam_2023_desktop/UI/book_dialog/training_direction_text_field.dart';
import 'package:flutter/material.dart';

import '../../Resources/dimensions.dart';
import '../../Resources/text.dart';
import '../../Util/stringUtil.dart';

/*
the widget that makes it possible to add optional trainingDirections that follow
a pattern of SOMETEXT"-"CLASSLEVEL
 */
class TrainingDirectionCreationRow extends StatefulWidget {
  const TrainingDirectionCreationRow({super.key, required this.onEveryInputChange,
    required this.onDeleteTrainingDirection, required this.currTrainingDirection, required this.currClassLevel, required this.onTrainingDirectionChanged});

  final Function(String trainingDirection) onEveryInputChange; //notify parent about every change
  final Function(TrainingDirectionsData? trainingDirectionsData) onTrainingDirectionChanged; //notify parent about valid changes (errors are checked)
  final Function() onDeleteTrainingDirection; //delete button pressed

  final String currTrainingDirection; //use parent state for textFields
  final String currClassLevel;


  @override
  State<TrainingDirectionCreationRow> createState() => _TrainingDirectionCreationRowState();
}

class _TrainingDirectionCreationRowState extends State<TrainingDirectionCreationRow> {

  late TextEditingController trainingDirectionsNameController;
  late TextEditingController classLevelController;


  String? classLevelError ;
  String? trainingDirectionsNameError ;

  @override
  void initState () {
    super.initState();
    trainingDirectionsNameController = TextEditingController();
    classLevelController = TextEditingController();

    /*
    just set the error in the beginning and then delete it
     */
    classLevelError = TextRes.classLevelError;
    trainingDirectionsNameError = TextRes.trainingDirectionsNameError;

    trainingDirectionsNameController.text = widget.currTrainingDirection;
    classLevelController.text = widget.currClassLevel;
    updateClassLevelError(classLevelController.text);
    updateTrainingDirectionNameError(trainingDirectionsNameController.text);

  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    /*
    when parent state changes update textFields and errors
     */
      trainingDirectionsNameController.text = widget.currTrainingDirection;
      classLevelController.text = widget.currClassLevel;
      updateClassLevelError(classLevelController.text);
      updateTrainingDirectionNameError(trainingDirectionsNameController.text);
  }

  @override
  void dispose() {
    super.dispose();
    trainingDirectionsNameController.dispose();
    classLevelController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSmall),
      child: Row(
        children: [
          //SOMETEXT PART
          Expanded(
            flex: 7,
            child: Tooltip(
              message: TextRes.trainingDirectionsNameError,
              waitDuration: const Duration(seconds: Dimensions.toolTipDuration),
              child: TrainingDirectionTextField(
                    controller: trainingDirectionsNameController,
                    errorText: trainingDirectionsNameError,
                    hint: TextRes.trainingDirectionLabelInput,
                    onTextChanged: (String text) {
                      updateTrainingDirectionNameError(text);
                      passInputChange();
                      updateTrainingDirection();
                    },
                ),
            ),
          ),
          const SizedBox(width: Dimensions.spaceMedium,),
          Text(
            TextRes.hyphen,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(width: Dimensions.spaceMedium,),

          //SOME CLASSLEVEL PART
          Expanded(
            flex: 3,
            child: Tooltip(
              message: TextRes.classLevelError,
              waitDuration: const Duration(seconds: Dimensions.toolTipDuration),
              enableFeedback: classLevelError == null,
              child: TrainingDirectionTextField(
                controller: classLevelController,
                  errorText: classLevelError,
                  hint: TextRes.classLevelWithoutDot,
                onTextChanged: (String text) {
                updateClassLevelError(text);
                passInputChange();
                updateTrainingDirection();
                },
              ),
             ),
          ),
          const SizedBox(width: Dimensions.spaceSmall,),
          IconButton( //delete trainingDirection via iconButton
              onPressed: widget.onDeleteTrainingDirection,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close, ),
              iconSize: Dimensions.iconSizeSmall,
          )
        ],
      ),
    );
  }

  void passInputChange() {
      widget.onEveryInputChange(
          "${trainingDirectionsNameController.text}${TextRes.trainingDirectionHyphen}${classLevelController.text}"
      );
  }

  void updateTrainingDirectionNameError(String currTrainingDirectionName) {
      if (!isOnlyWhitespace(currTrainingDirectionName)) {
        setState(() {
          trainingDirectionsNameError = null;
        });
      } else {
        setState(() {
          trainingDirectionsNameError = TextRes.trainingDirectionsNameError;
        });
      }
  }

  void updateClassLevelError(String currClassLevel) {
      if(isNumeric(currClassLevel)) {
        setState(() {
          classLevelError = null;
        });
      } else {
        setState(() {
          classLevelError = TextRes.classLevelError;
        });
      }
  }

  void updateTrainingDirection () {
    //no errors => provide parent TrainingDirectionsData else provide null indication an error
    if (classLevelError == null && trainingDirectionsNameError == null) {
      widget.onTrainingDirectionChanged(
        TrainingDirectionsData(
          "${trainingDirectionsNameController.text}${TextRes.trainingDirectionHyphen}${classLevelController.text}"
        )
      );
    } else {
      widget.onTrainingDirectionChanged(null);
    }
  }


}
