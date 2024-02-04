import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';
import 'package:video_analytics/providers/frames_panel_controller.dart';
import 'package:video_analytics/screens/video_select_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Analysis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => FFmpegDownloadTrackerController(),
          ),
          ChangeNotifierProvider(
            create: (_) => FramesPanelController(),
          ),
          ChangeNotifierProvider(
            create: (_) => ConvertSettingsController(),
          ),
        ],
        child: const VideoSelectScreen(),
      ),
    );
  }
}
