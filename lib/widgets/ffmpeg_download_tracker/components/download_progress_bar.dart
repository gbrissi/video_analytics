import 'package:flutter/material.dart';

class DownloadProgressBar extends StatefulWidget {
  const DownloadProgressBar({
    super.key,
    required this.progress,
  });
  final double progress;

  @override
  State<DownloadProgressBar> createState() => _DownloadProgressBarState();
}

class _DownloadProgressBarState extends State<DownloadProgressBar> {
  ThemeData get themeData => Theme.of(context);
  Color get downloadedColor => themeData.buttonTheme.colorScheme!.primary;
  Color get progressBarColor => Colors.grey.shade500;
  late double totalDownloadedStop = _getTotalDownloadedStop();
  double _getTotalDownloadedStop() => widget.progress / 100;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      setState(() {
        totalDownloadedStop = _getTotalDownloadedStop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            downloadedColor,
            downloadedColor,
            progressBarColor,
            progressBarColor,
          ],
          stops: [
            0.0,
            totalDownloadedStop,
            totalDownloadedStop,
            1.0,
          ],
        ),
      ),
    );
  }
}
