import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/ViewModels/DownloadChaptersAudioViewModel.dart';
import 'package:project_login/toast_util.dart';

class DownloadSingleChapterAudioDialog extends StatefulWidget {
  final ContentStoryAudioViewModel _contentStoryAudioViewModel;

  const DownloadSingleChapterAudioDialog(this._contentStoryAudioViewModel,
      {super.key});

  @override
  _DownloadSingleChapterAudioDialogState createState() {
    return _DownloadSingleChapterAudioDialogState();
  }
}

class _DownloadSingleChapterAudioDialogState
    extends State<DownloadSingleChapterAudioDialog> {

  int startTime = 0;
  int endTime = 0;

  ContentStoryAudioViewModel get contentStoryAudioViewModel =>
      widget._contentStoryAudioViewModel;

  String? selectedFormat;

  @override
  void initState() {
    super.initState();
    selectedFormat = contentStoryAudioViewModel.formatList[0];
  }

  @override
  Widget build(BuildContext context) {
    DownloadChaptersAudioViewModel viewModel = DownloadChaptersAudioViewModel();
    return AlertDialog(
      title: Center(child: Text('Định dạng')),
      content: StatefulBuilder(
        builder: ( context,  setState) {
          return  SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose Start Time:',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    ),
                  ),
                  StatefulBuilder(
                      builder: (context, state) {
                        return
                        Slider(
                          value: startTime.toDouble(),
                          min: 0,
                          max: contentStoryAudioViewModel.getDuration().toDouble(),
                          onChanged: (double value) {
                            startTime = value.toInt();

                            state(() {
                              startTime = value.toInt();
                            });

                            setState((){
                              startTime = value.toInt();
                            });

                          },
                        );
                      }),

                  Text(
                    '${_formatDuration((startTime))} / ${_formatDuration((contentStoryAudioViewModel.getDuration()))}',
                  ),
                  const Text(
                    'Choose end Time:',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, state) {
                      return
                        Slider(
                          value: endTime.toDouble(),
                          min: 0,
                          max: contentStoryAudioViewModel.getDuration().toDouble(),
                          onChanged: (double value) {
                            endTime = value.toInt();

                            setState(() {
                              endTime = value.toInt();
                            });
                          },
                        );
                  }),
                  Text(
                    '${_formatDuration((endTime))} / ${_formatDuration((contentStoryAudioViewModel.getDuration()))}',
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: contentStoryAudioViewModel.formatList
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
                        .toList()
                    ,
                  )
                ]
            ),
          );
        },
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            List<int> chapNumberList = [
              contentStoryAudioViewModel.currentChapNumber
            ];
            Navigator.of(context).pop();
            if (startTime >= endTime) {
              ToastUtil.showToast('End Time must more than Start Time!');
              return;
            }
            // download
            viewModel
                .downloadChaptersAudioOfStory(
                contentStoryAudioViewModel.contentStory!.title,
                contentStoryAudioViewModel.contentStory!.cover,
                contentStoryAudioViewModel.contentStory!.name,
                chapNumberList,
                selectedFormat!,
                contentStoryAudioViewModel.currentSource,
                startTime,
                endTime
            )
                .then((isSuccess) {
              if (isSuccess){
                ToastUtil.showToast('Download thành công');
              } else {
                ToastUtil.showToast('Download thất bại');
              }
            });
          },
          child: Text('Ok'),
        ),
      ],
    );
  }

  String _formatDuration(int durationInSeconds) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    Duration duration = Duration(seconds: durationInSeconds);

    int durationHour = duration.inHours;
    int durationMinute = duration.inMinutes.remainder(60);
    int durationSecond = duration.inSeconds.remainder(60);

    String hours = (durationHour).toString();
    String minutes = twoDigits(durationMinute);
    String seconds = twoDigits(durationSecond);


    if (durationHour <= 0) {
      if (durationMinute <= 0) {
        return "${seconds}s";
      }
      return "${minutes}m ${seconds}s";
    }
    return "${hours}h ${minutes}m ${seconds}s";
  }

}
/* AlertDialog(
      title: Center(child: Text('Định dạng')),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return  SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose Start Time:',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    ),
                  ),
                  Slider(
                    value: startTime.toDouble(),
                    min: 0,
                    max: 5000,//contentStoryAudioViewModel.getDuration().toDouble(),
                    onChanged: (double value) {
                      startTime = value.toInt();
                    },
                  ),
                  Text(
                    '${_formatDuration((startTime))} / ${_formatDuration((contentStoryAudioViewModel.getDuration()))}',
                  ),
                  /*const Text(
              'Choose end Time:',
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
              ),
            ),
            Slider(
              value: 0,
              min: 0,
              max: contentStoryAudioViewModel.getDuration().toDouble(),
              onChanged: (double value) {
                endTime = value.toInt();
              },
            ),
            Text(
              '${_formatDuration((endTime))} / ${_formatDuration((contentStoryAudioViewModel.getDuration()))}',
            ),*/
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: contentStoryAudioViewModel.formatList
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
                        .toList()
                    ,
                  )
                ]
            ),
          );
        },
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            List<int> chapNumberList = [
              contentStoryAudioViewModel.currentChapNumber
            ];
            Navigator.of(context).pop();
            if (startTime >= endTime) {
              ToastUtil.showToast('End Time must more than Start Time');
              return;
            }
            // download
            viewModel
                .downloadChaptersAudioOfStory(
                contentStoryAudioViewModel.contentStory!.title,
                contentStoryAudioViewModel.contentStory!.cover,
                contentStoryAudioViewModel.contentStory!.name,
                chapNumberList,
                selectedFormat!,
                contentStoryAudioViewModel.currentSource,
                startTime,
                endTime
            )
                .then((isSuccess) {
              if (isSuccess){
                ToastUtil.showToast('Download thành công');
              } else {
                ToastUtil.showToast('Download thất bại');
              }
            });
          },
          child: Text('Ok'),
        ),
      ],
    );*/