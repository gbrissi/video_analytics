String formatBytes(int bytes) {
  if (bytes < 1024) {
    return '${bytes}b';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)}kb';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)}mb';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)}gb';
  }
}
