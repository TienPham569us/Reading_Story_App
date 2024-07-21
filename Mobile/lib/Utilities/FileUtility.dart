import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUtility {
  static void deleteFile(String filePath) {
    File file = File(filePath);
    file.delete().then((_) {
      print('File deleted successfully');
    }).catchError((error) {
      print('Failed to delete file: $error');
    });
  }

}