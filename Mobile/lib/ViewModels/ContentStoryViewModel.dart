import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/ChapterPagination.dart';
import 'package:project_login/Models/ReadingHistory.dart';
import 'package:project_login/Services/DownloadService.dart';
import 'package:project_login/Services/LocalDatabase.dart';
import 'package:project_login/Models/ContentDisplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';
import '../Models/ContentStory.dart';
import '../Services/StoryService.dart';

class ContentStoryViewModel extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  final LocalDatabase _localDatabase = LocalDatabase();
  final DownloadService _downloadService = DownloadService();
  late final SharedPreferences prefs;
  ContentStory? contentStory;
  ContentDisplay contentDisplay = ContentDisplay.defaults();
  List<String> fontNames =
      []; // list of fonts user can choose to change display of content story
  int currentChapNumber = 1;
  List<String> sourceBooks = []; // list of data source app can get story from
  int indexSource =
      0; // to get the index of current source in sourceBooks (only using when automatically change source)
  String currentSource = '';
  List<String> formatList = []; // list of format user can choose when download
  ChapterPagination _chapterPagination = ChapterPagination.defaults();

  ChapterPagination get chapterPagination => _chapterPagination;

  // chapterPagination change when user see chapter in ChooseChapterBottomSheet
  // so we need this variable to track page number of current chapter
  int currentPageNumber = 1;
  String name = ''; // name of story, use to pass to fetchChangeContentStoryToThisDataSource at initState

  ContentStory? _changedStory;
  ContentStory? get changedStory => _changedStory;

  void setPreferences(SharedPreferences sharedPreferences) {
    prefs = sharedPreferences;
  }

  // fetch content story
  Future<bool> fetchContentStory(String storyTitle, int chapNumber,
      String dataSource, String chosenDataSource, bool first) async {
    try {
      if (first){
        _changedStory = await _storyService.fetchContentStory(
            storyTitle, chapNumber, dataSource);
      } else {
        _changedStory = await _storyService.fetchChangeContentStoryToThisDataSource(
            name, dataSource, chapNumber);
      }
      // if fetch success, change UI
      if (_changedStory == null || _changedStory!.content.isEmpty){
        throw Exception();
      } else {
        contentStory = _changedStory?.clone();
      }
      indexSource = 0;
      currentChapNumber = chapNumber;

      // save current data source
      currentSource = dataSource;
      notifyListeners();

      // reload chapterPagination when navigate to next or previous chapter
      // or reload when fetching chapterPagination failed
      if (currentPageNumber != chapterPagination.currentPage || chapterPagination.currentPage == 0) {
        fetchChapterPagination(storyTitle, currentPageNumber, dataSource, true);
      }

      // insert reading history to local database
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
          format: "word"
      ));
      return (dataSource == chosenDataSource);
    } catch (e) {
      // if fetch fail, fetch another source instead
      print('Error fetching story content source $dataSource: $e');
      if (indexSource <= sourceBooks.length - 1) {
        return fetchContentStory(storyTitle, chapNumber,
            sourceBooks[indexSource++], chosenDataSource, false);
      } else {
        return false;
      }
    }
  }

  // fetch display info: text size, line space, text color, background color and font family
  Future<void> fetchContentDisplay() async {
    try {
      double? textSize;
      double? lineSpacing;
      int? textColor;
      int? backgroundColor;
      String? fontFamily;

      await Future.wait([
        getDouble(TEXT_SIZE_KEY).then((value) => textSize = value),
        getDouble(LINE_SPACING_KEY).then((value) => lineSpacing = value),
        getInt(TEXT_COLOR_KEY).then((value) => textColor = value),
        getInt(BACKGROUND_COLOR_KEY).then((value) => backgroundColor = value),
        getString(FONT_FAMILY_KEY).then((value) => fontFamily = value),
      ]);

      int? isTesting = await getInt(IS_TESTING_KEY);

      if (isTesting != 1){
        fontNames = fonts.map<String>((font) => font().fontFamily!).toList();
      }

      if (!fontNames.contains(fontFamily)) {
        if (fontNames.isNotEmpty) {
          fontFamily = fontNames[0];
        }
      }

      contentDisplay = ContentDisplay(
          textSize: textSize ?? DEFAULT_TEXT_SZIE,
          lineSpacing: lineSpacing ?? DEFAULT_LINE_SPACING,
          fontFamily: fontFamily ?? DEFAULT_FONT_FAMILY,
          textColor: textColor ?? DEFAULT_TEXT_COLOR,
          backgroundColor: backgroundColor ?? DEFAULT_BACKGROUND_COLOR);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching story content: $e');
    }
  }

  // fetch chapter pagination
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
      print('Error fetching chapter pagination list: $e');
    }
  }

  // fetch all source where story can get content
  Future<void> fetchSourceBooks() async {
    try {
      List<String> sourceBooksApi =
          await _storyService.fetchListNameDataSource();
      List<String>? sourceBooksLocal = [];
      sourceBooksLocal = await getStringList("LIST_SOURCE");
      if (sourceBooksLocal == null) {
        // if user don't save order of source in local, use order in api
        sourceBooks = sourceBooksApi;
      } else {
        sourceBooks = sourceBooksLocal;
        // remove old source in SharePreferences from sourceBooks
        for (int i = 0; i < sourceBooksLocal.length; i++) {
          if (!sourceBooksApi.contains(sourceBooksLocal[i])) {
            sourceBooks.removeAt(i);
            i--;
          }
        }
        // add all new source in api to sourceBooks
        for (int i = 0; i < sourceBooksApi.length; i++) {
          if (!sourceBooks.contains(sourceBooksApi[i])) {
            sourceBooks.add(sourceBooksApi[i]);
          }
        }
      }
      // save order of source to SharePreferences
      saveStringList("LIST_SOURCE", sourceBooks);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching source book: $e');
    }
  }

  // fetch all format use can choose to download
  Future<void> fetchFormatList() async {
    try {
      formatList = await _downloadService.fetchListFileExtension();
      notifyListeners();
    } catch (e) {
      print('Error fetching format list: $e');
    }
  }

  // save, get String, Int, Double and String List in SharePreferences
  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }

  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  Future<int?> getInt(String key) async {
    return prefs.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    return prefs.getDouble(key);
  }

  Future<List<String>?> getStringList(String key) async {
    // Lấy chuỗi JSON từ SharedPreferences
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      // Nếu có chuỗi JSON, chuyển đổi nó thành List<String>
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => item.toString()).toList();
    }
    // Trả về null nếu không tìm thấy hoặc có lỗi
    return null;
  }

  Future<void> saveStringList(String key, List<String> valueList) async {
    // Chuyển đổi List<String> thành một chuỗi JSON trước khi lưu vào SharedPreferences
    final jsonString = jsonEncode(valueList);
    await prefs.setString(key, jsonString);
  }
}
