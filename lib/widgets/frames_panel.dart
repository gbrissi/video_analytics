import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/frames_panel_controller.dart';

import 'file_frame.dart';

class FramesPanel extends StatelessWidget {
  const FramesPanel({super.key});
  double get _spacing => 8;

  @override
  Widget build(BuildContext context) {
    return Consumer<FramesPanelController>(
      builder: (context, provider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: _spacing,
              runSpacing: _spacing,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: provider.sortedFiles
                  .map(
                    (file) => FileFrame(
                      file: file,
                      width: constraints.maxWidth / 6 - _spacing,
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}
