import 'package:flutter/material.dart';

import 'Views/ReadOfflineFile.dart';
import 'Views/SplashView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Story App',
      home: SplashScreen(),
      //home: ReadOfflineFile()
    );
  }
}
