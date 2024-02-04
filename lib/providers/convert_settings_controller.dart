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

  DurationRange? get durationRange => _durationRange;
  ImgFormat get imgFormat => _imgFormat;
  bool get isInitialized => _isInitialized;

  initializeSettings(File vidFile) async {
    _isInitialized = false;
    notifyListeners();

    final Duration? totalDuration = await FFmpegService.getVidTotalDuration(
      vidFile.path,
    );

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
    if (end == null) throw ("Duration end has not been properly setted");

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
