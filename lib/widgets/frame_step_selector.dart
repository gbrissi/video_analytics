import 'package:flutter/material.dart';
import 'package:video_analytics/widgets/row_separated.dart';
import 'package:video_analytics/widgets/settings_selector.dart';

import '../constants/input_decorations.dart';

extension CaptureTypeExtension on CaptureType {
  String get label {
    switch (this) {
      case CaptureType.perXSecond:
        return "every";
      case CaptureType.totalFrames:
        return "total";
      case CaptureType.everyFrame:
        return "every image";
    }
  }
}

enum CaptureType {
  perXSecond,
  totalFrames,
  everyFrame,
}

class FrameStepSelector extends StatefulWidget {
  const FrameStepSelector({super.key});

  @override
  State<FrameStepSelector> createState() => _FrameStepSelectorState();
}

class _FrameStepSelectorState extends State<FrameStepSelector> {
  final _secondsTextController = TextEditingController();
  CaptureType _captureType = CaptureType.everyFrame;

  void _setCaptureType(CaptureType captureType) {
    setState(() {
      _captureType = captureType;
    });
  }

  void _positionCursorToTheEnd() {
    _secondsTextController.selection = TextSelection.collapsed(
      offset: _secondsTextController.text.length,
    );
  }

  void _filterInput() {
    if (_secondsTextController.text.isEmpty) {
      _secondsTextController.text = "0";
      _positionCursorToTheEnd();
    }

    if (_secondsTextController.text.length > 1 &&
        _secondsTextController.text.startsWith("0")) {
      _secondsTextController.text = _secondsTextController.text.substring(
        1,
        _secondsTextController.text.length,
      );

      _positionCursorToTheEnd();
    }
  }

  @override
  void initState() {
    _secondsTextController.text = "0";
    _secondsTextController.addListener(_filterInput);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 12,
      children: [
        const Text(
          "Frame capture",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        RowSeparated(
          spacing: 12,
          children: [
            SettingsSelector(
              selectedOption: _captureType,
              onChanged: _setCaptureType,
              options: CaptureType.values
                  .map(
                    (e) => SelectorOption(
                      value: e,
                      name: e.label,
                    ),
                  )
                  .toList(),
            ),
            if (_captureType == CaptureType.perXSecond)
              IntrinsicWidth(
                child: RowSeparated(
                  spacing: 12,
                  children: [
                    Flexible(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextField(
                            controller: _secondsTextController,
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecorations.unstyled,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "second(s)",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              )
            else if (_captureType == CaptureType.totalFrames)
              IntrinsicWidth(
                child: RowSeparated(
                  spacing: 12,
                  children: [
                    Flexible(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: TextField(
                            controller: _secondsTextController,
                            enableInteractiveSelection: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecorations.unstyled,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "frame(s)",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              )
          ],
        )
      ],
    );
  }
}
