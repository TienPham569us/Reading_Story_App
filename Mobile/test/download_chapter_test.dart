import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_login/Models/Chapter.dart';
import 'package:project_login/ViewModels/DownloadChaptersViewModel.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  final DownloadChaptersViewModel downloadChaptersViewModel = DownloadChaptersViewModel();
  group('DownloadChapterViewModel', () {
    List<int> chapters =[1,2];
    test('Check downloadChapter by TXT successfully', () async {
      await downloadChaptersViewModel.fetchListFileExtension();
      List<String> result = downloadChaptersViewModel.listFileExtension;
      expect(result.contains("TXT"), true);
      expect(result.contains("DOC"), true);
      expect(result.contains("HTML"), true);
      expect(result.contains("PDF"), true);
      expect(result.contains("EPUB"), true);
    });
  });
}