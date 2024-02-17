import 'package:flutter/material.dart';

import '../../../service/shared_prefs.dart';

class CustomColorsProvider extends ChangeNotifier {
  final int _customColorsLimit = 4;
  List<Color>? _customColors;
  List<Color> get customColors => _customColors ?? [];

  CustomColorsProvider() {
    _loadStoredColors();
  }

  Future<void> _loadStoredColors() async {
    _customColors = await SharedPrefs.getCustomColors();
    notifyListeners();
  }

  Future<void> addCustomColor(Color color) async {
    if (customColors.length >= _customColorsLimit) {
      await SharedPrefs.removeCustomColor(customColors.first);
      _customColors?.removeAt(0);
    }

    await SharedPrefs.addCustomColor(color);
    _customColors = [...customColors, color];
    notifyListeners();
  }
}
