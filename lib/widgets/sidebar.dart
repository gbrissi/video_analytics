import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/theme_provider.dart';
import 'package:video_analytics/utils/get_text_color.dart';
import 'package:video_analytics/widgets/color_selector/color_selector.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import 'package:video_analytics/widgets/row_separated.dart';

import '../providers/path_controller.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
                right: 8,
                left: 8,
              ),
              child: Text(
                "General",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.7),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            ColumnSeparated(
              spacing: 8,
              mainAxisSize: MainAxisSize.max,
              children: const [
                SidebarLinkButton(
                  label: "Conversion",
                  path: "/convert",
                  icon: Icons.sync,
                ),
                SidebarLinkButton(
                  label: "Album",
                  path: "/album",
                  icon: Icons.photo_album,
                )
              ],
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SettingsSidebarButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsSidebarButton extends StatefulWidget {
  const SettingsSidebarButton({super.key});

  @override
  State<SettingsSidebarButton> createState() => _SettingsSidebarButtonState();
}

class _SettingsSidebarButtonState extends State<SettingsSidebarButton> {
  void _openSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          contentPadding: const EdgeInsets.all(4),
          title: const Text("Settings"),
          content: ColumnSeparated(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: const [
              ThemeSwitcher(),
              ColorSelector(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SidebarButton(
      icon: Icons.settings,
      label: "Settings",
      onTap: _openSettingsDialog,
      bgColor: Colors.transparent,
      textColor: Theme.of(context).textTheme.bodyMedium!.color!,
    );
  }
}

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  late final _controller = context.read<ThemeProvider>();
  bool get _isDark => _controller.brightness == Brightness.dark ? true : false;

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeProvider, Brightness>(
      selector: (_, provider) => provider.brightness,
      builder: (_, brightness, __) {
        return SwitchListTile(
          title: const Text("Dark mode"),
          subtitle: const Text("Activate the dark mode UI"),
          value: _isDark,
          onChanged: (_) => _controller.setBrightness(
            _isDark ? Brightness.light : Brightness.dark,
          ),
        );
      },
    );
  }
}

class SidebarLinkButton extends StatefulWidget {
  const SidebarLinkButton({
    super.key,
    required this.label,
    required this.path,
    required this.icon,
  });
  final String label;
  final IconData icon;
  final String path;

  @override
  State<SidebarLinkButton> createState() => _SidebarButtonState();
}

class _SidebarButtonState extends State<SidebarLinkButton> {
  Color get _primaryColor => Theme.of(context).colorScheme.primary;
  late final _pathController = context.read<PathController>();

  void _navigateToPath() {
    context.go(
      widget.path,
    );
  }

  bool get _isCurrentPath => _pathController.routerPath == widget.path;
  late bool _isActive;
  Color get _lightColor => _primaryColor.withOpacity(0.1);
  Color get _buttonBgColor => !_isActive ? _lightColor : _primaryColor;
  Color get _buttonTextColor => !_isActive
      ? _primaryColor
      : getTextColor(
          _primaryColor,
        );

  void _updateButtonState() {
    if (mounted && _isActive != _isCurrentPath) {
      setState(() {
        _isActive = _isCurrentPath;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isActive = _isCurrentPath;
    _pathController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    super.dispose();
    _pathController.removeListener(_updateButtonState);
  }

  @override
  Widget build(BuildContext context) {
    return SidebarButton(
      icon: widget.icon,
      textColor: _buttonTextColor,
      bgColor: _buttonBgColor,
      label: widget.label,
      onTap: _navigateToPath,
    );
  }
}

class SidebarButton extends StatelessWidget {
  const SidebarButton({
    super.key,
    required this.icon,
    required this.textColor,
    required this.bgColor,
    required this.label,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final void Function()? onTap;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: bgColor,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              child: RowSeparated(
                spacing: 8,
                children: [
                  Icon(
                    icon,
                    color: textColor,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
