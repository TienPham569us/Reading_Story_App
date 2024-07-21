import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/Views/Components/DownloadSingleChapterAudioDialog.dart';

class ContentStoryAudioTopAppBar extends StatefulWidget {
  final ContentStoryAudioViewModel  _contentStoryAudioViewModel;

  const ContentStoryAudioTopAppBar(this._contentStoryAudioViewModel, {super.key});

  @override
  _ContentStoryAudioTopAppBarState createState() {
    return _ContentStoryAudioTopAppBarState();
  }
}

class _ContentStoryAudioTopAppBarState extends State<ContentStoryAudioTopAppBar> {
  ContentStoryAudioViewModel get contentStoryAudioViewModel =>
      widget._contentStoryAudioViewModel;

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
      if (contentStoryAudioViewModel.contentStory != null)
        IconButton(
          icon: Image.asset('assets/images/download_icon.png'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DownloadSingleChapterAudioDialog(contentStoryAudioViewModel);
                });
          },
        ),
    ],
      title: Text(
        contentStoryAudioViewModel.contentStory?.chapterTitle ?? 'chapterTitle',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }
}
