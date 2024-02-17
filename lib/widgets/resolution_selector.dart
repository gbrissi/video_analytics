import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/convert_settings_controller.dart';
import 'package:video_analytics/widgets/settings_selector.dart';

extension ResolutionExtension on ResEnum {
  double get baseSize {
    switch (this) {
      case ResEnum.extraTiny:
        return 320;
      case ResEnum.tiny:
        return 480;
      case ResEnum.small:
        return 640;
      case ResEnum.mediumSmall:
        return 800;
      case ResEnum.medium:
        return 1024;
      case ResEnum.mediumLarge:
        return 1280;
      case ResEnum.large:
        return 1920;
      case ResEnum.extraLarge:
        return 2560;
    }
  }

  Size getSizeWithAspectRatio(double ratio) {
    if (ratio < 1) {
      return Size(
        baseSize * ratio,
        baseSize,
      );
    } else {
      return Size(
        baseSize,
        baseSize / ratio,
      );
    }
  }
}

class Resolution {
  final Size size;
  final bool isPreset;

  double get aspectRatio => (size.width / size.height);
  double get baseSize => size.width > size.height ? size.width : size.height;

  String stringify() => '${size.width.toInt()}x${size.height.toInt()}';

  Resolution({
    required this.size,
  }) : isPreset = false;

  Resolution.fromResEnum({
    required ResEnum resEnum,
    required double aspectRatio,
  })  : size = resEnum.getSizeWithAspectRatio(aspectRatio),
        isPreset = true;
}

enum ResEnum {
  extraTiny,
  tiny,
  small,
  mediumSmall,
  medium,
  mediumLarge,
  large,
  extraLarge,
}

class ResolutionSelector extends StatefulWidget {
  const ResolutionSelector({super.key});

  @override
  State<ResolutionSelector> createState() => _SelectResolutionState();
}

class _SelectResolutionState extends State<ResolutionSelector> {
  late final _controller = context.read<ConvertSettingsController>();
  late Resolution _selectedResolution = _validResolutions.first;

  Size? get _size => _controller.videoRes;
  double? get _highestSizeInRes => _controller.highestSizeInRes;
  double? get _aspectRatio => _controller.aspectRatio;
  Resolution? get _resolution =>
      _size != null ? Resolution(size: _size!) : null;

  List<Resolution> get _validResolutions => _size != null
      ? [
          ...ResEnum.values
              .where((e) => e.baseSize <= _highestSizeInRes!)
              .map((e) => _getResFromEnum(e))
              .toList(),
          // Original resolution
          _resolution,
        ].whereType<Resolution>().toList()
      : ResEnum.values.map((e) => _getResFromEnum(e)).toList();

  Resolution _getResFromEnum(ResEnum resEnum) {
    return Resolution.fromResEnum(
      resEnum: resEnum,
      aspectRatio: _aspectRatio ?? 16 / 9,
    );
  }

  void _setResolution(Resolution resolution) {
    setState(() {
      _selectedResolution = resolution;
    });
  }

  void _updateResolution() {
    if (_size != _selectedResolution.size && _size != null && mounted) {
      _setResolution(
        _resolution!,
      );
    }
  }

  @override
  void initState() {
    _controller.addListener(_updateResolution);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateResolution);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Image resolution",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Selector<ConvertSettingsController, Size?>(
          selector: (_, provider) => provider.videoRes,
          builder: (_, value, __) {
            return SettingsSelector(
              selectedOption: _selectedResolution,
              onChanged: _setResolution,
              equals: (e1, e2) => e1.baseSize == e2.baseSize,
              options: _validResolutions.map((e) {
                if (e.baseSize == _highestSizeInRes) {
                  return SelectorOption(
                    value: e,
                    name: "${e.stringify()} (original)",
                  );
                } else {
                  return SelectorOption(
                    value: e,
                    name: e.stringify(),
                  );
                }
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
