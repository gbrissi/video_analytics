import 'package:flutter/material.dart';
import 'package:video_analytics/service/shared_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  Color _colorSeed = Colors.indigoAccent;
  Brightness _brightness = Brightness.light;
  bool _isLoad = false;

  bool get isLoad => _isLoad;
  Color get colorSeed => _colorSeed;
  Brightness get brightness => _brightness;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    Brightness? storedBrightness = await SharedPrefs.getBrightness();
    _brightness = storedBrightness ?? _brightness;

    Color? storedColor = await SharedPrefs.getColorSeed();
    _colorSeed = storedColor ?? _colorSeed;

    _isLoad = true;
    notifyListeners();
  }

  Future<void> setColorSeed(Color seed) async {
    _colorSeed = seed;
    await SharedPrefs.setColorSeed(colorSeed);
    notifyListeners();
  }

  Future<void> setBrightness(Brightness brightness) async {
    _brightness = brightness;
    await SharedPrefs.setBrightness(brightness);
    notifyListeners();
  }
}
