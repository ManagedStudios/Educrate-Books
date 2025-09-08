
import 'package:buecherteam_2023_desktop/UI/mobile/class_view.dart';
import 'package:buecherteam_2023_desktop/UI/mobile/login_flow.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Resources/text.dart';


Future<String> getInitialPathMobile() async{
  const storage = FlutterSecureStorage();
  final uri = await storage.read(key: TextRes.uriKey);
  final username = await storage.read(key: TextRes.usernameKey);
  final password = await storage.read(key: TextRes.passwordKey);

  if (username == null || password == null || uri == null) {
    return LoginFlow.routeName;
  } else {
    return ClassView.routeName;
  }


}