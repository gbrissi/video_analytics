import 'package:flutter/material.dart';
import 'package:video_analytics/app.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:media_kit/media_kit.dart';   

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  await FFMpegHelper.instance.initialize(); // This is a singleton instance
  runApp(const App());
}
