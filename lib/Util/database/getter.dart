
import 'dart:math';
import 'dart:ui';

import 'package:buecherteam_2023_desktop/Data/class_data.dart';
import 'package:buecherteam_2023_desktop/Resources/chip_colors.dart';

import '../../Data/book.dart';
import '../../Data/bookLite.dart';
import '../../Data/buildQuery.dart';
import '../../Data/db.dart';
import '../../Data/student.dart';
import '../../Data/tag_data.dart';
import '../../Data/training_directions_data.dart';
import '../../Resources/text.dart';

Future<List<TrainingDirectionsData>> getAllTrainingDirectionsUtil (DB database) async {
  String query = BuildQuery.getAllTrainingDirections();
  final res = await database.getDocs(query);
  return res
      .asStream()
      .map((result) =>
      database.toEntity(TrainingDirectionsData.fromJson, result))
      .toList();
}


Future<List<Student>> getAllStudentsUtil(DB database) async{
  String query = BuildQuery.getAllStudents();
  final res = await database.getDocs(query);
  return res
      .asStream()
      .map((result) =>
      database.toEntity(Student.fromJson, result))
      .toList();
}

/*
  Method to retrieve all books of given trainingDirections
   */
Future<List<BookLite>?> getBooksFromTrainingDirectionsUtil(
    List<String> trainingDirections, DB database) async {
  if (trainingDirections.isEmpty) return null;
  final query = BuildQuery.getBooksOfTrainingDirections(trainingDirections);
  final bookDocs = await database.getDocs(query);
  List<BookLite> books = await bookDocs
      .asStream()
      .map((res) => database.toEntity(Book.fromJson, res).toBookLite())
      .toList();
  return books;
}

Future<List<ClassData>?> getAllClasses(DB database) async{
  final query = BuildQuery.getAllClassesQuery();
  final classesDocs = await database.getDocs(query);
  List<ClassData> classes = await classesDocs
      .asStream()
      .map((res) => database.toEntity(ClassData.fromJson, res))
      .toList();
  return classes;
}


Future<List<TagData>> getAllTagDataUtil(DB database) async{
  final query = BuildQuery.getAllTagsQuery();
  final tagsDocs = await database.getDocs(query);
  List<TagData> tags = await tagsDocs
      .asStream()
      .map((res) => database.toEntity(TagData.fromJson, res))
      .toList();
  return tags;
}

Future<List<TagData>> getTagsOfUtil(DB database, List<String> tags) async{
  final query = BuildQuery.getTagsOfQuery(tags);
  if (tags.isEmpty) return [];

  final tagsDocs = await database.getDocs(query);
  List<TagData> tagObjects = await tagsDocs
      .asStream()
      .map((res) => database.toEntity(TagData.fromJson, res))
      .toList();

  return tagObjects;

}

Color getTagColor(Set<Color?> usedColors) {

  List<Color> availableColors = ChipColors.chipColors.toList();

  for (Color? color in usedColors) {
    availableColors.remove(color);
  }

  if (availableColors.isEmpty) {
    return ChipColors.chipColors[Random().nextInt(ChipColors.chipColors.length-1)];
  }

  return availableColors.first;


}

Future<List<Book>> getAllBooks(DB database) async{
  final query = BuildQuery.getAllBooks();
  final bookDocs = await database.getDocs(query);

  List<Book> books = await bookDocs
      .asStream()
      .map((res) => database.toEntity(Book.fromJson, res))
      .toList();

  return books;
}

Future<List<int>> getAllClassLevels (DB database) async{
  String query = BuildQuery.getAllClassLevels();
  final res = await database.getDocs(query);
  return res
      .asStream()
      .map((result) =>
  result.toPlainMap()[TextRes.classDataClassLevelJson] as int)
      .toList();
}

Future<List<Book>> getBooksOfBasicTrainingDirection(DB database, int classLevel) async {
  final query = BuildQuery.getBooksOfBasicTrainingDirectionQuery(classLevel);
  final bookDocs = await database.getDocs(query);

  List<Book> books = await bookDocs
      .asStream()
      .map((res) => database.toEntity(Book.fromJson, res))
      .toList();

  return books;
}


