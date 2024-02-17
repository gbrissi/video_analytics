import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';
import 'package:video_analytics/utils/format_bytes.dart';

class VideoDetailsController extends ChangeNotifier {
  String? _filePath;
  String? _fileName;
  Size? _resolution;
  double? _framerate;
  Duration? _duration;
  DateTime? _createdAt;
  String? _fileSize;
  String? _fileType;

  bool _isInitialized = false;
  bool _isError = false;
  bool get isInitialized => _isInitialized;
  bool get isError => _isError;

  String? get fileName => _fileName;
  String? get filePath => _filePath;
  Size? get resolution => _resolution;
  String? get framerate => _framerate?.toStringAsFixed(2);
  Duration? get duration => _duration;
  DateTime? get createdAt => _createdAt;
  String? get fileSize => _fileSize;
  String? get fileType => _fileType;

  Future<void> initializeVideoDataExtraction(String filePath) async {
    final Map<dynamic, dynamic>? infoDetails =
        await FFmpegService.getVidInformation(
      filePath,
    );

    if (infoDetails != null) {
      final Map<String, dynamic> streamDetails = infoDetails["streams"][0]!;

      _filePath = filePath;
      _fileName = _filePath!.split("\\").last;
      final Map<String, dynamic>? streamTags = streamDetails["tags"];
      final String? streamDuration = streamDetails["duration"];
      final int? streamWidth = streamDetails["width"];
      final int? streamHeight = streamDetails["height"];
      final String? streamFramerate = streamDetails["avg_frame_rate"];

      if (streamFramerate != null) {
        final List<int> framerateDiv = streamDetails["avg_frame_rate"]
            .split("/")
            .map<int>(
              (e) => int.parse(e),
            )
            .toList();

        _framerate = framerateDiv[0] / framerateDiv[1];
      }

      if (streamWidth != null && streamHeight != null) {
        _resolution = Size(
          streamDetails["width"].toDouble(),
          streamDetails["height"].toDouble(),
        );
      }

      if (streamTags != null) {
        final String? streamCreationTime = streamTags["creation_time"];

        if (streamCreationTime != null) {
          _createdAt = DateTime.parse(
            streamCreationTime,
          );
        }
      }

      if (streamDuration != null) {
        _duration = Duration(
          milliseconds: (double.parse(streamDuration) * 1000).toInt(),
        );
      }

      final File file = File(filePath);
      _fileSize = formatBytes(file.lengthSync());
      _fileType = lookupMimeType(
        file.path,
        headerBytes: file.readAsBytesSync(),
      );
    } else {
      _isError = true;
    }

    _isInitialized = true;
    notifyListeners();
  }
}
