

import 'package:buecherteam_2023_desktop/Data/shared_preferences.dart';
import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:buecherteam_2023_desktop/UI/student_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Data/db.dart';

class AppIntroductionState extends ChangeNotifier {
  AppIntroductionState(this.database);

  final DB database;

  String? selectedPath;
  int currIntroIndex = 0;
  String? currError = TextRes.selectPathError;

  Future<void> getAndSavePath() async{
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;
    selectedPath = selectedDirectory;
    await savePreference(TextRes.dbPath, selectedPath!);
    currError = null;
    notifyListeners();
  }

  Future<void> goToNextPage (BuildContext context) async{
    if (currError != null) return;
    if (currIntroIndex < TextRes.introPaths.length-1) {
      currIntroIndex++;
      context.go(TextRes.introPaths[currIntroIndex]);
    } else {
      context.go(StudentView.routeName);
    }
    if (currIntroIndex == 1 || TextRes.introPaths.length == 1) {
      await database.initializeDatabase(selectedPath!);
    }
  }



}