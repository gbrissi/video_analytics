import 'dart:io';

import 'package:flutter/material.dart';

class FileController extends ChangeNotifier {
  File? _file;
  File? get file => _file;

  void setFile(File file) {
    _file = file;
    notifyListeners();
  }

  void removeFile() {
    _file = null;
    notifyListeners();
  }
}

