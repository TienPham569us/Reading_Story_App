import 'package:flutter/material.dart';

import '../../Models/ReadingHistory.dart';

class ReadingHistoryItem extends StatelessWidget{
  final ReadingHistory readingHistory;
  final Function(ReadingHistory) onClick;

  const ReadingHistoryItem(this.readingHistory, this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick(readingHistory);
      },
      child: SizedBox(
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
                borderRadius: BorderRadius.circular(15),
                child: Image.network(readingHistory.cover,errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    readingHistory.name,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "By: ${readingHistory.author}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Đã đọc đến chương: ${readingHistory.chap}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}