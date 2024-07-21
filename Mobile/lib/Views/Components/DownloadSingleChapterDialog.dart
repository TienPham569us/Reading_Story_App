import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_login/toast_util.dart';
import 'package:provider/provider.dart';

import '../../ViewModels/ContentStoryViewModel.dart';
import '../../ViewModels/DownloadChaptersViewModel.dart';

class DownloadSingleChapterDialog extends StatefulWidget {
  final ContentStoryViewModel _contentStoryViewModel;

  const DownloadSingleChapterDialog(this._contentStoryViewModel, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _DownloadSingleChapterDialogState();
  }
}

class _DownloadSingleChapterDialogState
    extends State<DownloadSingleChapterDialog> {
  ContentStoryViewModel get contentStoryViewModel =>
      widget._contentStoryViewModel;

  String? selectedFormat;

  @override
  void initState() {
    super.initState();
    selectedFormat = contentStoryViewModel.formatList[0];
  }

  @override
  Widget build(BuildContext context) {
    DownloadChaptersViewModel viewModel = DownloadChaptersViewModel();
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
                .downloadChaptersOfStory(
                    contentStoryViewModel.contentStory!.title,
                    contentStoryViewModel.contentStory!.cover,
                    contentStoryViewModel.contentStory!.name,
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
