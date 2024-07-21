
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/ChapterPagination.dart';
import 'package:project_login/Models/ContentStoryComics.dart';
import 'package:project_login/Services/DownloadService.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/Services/StoryService.dart';

import '../Models/ReadingHistory.dart';

class ContentStoryComicsViewModel extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  final DownloadService _downloadService = DownloadService();
  final LocalDatabase _localDatabase = LocalDatabase();

  List<String> formatList = [];
  int currentChapNumber = 1;
  int currentPageNumber = 1;
  String name = '';
  String currentSource = '';

  ContentStoryComics? _contentStoryComics;
  ContentStoryComics? get contentStoryComics => _contentStoryComics;
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
      print('Error fetching chapter pagination list in content story comics: $e');
    }
  }

  Future<bool> fetchContentStoryComics(String storyTitle, int chapNumber,
      String dataSource) async {
    try {
      _contentStoryComics = await _storyService.fetchContentStoryComics(
          storyTitle, chapNumber, dataSource);

      Logger logger = Logger();
      logger.i("_contentStoryComics: $_contentStoryComics");
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
          title: _contentStoryComics!.title,
          name: _contentStoryComics!.name,
          chap: chapNumber,
          date: currentTimeMillis,
          author: _contentStoryComics!.author,
          cover: _contentStoryComics!.cover,
          dataSource: currentSource,
          format: "image"
      ));

      return true;
    } catch (e) {
      print('Error fetching story content comics source $dataSource: $e');
      return false;
    }
  }
  Future<void> fetchFormatList() async {
    try {
      formatList = await _downloadService.fetchListFileExtensionComics();
      notifyListeners();
    } catch (e) {
      print('Error fetching format list: $e');
    }
  }

}