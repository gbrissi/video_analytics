import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/providers/path_controller.dart';
import 'package:video_analytics/providers/theme_provider.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import 'package:video_analytics/widgets/sidebar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class Shell extends StatefulWidget {
  const Shell({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  late final _pathController = context.read<PathController>();

  @override
  void initState() {
    _pathController.initializePathController(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ThemeProvider, bool>(
      selector: (_, provider) => provider.isLoad,
      builder: (_, isLoad, __) {
        if (isLoad) {
          return Scaffold(
            body: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Sidebar(),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      WindowTitleBarBox(
                        child: Row(
                          children: [
                            Expanded(child: MoveWindow()),
                            MinimizeWindowButton(),
                            CloseWindowButton()
                          ],
                        ),
                      ),
                      Expanded(
                        child: widget.child,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Material(
          child: Center(
            child: ColumnSeparated(
              spacing: 32,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: const [
                Text(
                  "Loading theme settings...",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
