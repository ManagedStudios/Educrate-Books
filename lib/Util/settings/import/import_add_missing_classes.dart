import 'dart:collection';

import 'package:buecherteam_2023_desktop/Util/database/adder.dart';

import '../../../Data/class_data.dart';
import '../../../Data/db.dart';

Future<void> addMissingClasses
    (HashSet<ClassData> uniqueClasses,
    List<ClassData>? availableClasses, DB database) async{

    List<ClassData> classesToAdd = getMissingClassesFrom(uniqueClasses, availableClasses);
    await addClasses(classesToAdd, database);

}

List<ClassData> getMissingClassesFrom(
HashSet<ClassData> uniqueClasses,
List<ClassData>? availableClasses,) {

  for (ClassData classData in availableClasses??[]) {
    uniqueClasses.remove(classData);
  }

  return uniqueClasses.toList();
}