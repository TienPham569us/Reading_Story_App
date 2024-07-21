import 'package:flutter/foundation.dart';

import '../Models/Story.dart';
import '../Services/StoryService.dart';

class ListTypeViewModel extends ChangeNotifier{
  final StoryService _storyService;

  Map<String, List<Story>> _stories = <String, List<Story>>{};

  Map<String, List<Story>> get stories => _stories;

  String sourceBook='';

  bool listOn=true;

  int page=1;

  String type='';

  ListTypeViewModel({required StoryService storyService}):_storyService=storyService;

  Future<void> fetchTypeStories(String sourceBook,String type) async {
    try {
      print("fetch ");
      print(page);
      List<Story> tmp;
      this.sourceBook=sourceBook;
      this.type=type;
      tmp = (await _storyService.fetchListStoryByType(type,page,sourceBook))!;
      if(page==1){
        _stories.clear();
        _stories[type]=tmp;
      }
      else{
        if(tmp.isNotEmpty){
          _stories[type]?.addAll(tmp);
        }
      }
      print(_stories[type]!.length);
      notifyListeners();
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching stories: $e');
      }
    }
  }

  void changeSourceBook(String newSourceBook){
    sourceBook=newSourceBook;
    notifyListeners();
  }

  void changeListOrGrid(bool listchange){
    listOn=listchange;
    notifyListeners();
  }

  void changeType(String newType){
    type=newType;
    notifyListeners();
  }

  void changepage(int newpage){
    page=newpage;
    notifyListeners();
  }

  void insertpage(){
    ++page;
    notifyListeners();
  }
}