import 'package:flutter/material.dart';

Color getTextColor(Color backgroundColor) {
  // Calculate the relative luminance of the background color
  double luminance = (0.2126 * backgroundColor.red +
          0.7152 * backgroundColor.green +
          0.0722 * backgroundColor.blue) /
      255.0;

  // Use a threshold to determine whether to use light or dark text color
  return luminance > 0.5 ? Colors.grey.shade900 : Colors.grey.shade100;
}
