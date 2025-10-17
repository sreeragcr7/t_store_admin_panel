import 'package:flutter/services.dart';

Future<Uint8List> getBytesFromAsset(String path) async {
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}
