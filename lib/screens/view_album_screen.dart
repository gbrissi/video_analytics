import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_analytics/extensions/list_extension.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import 'package:video_analytics/widgets/descriptive_text_section.dart';

import '../widgets/file_frame.dart';

class ViewAlbumScreen extends StatefulWidget {
  final Directory album;

  const ViewAlbumScreen({
    super.key,
    required this.album,
  });

  @override
  State<ViewAlbumScreen> createState() => _ViewAlbumScreenState();
}

class _ViewAlbumScreenState extends State<ViewAlbumScreen> {
  final List<File> files = [];
  List<File> get sortedFiles => files.sortPosition();

  Future<void> _autoSetFiles() async {
    await for (FileSystemEntity entity in widget.album.list()) {
      if (entity is File) {
        setState(() {
          files.add(entity);
        });
      }
    }
  }

  @override
  void initState() {
    _autoSetFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ColumnSeparated(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButton(
            // TODO: context.pop() is not triggering routeInformationProvider listener.
            onPressed: () => context.goNamed("Album"),
          ),
          Flexible(
            child: ColumnSeparated(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DescriptiveTextSection(
                  title: "Generated album",
                  subtitle: "Check the details about your generated album",
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          children: sortedFiles
                              .map(
                                (file) => FileFrame(
                                  file: file,
                                  width: constraints.maxWidth / 6 - 12,
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
