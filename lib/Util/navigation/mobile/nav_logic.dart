
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/login_flow.dart';
import '../../../Data/class_data.dart';
import '../../../Data/db.dart';
import '../../database/getter.dart';


Future<String> getInitialPathMobile(DB db) async{

  List<ClassData>? classes = await getAllClasses(DB());
  if (classes != null && classes.isNotEmpty) { //no classes available
    return ClassView.routeName;
  }

  final error = await db.checkConnection();
  if (error != null) {
    return LoginFlow.routeName;
  }

  return ClassView.routeName;



}