import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:video_analytics/extensions/date_time_extension.dart';
import 'package:video_analytics/extensions/directory_extension.dart';
import 'package:video_analytics/widgets/column_separated.dart';

class PhotoAlbum extends StatefulWidget {
  const PhotoAlbum({
    super.key,
    required this.album,
  });
  final Directory album;

  @override
  State<PhotoAlbum> createState() => _PhotoAlbumState();
}

class _PhotoAlbumState extends State<PhotoAlbum> {
  String get _dirname => widget.album.path.split("\\").last;
  Color get _iconColor => Theme.of(context).colorScheme.primary;
  BorderRadius get _borderRadius => BorderRadius.circular(8);
  final Map<String, String> _fileMetadata = <String, String>{};
  bool _isHovering = false;

  void _openDir() => context.pushNamed("ViewAlbum", extra: <String, dynamic>{
        "directory": widget.album,
      });

  void _setHoverState(bool state) {
    setState(() {
      _isHovering = state;
    });
  }

  Future<void> _setFileMetadata() async {
    final String albumPath = widget.album.path;
    final String size = await widget.album.getFormattedSize();
    final int totalFiles = await widget.album.list().length;
    final DateTime updatedAt = await widget.album.getUpdatedAt();

    if (mounted) {
      setState(() {
        _fileMetadata.addAll({
          "name": _dirname,
          "path": albumPath,
          "size": size,
          "total files": totalFiles.toString(),
          "updated at": updatedAt.stringify(),
        });
      });
    }
  }

  @override
  void initState() {
    _setFileMetadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: _borderRadius,
            ),
            child: ClipRRect(
              borderRadius: _borderRadius,
              child: Material(
                color: Colors.transparent,
                child: MouseRegion(
                  onEnter: (_) => _setHoverState(true),
                  onExit: (_) => _setHoverState(false),
                  child: InkWell(
                    onTap: _openDir,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ColumnSeparated(
                        spacing: 8,
                        children: [
                          FaIcon(
                            _isHovering
                                ? FontAwesomeIcons.folderOpen
                                : FontAwesomeIcons.folder,
                            color: _iconColor,
                            size: 36,
                          ),
                          Text(
                            _dirname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Tooltip(
              richMessage: TextSpan(
                children: _fileMetadata.entries.expand((entry) {
                  return [
                    FileMeta(label: entry.key, value: entry.value),
                    if (_fileMetadata.entries.last.key != entry.key)
                      const TextSpan(text: '\n'),
                  ];
                }).toList(),
              ),
              child: const Icon(
                Icons.info_outline,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FileMeta extends TextSpan {
  const FileMeta({
    required String label,
    required String value,
  }) : super(
          text: '$label: $value',
          style: const TextStyle(
            fontSize: 14,
          ),
        );
}
