import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';

class GetVideoFramesButton extends StatefulWidget {
  const GetVideoFramesButton({
    super.key,
    required this.duration,
    required this.video,
  });
  final Duration duration;
  final File video;

  @override
  State<GetVideoFramesButton> createState() => _GetVideoFramesButtonState();
}

class _GetVideoFramesButtonState extends State<GetVideoFramesButton> {
  late final _downloadController =
      context.read<FFmpegDownloadTrackerController>();

  void _showFFmpegFailDialog(DownloadResult result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("FFmpeg download has failed"),
          content: Text(result.reasoning),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  Future<void> _getVideoFrames() async {
    bool isFFmpegAvailable = await FFmpegService.isFFMpegAvailable();

    if (mounted) {
      if (isFFmpegAvailable) {
        //
      } else {
        DownloadResult result = await FFmpegService.downloadFFMPeg(
          onProgress: _downloadController.calculateFFmpegProgress,
        );

        if (mounted) {
          if (result.isSuccess) {
            // Execute first fun AND show success snackbar.
          } else {
            _showFFmpegFailDialog(result);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text("Converter vídeos em frames"),
      icon: const Icon(Icons.add),
      onPressed: _getVideoFrames,
    );
  }
}
