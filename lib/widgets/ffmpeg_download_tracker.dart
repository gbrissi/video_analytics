import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';

class FFMpegDownloadTracker extends StatelessWidget {
  const FFMpegDownloadTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FFmpegDownloadTrackerController>(
      builder: (context, provider, child) {
        return Slider(
          min: 0,
          value: provider.totalDownloadProgress,
          onChanged: (_) => {},
          max: 100,
        );
      },
    );
  }
}
