import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/widgets/color_selector/components/small_circular_button.dart';

import '../../../providers/theme_provider.dart';

class ColorOption extends StatefulWidget {
  const ColorOption({super.key, required this.color});
  final Color color;

  @override
  State<ColorOption> createState() => _ColorOptionState();
}

class _ColorOptionState extends State<ColorOption> {
  late final _controller = context.read<ThemeProvider>();

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeProvider, Color>(
      selector: (_, provider) => provider.colorSeed,
      builder: (_, colorSeed, __) {
        return SmallCircularButton(
          onTap: () => _controller.setColorSeed(widget.color.withOpacity(1.0)),
          color: widget.color,
          isSelected: colorSeed.value == widget.color.value,
        );
      },
    );
  }
}
