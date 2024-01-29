import 'package:flutter/material.dart';
import 'package:video_analytics/screens/video_select_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Analysis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: const VideoSelectScreen(),
    );
  }
}
