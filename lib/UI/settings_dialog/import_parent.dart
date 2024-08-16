import 'package:buecherteam_2023_desktop/Data/student_excel_mapper_attributes.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/excel_to_attribute_mapper.dart';
import 'package:flutter/material.dart';

class ImportParent extends StatelessWidget {
  const ImportParent({super.key});



  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ExcelToAttributeMapper(
              excelKey: "Test",
              availableAttributes: StudentAttributes.values,
              width: availableWidth*0.35),
        ],
      ),
    );
  }
}
