import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/ChapterPagination.dart';
import 'package:project_login/Services/DownloadService.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/Services/StoryService.dart';
import '../Models/ContentStory.dart';
import '../Models/ReadingHistory.dart';

class ContentStoryAudioViewModel extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  final DownloadService _downloadService = DownloadService();
  final LocalDatabase _localDatabase = LocalDatabase();
  int _duration = 0;
  List<String> formatList = [];
  int currentChapNumber = 1;
  int currentPageNumber = 1;
  String name = '';
  String currentSource = '';

  ContentStory? _contentStory;
  ContentStory? get contentStory => _contentStory;
  ChapterPagination _chapterPagination = ChapterPagination.defaults();

  ChapterPagination get chapterPagination => _chapterPagination;


  Future<void> fetchChapterPagination(String storyTitle, int pageNumber,
      String datasource, bool changePageNumber) async {
    try {
      // Fetch story details from the API using the storyId
      _chapterPagination = await _storyService.fetchChapterPagination(
          storyTitle, pageNumber, datasource);
      if (changePageNumber) {
        currentPageNumber = pageNumber;
      }
      Logger logger = Logger();
      logger.i(_chapterPagination.toString());
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching chapter pagination list in content story audio: $e');
    }
  }

  Future<bool> fetchContentStoryAudio(String storyTitle, int chapNumber,
      String dataSource) async {
    try {
      _contentStory = await _storyService.fetchContentStory(
          storyTitle, chapNumber, dataSource);

      Logger logger = Logger();
      logger.i("_contentStoryAudio: $_contentStory");
      currentChapNumber = chapNumber;
      currentSource = dataSource;
      notifyListeners();

      if (currentPageNumber != chapterPagination.currentPage ||
          chapterPagination.currentPage == 0) {
        fetchChapterPagination(storyTitle, currentPageNumber, dataSource, true);
      }

      int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      _localDatabase.insertHistoryData(ReadingHistory(
          pageNumber: currentPageNumber,
          title: contentStory!.title,
          name: contentStory!.name,
          chap: chapNumber,
          date: currentTimeMillis,
          author: contentStory!.author,
          cover: contentStory!.cover,
          dataSource: currentSource,
          format: "audio"
      ));

      return true;
    } catch (e) {
      print('Error fetching story content comics source $dataSource: $e');
      return false;
    }
  }
  Future<void> fetchFormatList() async {
    try {
      formatList = await _downloadService.fetchListFileExtensionAudio();
      notifyListeners();
    } catch (e) {
      print('Error fetching format list: $e');
    }
  }

  void setDuration(int value) {
    this._duration = value;
  }
  int getDuration() {
    return this._duration;
  }

}