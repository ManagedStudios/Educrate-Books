import '../../Data/class_data.dart';

Map<int, List<ClassData>> groupClassesByLevel(List<ClassData> classes) {
  final Map<int, List<ClassData>> groupedClasses = {};
  for (var classData in classes) {
    if (!groupedClasses.containsKey(classData.classLevel)) {
      groupedClasses[classData.classLevel] = [];
    }
    groupedClasses[classData.classLevel]!.add(classData);
  }
  return groupedClasses;
}