import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/widgets/color_selector/providers/custom_color_provider.dart';

import 'components/color_option.dart';
import 'components/select_color_option.dart';
import 'constants/preset_colors.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomColorsProvider(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                "Select your app color",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Consumer<CustomColorsProvider>(
              builder: (_, provider, __) {
                return Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.from(
                    [
                      ...PresetColors.colors.map(
                        (e) => ColorOption(color: e),
                      ),
                      ...provider.customColors.map(
                        (e) => ColorOption(
                          color: e,
                        ),
                      ),
                      const SelectColorOption()
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
