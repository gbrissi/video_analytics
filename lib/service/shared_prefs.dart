import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // TODO: Should be a singleton instance.
  static Future<SharedPreferences> _getPrefs() async =>
      await SharedPreferences.getInstance();

  static const String _brightnessKey = "brightness";
  static const String _colorSeedKey = "colorSeed";
  static const String _customColorsKey = "customColors";

  static Future<void> setColorSeed(Color colorSeed) async {
    final SharedPreferences prefs = await _getPrefs();
    prefs.setInt(_colorSeedKey, colorSeed.value);
  }

  static Future<Color?> getColorSeed() async {
    Color? colorSeed;

    final SharedPreferences prefs = await _getPrefs();
    final int? value = prefs.getInt(_colorSeedKey);

    if (value != null) {
      colorSeed = Color(value);
    }

    return colorSeed;
  }

  static Future<void> setBrightness(Brightness brightness) async {
    final SharedPreferences prefs = await _getPrefs();
    prefs.setInt(_brightnessKey, brightness.index);
  }

  static Future<Brightness?> getBrightness() async {
    Brightness? brightness;

    final SharedPreferences prefs = await _getPrefs();
    final int? index = prefs.getInt(_brightnessKey);
    if (index != null) {
      brightness = Brightness.values[index];
    }

    return brightness;
  }

  static Future<List<Color>?> getCustomColors() async {
    List<Color>? colors;
    final prefs = await _getPrefs();
    final String? colorsVal = prefs.getString(_customColorsKey);
    if (colorsVal != null) {
      final List<String> decodedColorsVal =
          jsonDecode(colorsVal).cast<String>();
      colors = decodedColorsVal.map((e) => Color(int.parse(e))).toList();
    }

    return colors;
  }

  static Future<void> addCustomColor(Color color) async {
    final prefs = await _getPrefs();
    List<Color>? storedColors = await getCustomColors();
    storedColors = storedColors != null ? [...storedColors, color] : [color];
    final String stringifiedColors = jsonEncode(
      storedColors.map((e) => e.value.toString()).toList(),
    );

    await prefs.setString(
      _customColorsKey,
      stringifiedColors,
    );
  }

  static Future<void> removeCustomColor(Color color) async {
    final prefs = await _getPrefs();
    final String? colorsVal = prefs.getString(_customColorsKey);
    if (colorsVal != null) {
      final List<String> decodedColorsVal =
          jsonDecode(colorsVal).cast<String>();
      final int colorIndex = decodedColorsVal.indexOf(color.value.toString());
      if (colorIndex != -1) decodedColorsVal.removeAt(colorIndex);
      final encodedColorsVal = jsonEncode(decodedColorsVal);

      await prefs.setString(
        _customColorsKey,
        encodedColorsVal,
      );
    }
  }
}
