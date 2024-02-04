import 'dart:io';

Future<void> createFolderIfNotExists(String folderPath) async {
  Directory(folderPath).create(recursive: true).then((Directory directory) {
    print("Folder created at: ${directory.path}");
  }).catchError((e) {
    print("Error while creating folder: $e");
  });
}
