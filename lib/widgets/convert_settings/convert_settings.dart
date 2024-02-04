import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';

import '../duration_text_field.dart';

class VideoRangeSelector extends StatefulWidget {
  const VideoRangeSelector({
    super.key,
    required this.file,
  });
  final File file;

  @override
  State<VideoRangeSelector> createState() => _ConvertSettingsState();
}

class _ConvertSettingsState extends State<VideoRangeSelector> {
  late final _settingsController = context.read<ConvertSettingsController>();
  late DurationRange durationRange;
  DurationRange? get settingsRange => _settingsController.durationRange;

  void _setStartDuration(Duration value) =>
      _settingsController.setStartDuration(value);
  void _setEndDuration(Duration value) =>
      _settingsController.setEndDuration(value);

  void _updateSettings() {
    if (settingsRange != null && mounted) {
      if (!durationRange.equals(settingsRange!)) {
        setState(() {
          durationRange = settingsRange!;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: Placeholder.
    durationRange = _settingsController.durationRange ??
        DurationRange(
          start: Duration.zero,
          end: Duration.zero,
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _settingsController.initializeSettings(widget.file);
      _settingsController.addListener(_updateSettings);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecione o periodo do vídeo em que os frames serão extraídos",
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IntrinsicWidth(
              child: DurationTextField(
                initialValue: durationRange.start,
                maxDuration: durationRange.end,
                onChanged: _setEndDuration,
              ),
            ),
            const Text(
              "-",
            ),
            IntrinsicWidth(
              child: DurationTextField(
                initialValue: durationRange.end,
                minDuration: durationRange.start,
                onChanged: _setStartDuration,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
