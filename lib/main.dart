
import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/desktop_entry.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/desktop/nav_logic.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';



late String initialLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();

  await DB().initializeDatabase();


  initialLocation = await getInitialPath();

  //TODO shift init methods down to the widget and show a startup screen while initializing
  runApp(desktopEntry);
}



