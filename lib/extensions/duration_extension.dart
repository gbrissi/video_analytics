extension DurationExtension on Duration {
  String stringify() {
    String hours = (inHours % 24).toString().padLeft(2, '0');
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds = (inMilliseconds % 1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds:$milliseconds';
  }
}
