import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ReadOfflineComics extends StatefulWidget{
  final String link;
  final Function(String) deleteDatabase;

  const ReadOfflineComics({super.key, required this.link, required this.deleteDatabase});

  @override
  State<StatefulWidget> createState() {
    return _ReadOfflineComicsState();
  }
}

class _ReadOfflineComicsState extends State<ReadOfflineComics> {
  String fileContent = '';
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _readFileContent();
  }

  // delete a file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        widget.deleteDatabase(filePath);
      } else {
        print('File không tồn tại: $filePath');
      }
    } catch (e) {
      print('Lỗi khi xóa file: $e');
    }
  }

  // read content of .txt file
  Future<void> _readFileContent() async {
    try {
      final file = File(widget.link);
      String content = await file.readAsString();
      setState(() {
        fileContent = content;
      });
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/back_icon.png'), // Icon bên trái
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white,),
            onPressed: () async {
              await deleteFile(widget.link);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background_home.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InAppWebView(
                      initialData: InAppWebViewInitialData(data: fileContent),
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                    ),
                  ),
                )
            ),
          )),
    );
  }
}