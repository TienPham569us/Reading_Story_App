import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/Views/Components/ChooseChapterAudioBottomSheet.dart';

class ContentStoryAudioBottomAppBar extends StatelessWidget {
  final ContentStoryAudioViewModel contentStoryAudioViewModel;
  final Function(int, int) onChooseChapter;
  final Function() navigateToNextChap;
  final Function() navigateToPrevChap;

  const ContentStoryAudioBottomAppBar(
      {super.key,
        required this.contentStoryAudioViewModel,
        required this.onChooseChapter,
        required this.navigateToNextChap,
        required this.navigateToPrevChap});

  @override
  Widget build(BuildContext context) {
    bool canNavigateToNextChap = true;
    bool canNavigateToPrevChap = true;

    // disable or enable previous button base on current chapter
    if (contentStoryAudioViewModel.currentChapNumber == 1) {
      canNavigateToPrevChap = false;
    }

    // disable or enable next button base on current chapter
    if (contentStoryAudioViewModel.currentChapNumber == contentStoryAudioViewModel.chapterPagination.maxChapter) {
      canNavigateToNextChap = false;
    }

    // choose color base on state (disable, enable) of button
    Color nextChapIconColor =
    canNavigateToNextChap ? Colors.black : Colors.grey;
    Color prevChapIconColor =
    canNavigateToPrevChap ? Colors.black : Colors.grey;

    return Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(
                    const AssetImage('assets/images/back_button.png'),
                    color: prevChapIconColor),
                label: ''),
            const BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/images/list_icon.png')),
                label: ''),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  const AssetImage('assets/images/next_button.png'),
                  color: nextChapIconColor,
                ),
                label: '')
          ],
          onTap: (int index) async {
            // navigate to previous chapter
            if (index == 0) {
              if (canNavigateToPrevChap) {
                navigateToPrevChap();
              }
            } else if (index == 1) {
              // show choose chapter bottom sheet
             showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ChooseChapterAudioBottomSheet(
                    contentStoryAudioViewModel, onChooseChapter),
              );
            } else if (index == 2) {
              // navigate to previous chapter
              if (canNavigateToNextChap) {
                navigateToNextChap();
              }
            }
          },
        ));
  }

}