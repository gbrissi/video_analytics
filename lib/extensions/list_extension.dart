import 'dart:io';

extension ListExtension on List<File> {
  List<File> sortPosition() => List.from(this)
    ..sort(
      _sortPosition,
    );

  int _getPosition(String filePath) => int.parse(
        filePath.split('_').last.split(".").first,
      );

  int _sortPosition(File a, File b) {
    int posA = _getPosition(a.path);
    int posB = _getPosition(b.path);

    return posA.compareTo(posB);
  }
}
