import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'BookShelfView.dart';
import 'HomeView.dart';
import 'SettingView.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _page=1;

  final List<Widget> _pages = [
    const BookShelfPage(),
    const HomePage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit:BoxFit.cover
                  )
              ),
            ),
            SafeArea(
              child: Center(
                child: IndexedStack(
                  index: _page,
                  children: _pages,
                ),
              ),
            ),
          ]
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 2, 3, 7),
        buttonBackgroundColor: const Color.fromARGB(255, 80, 137, 191),
        color: const Color.fromARGB(255, 21, 23, 21),
        animationDuration: const Duration(milliseconds: 500),
        items: const <Widget>[
          Icon(Icons.menu_book,size: 24,color: Colors.white,),
          Icon(Icons.home,size: 24,color: Colors.white,),
          Icon(Icons.settings,size: 24,color: Colors.white)
        ],
        onTap: (index){
          setState(() {
            _page=index;
          });
        },
        index: 1,
      ),
    );
  }
}
