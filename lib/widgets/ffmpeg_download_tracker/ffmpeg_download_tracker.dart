import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';

import 'components/download_progress_bar.dart';

class FFMpegDownloadTracker extends StatelessWidget {
  const FFMpegDownloadTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FFmpegDownloadTrackerController>(
      builder: (context, provider, child) {
        if (provider.showDownloadTracker) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FadeAnimatedText(
                    "FFmpeg tool download in progress...",
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              DownloadProgressBar(
                progress: provider.totalDownloadProgress,
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
