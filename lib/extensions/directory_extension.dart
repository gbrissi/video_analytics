import 'dart:io';

import 'package:video_analytics/utils/format_bytes.dart';

extension DirectoryExtension on Directory {
  Future<int> getSize() async {
    int size = 0;

    await for (FileSystemEntity entity in list()) {
      if (entity is File) {
        size += await entity.length();
      } else if (entity is Directory) {
        size += await entity.getSize();
      }
    }

    return size;
  }

  Future<String> getFormattedSize() async {
    final int size = await getSize();
    return formatBytes(size);
  }

  Future<DateTime> getUpdatedAt() async {
    FileStat fileStat = await stat();
    return fileStat.changed;
  }
}

extension FileExtension on File {
  Future<String> getFormattedLength() async {
    final int length = await this.length();
    return formatBytes(length);
  }

  Future<DateTime> getUpdatedAt() async {
    FileStat fileStat = await stat();
    return fileStat.changed;
  }
}
