import 'dart:io';

import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';
import 'package:video_analytics/utils/get_temporary_directory.dart';

class DurationRange {
  final Duration start;
  final Duration end;

  DurationRange({
    required this.start,
    required this.end,
  });
}

// If the JPEG encoding step is too performance intensive, you could always store the frames uncompressed as BMP images:
// Extract frames from 00:20 to 00:30
// Instead of .png I'm using .bmp
// ffmpeg -i input_video.mp4 -ss 00:20 -t 00:10 output_%04d.bmp
class StartTimeArgument implements CliArguments {
  final Duration duration;
  String get durationArg => duration.toStandardFormat();

  const StartTimeArgument({
    required this.duration,
  });

  @override
  List<String> toArgs() {
    return [
      "-ss",
      durationArg,
    ];
  }
}

class EndTimeArgument implements CliArguments {
  final DurationRange rangeDuration;
  String get durationArg => _getDurationArg(rangeDuration);

  String _getDurationArg(DurationRange duration) {
    final int startTimeMilli = rangeDuration.start.inMilliseconds;
    final int endTimeMilli = rangeDuration.end.inMilliseconds;
    final int timeDiffMilli = endTimeMilli - startTimeMilli;
    final Duration diffDuration = Duration(milliseconds: timeDiffMilli);

    return diffDuration.toStandardFormat();
  }

  const EndTimeArgument({
    required this.rangeDuration,
  });

  @override
  List<String> toArgs() {
    return [
      "-t",
      durationArg,
    ];
  }
}

class DownloadResult {
  bool _isSuccess;
  String _reasoning;

  bool get isSuccess => _isSuccess;
  String get reasoning => _reasoning;

  setSuccessState(bool value) {
    _isSuccess = value;
  }

  setResultReasoning(String value) {
    _reasoning = value;
  }

  DownloadResult({
    bool? isSuccess,
    required String reasoning,
  })  : _reasoning = reasoning,
        _isSuccess = isSuccess ?? false;
}

class FFmpegService {
  static final FFMpegHelper _ffmpeg = FFMpegHelper.instance;
  static Future<bool> isFFMpegAvailable() => _ffmpeg.isFFMpegPresent();

  static Future<DownloadResult> downloadFFMPeg({
    void Function(FFMpegProgress progress)? onProgress,
  }) async {
    DownloadResult result = DownloadResult(
      isSuccess: false,
      reasoning:
          "The download has failed without returning any additional information, report this behavior to the developer for guidance",
    );

    try {
      bool isFFmpegAvailable = await isFFMpegAvailable();
      bool isWindows = Platform.isWindows;

      if (isFFmpegAvailable) {
        result.setResultReasoning(
          "FFmpeg is already available on your device.",
        );
      } else {
        if (isWindows) {
          bool isDownloadSuccess = await _ffmpeg.setupFFMpegOnWindows(
            onProgress: onProgress,
          );

          result.setSuccessState(isDownloadSuccess);
          if (!isDownloadSuccess) {
            result.setResultReasoning(
              "Some unknown error happened on FFmpeg download in your Windows OS, try to restart the application or download the tool manually through it's official website.",
            );
          } else {
            result.setResultReasoning(
              "FFMpeg was successfully downloaded into your system.",
            );
          }
        } else if (Platform.isLinux) {
          result.setResultReasoning(
            "Linux platform must download FFmpeg through it's CLI tool, use ${"sudo apt-get install ffmpeg"} to download the required tool.",
          );
        } else {
          result.setResultReasoning(
            "FFmpeg tool can't be automatically downloaded into your system, download it through it's official website to use this application",
          );
        }
      }
    } catch (err) {
      debugPrint("FFMPEG DOWNLOAD ERROR ---> $err");
    }

    return result;
  }

  static FFMpegCommand _createFFmpegCliCommand({
    required DurationRange durationRange,
    required String inputPath,
  }) {
    return FFMpegCommand(
      inputs: [
        // Video input file is set here.
        FFMpegInput.asset(
          inputPath,
        ),
      ],
      args: [
        StartTimeArgument(
          duration: durationRange.start,
        ),
        EndTimeArgument(
          rangeDuration: durationRange,
        ),
        // If a file with the same output name already exists, it will be overwritten.
        const OverwriteArgument(),
      ],
      // TODO:
      outputFilepath: "output_%04d.bmp",
    );
  }

  static getFFmpegVideoFrames(
    videoPath,
    durationRange,
    onNewFrame,
    onComplete,
  ) async {
    final FFMpegCommand ffmpegCommand = _createFFmpegCliCommand(
      durationRange: durationRange,
      inputPath: videoPath,
    );

    // _ffmpeg.getThumbnailFileSync(videoPath: videoPath, fromDuration: fromDuration, outputPath: outputPath)
  }
}
