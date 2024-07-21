import 'package:flutter/material.dart';
import 'package:project_login/Models/DownloadHistory.dart';
import 'package:project_login/ViewModels/DownloadChaptersViewModel.dart';

class DownloadListItem extends StatelessWidget{
  final DownloadChaptersViewModel _downloadChaptersViewModel = DownloadChaptersViewModel();
  final DownloadHistory downloadHistory;
  final Function(DownloadHistory) onClick;

  DownloadListItem(this.downloadHistory, this.onClick, {super.key});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(downloadHistory);
      },
      child: Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.yellow,
                  width: 2.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(downloadHistory.cover,errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/default_image.png',
                    height: 101,
                    width: 84,
                  );
                },),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(
                    width: 250,
                      child: Text(
                        downloadHistory.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Tập: " + downloadHistory.chap.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      downloadHistory.dataSource,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
            )

          ],
        ),
      ),
    );
  }

}