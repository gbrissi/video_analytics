import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:video_analytics/service/ffmpeg_service.dart';
import 'package:video_analytics/widgets/convert_settings/convert_settings.dart';
import 'package:video_analytics/widgets/ffmpeg_download_tracker/ffmpeg_download_tracker.dart';
import 'package:video_analytics/widgets/file_video_player.dart';
import 'package:video_analytics/widgets/frame_step_selector.dart';
import 'package:video_analytics/widgets/frames_panel.dart';
import 'package:video_analytics/widgets/get_video_frames_button.dart';
import 'package:video_analytics/widgets/image_format_selector.dart';
import 'package:video_analytics/widgets/row_separated.dart';

import '../providers/file_controller.dart';
import '../widgets/column_separated.dart';
import '../widgets/descriptive_text_section.dart';
import '../widgets/resolution_selector.dart';
import '../widgets/video_details.dart';

class VideoSelectScreen extends StatelessWidget {
  const VideoSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FileController>(
      builder: (_, provider, __) {
        if (provider.file != null) {
          return ConvertFileToFrames(
            file: provider.file!,
          );
        } else {
          return const UploadFileZone();
        }
      },
    );
  }
}

class UploadFileZone extends StatefulWidget {
  const UploadFileZone({super.key});

  @override
  State<UploadFileZone> createState() => _UploadFileZoneState();
}

class _UploadFileZoneState extends State<UploadFileZone> {
  late final _controller = context.read<FileController>();
  bool _isDragActive = false;

  void _updateDragState(bool state) {
    setState(() {
      _isDragActive = state;
    });
  }

  void _showFileUploadError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade300,
        content: const Text(
          "The uploaded file is not a video",
        ),
      ),
    );
  }

  Future<void> _getFileDrop(xFile) async {
    final File file = File(xFile.path);
    final String filename = file.path.split("\\").last;
    final String? mimeType = lookupMimeType(filename);

    if (mimeType != null) {
      final List<String> splitType = mimeType.split("/");
      final String mainType = splitType[0];

      if (mainType == "video") {
        return _controller.setFile(file);
      }
    }

    _showFileUploadError();
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      if (file.existsSync()) {
        final String filename = file.path.split("\\").last;
        final String? mimeType = lookupMimeType(filename);

        if (mimeType != null) {
          final List<String> splitType = mimeType.split("/");
          final String mainType = splitType[0];

          if (mainType == "video") {
            return _controller.setFile(file);
          }
        }
      }

      _showFileUploadError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => _updateDragState(true),
      onDragExited: (_) => _updateDragState(false),
      onDragDone: (details) => _getFileDrop(
        details.files.first,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ColumnSeparated(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.upload,
                size: 48,
              ),
              const Text(
                "Upload your file \n clicking the button below",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FilledButton.icon(
                style: ButtonStyle(
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                onPressed: _uploadFile,
                icon: const Icon(
                  Icons.upload,
                  size: 24,
                ),
                label: const Text(
                  "Upload file",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Text(
                "or drag your file here",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
          IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _isDragActive ? 1 : 0,
              child: Container(
                color: Colors.black.withOpacity(0.9),
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(12),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colors.grey.shade100,
                  dashPattern: const [12, 12],
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: ColumnSeparated(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.upload,
                          size: 64,
                        ),
                        Text(
                          "Drop your file here",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ConvertFileToFrames extends StatelessWidget {
  final File file;
  const ConvertFileToFrames({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ColumnSeparated(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DescriptiveTextSection(
                      title: "Convert video to image album",
                      subtitle:
                          "Select a video and generate a new image album following your settings specification",
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: VideoPlayer(
                              video: file,
                            ),
                          ),
                          Flexible(
                            child: VideoDetails(
                              filePath: file.path,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ColumnSeparated(
                          spacing: 18,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DescriptiveTextSection(
                              title: "Conversion settings",
                              subtitle:
                                  "Specify your image conversion settings selecting appropriate parameters",
                            ),
                            ColumnSeparated(
                              spacing: 12,
                              children: [
                                RowSeparated(
                                  spacing: 24,
                                  children: [
                                    VideoRangeSelector(
                                      file: file,
                                    ),
                                    const ImageFormatSelector(),
                                  ],
                                ),
                                RowSeparated(
                                  spacing: 24,
                                  children: const [
                                    FrameStepSelector(),
                                    ResolutionSelector(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GetVideoFramesButton(
                      video: file,
                      range: DurationRange(
                        start: Duration.zero,
                        end: const Duration(
                          seconds: 5,
                        ),
                      ),
                    ),
                    const FramesPanel(),
                  ],
                ),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: FFMpegDownloadTracker(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
