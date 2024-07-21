import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Services/DownloadService.dart';
import '../Models/DownloadHistory.dart';
import '../Services/LocalDatabase.dart';

class DownloadChaptersAudioViewModel extends ChangeNotifier {
  final DownloadService downloadService = DownloadService();
  final LocalDatabase _localDatabase = LocalDatabase();

  List<String> _downloadedAudioFilePath = [];
  List<String> get downloadedAudioFilePath => _downloadedAudioFilePath;

  List<String> _listFileExtension = [];
  List<String> get listFileExtension => _listFileExtension;


  Future<bool> downloadChaptersAudioOfStory(String storyTitle,String cover,String nameStory, List<int> chapters, String fileType, String datasource, int startTime, int endTime) async {
    try {
      _downloadedAudioFilePath.clear();
      for (int i = 0; i<chapters.length;i++) {
        int chapter = chapters[i];
        String filePath = await downloadService.downloadAudioAndUnzipFile(
            storyTitle, chapter, fileType, datasource, startTime, endTime);
        Logger logger = Logger();
        logger.i("File path: $filePath");
        _downloadedAudioFilePath.add(filePath);


        // insert reading history to local database
        if (fileType.toLowerCase() == 'mp3') {
          int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
          _localDatabase.insertDataDownload(
            DownloadHistory(
                title: storyTitle,
                name: nameStory,
                date: currentTimeMillis,
                chap: chapter,
                cover: cover,
                dataSource: datasource,
                link: _downloadedAudioFilePath[i],
                format: 'audio'),
          );
        }

      }
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error download chapters of story: $e');
      return false;
    }
    return true;
  }
  Future<void> fetchListFileExtension() async{
    try {
      _listFileExtension = await downloadService.fetchListFileExtensionAudio();
      Logger logger = Logger();
      logger.i(_listFileExtension);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error can not fetch list file extension: $e");
    }
  }


}