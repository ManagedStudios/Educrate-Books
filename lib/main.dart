
import 'dart:io';

import 'package:buecherteam_2023_desktop/Data/db.dart';
import 'package:buecherteam_2023_desktop/UI/desktop/desktop_entry.dart';
import 'package:buecherteam_2023_desktop/Util/navigation/desktop/nav_logic.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';

import 'UI/mobile/mobile_entry.dart';
import 'Util/navigation/mobile/nav_logic.dart';



late String initialLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CouchbaseLiteFlutter.init();

  await DB().initializeDatabase();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) { //desktop
    initialLocation = await getInitialPathDesktop();
    runApp(desktopEntry);
  } else { //mobile
    initialLocation = await getInitialPathMobile(DB());
    runApp(mobileEntry);
  }





}



