import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/ffmpeg_download_tracker_controller.dart';
import 'package:video_analytics/providers/frames_panel_controller.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';
import 'package:video_analytics/widgets/row_separated.dart';

class GetVideoFramesButton extends StatefulWidget {
  const GetVideoFramesButton({
    super.key,
    required this.range,
    required this.video,
  });
  final DurationRange range;
  final File video;

  @override
  State<GetVideoFramesButton> createState() => _GetVideoFramesButtonState();
}

class _GetVideoFramesButtonState extends State<GetVideoFramesButton> {
  late final _downloadController =
      context.read<FFmpegDownloadTrackerController>();
  late final _framesPanelController = context.read<FramesPanelController>();

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
        FFmpegService.getFFmpegVideoFrames(
          widget.video.path,
          widget.range,
          (file) {
            if (file != null) {
              _framesPanelController.appendFile(
                file,
              );
            }
          },
        );
      } else {
        _downloadController.setDownloadTrackerStatus(true);
        DownloadResult result = await FFmpegService.downloadFFMPeg(
          onProgress: _downloadController.calculateFFmpegProgress,
        );

        // Hide tracker after download has finished.
        _downloadController.setDownloadTrackerStatus(false);

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
    return FilledButton.icon(
      onPressed: _getVideoFrames,
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      icon: const Icon(Icons.sync, size: 18),
      label: const Text(
        "Convert video to image album",
        // style: TextStyle(
        //   fontSize: 16,
        // ),
      ),
    );
  }
}
