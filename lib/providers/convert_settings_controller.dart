import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';

enum ImgFormat {
  png,
  jpg,
  bmp,
  webp,
}

class VidStep {
  final int seconds;
  final int? frames;

  VidStep(
    this.seconds,
    this.frames,
  );
}

class ConvertSettingsController extends ChangeNotifier {
  DurationRange? _durationRange;
  ImgFormat _imgFormat = ImgFormat.bmp;
  VidStep? step;
  bool _isInitialized = false;
  Size? videoRes;

  double? get aspectRatio {
    double? value;
    if (videoRes != null) {
      value = videoRes!.width / videoRes!.height;
      print("Valora qui: ${videoRes!.width}, ${videoRes!.height}, $value");
    }

    return value;
  }

  double? get highestSizeInRes {
    double? value;
    if (videoRes != null) {
      if (videoRes!.width > videoRes!.height) {
        value = videoRes!.width;
      } else {
        value = videoRes!.height;
      }
    }

    return value;
  }

  DurationRange? get durationRange => _durationRange;
  ImgFormat get imgFormat => _imgFormat;
  bool get isInitialized => _isInitialized;

  initializeSettings(File vidFile) async {
    _isInitialized = false;
    notifyListeners();

    final Duration? totalDuration = await FFmpegService.getVidTotalDuration(
      vidFile.path,
    );

    final Size? res = await FFmpegService.getVidRes(
      vidFile.path,
    );

    if (res != null) {
      setRes(res);
    }

    if (totalDuration != null) {
      setEndDuration(totalDuration);
    }

    _isInitialized = true;
    notifyListeners();
  }

  clearDurationRange(DurationRange range) {
    _durationRange = null;
    notifyListeners();
  }

  setImgFormat(ImgFormat imgFormat) {
    _imgFormat = imgFormat;
    notifyListeners();
  }

  void setRes(Size res) {
    videoRes = res;
    notifyListeners();
  }

  setEndDuration(Duration duration) {
    final Duration start = _durationRange?.start ?? Duration.zero;
    if (start.inMilliseconds < duration.inMilliseconds) {
      _durationRange = DurationRange(
        start: start,
        end: duration,
      );
    }

    notifyListeners();
  }

  setStartDuration(Duration duration) {
    final Duration? end = _durationRange?.end;
    if (end == null) throw ("Duration end has not been properly set");

    if (end.inMilliseconds < duration.inMilliseconds) {
      _durationRange = DurationRange(
        start: duration,
        end: end,
      );
    }

    notifyListeners();
  }

  setDurationRange(DurationRange range) {
    _durationRange = range;
    notifyListeners();
  }
}
