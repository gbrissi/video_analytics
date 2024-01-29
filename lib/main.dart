import 'package:flutter/material.dart';
import 'package:video_analytics/app.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';

Future<void> main() async {
  await FFMpegHelper.instance.initialize(); // This is a singleton instance
  runApp(const App());
}

