import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_analytics/providers/file_controller.dart';
import 'package:video_analytics/providers/video_details_controller.dart';
import 'package:video_analytics/widgets/column_separated.dart';
import '../extensions/date_time_extension.dart';
import '../extensions/duration_extension.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({
    super.key,
    required this.filePath,
  });
  final String filePath;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  late final _controller = context.read<VideoDetailsController>();
  late final _fileController = context.read<FileController>();

  void _initializeSettings() =>
      _controller.initializeVideoDataExtraction(widget.filePath);

  void _removeImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove video'),
          content:
              const Text('Are you sure that you want to remove this video?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _fileController.removeFile();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _initializeSettings(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // TODO: Temporarily replicating video player height through hard coding.
      // width: 500 - (500 * 0.25),
      height: 500 * (9.0 / 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Selector<VideoDetailsController, bool>(
            selector: (_, provider) => provider.isInitialized,
            builder: (_, isInitialized, __) {
              if (!_controller.isError) {
                return ColumnSeparated(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Video details",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Flexible(
                      child: Skeletonizer(
                        enabled: !_controller.isInitialized,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FileDetail(
                              text: _controller.fileName ?? "filename unknown",
                              label: "Filename",
                            ),
                            FileDetail(
                              label: "Filepath",
                              text: _controller.filePath ?? "path unknown",
                            ),
                            FileDetail(
                              label: "Resolution",
                              text: _controller.resolution != null
                                  ? "${_controller.resolution!.width.toInt()}x${_controller.resolution!.height.toInt()}"
                                  : "resolution unknown",
                            ),
                            FileDetail(
                              label: "Framerate",
                              text: _controller.framerate?.toString() ??
                                  "framerate unknown",
                            ),
                            FileDetail(
                              label: "Duration",
                              text: _controller.duration?.stringify() ??
                                  "duration unknown",
                            ),
                            FileDetail(
                              label: "Created At",
                              text: _controller.createdAt?.stringify() ??
                                  "creation date unknown",
                            ),
                            FileDetail(
                              label: "File size",
                              text: _controller.fileSize ?? "size unknown",
                            ),
                            FileDetail(
                              label: "Mime type",
                              text: _controller.fileType ?? "type unknown",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: _removeImage,
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text(
                            "Remove selected video",
                          ),
                        )
                      ],
                    )
                  ],
                );
              }

              return ColumnSeparated(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Failed to retrieve video details",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "If you want to try to extract the video details again, click in the button right below.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _initializeSettings,
                          icon: const Icon(Icons.replay),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FileDetail extends StatelessWidget {
  const FileDetail({
    super.key,
    required this.text,
    required this.label,
  });
  final String text;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${label.toLowerCase()}: ",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
