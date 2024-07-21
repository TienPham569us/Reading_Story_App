import 'package:flutter/material.dart';

import 'Components/HistoryListWidget.dart';
import 'Components/DownloadListWidget.dart';

class BookShelfPage extends StatelessWidget {
  const BookShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});
  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  bool _isBtnHistoryPressed = true;
  bool _isBtnDownloadPressed = false;
  Widget _currentData =  HistoryListWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: (){
                      setState(() {
                        // show history list
                        _isBtnHistoryPressed = true;
                        _isBtnDownloadPressed = false;
                        _currentData = HistoryListWidget(); // do not add const
                      });
                    },
                    child: Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isBtnHistoryPressed ? Colors.red : Colors.white,
                          fontSize: 20,
                        ),
                        'Lịch sử'
                    )
                ),

                const SizedBox(
                  width: 30,
                ),
                TextButton(
                    onPressed: (){
                      setState(() {
                        _isBtnDownloadPressed = true;
                        _isBtnHistoryPressed = false;
                        _currentData = DownloadListWidget();
                      });
                    },
                    child: Text(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isBtnDownloadPressed ? Colors.red : Colors.white,
                          fontSize: 20,
                        ),
                        'Tải xuống'
                    )
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _currentData, // Hiển thị widget tương ứng
          ],
        ),
      ),
    );
  }
}

class MyCustomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.yellow, // Màu của đường viền
                width: 2.5, // Độ rộng của đường viền
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                  'assets/images/naruto.jpg'
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wonder Lab (Labotomy Corp)",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "By: ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "Đã đọc đến chương:  ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}