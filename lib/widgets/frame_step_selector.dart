import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/constants/input_decorations.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';

class FrameStepSelector extends StatefulWidget {
  const FrameStepSelector({super.key});

  @override
  State<FrameStepSelector> createState() => _FrameStepSelectorState();
}

class _FrameStepSelectorState extends State<FrameStepSelector> {
  final _framesTextController = TextEditingController();
  final _secondsTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Selector<ConvertSettingsController, VidStep?>(
      selector: (_, provider) => provider.step,
      builder: (_, step, __) {
        return Row(
          children: [
            const Text(
              "Extrair ",
            ),
            IntrinsicWidth(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextField(
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    controller: _framesTextController,
                    decoration: InputDecorations.unstyled,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const Text(
              " imagens a cada ",
            ),
            IntrinsicWidth(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: TextField(
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.number,
                    controller: _secondsTextController,
                    decoration: InputDecorations.unstyled,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            const Text(" segundos"),
          ],
        );
      },
    );
  }
}
