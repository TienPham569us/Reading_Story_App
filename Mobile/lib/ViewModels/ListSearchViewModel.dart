import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Story.dart';
import '../Services/StoryService.dart';

class ListSearchViewModel extends ChangeNotifier{

  final StoryService _storyService;

  Map<String, List<Story>> _stories = <String, List<Story>>{};

  Map<String, List<Story>> get stories => _stories;

  List<String> sourceBooks=[];

  String sourceBook='';

  int indexSourceBook=0;

  bool listOn=true;

  String searchString='';

  String category='All';

  int page=1;

  bool isLoading=true;

  ListSearchViewModel({required StoryService storyService}): _storyService = storyService;

  Future<void> fetchSearchStories(String datasource) async {
    try {
      List<Story>? tmp;
      if (category != 'All') {
        tmp = await _storyService.fetchSearchStoryByCategory(searchString, datasource, page, category);
      } else {
        tmp = await _storyService.fetchSearchStoryByCategory(searchString, datasource, page, '');
      }

      if (page == 1) {
        _stories!.clear();
        _stories[searchString] = tmp!;
      } else {
        if (tmp != null) {
          _stories[searchString] = _stories[searchString] ?? [];
          _stories[searchString]!.addAll(tmp);
        }
      }

      isLoading = _stories.isEmpty;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching stories: $e');
      }
    }
  }

  Future<void> fetchSearchSourceBooks(String searchString) async{
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
        changeSearchString(searchString);
        fetchSearchStories(sourceBooks[0]);
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

  Future<void> saveStringList(String key, List<String> valueList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Chuyển đổi List<String> thành một chuỗi JSON trước khi lưu vào SharedPreferences
    final jsonString = jsonEncode(valueList);
    await prefs.setString(key, jsonString);
  }

  void changeSourceBook(String newSourceBook){
    sourceBook=newSourceBook;
    notifyListeners();
  }

  void changeListOrGrid(bool listchange){
    listOn=listchange;
    notifyListeners();
  }

  void changeIndex(int newIndex){
    indexSourceBook=newIndex;
    notifyListeners();
  }

  void changeCategory(String newCategory){
    category=newCategory;
    notifyListeners();
  }

  void changeSearchString(String newSearchString){
    searchString=newSearchString;
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

  void changeIsLoading(bool check){
    isLoading=check;
    notifyListeners();
  }
}