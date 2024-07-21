import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryComicsViewModel.dart';
import 'package:project_login/Views/Components/DownloadSingleChapterComicsDialog.dart';


class ContentStoryComicsTopAppBar extends StatefulWidget {
  final ContentStoryComicsViewModel _contentStoryComicsViewModel;

  const ContentStoryComicsTopAppBar(this._contentStoryComicsViewModel, {super.key});

  @override
  _ContentStoryComicsTopAppBarState createState() {
    return _ContentStoryComicsTopAppBarState();
  }
}

class _ContentStoryComicsTopAppBarState extends State<ContentStoryComicsTopAppBar> {
  ContentStoryComicsViewModel get contentStoryComicsViewModel =>
      widget._contentStoryComicsViewModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Image.asset('assets/images/back_icon.png'), // Icon bên trái
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        // download button
        if (contentStoryComicsViewModel.contentStoryComics != null)
          IconButton(
            icon: Image.asset('assets/images/download_icon.png'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DownloadSingleChapterComicsDialog(contentStoryComicsViewModel);
                  });
            },
          ),
      ],
      title: Text(
        contentStoryComicsViewModel.contentStoryComics?.chapterTitle ?? 'chapterTitle',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }
}
