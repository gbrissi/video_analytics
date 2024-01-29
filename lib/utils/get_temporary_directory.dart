import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getTemporaryDirPath() async {
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

  return tempPath;
}