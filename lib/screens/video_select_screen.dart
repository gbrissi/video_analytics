import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';
import 'package:video_analytics/widgets/convert_settings/convert_settings.dart';
import 'package:video_analytics/widgets/ffmpeg_download_tracker/ffmpeg_download_tracker.dart';
import 'package:video_analytics/widgets/file_video_player.dart';
import 'package:video_analytics/widgets/frame_step_selector.dart';
import 'package:video_analytics/widgets/frames_panel.dart';
import 'package:video_analytics/widgets/get_video_frames_button.dart';
import 'package:video_analytics/widgets/image_format_selector.dart';

import '../widgets/column_separated.dart';

class VideoSelectScreen extends StatefulWidget {
  const VideoSelectScreen({super.key});

  @override
  State<VideoSelectScreen> createState() => _VideoSelectScreenState();
}

class _VideoSelectScreenState extends State<VideoSelectScreen> {
  final File video = File(
    "C:\\Users\\gabriel\\Desktop\\placeholder_videos\\video-fundo.mp4",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ColumnSeparated(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VideoPlayer(
                      video: video,
                    ),
                    ColumnSeparated(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VideoRangeSelector(
                          file: video,
                        ),
                        const ImageFormatSelector(),
                        const FrameStepSelector(),
                      ],
                    ),
                    GetVideoFramesButton(
                      video: video,
                      range: DurationRange(
                        start: Duration.zero,
                        end: const Duration(
                          seconds: 5,
                        ),
                      ),
                    ),
                    const FramesPanel(),
                  ],
                ),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: FFMpegDownloadTracker(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
