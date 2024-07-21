import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryViewModel.dart';
import 'package:project_login/Views/Components/SettingContentStoryBottomSheet.dart';
import 'package:project_login/Views/Components/ChooseChapterBottomSheet.dart';

class ContentStoryBottomAppBar extends StatelessWidget {
  final ContentStoryViewModel contentStoryViewModel;
  final Function(double) onTextSizeChanged;
  final Function(double) onLineSpacingChanged;
  final Function(String) onFontFamilyChanged;
  final Function(int) onTextColorChanged;
  final Function(int) onBackgroundChanged;
  final Function(int, int) onChooseChapter;
  final Function() navigateToNextChap;
  final Function() navigateToPrevChap;
  final Function(String) onSourceChange;

  const ContentStoryBottomAppBar(
      {super.key,
      required this.contentStoryViewModel,
      required this.onTextSizeChanged,
      required this.onLineSpacingChanged,
      required this.onFontFamilyChanged,
      required this.onTextColorChanged,
      required this.onBackgroundChanged,
      required this.onChooseChapter,
      required this.navigateToNextChap,
      required this.navigateToPrevChap,
      required this.onSourceChange});

  @override
  Widget build(BuildContext context) {
    bool canNavigateToNextChap = true;
    bool canNavigateToPrevChap = true;

    // disable or enable previous button base on current chapter
    if (contentStoryViewModel.currentChapNumber == 1) {
      canNavigateToPrevChap = false;
    }

    // disable or enable next button base on current chapter
    if (contentStoryViewModel.currentChapNumber == contentStoryViewModel.chapterPagination.maxChapter) {
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
            const BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded), label: ''),
            BottomNavigationBarItem(
                icon: ImageIcon(
                  const AssetImage('assets/images/next_button.png'),
                  color: nextChapIconColor,
                ),
                label: '')
          ],
          onTap: (int index) {
            // navigate to previous chapter
            if (index == 0) {
              if (canNavigateToPrevChap) {
                navigateToPrevChap();
              }
            } else if (index == 1) {
              // show choose chapter bottom sheet
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => ChooseChapterBottomSheet(
                    contentStoryViewModel, onChooseChapter),
              );
            } else if (index == 2) {
              // show setting bottom sheet
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) =>
                    SettingContentStoryBottomSheet(
                  contentStoryViewModel: contentStoryViewModel,
                  onTextSizeChanged: onTextSizeChanged,
                  onLineSpacingChanged: onLineSpacingChanged,
                  onFontFamilyChanged: onFontFamilyChanged,
                  onTextColorChanged: onTextColorChanged,
                  onBackgroundChanged: onBackgroundChanged,
                  onSourceChange: onSourceChange,
                ),
              );
            } else if (index == 3) {
              // navigate to previous chapter
              if (canNavigateToNextChap) {
                navigateToNextChap();
              }
            }
          },
        ));
  }
}
