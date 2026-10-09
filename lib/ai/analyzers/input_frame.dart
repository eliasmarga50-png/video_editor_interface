import 'dart:typed_data';

class InputFrame {
  final Uint8List bytes;
  final int width;
  final int height;
  final int timestampMs;

  const InputFrame({
    required this.bytes,
    required this.width,
    required this.height,
    required this.timestampMs,
  });
}