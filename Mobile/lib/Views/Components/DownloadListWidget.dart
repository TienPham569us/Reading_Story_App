import 'package:flutter/material.dart';
import 'package:project_login/Models/DownloadHistory.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/ViewModels/ContentStoryComicsViewModel.dart';
import 'package:project_login/ViewModels/DownloadHistoryViewModel.dart';
import 'package:project_login/Views/Components/DownloadListItem.dart';
import 'package:project_login/Views/ReadOfflineAudio.dart';
import 'package:project_login/Views/ReadOfflineComics.dart';
import 'package:project_login/Views/ReadOfflineFile.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/ContentStoryViewModel.dart';

class DownloadListWidget extends StatefulWidget {
  const DownloadListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryListWidgetState();
}

class _HistoryListWidgetState extends State<DownloadListWidget> {
  late DownloadHistoryViewModel _downloadHistoryViewModel;

  @override
  void initState() {
    super.initState();
    _downloadHistoryViewModel =
        Provider.of<DownloadHistoryViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _downloadHistoryViewModel.fetchDownloadList();

    return Consumer<DownloadHistoryViewModel>(
        builder: (context, downloadHistoryViewModel, _) {
      return Expanded(
        child: ListView.builder(
          itemCount: downloadHistoryViewModel.downloadHistoryList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: DownloadListItem(
                  downloadHistoryViewModel.downloadHistoryList![index],
                  onClickItem),
            );
          },
        ),
      );
    });
  }

  void onClickItem(DownloadHistory downloadHistory) {
    String format = downloadHistory.format;

    if (format!=null) {
      switch (format) {
        case "audio":
          navigateToReadOfflineAudioScreen(
              downloadHistory.link,
                  (link) {
                _downloadHistoryViewModel.deleteDownloadChapter(link);
              }
          );
          break;
        case "image":
          navigateToReadOfflineComicsScreen(
              downloadHistory.link,
                  (link) {
                _downloadHistoryViewModel.deleteDownloadChapter(link);
              }
          );
          break;
        case "word":
          navigateToReadOfflineFileScreen(
              downloadHistory.link,
                  (link) {
                _downloadHistoryViewModel.deleteDownloadChapter(link);
              }
          );
          break;
        default:
          navigateToReadOfflineFileScreen(
              downloadHistory.link,
                  (link) {
                _downloadHistoryViewModel.deleteDownloadChapter(link);
              }
          );
          break;
      }
    } else {
      navigateToReadOfflineFileScreen(
          downloadHistory.link,
              (link) {
            _downloadHistoryViewModel.deleteDownloadChapter(link);
          }
      );
    }

  }

  void navigateToReadOfflineFileScreen(String link, Function(String) deleteDatabase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
            create: (context) => ContentStoryViewModel(),
            child: ReadOfflineFile(
              link: link,
              deleteDatabase: deleteDatabase,
            )),
      ),
    );
  }
  void navigateToReadOfflineAudioScreen(String link, Function(String) deleteDatabase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
            create: (context) => ContentStoryAudioViewModel(),
            child: ReadOfflineAudio(
              link: link,
              deleteDatabase: deleteDatabase,
            )),
      ),
    );
  }
  void navigateToReadOfflineComicsScreen(String link, Function(String) deleteDatabase) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
            create: (context) => ContentStoryComicsViewModel(),
            child: ReadOfflineComics(
              link: link,
              deleteDatabase: deleteDatabase,
            )),
      ),
    );
  }
}
