import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:video_analytics/extensions/date_time_extension.dart';
import 'package:video_analytics/extensions/directory_extension.dart';
import 'package:video_analytics/widgets/photo_albums/components/album.dart';
import 'package:video_analytics/widgets/row_separated.dart';
import 'package:path/path.dart' as path;

class FileFrame extends StatefulWidget {
  const FileFrame({
    super.key,
    required this.file,
    this.width = 120,
  });
  final File file;
  final double width;

  @override
  State<FileFrame> createState() => _FileFrameState();
}

class _FileFrameState extends State<FileFrame> {
  double get _videoAspectRatio => 16 / 9;
  BorderRadius get _borderRadius => BorderRadius.circular(4);
  late final FileImage _imageProvider = FileImage(widget.file);
  bool _isImageLoading = true;

  Widget get _image => Image(
        image: _imageProvider,
      );

  Widget get _imagePlaceholder => const Center(
        child: CircularProgressIndicator(),
      );

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ImgDialog(
          file: widget.file,
        );
      },
    );
  }

  @override
  void initState() {
    _imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (_, __) {
          if (mounted) {
            setState(() {
              _isImageLoading = false;
            });
          }
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
        margin: EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _showImageDialog,
            child: SizedBox(
              width: widget.width,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoAspectRatio,
                    child: _isImageLoading ? _imagePlaceholder : _image,
                  ),
                  Text(
                    widget.file.path.split("\\").last,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImgDialog extends StatefulWidget {
  final File file;

  const ImgDialog({
    super.key,
    required this.file,
  });

  @override
  State<ImgDialog> createState() => _ImgDialogState();
}

class _ImgDialogState extends State<ImgDialog> {
  final Map<String, String> _fileMetadata = <String, String>{};
  late final Image image = Image.file(widget.file);

  Future<void> _setFileMetadata() async {
    final String filePath = widget.file.path;
    final String size = await widget.file.getFormattedLength();
    final DateTime updatedAt = await widget.file.getUpdatedAt();
    final String fileName = filePath.split("\\").last;

    if (mounted) {
      setState(() {
        _fileMetadata.addAll({
          "name": fileName,
          "path": filePath,
          "size": size,
          "updated at": updatedAt.stringify(),
        });
      });
    }
  }

  void _openFolder() => OpenFile.open(
        path.dirname(widget.file.path),
      );

  @override
  void initState() {
    _setFileMetadata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Image.file(
              widget.file,
              width: MediaQuery.of(context).size.width / 1.5,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: RowSeparated(
                spacing: 8,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _openFolder,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.folder_open,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
