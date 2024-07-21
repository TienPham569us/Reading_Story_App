import 'package:flutter/material.dart';
import 'package:project_login/Models/FormatEnum.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/ViewModels/ContentStoryComicsViewModel.dart';
import 'package:project_login/ViewModels/ReadingHistoryViewModel.dart';
import 'package:project_login/Views/Components/ReadingHistoryItem.dart';
import 'package:project_login/Views/ContentStoryAudioView.dart';
import 'package:project_login/Views/ContentStoryComicsView.dart';
import 'package:provider/provider.dart';

import '../../Models/ReadingHistory.dart';
import '../../ViewModels/ContentStoryViewModel.dart';
import '../ContentStoryView.dart';

class HistoryListWidget extends StatefulWidget {
  const HistoryListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<HistoryListWidget> {
  late ReadingHistoryViewModel _readingHistoryViewModel;

  @override
  void initState() {
    super.initState();
    _readingHistoryViewModel =
        Provider.of<ReadingHistoryViewModel>(context, listen: false);
    _readingHistoryViewModel.fetchReadingHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingHistoryViewModel>(
      builder: (context, readingHistoryViewModel, _) {
        return Expanded(
            child: RefreshIndicator(
              onRefresh: () async{
                await _readingHistoryViewModel.fetchReadingHistoryList();
                setState(() {});
              },
              child: ListView.builder(
              itemCount: readingHistoryViewModel.readingHistoryList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ReadingHistoryItem(
                    readingHistoryViewModel.readingHistoryList![index],
                    onClickItem,
                  ),
                );
              },
            ),));
      },
    );
  }

  // navigate to content story screen
  void onClickItem(ReadingHistory readingHistory) {
    String format = readingHistory.format;
    if (format != null) {
       switch (format) {
         case FormatEnum.audio:
           navigateToContentStoryAudioScreen(readingHistory);
           break;
         case FormatEnum.image:
           navigateToContentStoryComicsScreen(readingHistory);
           break;
         case FormatEnum.word:
           navigateToContentStoryScreen(readingHistory);
           break;
         default:
           navigateToContentStoryScreen(readingHistory);
           break;
       }
    } else {
      navigateToContentStoryScreen(readingHistory);
    }
  }

  void navigateToContentStoryScreen(ReadingHistory readingHistory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider(
                create: (context) => ContentStoryViewModel(),
                child: ContentStoryScreen(
                  storyTitle: readingHistory.title,
                  chap: readingHistory.chap,
                  dataSource: readingHistory.dataSource,
                  pageNumber: readingHistory.pageNumber,
                  name: readingHistory.name,
                )),
      ),
    );
  }

  void navigateToContentStoryComicsScreen(ReadingHistory readingHistory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider(
                create: (context) => ContentStoryComicsViewModel(),
                child: ContentStoryComicsScreen(
                  storyTitle: readingHistory.title,
                  chap: readingHistory.chap,
                  dataSource: readingHistory.dataSource,
                  pageNumber: readingHistory.pageNumber,
                  name: readingHistory.name,
                )),
      ),
    );
  }

  void navigateToContentStoryAudioScreen(ReadingHistory readingHistory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider(
                create: (context) => ContentStoryAudioViewModel(),
                child: ContentStoryAudioScreen(
                  storyTitle: readingHistory.title,
                  chap: readingHistory.chap,
                  dataSource: readingHistory.dataSource,
                  pageNumber: readingHistory.pageNumber,
                  name: readingHistory.name,
                )),
      ),
    );
  }
}
