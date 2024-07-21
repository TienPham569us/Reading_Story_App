
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/Story.dart';
import 'package:project_login/Services/StoryService.dart';
import 'dart:async';

class SearchStoryViewModel extends ChangeNotifier {
  final StoryService _storyService = StoryService();
  List<Story> _stories = [];
  List<Story> get stories => _stories;

  Future<void> fetchSearchStories(String query, String datasource, int page) async {
    try {
      _stories = await _storyService.fetchSearchStory(query,datasource, page);
      Logger logger = Logger();
      logger.i(stories[0].toString());
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching search stories: $e');
    }
  }
}
