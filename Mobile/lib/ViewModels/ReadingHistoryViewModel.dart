import 'package:flutter/cupertino.dart';
import 'package:project_login/Models/ReadingHistory.dart';

import '../Services/LocalDatabase.dart';

class ReadingHistoryViewModel extends ChangeNotifier {
  LocalDatabase localDatabase = LocalDatabase();

  List<ReadingHistory>? readingHistoryList = [];

  // get all reading history in database
  Future<void> fetchReadingHistoryList() async{
    readingHistoryList?.clear();
    readingHistoryList = await localDatabase.getReadingHistoryList();
    readingHistoryList?.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }
}