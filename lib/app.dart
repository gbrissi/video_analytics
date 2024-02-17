import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';
import 'package:video_analytics/providers/file_controller.dart';
import 'package:video_analytics/providers/frames_panel_controller.dart';
import 'package:video_analytics/providers/path_controller.dart';
import 'package:video_analytics/providers/theme_provider.dart';
import 'package:video_analytics/providers/video_details_controller.dart';
import 'package:video_analytics/router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FFmpegDownloadTrackerController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FileController(),
        ),
        ChangeNotifierProvider(
          create: (_) => FramesPanelController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConvertSettingsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoDetailsController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PathController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, provider, __) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Video Analysis',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: provider.colorSeed,
                brightness: provider.brightness,
              ),
            ),
          );
        },
      ),
    );
  }
}