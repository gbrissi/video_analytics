import 'package:flutter/material.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import 'package:video_analytics/widgets/descriptive_text_section.dart';

import '../widgets/photo_albums/photo_albums.dart';

class PhotoAlbumsScreen extends StatelessWidget {
  const PhotoAlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColumnSeparated(
      spacing: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.all(12),
          child: DescriptiveTextSection(
            title: "Photo Albums",
            subtitle:
                "Check here the photo albums that you've generated through the conversion process.",
          ),
        ),
        Flexible(
          child: PhotoAlbums(),
        ),
      ],
    );
  }
}
