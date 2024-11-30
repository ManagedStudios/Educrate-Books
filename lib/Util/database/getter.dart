
import 'package:buecherteam_2023_desktop/Data/class_data.dart';

import '../../Data/book.dart';
import '../../Data/bookLite.dart';
import '../../Data/buildQuery.dart';
import '../../Data/db.dart';
import '../../Data/student.dart';
import '../../Data/tag_data.dart';
import '../../Data/training_directions_data.dart';

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

