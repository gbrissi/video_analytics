import 'dart:io';

import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_analytics/utils/create_folder_if_not_exists.dart';

// TODO: Count the total video frame.
// Catches the 35th frame of the video and create the png out of that.
// ffmpeg -i <input> -vf "select=eq(n\,34)" -vframes 1 out.png
class ExtractCurrentlySelectedFrame implements CliArguments {
  @override
  List<String> toArgs() {
    return [
      "-vframes",
      "1",
    ];
  }
}

class SelectFramePosition implements CliArguments {
  final int frameToCatch;
  String get positionArg => "select=eq(n\\,${frameToCatch - 1})";

  const SelectFramePosition({
    required this.frameToCatch,
  });

  @override
  List<String> toArgs() {
    return [
      "-vf",
      positionArg,
    ];
  }
}

class DurationRange {
  final Duration start;
  final Duration end;

  bool equals(DurationRange range) {
    bool isStartEquiv = range.start.inMilliseconds == start.inMilliseconds;
    bool isEndEquiv = range.end.inMilliseconds == end.inMilliseconds;

    return isStartEquiv && isEndEquiv;
  }

  DurationRange({
    required this.start,
    required this.end,
  });
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
      bool isLinux = Platform.isLinux;

      if (isFFmpegAvailable) {
        result.setResultReasoning(
          "FFmpeg is already available on your device.",
        );
      } else {
        if (isWindows) {
          // TODO: On complete, delete FFmpeg temporary compressed file (administrative permissions).
          bool isDownloadSuccess = await _ffmpeg.setupFFMpegOnWindows(
            onProgress: (progress) {
              print(
                  "Download state: ${progress.downloaded}, ${progress.downloaded}, ${progress.phase}");
              if (onProgress != null) {
                onProgress(progress);
              }
            },
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
        } else if (isLinux) {
          result.setResultReasoning(
            "Linux platforms must download FFmpeg through linux terminal, use ${'"sudo apt-get install ffmpeg"'} to download the required tool to execute this function.",
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

  static Future<Map<dynamic, dynamic>?> getVidInformation(
      String filePath) async {
    final MediaInformation? mediaInfo = await _ffmpeg.runProbe(filePath);
    final Map<dynamic, dynamic>? mediaProperties =
        mediaInfo?.getAllProperties();

    return mediaProperties;
  }

  static Future<Size?> getVidRes(String filePath) async {
    Size? resolution;
    final Map<dynamic, dynamic>? vidInfo = await getVidInformation(filePath);
    if (vidInfo != null) {
      resolution = Size(
        vidInfo["streams"][0]['width'].toDouble(),
        vidInfo["streams"][0]['height'].toDouble(),
      );
    }

    return resolution;
  }

  static Future<Duration?> getVidTotalDuration(String filePath) async {
    Duration? duration;

    final Map<dynamic, dynamic>? mediaProperties = await getVidInformation(
      filePath,
    );

    final String? vidTotalDurationArg =
        mediaProperties?["streams"][0]["duration"];

    if (vidTotalDurationArg != null) {
      final double? totalDurationInSeconds = double.tryParse(
        vidTotalDurationArg,
      );

      if (totalDurationInSeconds != null) {
        duration = Duration(
          microseconds: ((totalDurationInSeconds * 1000) * 1000).toInt(),
        );
      }
    }

    return duration;
  }

  static Future<int?> _getVidTotalFrames(String filePath) async {
    int? vidTotalFrames;

    final Map<dynamic, dynamic>? mediaProperties = await getVidInformation(
      filePath,
    );

    final String? vidTotalFramesArg =
        mediaProperties?["streams"][0]["nb_frames"];

    if (vidTotalFramesArg != null) {
      vidTotalFrames = int.tryParse(vidTotalFramesArg);
    }

    return vidTotalFrames;
  }

  static FFMpegCommand _createFFmpegCliCommand({
    required int frameToCatch,
    required String inputPath,
    required String outputFilepath,
  }) {
    return FFMpegCommand(
      inputs: [
        // Video input file is set here.
        FFMpegInput.asset(
          inputPath,
        ),
      ],
      args: [
        SelectFramePosition(
          frameToCatch: frameToCatch,
        ),
        ExtractCurrentlySelectedFrame(),
        const OverwriteArgument(),
      ],
      outputFilepath: outputFilepath,
    );
  }

  static void _runFFmpegCommand(
    FFMpegCommand cliCommand,
    void Function(File? file) onComplete,
  ) async {
    _ffmpeg.runAsync(
      cliCommand,
      onComplete: onComplete,
    );
  }

  static Future<String> _getAppLocalImagesPath() async {
    final docDir = await getApplicationDocumentsDirectory();
    final appDir = "${docDir.path}\\video_analytics";
    final imagesDir = "$appDir\\videos_frames";
    await createFolderIfNotExists(imagesDir);

    return imagesDir;
  }

  static String _getUniqueFilenameFromFilePath(String filePath) {
    final DateTime curDate = DateTime.now();
    final String filename = filePath.split("\\").last.split('.').first;
    return "${filename}_${curDate.millisecondsSinceEpoch}";
  }

  static Future<String> _getVideoFramesOutputPath(String videoPath) async {
    final String appImagesFolderPath = await _getAppLocalImagesPath();
    final String uniqueFilename = _getUniqueFilenameFromFilePath(videoPath);
    final String framesFolder = "$appImagesFolderPath\\$uniqueFilename";
    await createFolderIfNotExists(framesFolder);

    return framesFolder;
  }

  static String _getFrameOutputPathWithFolder(
          {required String folderPath, required int frame}) =>
      "$folderPath\\frame_$frame.bmp";

  // static Future<String> _getFrameOutputPath({
  //   required String videoPath,
  //   required int currentFrame,
  // }) async {
  //   final String framesOutputFolderPath = await _getVideoFramesOutputPath(
  //     videoPath,
  //   );

  //   final String outputFilepath = _getFrameOutputPathWithFolder(
  //     framesOutputFolderPath,
  //     currentFrame,
  //   );

  //   return outputFilepath;
  // }

  static int _getFramePosition(
    int totalFrames,
    Duration totalDuration,
    Duration selectedDuration,
  ) =>
      (totalFrames ~/
          (totalDuration.inMicroseconds / selectedDuration.inMicroseconds)) +
      1;

  static Future<void> _getSelectedVidFrame({
    required int frame,
    required String inputPath,
    required String outputFilepath,
    required void Function(File? file) onFrameGenerated,
  }) async {
    final FFMpegCommand ffmpegCommand = _createFFmpegCliCommand(
      frameToCatch: frame,
      inputPath: inputPath,
      outputFilepath: outputFilepath,
    );

    _runFFmpegCommand(
      ffmpegCommand,
      onFrameGenerated,
    );
  }

  static getFFmpegVideoFrames(
    String videoPath,
    DurationRange durationRange,
    void Function(File? frameFile) onFrameGenerated,
  ) async {
    final int? vidFrames = await _getVidTotalFrames(videoPath);
    final Duration? totalDuration = await getVidTotalDuration(videoPath);

    final int startFrame = _getFramePosition(
      vidFrames!,
      totalDuration!,
      durationRange.start,
    );

    final int lastFrame = _getFramePosition(
      vidFrames,
      totalDuration,
      durationRange.end,
    );

    final String framesOutputFolderPath = await _getVideoFramesOutputPath(
      videoPath,
    );

    for (var frame = startFrame; frame < lastFrame; frame++) {
      final String outputFilepath = _getFrameOutputPathWithFolder(
        folderPath: framesOutputFolderPath,
        frame: frame,
      );

      _getSelectedVidFrame(
        frame: frame,
        inputPath: videoPath,
        outputFilepath: outputFilepath,
        onFrameGenerated: onFrameGenerated,
      );
    }
  }
}
