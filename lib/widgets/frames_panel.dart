import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/frames_panel_controller.dart';

import 'file_frame.dart';

class FramesPanel extends StatelessWidget {
  const FramesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FramesPanelController>(
      builder: (context, provider, child) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: provider.sortedFiles
              .map(
                (file) => FileFrame(
                  file: file,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
