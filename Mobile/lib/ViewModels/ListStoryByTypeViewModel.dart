
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Services/StoryService.dart';

import '../Models/Story.dart';

class ListStoryByTypeViewModel extends ChangeNotifier {
  final StoryService storyService = StoryService();

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  Future<void> fetchListStoryByType(String typeOfList, int pageNumber, String datasource) async {
    try {
      _stories = await storyService.fetchListStoryByType(typeOfList, pageNumber, datasource);
      Logger logger = Logger();
      logger.i(_stories[0].toString());
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error fetching list stories by type: $e');
    }
  }
}