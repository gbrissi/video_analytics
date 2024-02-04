import 'dart:io';

import 'package:flutter/material.dart';

class FramesPanelController extends ChangeNotifier {
  final List<File> _files = [];
  List<File> get files => _files;
  List<File> get sortedFiles => List.from(files)
    ..sort(
      _sortPosition,
    );

  int _getPosition(String filePath) => int.parse(
        filePath.split('_').last.split(".").first,
      );

  int _sortPosition(File a, File b) {
    int posA = _getPosition(a.path);
    int posB = _getPosition(b.path);

    return posA.compareTo(posB);
  }

  void appendFile(File file) {
    _files.add(file);
    notifyListeners();
  }

  void clearFiles() {
    _files.clear();
    notifyListeners();
  }
}
