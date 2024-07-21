import 'package:flutter/cupertino.dart';
import '../Models/Category.dart';
import '../Services/StoryService.dart';

class ChoiseCategoryViewModel extends ChangeNotifier {
  final StoryService _storyService;

  List<Category>? _categories;
  List<Category>? get categories => _categories;
  String choisedCategory = '';

  ChoiseCategoryViewModel({StoryService? storyService})
      : _storyService = storyService ?? StoryService();

  Future<void> fetchCategories(String datasource) async {
    try {
      _categories = await _storyService.fetchListCategory(datasource);
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void changeCategory(String newCategory) {
    choisedCategory = newCategory;
    notifyListeners();
  }
}
