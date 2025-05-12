

import 'package:buecherteam_2023_desktop/Data/settings/excel_data.dart';
import 'package:buecherteam_2023_desktop/Data/settings/student_excel_mapper_attributes.dart';
import 'package:buecherteam_2023_desktop/Util/comparison.dart';
import 'package:buecherteam_2023_desktop/Util/settings/import/import_general_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main () {
  group("Test getStudentAttributesToHeadersFrom method", () {

    test("Usual filled Map", () {
      Map<ExcelData, StudentAttributes?> mapToTransform = {
        ExcelData(row: 1, column: 1, content: "content1"):StudentAttributes.FIRSTNAME,
        ExcelData(row: 1, column: 2, content: "content2"):StudentAttributes.LASTNAME,
        ExcelData(row: 1, column: 3, content: "content3"):StudentAttributes.CLASS,
        ExcelData(row: 1, column: 4, content: "content4"):StudentAttributes.TRAININGDIRECTION,
        ExcelData(row: 1, column: 5, content: "content5"):StudentAttributes.TRAININGDIRECTION,
      };

      Map<StudentAttributes, List<ExcelData>> transformedMap =
      getStudentAttributesToHeadersFrom(mapToTransform);

      Map<StudentAttributes, List<ExcelData>> expectedTransformedMap = {
        StudentAttributes.FIRSTNAME:[ExcelData(row: 1, column: 1, content: "content1")],
        StudentAttributes.LASTNAME:[ExcelData(row: 1, column: 2, content: "content2")],
        StudentAttributes.CLASS:[ExcelData(row: 1, column: 3, content: "content3")],
        StudentAttributes.TRAININGDIRECTION:[ExcelData(row: 1, column: 4, content: "content4"),
          ExcelData(row: 1, column: 5, content: "content5")
        ],
        StudentAttributes.TAG:[]
      };

      expect(areImportMapsEqual(transformedMap, expectedTransformedMap), isTrue);

    });

    test("Usual filled Map with null values", () {
      Map<ExcelData, StudentAttributes?> mapToTransform = {
        ExcelData(row: 1, column: 1, content: "content1"):StudentAttributes.FIRSTNAME,
        ExcelData(row: 1, column: 6, content: "content6"):null,
        ExcelData(row: 1, column: 2, content: "content2"):StudentAttributes.LASTNAME,
        ExcelData(row: 1, column: 3, content: "content3"):StudentAttributes.CLASS,
        ExcelData(row: 1, column: 4, content: "content4"):StudentAttributes.TRAININGDIRECTION,
        ExcelData(row: 1, column: 5, content: "content5"):StudentAttributes.TRAININGDIRECTION,
        ExcelData(row: 1, column: 7, content: "content7"):null,
      };

      Map<StudentAttributes, List<ExcelData>> transformedMap =
      getStudentAttributesToHeadersFrom(mapToTransform);

      Map<StudentAttributes, List<ExcelData>> expectedTransformedMap = {
        StudentAttributes.FIRSTNAME:[ExcelData(row: 1, column: 1, content: "content1")],
        StudentAttributes.LASTNAME:[ExcelData(row: 1, column: 2, content: "content2")],
        StudentAttributes.CLASS:[ExcelData(row: 1, column: 3, content: "content3")],
        StudentAttributes.TRAININGDIRECTION:[ExcelData(row: 1, column: 4, content: "content4"),
          ExcelData(row: 1, column: 5, content: "content5")
        ],
        StudentAttributes.TAG:[]
      };

      expect(areImportMapsEqual(transformedMap, expectedTransformedMap), isTrue);

    });

    test("Usual filled Map with null values tags and multiple trainingdirections", () {
      Map<ExcelData, StudentAttributes?> mapToTransform = {
        ExcelData(row: 1, column: 1, content: "content1"):StudentAttributes.FIRSTNAME,
        ExcelData(row: 1, column: 6, content: "content6"):null,
        ExcelData(row: 1, column: 2, content: "content2"):StudentAttributes.LASTNAME,
        ExcelData(row: 1, column: 3, content: "content3"):StudentAttributes.CLASS,
        ExcelData(row: 1, column: 4, content: "content4"):StudentAttributes.TRAININGDIRECTION,
        ExcelData(row: 1, column: 5, content: "content5"):StudentAttributes.TRAININGDIRECTION,
        ExcelData(row: 1, column: 7, content: "content7"):null,
        ExcelData(row: 1, column: 8, content: "content7"):StudentAttributes.TAG,
        ExcelData(row: 1, column: 9, content: "content7"):StudentAttributes.TRAININGDIRECTION,
      };

      Map<StudentAttributes, List<ExcelData>> transformedMap =
      getStudentAttributesToHeadersFrom(mapToTransform);

      Map<StudentAttributes, List<ExcelData>> expectedTransformedMap = {
        StudentAttributes.FIRSTNAME:[ExcelData(row: 1, column: 1, content: "content1")],
        StudentAttributes.LASTNAME:[ExcelData(row: 1, column: 2, content: "content2")],
        StudentAttributes.CLASS:[ExcelData(row: 1, column: 3, content: "content3")],
        StudentAttributes.TRAININGDIRECTION:[ExcelData(row: 1, column: 4, content: "content4"),
          ExcelData(row: 1, column: 5, content: "content5"),
          ExcelData(row: 1, column: 9, content: "content7")
        ],
        StudentAttributes.TAG:[ExcelData(row: 1, column: 8, content: "content7")]
      };

      expect(areImportMapsEqual(transformedMap, expectedTransformedMap), isTrue);

    });





  });

  
}