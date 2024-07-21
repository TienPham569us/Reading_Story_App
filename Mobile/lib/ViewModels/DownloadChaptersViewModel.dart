import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/DownloadHistory.dart';
import 'package:project_login/Services/DownloadService.dart';
import '../Services/LocalDatabase.dart';

class DownloadChaptersViewModel extends ChangeNotifier {
  final DownloadService downloadService = DownloadService();
  final LocalDatabase _localDatabase = LocalDatabase();

  List<String> _downloadedTxtFilePath = [];
  List<String> get downloadedTxtFilePath => _downloadedTxtFilePath;

  List<String> _listFileExtension = [];
  List<String> get listFileExtension => _listFileExtension;


  Future<bool> downloadChaptersOfStory(String storyTitle,String cover,String nameStory, List<int> chapters, String fileType, String datasource) async {
    try {
        _downloadedTxtFilePath.clear();
        for (int i = 0; i<chapters.length;i++) {
          int chapter = chapters[i];
          String filePath = await downloadService.downloadAndUnzipFile(
              storyTitle, chapter, fileType, datasource);
          Logger logger = Logger();
          logger.i("File path: $filePath");
          _downloadedTxtFilePath.add(filePath);

          // insert reading history to local database
          int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
          _localDatabase.insertDataDownload(
            DownloadHistory(
                title: storyTitle,
                name: nameStory,
                date: currentTimeMillis,
                chap: chapter,
                cover: cover,
                dataSource: datasource,
                link: _downloadedTxtFilePath[i],
                format: 'word'),
          );
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
      _listFileExtension = await downloadService.fetchListFileExtension();
      Logger logger = Logger();
      logger.i(_listFileExtension);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error can not fetch list file extension: $e");
    }
  }


}