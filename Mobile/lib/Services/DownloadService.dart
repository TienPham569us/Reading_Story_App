import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class DownloadService {

  //avd: 10.0.2.2
  //final String ipAddress = "10.0.2.2";

  //physical device: localhost
  final String ipAddress = "localhost";

  final int port=3000;
  Future<String> findTxtFilePath(Archive archive) async {
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = file.name;
      if (filePath.toLowerCase().endsWith('.txt')) {
        return filePath;
      }
    }
    throw Exception('No .txt file found in the ZIP archive');
  }
  Future<String> findHtmlFilePath(Archive archive) async {
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = file.name;
      if (filePath.toLowerCase().endsWith('.html')) {
        return filePath;
      }
    }
    throw Exception('No .html file found in the ZIP archive');
  }
  Future<String> findMp3FilePath(Archive archive) async {
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = file.name;
      if (filePath.toLowerCase().endsWith('.mp3')) {
        return filePath;
      }
    }
    throw Exception('No .mp3 file found in the ZIP archive');
  }

  Future<String> downloadAndUnzipFile(String storyTitle, int chapter, String fileType, String datasource) async {
    // Request storage permissions
    PermissionStatus permission = await Permission.storage.request();

    String folderName = "DownloadedFile";
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse(
          "http://$ipAddress:$port/api/v1/download/downloadChapter/?datasource=$datasource&title=$storyTitle&chap=$chapter&type=$fileType"
        ));
    HttpClientResponse response = await request.close();
    List<int> bytes = await consolidateHttpClientResponseBytes(response);

    // Unzip the file
    Archive archive = ZipDecoder().decodeBytes(bytes);

    Directory? externalDir = await getExternalStorageDirectory();
    String? externalPath = externalDir?.path;
    Logger logger = Logger();
    //logger.i(externalPath);

    // Get the document directory path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    //logger.i(appDocPath);

    String? downloadDirectory = await getDownloadDirectory();

    // Create the target folder
    String targetFolderPath = '$downloadDirectory/$folderName';
    Directory(targetFolderPath).createSync(recursive: true);

    // Extract the files from the ZIP archive
    for (ArchiveFile file in archive) {
      String filePath = '$targetFolderPath/${file.name}';
      if (file.isFile) {
        List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      }
    }

    print('ZIP file extracted successfully to $targetFolderPath');

    // Get the file path of the extracted .txt file
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = '$externalPath/$folderName/${file.name}';
      if (filePath.toLowerCase().endsWith('.txt')) {
        List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        break;
      }
    }
    String txtFilePath = await findTxtFilePath(archive);
    String absoluteTxtFilePath = '$externalPath/$folderName/$txtFilePath';
    print('Path of the extracted .txt file: $absoluteTxtFilePath');

    // Delete the ZIP file
    /*File zipFile = File('$appDocPath/file.zip');
    if (await zipFile.exists()) {
      await zipFile.delete();
      print('ZIP file deleted successfully');
    }*/

    /*List<String> filePaths = await getAllFilePaths(targetFolderPath);

    for (String str in filePaths) {
      print("file path: $str");
    }*/

    return absoluteTxtFilePath;
  }

  Future<String> downloadComicsAndUnzipFile(String storyTitle, int chapter, String fileType, String datasource) async {
    // Request storage permissions
    PermissionStatus permission = await Permission.storage.request();

    String folderName = "DownloadedFile";
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse(
            "http://$ipAddress:$port/api/v1/downloadComics/downloadChapter/?datasource=$datasource&title=$storyTitle&chap=$chapter&type=$fileType"
        ));
    HttpClientResponse response = await request.close();
    List<int> bytes = await consolidateHttpClientResponseBytes(response);

    // Unzip the file
    Archive archive = ZipDecoder().decodeBytes(bytes);

    Directory? externalDir = await getExternalStorageDirectory();
    String? externalPath = externalDir?.path;
    Logger logger = Logger();
    //logger.i(externalPath);

    //logger.i(appDocPath);

    String? downloadDirectory = await getDownloadDirectory();

    // Create the target folder
    String targetFolderPath = '$downloadDirectory/$folderName';
    Directory(targetFolderPath).createSync(recursive: true);

    // Extract the files from the ZIP archive
    for (ArchiveFile file in archive) {
      String filePath = '$targetFolderPath/${file.name}';
      if (file.isFile) {
        if (file.name.toLowerCase().endsWith(fileType.toLowerCase())) {
          List<int> data = file.content as List<int>;
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
          break;
        }
       /* List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);*/
      }
    }

    print('ZIP file extracted successfully to $targetFolderPath');

    // Get the file path of the extracted .txt file
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = '$externalPath/$folderName/${file.name}';
      if (filePath.toLowerCase().endsWith('.html')) {
        List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        break;
      }
    }
    String txtFilePath = await findHtmlFilePath(archive);
    String absoluteTxtFilePath = '$externalPath/$folderName/$txtFilePath';
    print('Path of the extracted .html file: $absoluteTxtFilePath');

    return absoluteTxtFilePath;
  }

  Future<String> downloadAudioAndUnzipFile(String storyTitle, int chapter, String fileType, String datasource, int startTime, int endTime) async {
    // Request storage permissions
    PermissionStatus permission = await Permission.storage.request();

    String folderName = "DownloadedFile";
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse(
            "http://$ipAddress:$port/api/v1/downloadAudio/downloadChapter/?datasource=$datasource&title=$storyTitle&chap=$chapter&type=$fileType&start=$startTime&end=$endTime"
        ));
    HttpClientResponse response = await request.close();
    List<int> bytes = await consolidateHttpClientResponseBytes(response);

    // Unzip the file
    Archive archive = ZipDecoder().decodeBytes(bytes);

    Directory? externalDir = await getExternalStorageDirectory();
    String? externalPath = externalDir?.path;
    Logger logger = Logger();
    //logger.i(externalPath);

    // Get the document directory path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    //logger.i(appDocPath);

    String? downloadDirectory = await getDownloadDirectory();

    // Create the target folder
    String targetFolderPath = '$downloadDirectory/$folderName';
    Directory(targetFolderPath).createSync(recursive: true);

    // Extract the files from the ZIP archive
    for (ArchiveFile file in archive) {
      String filePath = '$targetFolderPath/${file.name}';
      if (file.isFile) {
        if (file.name.toLowerCase().endsWith(fileType.toLowerCase())) {
          List<int> data = file.content as List<int>;
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
          break;
        }
        /* List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);*/
      }
    }

    print('ZIP file extracted successfully to $targetFolderPath');

    // Get the file path of the extracted .txt file
    for (ArchiveFile file in archive) {
      if (!file.isFile) continue;
      String filePath = '$externalPath/$folderName/${file.name}';
      if (filePath.toLowerCase().endsWith('.mp3')) {
        List<int> data = file.content as List<int>;
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        break;
      }
    }
    String txtFilePath = await findMp3FilePath(archive);
    String absoluteTxtFilePath = '$externalPath/$folderName/$txtFilePath';
    print('Path of the extracted .mp3 file: $absoluteTxtFilePath');

    return absoluteTxtFilePath;

  }


  Future<String?> getDownloadDirectory() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<List<String>> getAllFilePaths(String directoryPath) async {
    Directory directory = Directory(directoryPath);
    List<String> filePaths = [];

    if (await directory.exists()) {
      await for (FileSystemEntity entity in directory.list(recursive: true)) {
        if (entity is File) {
          filePaths.add(entity.path);
        }
      }
    }

    return filePaths;
  }

  Future<List<String>> fetchListFileExtension() async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/download/listFileExtension/'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<String> result =  List<String>.from(jsonData['names']);
      return result;
    } else {
      throw Exception("Fail to fetch fetchListNameFileExtension");
    }
  }

  Future<List<String>> fetchListFileExtensionComics() async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/downloadComics/listFileExtension/'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<String> result =  List<String>.from(jsonData['names']);
      return result;
    } else {
      throw Exception("Fail to fetch fetchListFileExtensionComics");
    }
  }

  Future<List<String>> fetchListFileExtensionAudio() async {
    final response = await http.get(Uri.parse('http://$ipAddress:$port/api/v1/downloadAudio/listFileExtension/'));

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      List<String> result =  List<String>.from(jsonData['names']);
      return result;
    } else {
      throw Exception("Fail to fetch fetchListFileExtensionAudio");
    }
  }



}