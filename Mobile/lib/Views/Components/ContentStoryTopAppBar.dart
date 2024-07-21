import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ViewModels/ContentStoryViewModel.dart';
import 'DownloadSingleChapterDialog.dart';

class ContentStoryTopAppBar extends StatefulWidget {
  final ContentStoryViewModel _contentStoryViewModel;

  const ContentStoryTopAppBar(this._contentStoryViewModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ContentStoryTopAppBarState();
  }
}

class _ContentStoryTopAppBarState extends State<ContentStoryTopAppBar> {
  ContentStoryViewModel get contentStoryViewModel =>
      widget._contentStoryViewModel;

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
        if (contentStoryViewModel.contentStory != null)
          IconButton(
            icon: Image.asset('assets/images/download_icon.png'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DownloadSingleChapterDialog(contentStoryViewModel);
                  });
            },
          ),
      ],
      title: Text(
        contentStoryViewModel.contentStory?.chapterTitle ?? 'chapterTitle',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }
}
