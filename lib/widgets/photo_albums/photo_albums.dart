import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_analytics/extensions/directory_extension.dart';
import 'package:video_analytics/utils/date_format.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import 'package:video_analytics/widgets/photo_albums/components/album.dart';

class SimpleDate {
  final int year;
  final int month;
  final int day;

  bool equals(SimpleDate date) {
    final bool yearEquals = date.year == year;
    final bool monthEquals = date.month == month;
    final bool dayEquals = date.day == day;

    return yearEquals && monthEquals && dayEquals;
  }

  String extend() {
    final String monthName = getMonthName(month);
    final String daySuffix = getDaySuffix(day);
    final String formattedDate = "$monthName $day$daySuffix, $year";

    return formattedDate;
  }

  SimpleDate({
    required this.year,
    required this.month,
    required this.day,
  });

  SimpleDate.fromDateTime({
    required DateTime dateTime,
  })  : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day;
}

class DatedAlbums {
  final List<Directory> albums = [];
  final SimpleDate updatedAt;

  void addAlbum(Directory album) => albums.add(album);

  DatedAlbums({
    required this.updatedAt,
  });
}

class PhotoAlbums extends StatefulWidget {
  const PhotoAlbums({super.key});

  @override
  State<PhotoAlbums> createState() => _PhotoAlbumsState();
}

class _PhotoAlbumsState extends State<PhotoAlbums> {
  // final List<Directory> albums = [];
  final List<DatedAlbums> _datedAlbums = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> _autoSetAlbumsDir() async {
    // Get root directory access
    final Directory docsDir = await getApplicationDocumentsDirectory();
    final Directory rootDir = Directory(
      "${docsDir.path}\\video_analytics\\videos_frames",
    );

    // List all contents of the directory
    List<FileSystemEntity> dirContents = rootDir.listSync();

    // Filter out directories
    for (FileSystemEntity entity in dirContents) {
      if (entity is Directory) {
        final updatedAt = await entity.getUpdatedAt();
        final simpleUpdatedAt = SimpleDate.fromDateTime(
          dateTime: updatedAt,
        );

        final DatedAlbums? selectedDatedAlbums = _datedAlbums.firstWhereOrNull(
          (e) => e.updatedAt.equals(
            simpleUpdatedAt,
          ),
        );

        if (selectedDatedAlbums != null) {
          selectedDatedAlbums.addAlbum(entity);
        } else {
          final newDatedAlbums = DatedAlbums(
            updatedAt: simpleUpdatedAt,
          );

          newDatedAlbums.addAlbum(entity);
          _datedAlbums.add(newDatedAlbums);
        }

        setState(() => {});
      }
    }
  }

  @override
  void initState() {
    _autoSetAlbumsDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SHOULD USE
    return ListView.separated(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: _datedAlbums.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: 8,
      ),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: ColumnSeparated(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _datedAlbums[index].updatedAt.extend(),
              ),
              Wrap(
                children: _datedAlbums[index]
                    .albums
                    .map(
                      (e) => PhotoAlbum(
                        album: e,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
