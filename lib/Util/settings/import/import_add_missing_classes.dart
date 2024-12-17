import 'dart:collection';

import 'package:buecherteam_2023_desktop/Data/tag_data.dart';
import 'package:buecherteam_2023_desktop/Util/database/adder.dart';

import '../../../Data/class_data.dart';
import '../../../Data/db.dart';
import '../../database/getter.dart';

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


Future<void> addMissingTags(HashSet<TagData> uniqueTags,
                            List<TagData>? availableTags, DB database) async{
  List<TagData> tagsToAdd = getMissingTagsFrom(uniqueTags, availableTags);
  await addTags(tagsToAdd, database);
}

List<TagData> getMissingTagsFrom(
    HashSet<TagData> uniqueTags,
    List<TagData>? availableTags) {

  for (TagData tagData in availableTags??[]) {
    uniqueTags.remove(tagData);
  }

  return uniqueTags.toList();
}

Future<void> addMissingProperties(HashSet<ClassData> uniqueClasses,
    HashSet<TagData> uniqueTags, DB database) async{
  List<ClassData>? availableClasses = await getAllClasses(database);
  await addMissingClasses(uniqueClasses, availableClasses, database);
  List<TagData>? availableTags = await getAllTagDataUtil(database);
  await addMissingTags(uniqueTags, availableTags, database);
}