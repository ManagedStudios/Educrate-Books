
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../Data/class_data.dart';
import '../../../Data/db.dart';
import '../../../Resources/text.dart';
import '../../../UI/desktop/student_view.dart';
import '../../database/getter.dart';

Future<String> getInitialPath() async{
  const storage = FlutterSecureStorage();
  final uri = await storage.read(key: TextRes.uriKey);
  final username = await storage.read(key: TextRes.usernameKey);
  final password = await storage.read(key: TextRes.passwordKey);

  if (username == null || password == null || uri == null) {
    return TextRes.introPaths[1];
  }

  List<ClassData>? classes = await getAllClasses(DB());
  if (classes != null && classes.isNotEmpty) { //no classes available
    return StudentView.routeName;

  } else {
    return TextRes.introPaths[0];
  }
}