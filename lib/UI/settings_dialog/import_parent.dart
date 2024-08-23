
import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Data/settings/student_excel_mapper_attributes.dart';
import 'package:buecherteam_2023_desktop/Resources/dimensions.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/import/attribute_mapper_list.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/nav_bottom_bar.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/print_parent.dart';
import 'package:buecherteam_2023_desktop/UI/settings_dialog/warning_parent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImportParent extends StatelessWidget {
  const ImportParent({super.key});



  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingMedium),
          child: AttributeMapperList<StudentAttributes>(
              availableDropdownItems: StudentAttributes.values,
              excelDataKeys: List.generate(5, (i) =>
                  ExcelData(row: i, column: i, content: "content nr: $i")),
              onUpdatedMap: (m){
                print(
                    m.map((key, value) => MapEntry(key.content, value))
                );
                },
              width: availableWidth*0.4)
        ),
         const Spacer(),

         const NavBottomBar(nextWidget: PrintParent(),
             previousWidget: WarningParent())
      ],
    );
  }
}
