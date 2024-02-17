import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';
import 'package:video_analytics/widgets/settings_selector.dart';

class ImageFormatSelector extends StatefulWidget {
  const ImageFormatSelector({super.key});

  @override
  State<ImageFormatSelector> createState() => _ImageFormatSelectorState();
}

class _ImageFormatSelectorState extends State<ImageFormatSelector> {
  late final _controller = context.read<ConvertSettingsController>();

  @override
  Widget build(BuildContext context) {
    return Selector<ConvertSettingsController, ImgFormat>(
      selector: (_, provider) => provider.imgFormat,
      builder: (_, imgFormat, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Image format",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SettingsSelector<ImgFormat>(
              selectedOption: imgFormat,
              options: ImgFormat.values
                  .map(
                    (imgFormat) => SelectorOption(
                      value: imgFormat,
                      name: ".${imgFormat.name}",
                    ),
                  )
                  .toList(),
              onChanged: _controller.setImgFormat,
            ),
          ],
        );
      },
    );
  }
}
