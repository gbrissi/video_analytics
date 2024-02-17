import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_analytics/extensions/list_extension.dart';

class FramesPanelController extends ChangeNotifier {
  final List<File> _files = [];
  List<File> get files => _files;
  List<File> get sortedFiles => files.sortPosition();

  void appendFile(File file) {
    _files.add(file);
    notifyListeners();
  }

  void clearFiles() {
    _files.clear();
    notifyListeners();
  }
}
