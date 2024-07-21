import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchViewModel extends ChangeNotifier{
  List<String> historylist=[];

  void insertHistory(String searchstring){
    if(!historylist.contains(searchstring)){
      historylist.insert(0, searchstring);
    }
    notifyListeners();
  }

  void deleteAll(){
    historylist.clear();
    notifyListeners();
  }

  void saveAll(){
    saveStringList("Historysearch", historylist);
  }

  Future<void> fetchHistoryList() async{
    List<String>? search2=await getStringList("Historysearch");
    historylist=search2!;
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
}