import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_login/ViewModels/ContentStoryComicsViewModel.dart';
import 'package:project_login/Views/Components/ContentStoryComicsBottomAppBar.dart';
import 'package:project_login/Views/Components/ContentStoryComicsTopAppBar.dart';
import 'package:provider/provider.dart';

class ContentStoryComicsScreen extends StatefulWidget {
  final String storyTitle;
  final int chap;
  final String dataSource;
  final int pageNumber;
  final String name;

  const ContentStoryComicsScreen({
    super.key,
    required this.storyTitle,
    required this.chap,
    required this.name,
    required this.dataSource,
    required this.pageNumber
  });

  @override
  _ContentStoryComicsScreenState createState() => _ContentStoryComicsScreenState();
}

class _ContentStoryComicsScreenState extends State<ContentStoryComicsScreen> {
  late ContentStoryComicsViewModel _contentStoryComicsViewModel;
  bool isLoadingSuccess = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _contentStoryComicsViewModel =
        Provider.of<ContentStoryComicsViewModel>(context, listen: false);
    _contentStoryComicsViewModel.name = widget.name;
    _fetchData();
    // listen controller
    _contentStoryComicsViewModel.addListener(_scrollToTop);
  }
  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    _contentStoryComicsViewModel.removeListener(_scrollToTop);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentStoryComicsViewModel>(
        builder: (context, contentStoryComicsViewModel, _) {
           return Scaffold(
             extendBodyBehindAppBar: true,
             appBar: PreferredSize(
               preferredSize: const Size.fromHeight(kToolbarHeight),
               child: ContentStoryComicsTopAppBar(contentStoryComicsViewModel),
             ),
             body: Container(
               width: double.infinity,
               height: double.infinity,
               decoration: const BoxDecoration(
                 image: DecorationImage(
                    image: AssetImage('assets/images/background_home.png'),
                    fit: BoxFit.fill
                 )
               ),
               child: SafeArea(
                 child: Container(
                   width: double.infinity,
                   height: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius: const BorderRadius.only(
                       topLeft: Radius.circular(20),
                       topRight: Radius.circular(20),
                       bottomLeft: Radius.circular(0),
                       bottomRight: Radius.circular(0),
                     ),
                     color: intToColor(
                       0xFFFFFFFF
                     ),
                   ),
                   child: contentStoryComicsViewModel.contentStoryComics != null
                       && contentStoryComicsViewModel.contentStoryComics?.content != null
                       ? SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: contentStoryComicsViewModel.contentStoryComics
                                    ?.content?.length,
                                itemBuilder: (context, index) {
                                  final imageData = contentStoryComicsViewModel.contentStoryComics
                                      !.content?[index];

                                  return Image.network(
                                     imageData!.imagePath,
                                     width: MediaQuery.of(context).size.width,// Set the width to match the parent container's width
                                     //height:  MediaQuery.of(context).size.height, // Set the height to match the screen height
                                     fit: BoxFit.cover, // Adjust the image to fill the available space

                                     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                       return Image.asset(
                                         'assets/images/default_image.png',
                                         height: 101,
                                         width: 84,
                                       );
                                     },
                                  );
                                }
                            )
                          ),
                      )
                       : const Center(child: CircularProgressIndicator()),
                 ),
               ),
             ),
             bottomNavigationBar: _contentStoryComicsViewModel.contentStoryComics != null
              ? ContentStoryComicsBottomAppBar(
                 contentStoryComicsViewModel: contentStoryComicsViewModel,
                 onChooseChapter: (index, pageNumber) {
                   navigateToNewChap(index, pageNumber);
                 },
                 navigateToNextChap: () {
                   navigateToNextChap();
                 },
                 navigateToPrevChap: () {
                   navigateToPrevChap();
                 },)
                 : null
             ,
           );
        }
    );
  }
  // navigate to next chapter
  void navigateToNextChap() {
    setState(() {
      // fetch next chapter pagination if current chapter is the last item of current chapter pagination
      if (_contentStoryComicsViewModel.currentChapNumber %
          _contentStoryComicsViewModel.chapterPagination.chapterPerPage == 0) {
        _contentStoryComicsViewModel.fetchChapterPagination(
            widget.storyTitle,
            ++_contentStoryComicsViewModel.currentPageNumber,
            _contentStoryComicsViewModel.currentSource,
            true);
      }

      // fetch new content
      _contentStoryComicsViewModel.fetchContentStoryComics(
          widget.storyTitle,
          ++_contentStoryComicsViewModel.currentChapNumber,
          _contentStoryComicsViewModel.currentSource);
    });
  }

  // navigate to previous chapter
  void navigateToPrevChap() {
    setState(() {
      // fetch previous chapter pagination if current chapter is the first item of current chapter pagination
      if (_contentStoryComicsViewModel.currentChapNumber %
          _contentStoryComicsViewModel.chapterPagination.chapterPerPage == 1) {
        _contentStoryComicsViewModel.fetchChapterPagination(
            widget.storyTitle,
            --_contentStoryComicsViewModel.currentPageNumber,
            _contentStoryComicsViewModel.currentSource,
            true);
      }

      // fetch new content
      _contentStoryComicsViewModel.fetchContentStoryComics(
          widget.storyTitle,
          --_contentStoryComicsViewModel.currentChapNumber,
          _contentStoryComicsViewModel.currentSource);
    });
  }

  // navigate to a certain chapter
  void navigateToNewChap(int index, int pageNumber) {
    // calculate page and chapter number
    _contentStoryComicsViewModel.currentPageNumber = pageNumber;
    _contentStoryComicsViewModel.currentChapNumber = (pageNumber - 1) *
        _contentStoryComicsViewModel.chapterPagination.chapterPerPage + index + 1;

    // fetch new content
    setState(() {
      _contentStoryComicsViewModel.fetchContentStoryComics(
          widget.storyTitle,
          _contentStoryComicsViewModel.currentChapNumber,
          _contentStoryComicsViewModel.currentSource);
    });
  }
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _fetchData() async {
    await Future.wait([
      _contentStoryComicsViewModel.fetchChapterPagination(
          widget.storyTitle, widget.pageNumber, widget.dataSource, true),
    ]);

    isLoadingSuccess = await _contentStoryComicsViewModel.fetchContentStoryComics(
        widget.storyTitle, widget.chap, widget.dataSource);

    if (!isLoadingSuccess) {
      showMyDialog(widget.dataSource);
    }

    await Future.wait([
      _contentStoryComicsViewModel.fetchFormatList(),
    ]);
  }
  Color intToColor(int colorValue) {
    return Color(colorValue);
  }

  void showMyDialog(String chosenSource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tải thất bại'),
          content: Text(
              'Không thể tải truyện từ $chosenSource. Tải truyện từ ${_contentStoryComicsViewModel.currentSource} để thay thế'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}