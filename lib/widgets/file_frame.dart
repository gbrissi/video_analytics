import 'dart:io';

import 'package:flutter/material.dart';

class FileFrame extends StatelessWidget {
  const FileFrame({
    super.key,
    required this.file,
  });
  final File file;
  double get _videoAspectRatio => 16 / 9;
  BorderRadius get _borderRadius => BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _borderRadius,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: _videoAspectRatio,
                child: Image.file(
                  file,
                ),
              ),
              Text(
                file.path.split("\\").last,
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
    );
  }
}
