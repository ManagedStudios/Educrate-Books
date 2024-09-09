
import '../../Data/buildQuery.dart';
import '../../Data/db.dart';
import '../../Data/student.dart';
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


Future<Set<Student>> getAllStudentsUtil(DB database) async{
  String query = BuildQuery.getAllStudents();
  final res = await database.getDocs(query);
  return res
      .asStream()
      .map((result) =>
      database.toEntity(Student.fromJson, result))
      .toSet();
}