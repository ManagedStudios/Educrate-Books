
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/login_flow.dart';
import '../../../Data/db.dart';


Future<String> getInitialPathMobile(DB db) async{

  final error = await db.checkConnection();
  if (error != null
  ) {
    return LoginFlow.routeName;
  }

  return ClassView.routeName;



}