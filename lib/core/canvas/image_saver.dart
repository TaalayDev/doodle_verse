import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:file_picker/file_picker.dart';
import 'package:platform/platform.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageSaver {
  final BuildContext context;

  ImageSaver(this.context);

  Future<void> save(Uint8List bytes) async {
    final img.Image jpgImage = img.decodeImage(bytes)!;
    final jpg = img.encodeJpg(jpgImage, quality: 90);

    final String fileName =
        'doodle_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (kIsWeb) {
      _downloadFileWeb(jpg, fileName);
    } else {
      final LocalPlatform platform = LocalPlatform();

      if (platform.isMacOS || platform.isWindows || platform.isLinux) {
        await _saveWithFilePicker(jpg, fileName);
      } else if (platform.isIOS || platform.isAndroid) {
        await _saveToGallery(jpg, fileName);
      } else {
        await _saveToDocuments(jpg, fileName);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image saved as $fileName')),
    );
  }

  Future<void> _saveWithFilePicker(Uint8List jpg, String fileName) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName,
    );

    if (outputFile == null) {
      return;
    }

    final File file = File(outputFile);
    await file.writeAsBytes(jpg);
  }

  void _downloadFileWeb(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveToGallery(Uint8List jpg, String fileName) async {
    await ImageGallerySaver.saveImage(jpg, name: fileName);
  }

  Future<void> _saveToDocuments(Uint8List jpg, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    await File(filePath).writeAsBytes(jpg);
  }
}
