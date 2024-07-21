import 'package:flutter/cupertino.dart';
import 'package:project_login/Models/DownloadHistory.dart';

import '../Models/ReadingHistory.dart';
import '../Services/LocalDatabase.dart';

class DownloadHistoryViewModel extends ChangeNotifier {
  LocalDatabase localDatabase = LocalDatabase();

  List<DownloadHistory>? downloadHistoryList = [];

  Future<void> fetchDownloadList() async{
    downloadHistoryList?.clear();
    downloadHistoryList = await localDatabase.getDownloadHistoryList();
    downloadHistoryList?.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deleteDownloadChapter(String link) async {
    localDatabase.deleteDataDownloadByLink(link);
    notifyListeners();
  }
}