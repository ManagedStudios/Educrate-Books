

import 'dart:io';

import 'package:buecherteam_2023_desktop/Resources/text.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<FilePickerResult?> getFilePickerResult () async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx']
  );
  return result;
}

String getFileNameOf (FilePickerResult res)  {
  PlatformFile file = res.files.first;
  return file.name;
}

Excel getExcelFileOf(FilePickerResult res) {
  File file = File(res.files.single.path!);
  var bytes = file.readAsBytesSync();
  Excel excel = Excel.decodeBytes(bytes);
  return excel;
}

Future<bool> pathExists(String path) async{
  Directory directory = Directory(path);
  bool directoryExists = await directory.exists();
  return directoryExists;
}

Future<String> getDatabasePath () async {
  Directory applicationSupport = await getApplicationSupportDirectory();
  late String dbPath = applicationSupport.path;
  if (Platform.isWindows) {
    dbPath += r"\CouchbaseLite\";
    dbPath += TextRes.dbName;
    dbPath += ".cblite2";
  } else {
    dbPath = "${applicationSupport.path}/CouchbaseLite/${TextRes.dbName}.cblite2";
  }

  return dbPath;
}

