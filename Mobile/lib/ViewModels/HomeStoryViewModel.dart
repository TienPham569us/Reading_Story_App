import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:project_login/Models/Category.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Story.dart';
import '../Services/StoryService.dart';


class HomeStoryViewModel extends ChangeNotifier {
  StoryService _storyService;

  Map<String, List<Story>> _stories = <String, List<Story>>{};

  Map<String, List<Story>> get stories => _stories;

  List<String> sourceBooks=[];

  String sourceBook='thi';

  int indexSourceBook=0;

  bool listOn=true;

  String category="All";

/*  List<Category> _listCategories = <Category>[];
  List<Category> get listCategories => _listCategories;*/
  String screenType="Home";

  bool isLoading=true;

  HomeStoryViewModel({required StoryService storyService}) : this._storyService = storyService;

  Future<void> fetchHomeStories(String datasource) async {
    try {
      _stories.clear();
      _stories = (await _storyService.fetchHomeStory(datasource))!;
      if(stories.isNotEmpty){
        isLoading=false;
      }
      notifyListeners();
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching stories: $e');
      }
      print('Error fetching home stories: $e');
    }
  }

  Future<void> fetchHomeSourceBooks() async{
    try{
      sourceBooks.clear();
      List<String>? sourceBookstmp=await _storyService.fetchListNameDataSource();
      List<String>? sourceBookstmp2=[];
      sourceBookstmp2 = await getStringList("LIST_SOURCE");
      if(sourceBookstmp2 == null){
        sourceBooks=sourceBookstmp!;
      }
      else{
        List<String>tmp2=[];
        tmp2.addAll(sourceBookstmp2);
        if(checkSimilarity(sourceBookstmp!, tmp2)){
          sourceBooks=sourceBookstmp2;
        }
        else{
          //Kiểm tra nguồn bị xóa và remove
          for(int i=0;i<sourceBookstmp2.length;i++){
            if(! sourceBookstmp.contains(sourceBookstmp2[i])){
              sourceBookstmp2.removeAt(i);
              i--;
            }
          }

          //Kiểm tra có nguồn mới không và thêm vào
          List<String>tmp3=[];
          for (var element in sourceBookstmp) {
            if(!sourceBookstmp2.contains(element)){
              tmp3.add(element);
            }
          }
          sourceBookstmp2.addAll(tmp3);
          sourceBooks=sourceBookstmp2;
          saveStringList("LIST_SOURCE", sourceBooks);
        }
      }
      if(sourceBooks.isNotEmpty){
        saveStringList("LIST_SOURCE", sourceBooks);
        changeSourceBook(sourceBooks[0]);
        fetchHomeStories(sourceBooks[0]);
      }
      notifyListeners();
    }
    catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching sources: $e');
      }
    }
  }


  void changeSourceBook(String newSourceBook) {
    sourceBook = newSourceBook;
    notifyListeners();
  }

  void changeListOrGrid(bool listchange) {
    listOn = listchange;
    notifyListeners();
  }

  void changeIndex(int newIndex) {
    indexSourceBook = newIndex;
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final String item = sourceBooks.removeAt(oldIndex);
    sourceBooks.insert(newIndex, item);
    notifyListeners();
  }

  void changeindex(int newIndex) {
    indexSourceBook = newIndex;
    notifyListeners();
  }

  void updateSource(List<String> newSourceBooks){
    sourceBooks.clear();
    sourceBooks.addAll(newSourceBooks);
    notifyListeners();
  }

  Future<void> saveStringList(String key, List<String> valueList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Chuyển đổi List<String> thành một chuỗi JSON trước khi lưu vào SharedPreferences
    final jsonString = jsonEncode(valueList);
    await prefs.setString(key, jsonString);
  }

  Future<List<String>?> getStringList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  bool checkSimilarity(List<String> list1, List<String> list2) {
    // Kiểm tra nếu độ dài của hai danh sách không bằng nhau
    if (list1.length != list2.length) {
      return false; // Nếu độ dài khác nhau, hai danh sách không giống nhau hoàn toàn
    }
    // Sắp xếp cả hai danh sách theo thứ tự tăng dần
    list1.sort();
    list2.sort();
    // So sánh từng phần tử của hai danh sách đã được sắp xếp
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false; // Nếu tìm thấy một cặp phần tử khác nhau, hai danh sách không giống nhau hoàn toàn
      }
    }
    // Nếu không tìm thấy phần tử nào khác nhau và độ dài của cả hai danh sách bằng nhau, hai danh sách giống nhau hoàn toàn
    return true;
  }

  void changeCategory(String newCategory) {
    category = newCategory;
    notifyListeners();
  }

  void changeScreenType(String newScreenType){
    screenType=newScreenType;
    notifyListeners();
  }

  void changeIsLoading(bool check){
    isLoading=check;
    notifyListeners();
  }
}
