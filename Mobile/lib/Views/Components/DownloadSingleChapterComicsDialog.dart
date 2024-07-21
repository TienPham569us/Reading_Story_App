import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryComicsViewModel.dart';
import 'package:project_login/ViewModels/DownloadChaptersComicsViewModel.dart';
import 'package:project_login/toast_util.dart';

class DownloadSingleChapterComicsDialog extends StatefulWidget {
  final ContentStoryComicsViewModel _contentStoryComicsViewModel;

  const DownloadSingleChapterComicsDialog(this._contentStoryComicsViewModel, {super.key});

  @override
  _DownloadSingleChapterComicsDialogState createState() {
    return _DownloadSingleChapterComicsDialogState();
  }
}

class _DownloadSingleChapterComicsDialogState
    extends State<DownloadSingleChapterComicsDialog> {
  ContentStoryComicsViewModel get contentStoryViewModel =>
      widget._contentStoryComicsViewModel;

  String? selectedFormat;

  @override
  void initState() {
    super.initState();
    selectedFormat = contentStoryViewModel.formatList[0];
  }

  @override
  Widget build(BuildContext context) {
    DownloadChaptersComicsViewModel viewModel = DownloadChaptersComicsViewModel();
    return AlertDialog(
      title: const Center(child: Text('Định dạng')),
      content: SingleChildScrollView(
        child: Column(
          children: contentStoryViewModel.formatList
              .map((String format) => RadioListTile<String>(
            title: Text(format),
            value: format,
            groupValue: selectedFormat,
            onChanged: (String? value) {
              setState(() {
                // choose format
                selectedFormat = value;
              });
            },
          ))
              .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            List<int> chapNumberList = [
              contentStoryViewModel.currentChapNumber
            ];
            Navigator.of(context).pop();
            // download
            viewModel
                .downloadChaptersComicsOfStory(
                contentStoryViewModel.contentStoryComics!.title,
                contentStoryViewModel.contentStoryComics!.cover,
                contentStoryViewModel.contentStoryComics!.name,
                chapNumberList,
                selectedFormat!,
                contentStoryViewModel.currentSource)
                .then((isSuccess) {
              if (isSuccess){
                ToastUtil.showToast('Download thành công');
              } else {
                ToastUtil.showToast('Download thất bại');
              }
            });
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
