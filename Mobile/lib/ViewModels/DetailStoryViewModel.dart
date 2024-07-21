
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/ChapterPagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/ChapterPagination.dart';
import '../Models/Story.dart';
import '../Services/StoryService.dart';

class DetailStoryViewModel extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  List<String> sourceBooks = [];

  Story? _story;
  Story? get story => _story;

  Story? _changedStory;
  Story? get changedStory => _changedStory;

  int _indexSource = 0;
  ChapterPagination? _chapterPagination;
  ChapterPagination? get chapterPagination => _chapterPagination;
  String currentSource="";
  Future<bool> fetchDetailsStory(String title, String datasource) async {
    try {
      // Fetch story details from the API using the storyId
      _story = await _storyService.fetchDetailStory(title,datasource);
      currentSource = datasource;
      _indexSource = 0;
      Logger logger = Logger();
      logger.i(_story.toString());
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching story details: $e');
      return false;
    }
    return true;
  }

  Future<void> fetchChapterPagination(String title, int pageNumber, String datasource) async {
    try {
      _chapterPagination = await _storyService.fetchChapterPagination(title,pageNumber,datasource);
      print('title: $title');
      print('pageNumber: $pageNumber');
      print('datasource: $datasource');
      currentSource = datasource;
      Logger logger = Logger();
      logger.i(_chapterPagination.toString());
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching chapter pagination: $e');
    }
  }
  Future<void> fetchChangeDetailStoryToThisDataSource(String title, String datasource) async {
    try {
      // Fetch story details from the API using the storyId
      _changedStory = await _storyService.fetchChangeDetailStoryToThisDataSource(title,datasource);

      if (_changedStory!=null) {
        _story = _changedStory;
        currentSource = datasource;
        Logger logger = Logger();
        logger.i(_changedStory.toString());
      }
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching change details story to this data source: $e');
    }
  }
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
      Logger logger = Logger();
      logger.i("List source: $sourceBooks");
      // save order of source to SharePreferences
      saveStringList("LIST_SOURCE", sourceBooks);
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching source book: $e');
    }
  }
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
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
    final prefs = await SharedPreferences.getInstance();
    // Chuyển đổi List<String> thành một chuỗi JSON trước khi lưu vào SharedPreferences
    final jsonString = jsonEncode(valueList);
    await prefs.setString(key, jsonString);
  }
}