import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Services/DownloadService.dart';
import '../Models/DownloadHistory.dart';
import '../Services/LocalDatabase.dart';

class DownloadChaptersComicsViewModel extends ChangeNotifier {
  final DownloadService downloadService = DownloadService();
  final LocalDatabase _localDatabase = LocalDatabase();

  List<String> _downloadedHtmlFilePath = [];
  List<String> get downloadedHtmlFilePath => _downloadedHtmlFilePath;

  List<String> _listFileExtension = [];
  List<String> get listFileExtension => _listFileExtension;


  Future<bool> downloadChaptersComicsOfStory(String storyTitle,String cover,String nameStory, List<int> chapters, String fileType, String datasource) async {
    try {
      _downloadedHtmlFilePath.clear();
      for (int i = 0; i<chapters.length;i++) {
        int chapter = chapters[i];
        String filePath = await downloadService.downloadComicsAndUnzipFile(
            storyTitle, chapter, fileType, datasource);
        Logger logger = Logger();
        logger.i("File path: $filePath");
        _downloadedHtmlFilePath.add(filePath);


        // insert reading history to local database
        if (fileType.toLowerCase() == 'html') {
          int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
          _localDatabase.insertDataDownload(
            DownloadHistory(
                title: storyTitle,
                name: nameStory,
                date: currentTimeMillis,
                chap: chapter,
                cover: cover,
                dataSource: datasource,
                link: _downloadedHtmlFilePath[i],
                format: 'image'),
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
      _listFileExtension = await downloadService.fetchListFileExtensionComics();
      Logger logger = Logger();
      logger.i(_listFileExtension);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error can not fetch list file extension: $e");
    }
  }


}