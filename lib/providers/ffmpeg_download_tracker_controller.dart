import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:flutter/material.dart';

class FFmpegDownloadTrackerController extends ChangeNotifier {
  bool _showDownloadTracker = false;
  double _totalDownloadProgress = 0;

  double get totalDownloadProgress => _totalDownloadProgress;
  bool get showDownloadTracker => _showDownloadTracker;

  calculateFFmpegProgress(FFMpegProgress value) {
    double progress = (value.downloaded / value.fileSize) * 100;
    setDownloadProgress(progress);
  }

  setDownloadProgress(double value) {
    _totalDownloadProgress = value;
    notifyListeners();
  }

  setDownloadTrackerStatus(bool showTracker) {
    _showDownloadTracker = showTracker;
    notifyListeners();
  }
}
